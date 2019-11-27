Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F73D10B7BC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbfK0Ugh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728287AbfK0Ugg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:36:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E63EB2158C;
        Wed, 27 Nov 2019 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574886996;
        bh=28UcTghOrsaTsVNgqi4hwzYOQG18W8MsP+t0Js06z9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDcw5D/16kmpgSeP2aqr8EouM+oweTJDeNeZrTcelxkLjMkRSgFSu64HtJZMpAcmz
         G1GKtfchWNdYAirgNaiGCgXMR3NnXx/FcT6jKHgJxQZB2uhV4KvGyGXK5QgOvRnDnk
         Nk1YnVYNQ+quuzThWxwF5AwCqZBLr1HS7TK0bvbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 030/132] btrfs: handle error of get_old_root
Date:   Wed, 27 Nov 2019 21:30:21 +0100
Message-Id: <20191127202927.521838423@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit 315bed43fea532650933e7bba316a7601d439edf ]

In btrfs_search_old_slot get_old_root is always used with the assumption
it cannot fail. However, this is not true in rare circumstance it can
fail and return null. This will lead to null point dereference when the
header is read. Fix this by checking the return value and properly
handling NULL by setting ret to -EIO and returning gracefully.

Coverity-id: 1087503
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/ctree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 51a0409e1b84a..a980b33097701 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2966,6 +2966,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, struct btrfs_key *key,
 
 again:
 	b = get_old_root(root, time_seq);
+	if (!b) {
+		ret = -EIO;
+		goto done;
+	}
 	level = btrfs_header_level(b);
 	p->locks[level] = BTRFS_READ_LOCK;
 
-- 
2.20.1



