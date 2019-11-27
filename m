Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38B5910BC5F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732341AbfK0VIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:08:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732372AbfK0VIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:08:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 737D7217AB;
        Wed, 27 Nov 2019 21:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888917;
        bh=uvt2WQjL5phocKrW0Vmhg9IwDtK91eFaxGgWTLnWtMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRa3xPZiR6NJD79BjnMRntm7GWNYyT64o0vx8euvjeGgcIgGQCdWD325AcHj/HVVF
         UrAv6U92uq86i1tXhRjVex42n1P81YuCUuyI0Ih+9fd8XTFte2HkpjvOsLAc69HRWu
         AoaKJP0lL4dQyFCS3Y5eadQQhRF0Sa78Hbng0Vhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matteo Croce <mcroce@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 14/95] net/ipv4: fix sysctl max for fib_multipath_hash_policy
Date:   Wed, 27 Nov 2019 21:31:31 +0100
Message-Id: <20191127202850.142663505@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
References: <20191127202845.651587549@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit ca749bbb108c24a876014c804f9777c545be4d59 ]

Commit eec4844fae7c ("proc/sysctl: add shared variables for range
check") did:
-               .extra2         = &two,
+               .extra2         = SYSCTL_ONE,
here, which doesn't seem to be intentional, given the changelog.
This patch restores it to the previous, as the value of 2 still makes
sense (used in fib_multipath_hash()).

Fixes: eec4844fae7c ("proc/sysctl: add shared variables for range check")
Cc: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/sysctl_net_ipv4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -1028,7 +1028,7 @@ static struct ctl_table ipv4_net_table[]
 		.mode		= 0644,
 		.proc_handler	= proc_fib_multipath_hash_policy,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
+		.extra2		= &two,
 	},
 #endif
 	{


