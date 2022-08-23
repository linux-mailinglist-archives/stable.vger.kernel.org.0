Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543E959D54A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243370AbiHWI1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244207AbiHWI0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:26:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E6A72FD4;
        Tue, 23 Aug 2022 01:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF24BB81C26;
        Tue, 23 Aug 2022 08:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EDBC433C1;
        Tue, 23 Aug 2022 08:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242422;
        bh=1R4vBcGtvywwK6mm74BckJoc44zv4MEOsFxv7R4miYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvkVtz83tox0/kM20mpb2XrSGGUJTaI5eQkqyg6prJLRHHz4Y6bTxHOM2eB1KFhVg
         NfKs/M9i+GJminagW0VQhCkoX6q17OmuD5PomXk/Fm4q7InsaliyJPz3ggybwXFDLb
         neUOmntVfn1+fjY8kRcN2Ua1ZTEjzdDxu5zP0/lI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 069/101] btrfs: fix lost error handling when looking up extended ref on log replay
Date:   Tue, 23 Aug 2022 10:03:42 +0200
Message-Id: <20220823080037.197439038@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 7a6b75b79902e47f46328b57733f2604774fa2d9 upstream.

During log replay, when processing inode references, if we get an error
when looking up for an extended reference at __add_inode_ref(), we ignore
it and proceed, returning success (0) if no other error happens after the
lookup. This is obviously wrong because in case an extended reference
exists and it encodes some name not in the log, we need to unlink it,
otherwise the filesystem state will not match the state it had after the
last fsync.

So just make __add_inode_ref() return an error it gets from the extended
reference lookup.

Fixes: f186373fef005c ("btrfs: extended inode refs")
CC: stable@vger.kernel.org # 4.9+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1074,7 +1074,9 @@ again:
 	extref = btrfs_lookup_inode_extref(NULL, root, path, name, namelen,
 					   inode_objectid, parent_objectid, 0,
 					   0);
-	if (!IS_ERR_OR_NULL(extref)) {
+	if (IS_ERR(extref)) {
+		return PTR_ERR(extref);
+	} else if (extref) {
 		u32 item_size;
 		u32 cur_offset = 0;
 		unsigned long base;


