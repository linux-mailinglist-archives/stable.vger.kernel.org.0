Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1311840E45B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344277AbhIPQ5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243672AbhIPQzp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:55:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B81CF61AA8;
        Thu, 16 Sep 2021 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809840;
        bh=XW47Uo1xPV1hb30MATB/U2VwZ9EAXIQSmUmvn3oAYBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dro+fcFVTKu3tNEme9RwJ5o7n75tVM2gUYqWWr9SV2m8JWMv4LZCWA5EbRh+Mt3yN
         +0yxoSrCkubEOKgqXCmYJinKlMHduEyj1YLP3CIz11UAGBP5gnv+vQbuwaCSu/OSnl
         Sb5yEiLAK6OMcoG/V+JgU/ATh4lhewZhB+p69IgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 302/380] btrfs: tree-log: check btrfs_lookup_data_extent return value
Date:   Thu, 16 Sep 2021 18:00:59 +0200
Message-Id: <20210916155814.331080946@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit 3736127a3aa805602b7a2ad60ec9cfce68065fbb ]

Function btrfs_lookup_data_extent calls btrfs_search_slot to verify if
the EXTENT_ITEM exists in the extent tree. btrfs_search_slot can return
values bellow zero if an error happened.

Function replay_one_extent currently checks if the search found
something (0 returned) and increments the reference, and if not, it
seems to evaluate as 'not found'.

Fix the condition by checking if the value was bellow zero and return
early.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-log.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 24555cc1f42d..9e9ab41df7da 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -753,7 +753,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 			 */
 			ret = btrfs_lookup_data_extent(fs_info, ins.objectid,
 						ins.offset);
-			if (ret == 0) {
+			if (ret < 0) {
+				goto out;
+			} else if (ret == 0) {
 				btrfs_init_generic_ref(&ref,
 						BTRFS_ADD_DELAYED_REF,
 						ins.objectid, ins.offset, 0);
-- 
2.30.2



