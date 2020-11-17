Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484902B63E8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732739AbgKQNmJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733296AbgKQNmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20BBA206A5;
        Tue, 17 Nov 2020 13:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620527;
        bh=NjCrRT7NQpR+T1B/ZPxeHmAwSPceOVcqkABRxGxIU4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cq1Nmk3yLkLZYlTGqMtfKC+Gb0A+igvdjpXQesq9HGXsr3P/JAHc9q95Yn90LpaeI
         rbKbxDCBCYnZ4qYGT39+teBEaDt42Ku4ESRrGx7ukxG5FTMDoI6EET8PrrJsf5D3d5
         RBkvPZuB11So2MWsRT0VZJ+qCsA/bsn1R24GNXZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 248/255] mptcp: provide rmem[0] limit
Date:   Tue, 17 Nov 2020 14:06:28 +0100
Message-Id: <20201117122151.000605205@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 989ef49bdf100cc772b3a8737089df36b1ab1e30 ]

The mptcp proto struct currently does not provide the
required limit for forward memory scheduling. Under
pressure sk_rmem_schedule() will unconditionally try
to use such field and will oops.

Address the issue inheriting the tcp limit, as we already
do for the wmem one.

Fixes: 9c3f94e1681b ("mptcp: add missing memory scheduling in the rx path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Link: https://lore.kernel.org/r/37af798bd46f402fb7c79f57ebbdd00614f5d7fa.1604861097.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2122,6 +2122,7 @@ static struct proto mptcp_prot = {
 	.memory_pressure	= &tcp_memory_pressure,
 	.stream_memory_free	= mptcp_memory_free,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
+	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_rmem),
 	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.slab_flags	= SLAB_TYPESAFE_BY_RCU,


