Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6377B198FA6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgCaJE6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:04:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731019AbgCaJE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:04:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B42820787;
        Tue, 31 Mar 2020 09:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645497;
        bh=wx3fU5kf1GTuk5yaEKKJV+I0NEdDEdfUh2fN2C8mgCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1XHMwBvbuVJiTg/r/TgpYeYTCxlFASeN5yGpFjnLa/naOgScAynic0K7/WxACMyx
         TqgrhHuhct4aU8gtlyqf1nDD873C3kAy2KDiLkPVlmANfDHrGO6UxDOzGvP0CHh1iv
         Tkhx5/vN24lcsceA2V8xffLlDzlv2eyVCxNkDIZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 033/170] NFC: fdp: Fix a signedness bug in fdp_nci_send_patch()
Date:   Tue, 31 Mar 2020 10:57:27 +0200
Message-Id: <20200331085427.574778203@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085423.990189598@linuxfoundation.org>
References: <20200331085423.990189598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0dcdf9f64028ec3b75db6b691560f8286f3898bf ]

The nci_conn_max_data_pkt_payload_size() function sometimes returns
-EPROTO so "max_size" needs to be signed for the error handling to
work.  We can make "payload_size" an int as well.

Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nfc/fdp/fdp.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -184,7 +184,7 @@ static int fdp_nci_send_patch(struct nci
 	const struct firmware *fw;
 	struct sk_buff *skb;
 	unsigned long len;
-	u8 max_size, payload_size;
+	int max_size, payload_size;
 	int rc = 0;
 
 	if ((type == NCI_PATCH_TYPE_OTP && !info->otp_patch) ||
@@ -207,8 +207,7 @@ static int fdp_nci_send_patch(struct nci
 
 	while (len) {
 
-		payload_size = min_t(unsigned long, (unsigned long) max_size,
-				     len);
+		payload_size = min_t(unsigned long, max_size, len);
 
 		skb = nci_skb_alloc(ndev, (NCI_CTRL_HDR_SIZE + payload_size),
 				    GFP_KERNEL);


