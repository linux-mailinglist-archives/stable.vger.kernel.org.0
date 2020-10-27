Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A31E29B36C
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766543AbgJ0OtM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766534AbgJ0OtL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59B83206E5;
        Tue, 27 Oct 2020 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810150;
        bh=loz4kIDn+GzYB9P3fO67P3PfQJR2mDJQ+e1NHoQGLDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfrtFS54YirsU1mBPPLlTwMRYFxb2gT0irFfwL8+GgqGbhUcAiKOYkXqrKuRQF0lF
         A1cOws+jy1sDx2WLtxyBbzMdcw0wcaYwcV8lcEBR/X+XO5FyqVRjlkRmIcWcRMBhqU
         MK9CqKR1lWR9iZPCMhvOXuOGUcU5W5QFvSwojfns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 037/633] chelsio/chtls: fix writing freed memory
Date:   Tue, 27 Oct 2020 14:46:20 +0100
Message-Id: <20201027135524.440215005@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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


