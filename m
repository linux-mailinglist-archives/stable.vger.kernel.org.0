Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD0F29BC4D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1800531AbgJ0Prm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796499AbgJ0PTD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB3B20728;
        Tue, 27 Oct 2020 15:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811943;
        bh=loz4kIDn+GzYB9P3fO67P3PfQJR2mDJQ+e1NHoQGLDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbGKdI+cqDAUEl7ZXD+TB+UoaI/TbkI8h0e6+P2jhn/HyPaWM1Rcglc5glUVjV6R2
         uI3lRYmdJqK+NscZ88kB7bqGyaZQyhL+K2vK/LqRNpE5hzZsSVqSdwZSdEsWRRnUum
         RObcKcbZWzMtn/E8D4Cm3+nkAvZE30Fzd4tLEEZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 036/757] chelsio/chtls: fix writing freed memory
Date:   Tue, 27 Oct 2020 14:44:46 +0100
Message-Id: <20201027135452.216216555@linuxfoundation.org>
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

[ Upstream commit da1a039bcf293e4699d413c9f65d975da2d7c0bd ]

When chtls_sock *csk is freed, same memory can be allocated
to different csk in chtls_sock_create().
csk->cdev = NULL; statement might ends up modifying wrong
csk, eventually causing kernel panic.
removing (csk->cdev = NULL) statement as it is not required.

Fixes: 3a0a97838923 ("crypto/chtls: Fix chtls crash in connection cleanup")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_cm.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -483,7 +483,6 @@ void chtls_destroy_sock(struct sock *sk)
 	chtls_purge_write_queue(sk);
 	free_tls_keyid(sk);
 	kref_put(&csk->kref, chtls_sock_release);
-	csk->cdev = NULL;
 	if (sk->sk_family == AF_INET)
 		sk->sk_prot = &tcp_prot;
 #if IS_ENABLED(CONFIG_IPV6)


