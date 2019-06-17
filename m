Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2F049416
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFQVfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:35:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbfFQVWn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:22:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68E2D20673;
        Mon, 17 Jun 2019 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806562;
        bh=xAd0l4WamYl1Zv3TSZdd9NxnwWlSdcbYomFJUMpZK8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxYtrX1/veFlF4SKzVAVvK+bBYECEAUk9KmM1IHKNvG+xDgDjNoJDq1VQxj+jGu3j
         R11KMZrjx3rc1BZibk4XH2GcuOEZIahQ+wI1EIWPPwmXjcGF+DPElf9S7CfYA0d4tE
         wcWbzFypJFwx5E7KPcSN6apz2xeVn/3CDqMtOqKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 050/115] bpf: sockmap remove duplicate queue free
Date:   Mon, 17 Jun 2019 23:09:10 +0200
Message-Id: <20190617210803.036791634@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c42253cc88206fd0e9868c8b2fd7f9e79f9e0e03 ]

In tcp bpf remove we free the cork list and purge the ingress msg
list. However we do this before the ref count reaches zero so it
could be possible some other access is in progress. In this case
(tcp close and/or tcp_unhash) we happen to also hold the sock
lock so no path exists but lets fix it otherwise it is extremely
fragile and breaks the reference counting rules. Also we already
check the cork list and ingress msg queue and free them once the
ref count reaches zero so its wasteful to check twice.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 1bb7321a256d..4a619c85daed 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -528,8 +528,6 @@ static void tcp_bpf_remove(struct sock *sk, struct sk_psock *psock)
 {
 	struct sk_psock_link *link;
 
-	sk_psock_cork_free(psock);
-	__sk_psock_purge_ingress_msg(psock);
 	while ((link = sk_psock_link_pop(psock))) {
 		sk_psock_unlink(sk, link);
 		sk_psock_free_link(link);
-- 
2.20.1



