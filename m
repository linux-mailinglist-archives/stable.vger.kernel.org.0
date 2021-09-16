Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9837840E793
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347724AbhIPReC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:34:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347186AbhIPRby (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C99960FC0;
        Thu, 16 Sep 2021 16:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810852;
        bh=0ffYMfdpHIDmaWPEEAKeCUH0FGyny8eVV9zObef2Gxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcPhD7VCG1Bt7kqhWSl3Rw7y3F6IsrzxwMcVM0LaBm8ybPtNiMnFhKSCuATOJGMKv
         ubzQIyMIldi82kV4L4sRFbFV94VZ970lC2qZp6IQKGDV1R3teWtF3YUoIFQUx2edBA
         5Rxgha+eVoZVDeOq7wRiz03Vl0UYqVDodj/7wihk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 291/432] drm/msm/dp: reset aux controller after dp_aux_cmd_fifo_tx() failed.
Date:   Thu, 16 Sep 2021 18:00:40 +0200
Message-Id: <20210916155820.689236615@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



