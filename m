Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0311862202
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387721AbfGHPVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:47168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387703AbfGHPVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:21:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8789216C4;
        Mon,  8 Jul 2019 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599284;
        bh=mzbeTsKDy1cED57NDZNwyA+OUZJUbMKf/DQpwdW6/Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcBacKIO88/+/+IedMihzDOeeGNmV79b1lKVRyQs5chHnaRzOSSLmexoI9bQzxMPo
         9RBAtWJ59oZ+j+sgAp8KD4eEHIYtUG//6H8MWL8qWIJvxq/pi77rMI39kSnwpNDW5C
         tE3g4ZKgyKasCvpfAmkMODfjCO4d+DFHqgwqIRIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matias Karhumaa <matias.karhumaa@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 065/102] Bluetooth: Fix faulty expression for minimum encryption key size check
Date:   Mon,  8 Jul 2019 17:12:58 +0200
Message-Id: <20190708150529.818384971@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
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
@@ -1352,7 +1352,7 @@ static bool l2cap_check_enc_key_size(str
 	 * actually encrypted before enforcing a key size.
 	 */
 	return (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags) ||
-		hcon->enc_key_size > HCI_MIN_ENC_KEY_SIZE);
+		hcon->enc_key_size >= HCI_MIN_ENC_KEY_SIZE);
 }
 
 static void l2cap_do_start(struct l2cap_chan *chan)


