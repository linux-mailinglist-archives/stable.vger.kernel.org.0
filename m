Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378E14F4EB
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 11:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbfFVJrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 05:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbfFVJrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Jun 2019 05:47:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2A0F2084E;
        Sat, 22 Jun 2019 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561196824;
        bh=G1ozgte4xHm62Ls6xJ72+iAnWeHOdUhZJ/jiTj4t4EI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0cxu1rDVa4bFwItScvxUjTrTa60MCL66lLav5+Hpc/WvYzcmbBgfQsyai8+M1zX3l
         q/lD+kliEk2mIFTni/rTtsxqcj63P9u3Nk0SKvL6cDRxFQCTFV+5/1Oxmy2UTin+Zt
         dpYiNSV4/nAgMIAYk0j75APAyxogunReyv7sFAZs=
Date:   Sat, 22 Jun 2019 11:47:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.19.55
Message-ID: <20190622094701.GB12459@kroah.com>
References: <20190622094654.GA12459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190622094654.GA12459@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index b234837e4d07..3addd4c286fa 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 54
+SUBLEVEL = 55
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 147ed82b73d3..221d9b72423b 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1299,7 +1299,8 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
+		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
