Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95225F7AEE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfKKSa7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727516AbfKKSa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19FA2222C9;
        Mon, 11 Nov 2019 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497058;
        bh=n6AUb7a03zjKnkOPbOJkQb6cpxFO6lzi0Y90HfhWmtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9Wc6TTRZ6at+8zjVXS+DsJo73/2IzTc1NJCyhIdQz+//10u4vbuSHwbq17da/iwI
         aA/pCAIRdEk8vtuLfQryi6C/NsCAAA/+Zljequkw8i1bPN98Tnq0/sfK7yGd571g7W
         2EuH01n9A6aIQ6T2fL2xPqc9n/c0APfJWtAz+eaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 04/43] NFC: st21nfca: fix double free
Date:   Mon, 11 Nov 2019 19:28:18 +0100
Message-Id: <20191111181252.645265024@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
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
@@ -726,6 +726,7 @@ static int st21nfca_hci_complete_target_
 							NFC_PROTO_FELICA_MASK;
 		} else {
 			kfree_skb(nfcid_skb);
+			nfcid_skb = NULL;
 			/* P2P in type A */
 			r = nfc_hci_get_param(hdev, ST21NFCA_RF_READER_F_GATE,
 					ST21NFCA_RF_READER_F_NFCID1,


