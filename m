Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5654F17FE19
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCJMtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgCJMs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:48:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4BD62468E;
        Tue, 10 Mar 2020 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844538;
        bh=kTAVCmjkgt4yY7w8vHGxKTKF51LOERhUSmEEkoSYfzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jeDKGThuMaitai2e7XvdbKkYlLTm9c7kD7JzDYSf0hi/A8X7RWbmyqXHD6rIL+/Nw
         c7u2AQcV1cEY7H1HYYAltRZQttmhpX6JL/wXaN5kR5oKHBUWIdPcvwcfiSVObJw41l
         So1ujvtMWb44vl6q5ttkg2DGaTCC9lFc++WSB1yI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/168] dm thin metadata: fix lockdep complaint
Date:   Tue, 10 Mar 2020 13:37:33 +0100
Message-Id: <20200310123636.537069124@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 3918e0667bbac99400b44fa5aef3f8be2eeada4a ]

[ 3934.173244] ======================================================
[ 3934.179572] WARNING: possible circular locking dependency detected
[ 3934.185884] 5.4.21-xfstests #1 Not tainted
[ 3934.190151] ------------------------------------------------------
[ 3934.196673] dmsetup/8897 is trying to acquire lock:
[ 3934.201688] ffffffffbce82b18 (shrinker_rwsem){++++}, at: unregister_shrinker+0x22/0x80
[ 3934.210268]
               but task is already holding lock:
[ 3934.216489] ffff92a10cc5e1d0 (&pmd->root_lock){++++}, at: dm_pool_metadata_close+0xba/0x120
[ 3934.225083]
               which lock already depends on the new lock.

[ 3934.564165] Chain exists of:
                 shrinker_rwsem --> &journal->j_checkpoint_mutex --> &pmd->root_lock

For a more detailed lockdep report, please see:

	https://lore.kernel.org/r/20200220234519.GA620489@mit.edu

We shouldn't need to hold the lock while are just tearing down and
freeing the whole metadata pool structure.

Fixes: 44d8ebf436399a4 ("dm thin metadata: use pool locking at end of dm_pool_metadata_close")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-thin-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 8bb723f1a569a..4cd8868f80040 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -960,9 +960,9 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 			DMWARN("%s: __commit_transaction() failed, error = %d",
 			       __func__, r);
 	}
+	pmd_write_unlock(pmd);
 	if (!pmd->fail_io)
 		__destroy_persistent_data_objects(pmd);
-	pmd_write_unlock(pmd);
 
 	kfree(pmd);
 	return 0;
-- 
2.20.1



