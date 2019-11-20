Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A852E103F08
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731886AbfKTPkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53008 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731843AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5X-0004d5-Fu; Wed, 20 Nov 2019 15:40:15 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004P2-N8; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Hans van Kranenburg" <hans@knorrie.org>
Date:   Wed, 20 Nov 2019 15:38:31 +0000
Message-ID: <lsq.1574264230.614031573@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 81/83] btrfs: partially apply b8b93addde
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans van Kranenburg <hans@knorrie.org>

Extracted from commit b8b93addde "btrfs: cleanup 64bit/32bit divs,
provably bounded values", to allow commits 793ff2c88c6 "btrfs:
volumes: Cleanup stripe size calculation" and baf92114c7 "btrfs:
alloc_chunk: fix more DUP stripe size handling" to apply cleanly.

[bwh: Add patch description]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/volumes.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 4aa1a20fc5d7..b4b98a75ca8b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4274,8 +4274,8 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 */
 	if (stripe_size * data_stripes > max_chunk_size) {
 		u64 mask = (1ULL << 24) - 1;
-		stripe_size = max_chunk_size;
-		do_div(stripe_size, data_stripes);
+
+		stripe_size = div_u64(max_chunk_size, data_stripes);
 
 		/* bump the answer up to a 16MB boundary */
 		stripe_size = (stripe_size + mask) & ~mask;

