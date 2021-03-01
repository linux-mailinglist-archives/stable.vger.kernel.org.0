Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E6A328385
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235389AbhCAQVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:21:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237783AbhCAQTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:19:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C521C64EBE;
        Mon,  1 Mar 2021 16:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615447;
        bh=HD8zoycEz+avgQXZPfOseUSnSMHTUb6/F9Ww9RKB07M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zyzi8gKrE4jdX3asYnyH6V9IuX9QSIu83vZ+ndctXwMO2aYb6B7EjAJCrPz7iYNtK
         lsV2Re/0OliePbxTG83OAHN0ca3j8zIT7/HPwT5nX6ir3I73oyWdz1emlVmLtWGI48
         FLzFl4W5GXEwNIDWxb9rZHrKrxwDRmLBjOJaBAds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 33/93] jffs2: fix use after free in jffs2_sum_write_data()
Date:   Mon,  1 Mar 2021 17:12:45 +0100
Message-Id: <20210301161008.543271476@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 19646447ad3a680d2ab08c097585b7d96a66126b ]

clang static analysis reports this problem

fs/jffs2/summary.c:794:31: warning: Use of memory after it is freed
                c->summary->sum_list_head = temp->u.next;
                                            ^~~~~~~~~~~~

In jffs2_sum_write_data(), in a loop summary data is handles a node at
a time.  When it has written out the node it is removed the summary list,
and the node is deleted.  In the corner case when a
JFFS2_FEATURE_RWCOMPAT_COPY is seen, a call is made to
jffs2_sum_disable_collecting().  jffs2_sum_disable_collecting() deletes
the whole list which conflicts with the loop's deleting the list by parts.

To preserve the old behavior of stopping the write midway, bail out of
the loop after disabling summary collection.

Fixes: 6171586a7ae5 ("[JFFS2] Correct handling of JFFS2_FEATURE_RWCOMPAT_COPY nodes.")
Signed-off-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jffs2/summary.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index bc5385471a6e3..c05d6f5f10ecd 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -783,6 +783,8 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 					dbg_summary("Writing unknown RWCOMPAT_COPY node type %x\n",
 						    je16_to_cpu(temp->u.nodetype));
 					jffs2_sum_disable_collecting(c->summary);
+					/* The above call removes the list, nothing more to do */
+					goto bail_rwcompat;
 				} else {
 					BUG();	/* unknown node in summary information */
 				}
@@ -794,6 +796,7 @@ static int jffs2_sum_write_data(struct jffs2_sb_info *c, struct jffs2_eraseblock
 
 		c->summary->sum_num--;
 	}
+ bail_rwcompat:
 
 	jffs2_sum_reset_collected(c->summary);
 
-- 
2.27.0



