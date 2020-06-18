Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E095A1FDB47
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgFRBLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728720AbgFRBLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92C4F221EA;
        Thu, 18 Jun 2020 01:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442677;
        bh=/K41qGCOksYUWpJHCUej+cRAGtzlKjR6qaDmvAdcVdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YQGX1gns+BFm8e+yPfaJH+SlQ1RzaQ6NJWKjdU6BLmdyGQV8/YkMYByBAvDVo8Yvu
         zGsKrUairgqWLsvbawh3SsnI2DVQ1960teXzGb6n4DAuOP5msQiJFfS4VTLA9sK8ry
         0Ur5pXS4GnvIFYXnY1dYkGvl/+HTm50f2XQu/7rk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.7 145/388] staging: wfx: fix double init of tx_policy_upload_work
Date:   Wed, 17 Jun 2020 21:04:02 -0400
Message-Id: <20200618010805.600873-145-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jérôme Pouiller <jerome.pouiller@silabs.com>

[ Upstream commit 6ae0878b4800c7042d35c0fb4c6baabb62621ecc ]

The work_struct tx_policy_upload_work was initialized twice.

Fixes: 99879121bfbb ("staging: wfx: fix the cache of rate policies on interface reset")
Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Link: https://lore.kernel.org/r/20200427134031.323403-12-Jerome.Pouiller@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/sta.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
index 969d7a4a7fbd..b4cd7cb1ce56 100644
--- a/drivers/staging/wfx/sta.c
+++ b/drivers/staging/wfx/sta.c
@@ -1049,7 +1049,6 @@ int wfx_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	init_completion(&wvif->scan_complete);
 	INIT_WORK(&wvif->scan_work, wfx_hw_scan_work);
 
-	INIT_WORK(&wvif->tx_policy_upload_work, wfx_tx_policy_upload_work);
 	mutex_unlock(&wdev->conf_mutex);
 
 	hif_set_macaddr(wvif, vif->addr);
-- 
2.25.1

