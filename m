Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C340B29C498
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757338AbgJ0OSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:18:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757337AbgJ0OSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:18:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97F60206D4;
        Tue, 27 Oct 2020 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808326;
        bh=s4HhutJ7GBYO40cNmW6cPL7BjTXimIXpfL6vkdYyAvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjBOgGA20VQqfrGYxJccdW++vpuRadg35cUhQDg4jHremEWxFG3F03gwvcBWDO1v+
         08CcJ8xRuIuK6DUwu2F/ekO1oCb/ZRoXBI3NmPA93P9Rse1B0Z2S0LbiX8PTctr00/
         RznfxwUb455jJ+j3ocxzVJCPWZJYLIUHxQZgkzNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 018/264] chelsio/chtls: correct function return and return type
Date:   Tue, 27 Oct 2020 14:51:16 +0100
Message-Id: <20201027135431.522408687@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
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
@@ -914,9 +914,9 @@ static int tls_header_read(struct tls_hd
 	return (__force int)cpu_to_be16(thdr->length);
 }
 
-static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
+static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
 {
-	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
+	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
 }
 
 static int csk_wait_memory(struct chtls_dev *cdev,


