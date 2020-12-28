Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593D42E6747
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbgL1QWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:22:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732224AbgL1NNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:13:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E221C208D5;
        Mon, 28 Dec 2020 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161163;
        bh=waV4/zyCcsTYaqm0wBqC73lPK4M+tQcsB5fXUOYMaZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAi13fgoeiIHhsK+HcXj04I9zig0E1DWf9S3RvO/VjJ5VI4nGD2y3p8Ko1uBfcKax
         SFLCJT7f/8p2pDef6sZGSHG6KOvBpgy4jJzF/UFxbp5oULzbea8VblrbCWJlHEScJV
         YP+p3Pg8CEKqhWURh7MFPWWehEH9+3EI7MZT55+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 123/242] ath10k: Release some resources in an error handling path
Date:   Mon, 28 Dec 2020 13:48:48 +0100
Message-Id: <20201228124910.751751761@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6364e693f4a7a89a2fb3dd2cbd6cc06d5fd6e26d ]

Should an error occur after calling 'ath10k_usb_create()', it should be
undone by a corresponding 'ath10k_usb_destroy()' call

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201122170358.1346065-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index f4e6d84bfb91c..16d5fe6d1e2e4 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1032,7 +1032,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_warn(ar, "failed to register driver core: %d\n", ret);
-		goto err;
+		goto err_usb_destroy;
 	}
 
 	/* TODO: remove this once USB support is fully implemented */
@@ -1040,6 +1040,9 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	return 0;
 
+err_usb_destroy:
+	ath10k_usb_destroy(ar);
+
 err:
 	ath10k_core_destroy(ar);
 
-- 
2.27.0



