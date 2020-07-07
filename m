Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77803217013
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgGGPOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbgGGPOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:14:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D9F207C4;
        Tue,  7 Jul 2020 15:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594134880;
        bh=gD03nvGzSUO+Oo71OUhqcW4bS147QATjZu1+N0L9dtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OrIKRkeyvc6o5+EHMa1dhd+1KcySyPH79iaTDTixjpVZ4xW/aAUZzTQYfa3JjvpU+
         WlYE/S7biE5U92ITONyKhKsoPDC+lyVNPSJF8d6Bz93SYMHH/rGG056J3p3fGlSq2n
         Sqn+hfIkXWCSWgrK3LibOAPEq1KtprcnqZ5aUqrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH 4.9 23/24] netfilter: nf_conntrack_h323: lost .data_len definition for Q.931/ipv6
Date:   Tue,  7 Jul 2020 17:13:55 +0200
Message-Id: <20200707145750.096259233@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145748.952502272@linuxfoundation.org>
References: <20200707145748.952502272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

Could you please push this patch into stable@?
it fixes memory corruption in kernels  v3.5 .. v4.10

Lost .data_len definition leads to write beyond end of
struct nf_ct_h323_master. Usually it corrupts following
struct nf_conn_nat, however if nat is not loaded it corrupts
following slab object.

In mainline this problem went away in v4.11,
after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
for inkernel helpers") however many stable kernels are still affected.

Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data") # v3.5
cc: stable@vger.kernel.org
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_h323_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1225,6 +1225,7 @@ static struct nf_conntrack_helper nf_con
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
+		.data_len		= sizeof(struct nf_ct_h323_master),
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,


