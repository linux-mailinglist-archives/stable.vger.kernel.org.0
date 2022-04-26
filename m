Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C90510879
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353811AbiDZTFx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353770AbiDZTFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:05:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD2419981E;
        Tue, 26 Apr 2022 12:02:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF014B82252;
        Tue, 26 Apr 2022 19:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD5CC385A0;
        Tue, 26 Apr 2022 19:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999742;
        bh=9NY7USzhuSlp779ziJCCibr/+WvkaizSECqK6XQIv0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UILMLzfXJhWbX3YQIfNVPVEMHKMJgp91vhXSYXm/7qnsu7+9XoGB9wEVHFwtaqnyx
         eWUcxR79bdaBRTyONPkVy1E3z097XRzWecCamMIZ9GwKPHynzGTVG9NZ/uhZW9QbuJ
         PhcRMJ58mRvJTDjoWKik6ZMrH4LmCv3p9lRWtsTCfqmMOXzwcpMqieS9rESC4KdZDR
         ShqCPQuS3lZqjMtr47x7XhHbEPntjKRcpouQobllZMqp0H6hGDPjE+ZBdArYKovLxo
         KpPXL3M8jG58IY0ludU/Xzl6/Cxd7h4maARMhQAKd4VS8lPW3G/s9q+UnZpg5WGnG2
         LH8M3noefuNpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        hyc.lee@gmail.com, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/15] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
Date:   Tue, 26 Apr 2022 15:02:05 -0400
Message-Id: <20220426190216.2351413-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190216.2351413-1-sashal@kernel.org>
References: <20220426190216.2351413-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 02655a70b7cc0f534531ee65fa72692f4d31a944 ]

Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
If fat/exfat is a local share, ->f_bsize is a cluster size that is too
large to be used as a sector size. Sector sizes larger than 4K cause
problem occurs when mounting an iso file through windows client.

The error message can be obtained using Mount-DiskImage command,
 the error is:
"Mount-DiskImage : The sector size of the physical disk on which the
virtual disk resides is not supported."

This patch reports fixed 4KB sector size if ->s_blocksize is bigger
than 4KB.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index a9fdb47c2791..1ed3046dd5b3 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -11,6 +11,7 @@
 #include <linux/statfs.h>
 #include <linux/ethtool.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 
 #include "glob.h"
 #include "smb2pdu.h"
@@ -4997,15 +4998,17 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	case FS_SECTOR_SIZE_INFORMATION:
 	{
 		struct smb3_fs_ss_info *info;
+		unsigned int sector_size =
+			min_t(unsigned int, path.mnt->mnt_sb->s_blocksize, 4096);
 
 		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
 
-		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
+		info->LogicalBytesPerSector = cpu_to_le32(sector_size);
 		info->PhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
-		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
+		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(sector_size);
 		info->FSEffPhysicalBytesPerSectorForAtomicity =
-				cpu_to_le32(stfs.f_bsize);
+				cpu_to_le32(sector_size);
 		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
 				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
 		info->ByteOffsetForSectorAlignment = 0;
-- 
2.35.1

