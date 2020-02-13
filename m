Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F4415C320
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgBMP2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgBMP2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:09 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37CC3222C2;
        Thu, 13 Feb 2020 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607689;
        bh=V/uEaGsWAFBfL2iBVKhVAzWuFzZTXBtLPUQib+bCOjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJvmktKl29/dEVHb5q3tIkkC5oQqWsPXeIzbXjRbP0vw2+FQQib/5XDTKahDPUNP+
         gq81H1B0X/SZC6pfSUnEZWUf8C2gc3AahKzPCtzPD5iK8CwZNc1n+DrGlFZ1FUa1IE
         nc15/XDEZzUe5qQ83KnzMCsLCdy796B7PqoBye7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 026/120] netfilter: flowtable: Fix missing flush hardware on table free
Date:   Thu, 13 Feb 2020 07:20:22 -0800
Message-Id: <20200213151911.038632666@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

commit 0f34f30a1be80f3f59efeaab596396bc698e7337 upstream.

If entries exist when freeing a hardware offload enabled table,
we queue work for hardware while running the gc iteration.

Execute it (flush) after queueing.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -553,6 +553,7 @@ void nf_flow_table_free(struct nf_flowta
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);


