Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3309B404D19
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbhIIMAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245120AbhIIL4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:56:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E19EE611C6;
        Thu,  9 Sep 2021 11:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187923;
        bh=yIReAnM4BmjVOMDEMIAlM6cRmVcC9J3/OSMJ0cyLO08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqckzEbJ9EVUrFWNc6IM8HBvqLxVbGZNF8BR8mhpeWFPOJH4xvJnBXQuM8Q3bpOer
         GCj8KAeofq/vavcmYLeAwYyTIpbwJqzUIRc7Vz68fLIHk1WBuZqW5FFNHkNMZ+jvY6
         we8SjaIU4xd9aM3dfGyI2+5Z2dm/g4/RwUlcpz3lEYeG/AD8V9P5fCSpc4UUqfxGTu
         xDsLstiBDf3jGTpV6amRuN+hcm1EaLZKXlTx8h2rtH0iUoQWUKF8nNCwLnCXzqbyAm
         QmtUGcfjI1M28JUkzR0oesJrBMiUeOBfI0zZv/YRUfWgpCxSikgzdmdaKromL2vEPJ
         1Jrl2n4Wob9iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 197/252] btrfs: tree-log: check btrfs_lookup_data_extent return value
Date:   Thu,  9 Sep 2021 07:40:11 -0400
Message-Id: <20210909114106.141462-197-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index e6430ac9bbe8..7037e5855d2a 100644
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

