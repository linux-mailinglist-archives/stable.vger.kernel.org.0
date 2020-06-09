Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FCC1F44F5
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388551AbgFISKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:10:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41334 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388155AbgFISF6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:05:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001pA-Gu; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidF-006Vwp-Tb; Tue, 09 Jun 2020 19:05:53 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tahsin Erdogan" <tahsin@google.com>, "Jan Kara" <jack@suse.cz>
Date:   Tue, 09 Jun 2020 19:04:39 +0100
Message-ID: <lsq.1591725832.241188078@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 48/61] ext4: Make checks for metadata_csum feature safer
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tahsin Erdogan <tahsin@google.com>

This is just a small part of commit dec214d00e0d7 "ext4: xattr inode
deduplication" that makes checks for metadata_csum feature safer and is
actually needed by following fixes.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
Acked-by: Jan Kara <jack@suse.cz>
[bwh: Ported to 3.16: Use EXT4_HAS_RO_COMPAT_FEATURE()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2411,21 +2411,24 @@ extern void ext4_group_desc_csum_set(str
 extern int ext4_register_li_request(struct super_block *sb,
 				    ext4_group_t first_not_zeroed);
 
-static inline int ext4_has_group_desc_csum(struct super_block *sb)
-{
-	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
-					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
-	       (EXT4_SB(sb)->s_chksum_driver != NULL);
-}
-
 static inline int ext4_has_metadata_csum(struct super_block *sb)
 {
 	WARN_ON_ONCE(EXT4_HAS_RO_COMPAT_FEATURE(sb,
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
 		     !EXT4_SB(sb)->s_chksum_driver);
 
-	return (EXT4_SB(sb)->s_chksum_driver != NULL);
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	       (EXT4_SB(sb)->s_chksum_driver != NULL);
+}
+
+static inline int ext4_has_group_desc_csum(struct super_block *sb)
+{
+	return EXT4_HAS_RO_COMPAT_FEATURE(sb,
+					  EXT4_FEATURE_RO_COMPAT_GDT_CSUM) ||
+		ext4_has_metadata_csum(sb);
 }
+
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |

