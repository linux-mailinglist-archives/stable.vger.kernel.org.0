Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9B311622A
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfLHN57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60068 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbfLHNyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:41 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0007dZ-N3; Sun, 08 Dec 2019 13:54:37 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002Lv-0Q; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Rakesh Pandit" <rakesh@tuxera.com>
Date:   Sun, 08 Dec 2019 13:53:03 +0000
Message-ID: <lsq.1575813165.296462381@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 19/72] ext4: fix warning inside ext4_convert_unwritten_extents_endio
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rakesh Pandit <rakesh@tuxera.com>

commit e3d550c2c4f2f3dba469bc3c4b83d9332b4e99e1 upstream.

Really enable warning when CONFIG_EXT4_DEBUG is set and fix missing
first argument.  This was introduced in commit ff95ec22cd7f ("ext4:
add warning to ext4_convert_unwritten_extents_endio") and splitting
extents inside endio would trigger it.

Fixes: ff95ec22cd7f ("ext4: add warning to ext4_convert_unwritten_extents_endio")
Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3775,8 +3775,8 @@ static int ext4_convert_unwritten_extent
 	 * illegal.
 	 */
 	if (ee_block != map->m_lblk || ee_len > map->m_len) {
-#ifdef EXT4_DEBUG
-		ext4_warning("Inode (%ld) finished: extent logical block %llu,"
+#ifdef CONFIG_EXT4_DEBUG
+		ext4_warning(inode->i_sb, "Inode (%ld) finished: extent logical block %llu,"
 			     " len %u; IO logical block %llu, len %u\n",
 			     inode->i_ino, (unsigned long long)ee_block, ee_len,
 			     (unsigned long long)map->m_lblk, map->m_len);

