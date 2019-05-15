Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E101F167
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbfEOLxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:53:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbfEOLT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C7120843;
        Wed, 15 May 2019 11:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919166;
        bh=h3xdNg/q9zhRaJaNp3VWSoaqbdpc4FxgzygEbgsDw2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsZQBtRe+sJxpZpx5a4OtpG+Xf1VE5ZQTmVKejEQUPhYv+RubP9HZcgVt1FqhWfNy
         ANu/laCs0dxkXlJDb9I+qAMz7JIX/H8gyNi8/JW7QWmH4JhYvDiJQWTqFFNIk1mTwU
         KCWPtabiamskDeLLiFJA8zJUXbr1Wx6qTb6yWTLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 091/115] NFC: nci: Add some bounds checking in nci_hci_cmd_received()
Date:   Wed, 15 May 2019 12:56:11 +0200
Message-Id: <20190515090705.861199865@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d7ee81ad09f072eab1681877fc71ec05f9c1ae92 ]

This is similar to commit 674d9de02aa7 ("NFC: Fix possible memory
corruption when handling SHDLC I-Frame commands").

I'm not totally sure, but I think that commit description may have
overstated the danger.  I was under the impression that this data came
from the firmware?  If you can't trust your networking firmware, then
you're already in trouble.

Anyway, these days we add bounds checking where ever we can and we call
it kernel hardening.  Better safe than sorry.

Fixes: 11f54f228643 ("NFC: nci: Add HCI over NCI protocol support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/nfc/nci/hci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/nfc/nci/hci.c b/net/nfc/nci/hci.c
index ddfc52ac1f9b4..c0d323b58e732 100644
--- a/net/nfc/nci/hci.c
+++ b/net/nfc/nci/hci.c
@@ -312,6 +312,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 		create_info = (struct nci_hci_create_pipe_resp *)skb->data;
 		dest_gate = create_info->dest_gate;
 		new_pipe = create_info->pipe;
+		if (new_pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		/* Save the new created pipe and bind with local gate,
 		 * the description for skb->data[3] is destination gate id
@@ -336,6 +340,10 @@ static void nci_hci_cmd_received(struct nci_dev *ndev, u8 pipe,
 			goto exit;
 		}
 		delete_info = (struct nci_hci_delete_pipe_noti *)skb->data;
+		if (delete_info->pipe >= NCI_HCI_MAX_PIPES) {
+			status = NCI_HCI_ANY_E_NOK;
+			goto exit;
+		}
 
 		ndev->hci_dev->pipes[delete_info->pipe].gate =
 						NCI_HCI_INVALID_GATE;
-- 
2.20.1



