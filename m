Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A1DF7E8E
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfKKSk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:40:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728390AbfKKSkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:40:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 394E021E6F;
        Mon, 11 Nov 2019 18:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497624;
        bh=0iZaIIXbU/NqbmH15+RRrZpLj+GgN8NzNblxv7/I+gg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cmlG1sJfdAtfhD98hFXaAk8aYWHqX0Mjb5lmY1iXWxfmq+zDVZQJNuDFeDWz4ab7/
         I/ZmBqxyiuFaszxRQlLgNF5GiPHlj1Ur3pFMDktTn6bXwzL4z5UWyiMXfkOzHyl541
         Wd+zOuC5MlQMzbJezIXupNVztBIhWgZMs3wzfU3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 010/125] NFC: st21nfca: fix double free
Date:   Mon, 11 Nov 2019 19:27:29 +0100
Message-Id: <20191111181440.910169973@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 99a8efbb6e30b72ac98cecf81103f847abffb1e5 ]

The variable nfcid_skb is not changed in the callee nfc_hci_get_param()
if error occurs. Consequently, the freed variable nfcid_skb will be
freed again, resulting in a double free bug. Set nfcid_skb to NULL after
releasing it to fix the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/st21nfca/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -719,6 +719,7 @@ static int st21nfca_hci_complete_target_
 							NFC_PROTO_FELICA_MASK;
 		} else {
 			kfree_skb(nfcid_skb);
+			nfcid_skb = NULL;
 			/* P2P in type A */
 			r = nfc_hci_get_param(hdev, ST21NFCA_RF_READER_F_GATE,
 					ST21NFCA_RF_READER_F_NFCID1,


