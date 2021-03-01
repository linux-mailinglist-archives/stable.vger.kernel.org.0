Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84827328D67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbhCATK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:10:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240843AbhCATGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:06:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC898614A5;
        Mon,  1 Mar 2021 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620833;
        bh=+nZLZ+8DU1bB546hofKiUfN1z70R/SeU+DeYtpUD6Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y29M4497lOiWsJpEjijhrC27iqvoq8W9b9zBLGDQH3KpAwkVejNu+0uMUldGPqjHV
         zhVTa4fDCrOdqh0Mk3Cru30t+Z1owjyScQmhDcnTzHtTrocnGSTyDggPNDnlju5Pg8
         C3ANArrjvsRrTNWONn0nAx8YWfD5DtNyKpcxC9jM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 295/775] jffs2: fix use after free in jffs2_sum_write_data()
Date:   Mon,  1 Mar 2021 17:07:43 +0100
Message-Id: <20210301161216.199541359@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index be7c8a6a57480..4fe64519870f1 100644
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



