Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0432E63C3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406125AbgL1Pmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404972AbgL1NrB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:47:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A46C205CB;
        Mon, 28 Dec 2020 13:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163180;
        bh=yA00cOct8NAreEj6dOkgoSW+IU9a5MeZjUrMP32aASU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AE2e7IEBi97Bx74ARw/NrmtoNF18zwti3RVAqcE9wWXDaR0A75oPQQsf4xMyG/Uq1
         IY2cJ/ZI3NC2vaivr1X49HfyUGqrKkZXbRNqXOSZC3mZ8w/KmpSXko+ST0aSK/k6+M
         Eqz9v/xRYw2PS1yjYb43G8GcsLlTbEv/9++mUJjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 198/453] ath10k: Release some resources in an error handling path
Date:   Mon, 28 Dec 2020 13:47:14 +0100
Message-Id: <20201228124946.739644616@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 3f3675aa782fb..05c0d5e92475e 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1023,7 +1023,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_warn(ar, "failed to register driver core: %d\n", ret);
-		goto err;
+		goto err_usb_destroy;
 	}
 
 	/* TODO: remove this once USB support is fully implemented */
@@ -1031,6 +1031,9 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	return 0;
 
+err_usb_destroy:
+	ath10k_usb_destroy(ar);
+
 err:
 	ath10k_core_destroy(ar);
 
-- 
2.27.0



