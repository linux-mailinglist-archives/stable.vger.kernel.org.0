Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C255915C200
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgBMP2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbgBMP2J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:09 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95D352168B;
        Thu, 13 Feb 2020 15:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607688;
        bh=vy9wzLAXtpu/XTVoeNZRrmp6y35QIRVEViTmeL54EUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OeiHVwuTi9yAQQjVFLdKANevmisHzTYEOjf6464lIZYKHwAR+vgypEH9S6Mqy76fw
         p6UxUTCwwJyI1hNaKNvt910fbM+0M8Djt0YmWs0x6aGop8Isa/VsI/uSQSdthr3gCN
         7o2FmVJhSeXSKw1McqZYA0kzze6TknS7vDP7HWcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 025/120] netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup
Date:   Thu, 13 Feb 2020 07:20:21 -0800
Message-Id: <20200213151910.704317780@linuxfoundation.org>
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

commit 91bfaa15a379e9af24f71fb4ee08d8019b6e8ec7 upstream.

On netdev down event, nf_flow_table_cleanup() is called for the relevant
device and it cleans all the tables that are on that device.
If one of those tables has hardware offload flag,
nf_flow_table_iterate_cleanup flushes hardware and then runs the gc.
But the gc can queue more hardware work, which will take time to execute.

Instead first add the work, then flush it, to execute it now.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -529,9 +529,9 @@ static void nf_flow_table_do_cleanup(str
 static void nf_flow_table_iterate_cleanup(struct nf_flowtable *flowtable,
 					  struct net_device *dev)
 {
-	nf_flow_table_offload_flush(flowtable);
 	nf_flow_table_iterate(flowtable, nf_flow_table_do_cleanup, dev);
 	flush_delayed_work(&flowtable->gc_work);
+	nf_flow_table_offload_flush(flowtable);
 }
 
 void nf_flow_table_cleanup(struct net_device *dev)


