Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2908629B168
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759349AbgJ0O32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759344AbgJ0O31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:29:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2711920780;
        Tue, 27 Oct 2020 14:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808966;
        bh=dgnReUdtBDcIP1IBHLRt3DrRREzsidnhwYoX60Ioi/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBE2yuxgfuWosMOoC8nFvXBa4WPv2JcQjFrp+SkBeOsSZ5vLLJpgTZFvrIe0WNho3
         YexGpEhrBYSl+fkVdWDj7dA3W2JcjDIOAEzdKr0Owlw+KRHrNIq4ilfei7ohF1w6xZ
         RKvvsf945aKsPV3gyjgUYsTB4V6Ic2tVLSxjpbGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 027/408] chelsio/chtls: correct function return and return type
Date:   Tue, 27 Oct 2020 14:49:25 +0100
Message-Id: <20201027135456.320051027@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
@@ -910,9 +910,9 @@ static int tls_header_read(struct tls_hd
 	return (__force int)cpu_to_be16(thdr->length);
 }
 
-static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
+static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
 {
-	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
+	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
 }
 
 static int csk_wait_memory(struct chtls_dev *cdev,


