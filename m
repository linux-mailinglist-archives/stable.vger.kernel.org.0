Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F337848044C
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 20:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhL0TIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 14:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhL0THP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 14:07:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7700AC0698DA;
        Mon, 27 Dec 2021 11:07:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 379C1B81141;
        Mon, 27 Dec 2021 19:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52801C36AEE;
        Mon, 27 Dec 2021 19:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640632019;
        bh=JSBB6I1iNycnOk23h6lCNT9O5YTlSrtEZ6D1iPq7PJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhUKo+Vpx2wJPpJqmBDMdylpKphBB063YLq4DvWB0fAmhk/hklH4UvXUHWesfwGNo
         YA/qsg397U4HxPEi4fVW39DAQyHp5lC4hGfVJ/LT6sXGbuop47GXEfk7A5iZAcRDCI
         zSOoWNZ1+JyRIZhZrmIt6dI2JllbGqrZvRy7QwNgqzVEcg2dIWGiM8B4/ssGwQOOGe
         zeYLsASRrLl9fNRmUkgJj+tHndDVc3BigZOGxXLu2LzlYBAevOhY6/nH94oCezjCSp
         2nFwvJpC42xY+xDcpIBzHcu2Fx3t3toEpbvl6j0cG3hTlgmqPdLHV+A9R1DAC7JHtH
         DPFul2gCVAcgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>, Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/3] platform/x86: apple-gmux: use resource_size() with res
Date:   Mon, 27 Dec 2021 14:06:53 -0500
Message-Id: <20211227190653.1043578-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227190653.1043578-1-sashal@kernel.org>
References: <20211227190653.1043578-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

[ Upstream commit eb66fb03a727cde0ab9b1a3858de55c26f3007da ]

This should be (res->end - res->start + 1) here actually,
use resource_size() derectly.

Signed-off-by: Wang Qing <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1639484316-75873-1-git-send-email-wangqing@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/apple-gmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/apple-gmux.c b/drivers/platform/x86/apple-gmux.c
index 976efeb3f2ba3..a0f10ccdca3e4 100644
--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -461,7 +461,7 @@ static int gmux_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	}
 
 	gmux_data->iostart = res->start;
-	gmux_data->iolen = res->end - res->start;
+	gmux_data->iolen = resource_size(res);
 
 	if (gmux_data->iolen < GMUX_MIN_IO_LEN) {
 		pr_err("gmux I/O region too small (%lu < %u)\n",
-- 
2.34.1

