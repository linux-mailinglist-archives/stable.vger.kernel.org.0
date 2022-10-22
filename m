Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2407C608982
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234204AbiJVIgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234514AbiJVIfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B71491C2;
        Sat, 22 Oct 2022 01:04:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E871C60B8C;
        Sat, 22 Oct 2022 08:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF183C433D6;
        Sat, 22 Oct 2022 08:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425869;
        bh=TlFvzsGM4Nex1avejFrjzErcNggEJVizUEc0EWbwmEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCWCIZbJ+BfSgD1rMQ04suN/eiJXWuZkubvyS7BPtr6Rboo+9fv6zH+b7Nqzq3G8O
         Iw4vdUitwmN5jqx9fUuSsSVyla6D2OedR1qa0estQD8++GplGKc0Q9qQaVFXoGGrl/
         iPSvNSKxgZHVP3sACh3MI6Ne6sKLel5qtiHR/UjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 642/717] btrfs: dump extra info if one free space cache has more bitmaps than it should
Date:   Sat, 22 Oct 2022 09:28:41 +0200
Message-Id: <20221022072526.841385048@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 62cd9d4474282a1eb84f945955c56cbfc42e1ffe ]

There is an internal report on hitting the following ASSERT() in
recalculate_thresholds():

 	ASSERT(ctl->total_bitmaps <= max_bitmaps);

Above @max_bitmaps is calculated using the following variables:

- bytes_per_bg
  8 * 4096 * 4096 (128M) for x86_64/x86.

- block_group->length
  The length of the block group.

@max_bitmaps is the rounded up value of block_group->length / 128M.

Normally one free space cache should not have more bitmaps than above
value, but when it happens the ASSERT() can be triggered if
CONFIG_BTRFS_ASSERT is also enabled.

But the ASSERT() itself won't provide enough info to know which is going
wrong.
Is the bg too small thus it only allows one bitmap?
Or is there something else wrong?

So although I haven't found extra reports or crash dump to do further
investigation, add the extra info to make it more helpful to debug.

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index b1ae3ba2ca2c..16710d4571da 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -693,6 +693,12 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
 
 	max_bitmaps = max_t(u64, max_bitmaps, 1);
 
+	if (ctl->total_bitmaps > max_bitmaps)
+		btrfs_err(block_group->fs_info,
+"invalid free space control: bg start=%llu len=%llu total_bitmaps=%u unit=%u max_bitmaps=%llu bytes_per_bg=%llu",
+			  block_group->start, block_group->length,
+			  ctl->total_bitmaps, ctl->unit, max_bitmaps,
+			  bytes_per_bg);
 	ASSERT(ctl->total_bitmaps <= max_bitmaps);
 
 	/*
-- 
2.35.1



