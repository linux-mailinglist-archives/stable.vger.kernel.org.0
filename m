Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8D6B49E5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjCJPQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:16:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbjCJPQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:16:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F7513D1E1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:07:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEFB5B822DE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3628BC433EF;
        Fri, 10 Mar 2023 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460785;
        bh=BEzS6ZKP3APJpV2OTupwswSSJhdFKbbwtdlWTisIMlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwTeqBlY9pcpXeiJT7FxmTvwKuJAvEOVgZ3gnqmTaewdJ0fd3TZ+D0aptsnbcYycT
         E6PHeZI6EuO8cxkBbq1eC8OZJKRs3DM8or+HGXPfGX1weu4fPrMkQ3lMGpeBLhjjDx
         n1fRnJot9RRi643lI0Wy5nDECCNMuKlyz0X1TiJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhihao Cheng <chengzhihao1@huawei.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/529] ubifs: Re-statistic cleaned znode count if commit failed
Date:   Fri, 10 Mar 2023 14:39:54 +0100
Message-Id: <20230310133825.789098922@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 944e096aa24071d3fe22822f6249d3ae309e39ea ]

Dirty znodes will be written on flash in committing process with
following states:

	      process A			|  znode state
------------------------------------------------------
do_commit				| DIRTY_ZNODE
  ubifs_tnc_start_commit		| DIRTY_ZNODE
   get_znodes_to_commit			| DIRTY_ZNODE | COW_ZNODE
    layout_commit			| DIRTY_ZNODE | COW_ZNODE
     fill_gap                           | 0
  write master				| 0 or OBSOLETE_ZNODE

	      process B			|  znode state
------------------------------------------------------
do_commit				| DIRTY_ZNODE[1]
  ubifs_tnc_start_commit		| DIRTY_ZNODE
   get_znodes_to_commit			| DIRTY_ZNODE | COW_ZNODE
  ubifs_tnc_end_commit			| DIRTY_ZNODE | COW_ZNODE
   write_index                          | 0
  write master				| 0 or OBSOLETE_ZNODE[2] or
					| DIRTY_ZNODE[3]

[1] znode is dirtied without concurrent committing process
[2] znode is copied up (re-dirtied by other process) before cleaned
    up in committing process
[3] znode is re-dirtied after cleaned up in committing process

Currently, the clean znode count is updated in free_obsolete_znodes(),
which is called only in normal path. If do_commit failed, clean znode
count won't be updated, which triggers a failure ubifs assertion[4] in
ubifs_tnc_close():
 ubifs_assert_failed [ubifs]: UBIFS assert failed: freed == n

[4] Commit 380347e9ca7682 ("UBIFS: Add an assertion for clean_zn_cnt").

Fix it by re-statisticing cleaned znode count in tnc_destroy_cnext().

Fetch a reproducer in [Link].

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216704
Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/tnc.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 894f1ab14616e..7c36b66774301 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -3053,6 +3053,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
 		cnext = cnext->cnext;
 		if (ubifs_zn_obsolete(znode))
 			kfree(znode);
+		else if (!ubifs_zn_cow(znode)) {
+			/*
+			 * Don't forget to update clean znode count after
+			 * committing failed, because ubifs will check this
+			 * count while closing tnc. Non-obsolete znode could
+			 * be re-dirtied during committing process, so dirty
+			 * flag is untrustable. The flag 'COW_ZNODE' is set
+			 * for each dirty znode before committing, and it is
+			 * cleared as long as the znode become clean, so we
+			 * can statistic clean znode count according to this
+			 * flag.
+			 */
+			atomic_long_inc(&c->clean_zn_cnt);
+			atomic_long_inc(&ubifs_clean_zn_cnt);
+		}
 	} while (cnext && cnext != c->cnext);
 }
 
-- 
2.39.2



