Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46FF5404BE1
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241955AbhIILxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240632AbhIILvh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:51:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAF1761357;
        Thu,  9 Sep 2021 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187853;
        bh=0ffYMfdpHIDmaWPEEAKeCUH0FGyny8eVV9zObef2Gxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgwnaM6PhWReDxt/KNqLv8GDV+RUwM5Ls+cFQ1hksMMJOLA0QN3ML5RIc8ELoIPQB
         zlSk9UtY42sBf3VzFHgwJhCvXYLroVc85s0zhPDzvZKQgXu9oYjddWezMxPZU1oBDr
         Arzhm6LjMTdC/jVIMmVhv9rp4JYxNsmPLKCxtah2ykrAkSmLW3828JDmq+2Gaycie4
         fK9ksplIkNozypfIf9NIMeAam6WBgk52NxJE0j64jcq5l7qlTKM2n8ayTgWqT6cyq4
         VZ/Z9bx9Qfojqnyo/JUHeQLkU/5yXe5v7BZfT5Rbl1i8oGdN0f0G5k+nowhjtkPJN8
         NcjUOtCPxsuCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 143/252] drm/msm/dp: reset aux controller after dp_aux_cmd_fifo_tx() failed.
Date:   Thu,  9 Sep 2021 07:39:17 -0400
Message-Id: <20210909114106.141462-143-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 0b324564ff74fa0556002be8fbbace556b9b2ad0 ]

Aux hardware calibration sequence requires resetting the aux controller
in order for the new setting to take effect. However resetting the AUX
controller will also clear HPD interrupt status which may accidentally
cause pending unplug interrupt to get lost. Therefore reset aux
controller only when link is in connection state when dp_aux_cmd_fifo_tx()
fail. This fixes Link Layer CTS cases 4.2.1.1 and 4.2.1.2.

Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1628196295-7382-4-git-send-email-khsieh@codeaurora.org
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_aux.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/msm/dp/dp_aux.c b/drivers/gpu/drm/msm/dp/dp_aux.c
index 4a3293b590b0..eb40d8413bca 100644
--- a/drivers/gpu/drm/msm/dp/dp_aux.c
+++ b/drivers/gpu/drm/msm/dp/dp_aux.c
@@ -353,6 +353,9 @@ static ssize_t dp_aux_transfer(struct drm_dp_aux *dp_aux,
 			if (!(aux->retry_cnt % MAX_AUX_RETRIES))
 				dp_catalog_aux_update_cfg(aux->catalog);
 		}
+		/* reset aux if link is in connected state */
+		if (dp_catalog_link_is_connected(aux->catalog))
+			dp_catalog_aux_reset(aux->catalog);
 	} else {
 		aux->retry_cnt = 0;
 		switch (aux->aux_error_num) {
-- 
2.30.2

