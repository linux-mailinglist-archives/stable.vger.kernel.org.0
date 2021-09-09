Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763D240520B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348599AbhIIMko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352578AbhIIMhe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEAF261BA4;
        Thu,  9 Sep 2021 11:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188459;
        bh=63kIFkHrFm+wRAiUZlOM//EDuHZOFoI1nV/b2PZYWhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVrI68seqlmi94xQfaOaQUhHJ+8QKHWxlGQQ/XWnhIYTpIQcTqkwFYXvQeW/pqfNs
         6NXBsUGkUm5yX3ANg9LmCvI3rHUQhi9rcQm6RR2a5VXx96D8dudn/qoS4Vhkqiqs+R
         Lde14oN28mvkGKkV4gh0ma2bgecjuR5/E+P4BcTrdfLt4RUWjJjkUxi0ZpQ3VW0rIz
         Ix0BaD2001EM1yZ9OFhAWZAEUiEpj0dfFc6K8KGUHP8gYmu2ohkJhFx7A5G0ljPupt
         Biz1/QqxCTd6fFYNpThpQ55w98vPNW2tKSKbkxQrOc6XQS5r6P2fwlC4U0lhz9Co2w
         9VAHgoREe/tWA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 140/176] btrfs: tree-log: check btrfs_lookup_data_extent return value
Date:   Thu,  9 Sep 2021 07:50:42 -0400
Message-Id: <20210909115118.146181-140-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f36928efcf92..ec25e5eab349 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -708,7 +708,9 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
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

