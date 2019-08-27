Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE1D9DF3E
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbfH0Hwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:52:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729487AbfH0Hwf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:52:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832972173E;
        Tue, 27 Aug 2019 07:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892354;
        bh=V1T2FamzhMWmbIN+x5SXn0ar1Ks6oD9mnMmDqzKgv44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BvVJSTDneWC6SgqDOiMuSqlZRmOBkdQ2WBOJ07y3dpaaunOCeGgsP5v+zkqborbp
         cGSRuLiu/eihrx+8zI86wEf6ZDjc5xSY98SWKisZUFDsBZPlmXwGy6xQmmACTvANfZ
         jnHyD1AXymkLIY124xiJwuveoW1gUzS2kZ778zP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/62] st21nfca_connectivity_event_received: null check the allocation
Date:   Tue, 27 Aug 2019 09:50:14 +0200
Message-Id: <20190827072700.876426554@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072659.803647352@linuxfoundation.org>
References: <20190827072659.803647352@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9891d06836e67324c9e9c4675ed90fc8b8110034 ]

devm_kzalloc may fail and return null. So the null check is needed.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st21nfca/se.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 3a98563d4a121..eac608a457f03 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -326,6 +326,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 
 		transaction = (struct nfc_evt_transaction *)devm_kzalloc(dev,
 						   skb->len - 2, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
 		memcpy(transaction->aid, &skb->data[2],
-- 
2.20.1



