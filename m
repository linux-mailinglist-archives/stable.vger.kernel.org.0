Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C2D2C9CE3
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbgLAJFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388682AbgLAJDf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:03:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76738221FF;
        Tue,  1 Dec 2020 09:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813374;
        bh=Scz38dnR4gJ0WuJMAyZh3aBCli6RZcn+0DVfQoLpgcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMK9P92PxABfX2pXINL9LhFFJcIfV2Cm6mnspToGaYgPbqeV9yeXt03yW4lIf9vgF
         pfuYu1XBNxCoV7H8jMhOA/uxNFoUb6LBX44ubFv2nbPwrIp0g30Xmf505+23xiR9oc
         ZJsp25U/2LeoLhVFq/AevVh9+KCjVTqne2r1LyoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Hui Su <sh_def@163.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 18/98] trace: fix potenial dangerous pointer
Date:   Tue,  1 Dec 2020 09:52:55 +0100
Message-Id: <20201201084655.044007495@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Su <sh_def@163.com>

commit fdeb17c70c9ecae655378761accf5a26a55a33cf upstream.

The bdi_dev_name() returns a char [64], and
the __entry->name is a char [32].

It maybe dangerous to TP_printk("%s", __entry->name)
after the strncpy().

CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201124165205.GA23937@rlk
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/events/writeback.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -192,7 +192,7 @@ TRACE_EVENT(inode_foreign_history,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name, bdi_dev_name(inode_to_bdi(inode)), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(inode_to_bdi(inode)), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->cgroup_ino	= __trace_wbc_assign_cgroup(wbc);
 		__entry->history	= history;
@@ -221,7 +221,7 @@ TRACE_EVENT(inode_switch_wbs,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,	bdi_dev_name(old_wb->bdi), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(old_wb->bdi), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->old_cgroup_ino	= __trace_wb_assign_cgroup(old_wb);
 		__entry->new_cgroup_ino	= __trace_wb_assign_cgroup(new_wb);
@@ -254,7 +254,7 @@ TRACE_EVENT(track_foreign_dirty,
 		struct address_space *mapping = page_mapping(page);
 		struct inode *inode = mapping ? mapping->host : NULL;
 
-		strncpy(__entry->name,	bdi_dev_name(wb->bdi), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->bdi_id		= wb->bdi->id;
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
@@ -287,7 +287,7 @@ TRACE_EVENT(flush_foreign,
 	),
 
 	TP_fast_assign(
-		strncpy(__entry->name,	bdi_dev_name(wb->bdi), 32);
+		strscpy_pad(__entry->name, bdi_dev_name(wb->bdi), 32);
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
 		__entry->frn_bdi_id	= frn_bdi_id;
 		__entry->frn_memcg_id	= frn_memcg_id;


