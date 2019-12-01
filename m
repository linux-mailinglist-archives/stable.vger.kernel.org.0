Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C8010E136
	for <lists+stable@lfdr.de>; Sun,  1 Dec 2019 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfLAJkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Dec 2019 04:40:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfLAJkc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Dec 2019 04:40:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90B14215E5;
        Sun,  1 Dec 2019 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575193232;
        bh=5EY1sW0MiN3lDuLHMeoWRMVH5cH+T5WoBWJmM6+GYv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IS52tGF0og0OxGOwsgJfMANM0pm+gw3abmi57M3wydx4cGZDKM4xeuQHh+ExALB8P
         O6gb7p6gbNwGA2KH/Gm1/b9eSS7Mgyw/kjsXPERnpSG4dUUF64F4WJWCC6yoYhEc5e
         C+RY+39V2+IVhNWHfkbJ+bfweUBc4317iOun/2HU=
Date:   Sun, 1 Dec 2019 10:40:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.9.205
Message-ID: <20191201094029.GB3788378@kroah.com>
References: <20191201094024.GA3788378@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191201094024.GA3788378@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 0234869784fa..fc1a58ef7e56 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 4
 PATCHLEVEL = 9
-SUBLEVEL = 204
+SUBLEVEL = 205
 EXTRAVERSION =
 NAME = Roaring Lionus
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 9178c1654375..d22493351407 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -945,12 +945,10 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 			ret = -EPERM;
-		} else if (val != sk->sk_mark) {
+		else
 			sk->sk_mark = val;
-			sk_dst_reset(sk);
-		}
 		break;
 
 	case SO_RXQ_OVFL:
