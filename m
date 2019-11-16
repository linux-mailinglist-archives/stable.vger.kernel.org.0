Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1595FF3A2
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728541AbfKPQ1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:27:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbfKPPll (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:41 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 609AE2081E;
        Sat, 16 Nov 2019 15:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918900;
        bh=rsnNf15HrUbaGOrIbi6wyozb9yMbdByNuffKHCgCcss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9ItCvsSC2uJjajHlASRqYoi5HM99qCHZ6y+K2+rYf4dq+DxdMO+2QRNyjeQkHiuZ
         dOUT+5mQWyo0hbVLovnj63vTf9GV18Vq2FYNK4qSYPEsIVOHtFGwN+p86u4+nPxTBy
         9GmQj1uoTxjaQssmABcI2JvGUFbuZBXQ1hGSB3A4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 029/237] btrfs: handle error of get_old_root
Date:   Sat, 16 Nov 2019 10:37:44 -0500
Message-Id: <20191116154113.7417-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9fd383285f0ea..fc764f350f05a 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -3031,6 +3031,10 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 
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

