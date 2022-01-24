Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01EF498AA3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237312AbiAXTGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344246AbiAXTDN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1045AC061753;
        Mon, 24 Jan 2022 10:59:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A17E86020F;
        Mon, 24 Jan 2022 18:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7257EC340E7;
        Mon, 24 Jan 2022 18:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050743;
        bh=1LsIV7lL5lJ40dfUxO8pKqDVJSLOtPvkZEuXKWupjx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0nQjD9z2HTYmojl9TbYPZWt96gPnaPgE6OsqV44iyClLzRf0HpDxd+5pLRb3P9Lo
         9tT8gXVK/zDXV8n+DsBzLhPhfzlarpLG2tSMk8MGPXvIAnrYli/kvWXyTEitCjIZgZ
         pXG+dBIxDlvXmSgJV78chz1t+5G8A5IpKdj4bMso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 098/157] btrfs: remove BUG_ON(!eie) in find_parent_nodes
Date:   Mon, 24 Jan 2022 19:43:08 +0100
Message-Id: <20220124183935.878229190@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9f05c09d6baef789726346397438cca4ec43c3ee ]

If we're looking for leafs that point to a data extent we want to record
the extent items that point at our bytenr.  At this point we have the
reference and we know for a fact that this leaf should have a reference
to our bytenr.  However if there's some sort of corruption we may not
find any references to our leaf, and thus could end up with eie == NULL.
Replace this BUG_ON() with an ASSERT() and then return -EUCLEAN for the
mortals.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/backref.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 29a19bc2abe18..16169b35ab6e5 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1437,10 +1437,18 @@ again:
 				goto out;
 			if (!ret && extent_item_pos) {
 				/*
-				 * we've recorded that parent, so we must extend
-				 * its inode list here
+				 * We've recorded that parent, so we must extend
+				 * its inode list here.
+				 *
+				 * However if there was corruption we may not
+				 * have found an eie, return an error in this
+				 * case.
 				 */
-				BUG_ON(!eie);
+				ASSERT(eie);
+				if (!eie) {
+					ret = -EUCLEAN;
+					goto out;
+				}
 				while (eie->next)
 					eie = eie->next;
 				eie->next = ref->inode_list;
-- 
2.34.1



