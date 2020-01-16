Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE76313F6FA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387956AbgAPRA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387949AbgAPRA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:00:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22E732073A;
        Thu, 16 Jan 2020 17:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194055;
        bh=dBLPW9njnuUVOoAFzsSRiHy03VMXVhY5zLhOEo4mUIA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BB7LVwrAb8dEGrOW4jN3LMJigL2SC/Fm8e58SG7GoRkLvEShwsETYMpWUjsAyJFFt
         0/A3KZqxC22RnIp/sDYLdBv3hZ6V9yM/qUdoo0FkCu5zKeBlpHns/Xk3v9qSC2ivdc
         9CCV9AonO2kLEfjdGRqwQO+jcjAmAA0qCQVZw2+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Mc Guire <hofrat@osadl.org>,
        Corey Minyard <cminyard@mvista.com>,
        Haiyue Wang <haiyue.wang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 169/671] ipmi: kcs_bmc: handle devm_kasprintf() failure case
Date:   Thu, 16 Jan 2020 11:51:18 -0500
Message-Id: <20200116165940.10720-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Mc Guire <hofrat@osadl.org>

[ Upstream commit 42c7c6ef1e6fa5fc0425120f06f045190b1dda2d ]

devm_kasprintf() may return NULL if internal allocation failed so this
assignment is not safe. Moved the error exit path and added the !NULL
which then allows the devres manager to take care of cleanup.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
Fixes: cd2315d471f4 ("ipmi: kcs_bmc: don't change device name")
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Reviewed-by: Haiyue Wang <haiyue.wang@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/kcs_bmc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/kcs_bmc.c b/drivers/char/ipmi/kcs_bmc.c
index e6124bd548df..ed4dc3b1843e 100644
--- a/drivers/char/ipmi/kcs_bmc.c
+++ b/drivers/char/ipmi/kcs_bmc.c
@@ -440,12 +440,13 @@ struct kcs_bmc *kcs_bmc_alloc(struct device *dev, int sizeof_priv, u32 channel)
 	kcs_bmc->data_in = devm_kmalloc(dev, KCS_MSG_BUFSIZ, GFP_KERNEL);
 	kcs_bmc->data_out = devm_kmalloc(dev, KCS_MSG_BUFSIZ, GFP_KERNEL);
 	kcs_bmc->kbuffer = devm_kmalloc(dev, KCS_MSG_BUFSIZ, GFP_KERNEL);
-	if (!kcs_bmc->data_in || !kcs_bmc->data_out || !kcs_bmc->kbuffer)
-		return NULL;
 
 	kcs_bmc->miscdev.minor = MISC_DYNAMIC_MINOR;
 	kcs_bmc->miscdev.name = devm_kasprintf(dev, GFP_KERNEL, "%s%u",
 					       DEVICE_NAME, channel);
+	if (!kcs_bmc->data_in || !kcs_bmc->data_out || !kcs_bmc->kbuffer ||
+	    !kcs_bmc->miscdev.name)
+		return NULL;
 	kcs_bmc->miscdev.fops = &kcs_bmc_fops;
 
 	return kcs_bmc;
-- 
2.20.1

