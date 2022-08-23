Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A865259D411
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241743AbiHWIJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241717AbiHWIIa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E16CD08;
        Tue, 23 Aug 2022 01:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B6D2B81C19;
        Tue, 23 Aug 2022 08:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97167C433C1;
        Tue, 23 Aug 2022 08:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241921;
        bh=K5ZBDr6BEUr7UZVmEwDVuU96klWoAHjgVnTdnq/iI18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJTe8YHMgel2QJaVi39l39b+nAali4mApT9MQOZE/2PG5vbzH0ZL0zi4yzPvGakg7
         7RJlTmwG8gK2bAd75Buz4IH4ECmUS0i9g82DQ6Bv+RFvisyEV/VQ6YOIzNrts97DBE
         VhtxG4DuAgfeh0inFjW7dVJs3JgDj8M7EYoT7lBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.19 020/365] btrfs: fix lost error handling when looking up extended ref on log replay
Date:   Tue, 23 Aug 2022 09:58:41 +0200
Message-Id: <20220823080119.053017011@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -1146,7 +1146,9 @@ again:
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


