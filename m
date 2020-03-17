Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9FE18807D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgCQLKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbgCQLKg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:10:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC6F6206EC;
        Tue, 17 Mar 2020 11:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443436;
        bh=xeDGOU2FzIkIfmHeFajp1/GXc4arIXOD6z80Adr3VcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDNrUBv1XyhRuT82cfstd/M1Dlk8tMXFqUeX/Z6D5cqAZzbgT7RnPH2mXElQVSqdm
         ecvxv+PGhYA92R3vg4w2xtM2QOoZR3uoz6kVhOk6RcFrnUpXWRiVMC12HlZa9DULG3
         fDw0VqaAvBy8cApxQUvADEgctV3s5j5OPxhz5QUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.5 082/151] netfilter: x_tables: xt_mttg_seq_next should increase position index
Date:   Tue, 17 Mar 2020 11:54:52 +0100
Message-Id: <20200317103332.287954009@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

commit ee84f19cbbe9cf7cba2958acb03163fed3ecbb0f upstream.

If .next function does not change position index,
following .show function will repeat output related
to current position index.

Without patch:
 # dd if=/proc/net/ip_tables_matches  # original file output
 conntrack
 conntrack
 conntrack
 recent
 recent
 icmp
 udplite
 udp
 tcp
 0+1 records in
 0+1 records out
 65 bytes copied, 5.4074e-05 s, 1.2 MB/s

 # dd if=/proc/net/ip_tables_matches bs=62 skip=1
 dd: /proc/net/ip_tables_matches: cannot skip to specified offset
 cp   <<< end of  last line
 tcp  <<< and then unexpected whole last line once again
 0+1 records in
 0+1 records out
 7 bytes copied, 0.000102447 s, 68.3 kB/s

Cc: stable@vger.kernel.org
Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code ...")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/x_tables.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1551,6 +1551,9 @@ static void *xt_mttg_seq_next(struct seq
 	uint8_t nfproto = (unsigned long)PDE_DATA(file_inode(seq->file));
 	struct nf_mttg_trav *trav = seq->private;
 
+	if (ppos != NULL)
+		++(*ppos);
+
 	switch (trav->class) {
 	case MTTG_TRAV_INIT:
 		trav->class = MTTG_TRAV_NFP_UNSPEC;
@@ -1576,9 +1579,6 @@ static void *xt_mttg_seq_next(struct seq
 	default:
 		return NULL;
 	}
-
-	if (ppos != NULL)
-		++*ppos;
 	return trav;
 }
 


