Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE9C5783A
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727746AbfF0AdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfF0AdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:33:22 -0400
Received: from localhost (unknown [116.247.127.123])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75CCC217D9;
        Thu, 27 Jun 2019 00:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595601;
        bh=xXYNxkrdAJoh7I8KtJoyAJXR98LmJC9kPZlCwSw0jQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NvE5XP6B1HTMBdlSrh3BpLKO+41NWESyuVfa+YDuXpZVCwYT6u+QJiQLJ7xWfOOTc
         uH6Dy+3C88zhpJzWfwaqiBj5jL7oCa+Nxdn04aY0rPmS3gaUh5ecYejyQ23VS/RY4N
         aux+2VJfCB2PkQ6rPRce6ts9Euw+Y8onPTeGQ9JY=
Date:   Thu, 27 Jun 2019 08:33:13 +0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.14.131
Message-ID: <20190627003313.GB10859@kroah.com>
References: <20190627003306.GA10859@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190627003306.GA10859@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9d0715c300b1..275343cf27f7 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 130
+SUBLEVEL = 131
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a8772e11dc1c..a5960b9b6741 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1274,7 +1274,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf + 0x20000)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
