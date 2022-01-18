Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FDE491A3E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347820AbiARC65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:58:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36970 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348907AbiARCqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17F41612CF;
        Tue, 18 Jan 2022 02:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADA5C36AEB;
        Tue, 18 Jan 2022 02:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474002;
        bh=hpsSxjSLnJDDTG9w2Bn3LuhPP4a2bKLiwefzsv0k858=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhXJUeveoh3rm3UERphV/rXC3x4ygcchzJlbp6T1/Bxo6atoOP9Zh4Yk4sw3dd81x
         pyAx49QRpaWsiQrgEEO4l8qxAABqY88ezOZV/1jGH/iVm7zbos+xMVKnAZ95Bq1Yfm
         yBVVrCpwuku8A0+7+HsDM6oYvYDpSUklkTuqDwl15LidwIgckwS5Pl1uYMnCRGPRBE
         Wf9KXz1oC+hJ+S1e0IDTCT0IUdCYNktXUU5xjJWUaTlpUdA7h2Vby0nhYBsFGlTJoN
         m+ohXrldFW9Q1TCeIL9gmX5NCaZN/BiOqqi2o6ZR0gOhLmgonLG+w+unYIKj/teXe7
         Fxr6J/QRNH0yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 62/73] btrfs: remove BUG_ON(!eie) in find_parent_nodes
Date:   Mon, 17 Jan 2022 21:44:21 -0500
Message-Id: <20220118024432.1952028-62-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9044e7282d0b2..c701a19fac533 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1361,10 +1361,18 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
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

