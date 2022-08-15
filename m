Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5F059358A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241508AbiHOS10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243113AbiHOS0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4241D3122C;
        Mon, 15 Aug 2022 11:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF5C360C07;
        Mon, 15 Aug 2022 18:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2792C433C1;
        Mon, 15 Aug 2022 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587553;
        bh=uwI7jOt3LUj5x/gvUBN4HIO7/wzxiNFPzitTcyPAavQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GN9sS4M59OpeLi4zqhL/bdZpB8oPDB7z8yakGjzO3qZdiHafOif7rVfDYNkwG0fjI
         Tt5Hxz73tt3cJOI35yaCawvLVRQUxwQaUq+yq8ofA9XJSsPSsKkRzVcNjeJWWs9JnH
         RVRP2HLVyRShfjE4aI1QRylZlloKeVuBEVj5fMTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 090/779] mbcache: dont reclaim used entries
Date:   Mon, 15 Aug 2022 19:55:34 +0200
Message-Id: <20220815180341.138257153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 58318914186c157477b978b1739dfe2f1b9dc0fe upstream.

Do not reclaim entries that are currently used by somebody from a
shrinker. Firstly, these entries are likely useful. Secondly, we will
need to keep such entries to protect pending increment of xattr block
refcount.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/mbcache.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -288,7 +288,7 @@ static unsigned long mb_cache_shrink(str
 	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
-		if (entry->e_referenced) {
+		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
 			entry->e_referenced = 0;
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
@@ -302,6 +302,14 @@ static unsigned long mb_cache_shrink(str
 		spin_unlock(&cache->c_list_lock);
 		head = mb_cache_entry_head(cache, entry->e_key);
 		hlist_bl_lock(head);
+		/* Now a reliable check if the entry didn't get used... */
+		if (atomic_read(&entry->e_refcnt) > 2) {
+			hlist_bl_unlock(head);
+			spin_lock(&cache->c_list_lock);
+			list_add_tail(&entry->e_list, &cache->c_list);
+			cache->c_entry_count++;
+			continue;
+		}
 		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
 			hlist_bl_del_init(&entry->e_hash_list);
 			atomic_dec(&entry->e_refcnt);


