Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1916129B7D1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1796497AbgJ0PTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796491AbgJ0PTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC85A2064B;
        Tue, 27 Oct 2020 15:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811940;
        bh=8e0KLTFeI2WkNdLJIotItsFVR3JYYKl61qFB5qUwZqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IxY4w59ZpKyGZg57Z931VUwOhYJc9wdFNgjrx/tzzN3S84OFT1X3CHEsIfLUReJ8b
         W9ajEwyrxBRZKBRDfJXRjh1q+EFbIbIxm1GI+QDO1YXJB5f+pgVCEvBpLcvuDvwpvP
         qupmQRofzPcaZWbx0uaSG3sFo48U8zcFICHflrb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 035/757] chelsio/chtls: correct function return and return type
Date:   Tue, 27 Oct 2020 14:44:45 +0100
Message-Id: <20201027135452.172113304@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 8580a61aede28d441e1c80588803411ee86aa299 ]

csk_mem_free() should return true if send buffer is available,
false otherwise.

Fixes: 3b8305f5c844 ("crypto: chtls - wait for memory sendmsg, sendpage")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -902,9 +902,9 @@ static int chtls_skb_copy_to_page_nocach
 	return 0;
 }
 
-static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
+static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
 {
-	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
+	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
 }
 
 static int csk_wait_memory(struct chtls_dev *cdev,


