Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F417D62536
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732664AbfGHPQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:16:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:39958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732659AbfGHPQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:16:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 807D521537;
        Mon,  8 Jul 2019 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599009;
        bh=HewXvozBQ14YfeBODjCwdlOontBrIeyaFihaoGU3Knw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pr07ywVn+cf4feGQJWNFHJV1nD+k/d7yRRw2jQMpcKCumw5RclNsjxp4c4Z9Elp3
         zjZzxCROsZe/BaJtPq/HK6S3WDUF0nuPfZvo0E/aLDr6+6AqZUxGx+7KdmgtbuaHkU
         UJ9B2ip1iRE5OOO1RBKhbFOIoJKAIYaFMlMSJfiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matias Karhumaa <matias.karhumaa@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 47/73] Bluetooth: Fix faulty expression for minimum encryption key size check
Date:   Mon,  8 Jul 2019 17:12:57 +0200
Message-Id: <20190708150523.864229426@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matias Karhumaa <matias.karhumaa@gmail.com>

commit eca94432934fe5f141d084f2e36ee2c0e614cc04 upstream.

Fix minimum encryption key size check so that HCI_MIN_ENC_KEY_SIZE is
also allowed as stated in the comment.

This bug caused connection problems with devices having maximum
encryption key size of 7 octets (56-bit).

Fixes: 693cd8ce3f88 ("Bluetooth: Fix regression with minimum encryption key size alignment")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203997
Signed-off-by: Matias Karhumaa <matias.karhumaa@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/l2cap_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1341,7 +1341,7 @@ static bool l2cap_check_enc_key_size(str
 	 * actually encrypted before enforcing a key size.
 	 */
 	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
-		hcon->enc_key_size > HCI_MIN_ENC_KEY_SIZE);
+		hcon->enc_key_size >= HCI_MIN_ENC_KEY_SIZE);
 }
 
 static void l2cap_do_start(struct l2cap_chan *chan)


