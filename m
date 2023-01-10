Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BC8664845
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbjAJSKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239027AbjAJSJ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:09:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3312417E16
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1074B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45988C433D2;
        Tue, 10 Jan 2023 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374049;
        bh=UmmP9nAoiVGcDPOobEbHkraUxstIymo9uKKeIwU19sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YFhnoGLFEHyEPxcruhdykdxWCVdHQ3bDh0EHHu3+GjNTkhm7iOTDO7qy0DScejAt
         OZfTB5TyafGEsa3YBBTrwCiX9AaUBBdDtszQDlKJkNAvk0JYgAXwU58CLoa+uL9oEI
         ffQLG9vHSa0R0s5JTqfEwJHYA6wmCsLGWO4jl3u8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 012/148] btrfs: fix an error handling path in btrfs_defrag_leaves()
Date:   Tue, 10 Jan 2023 19:01:56 +0100
Message-Id: <20230110180017.571096489@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit db0a4a7b8e95f9312a59a67cbd5bc589f090e13d ]

All error handling paths end to 'out', except this memory allocation
failure.

This is spurious. So branch to the error handling path also in this case.
It will add a call to:

	memset(&root->defrag_progress, 0,
	       sizeof(root->defrag_progress));

Fixes: 6702ed490ca0 ("Btrfs: Add run time btree defrag, and an ioctl to force btree defrag")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-defrag.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index b6cf39f4e7e4..072ab9a1374b 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -31,8 +31,10 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	level = btrfs_header_level(root->node);
 
-- 
2.35.1



