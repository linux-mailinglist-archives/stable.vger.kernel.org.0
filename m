Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F6251AA45
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356468AbiEDRWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356741AbiEDROF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:14:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A91953B74;
        Wed,  4 May 2022 09:58:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3A26B82416;
        Wed,  4 May 2022 16:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DED7C385AA;
        Wed,  4 May 2022 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683492;
        bh=0Y5QnMd8T87CITmK3jIabf6VdsS8nJNvvvMpL+BzWVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=18UX1DpZBWSdlvlu5tlQYycNZeV255dF0sqrzh9N+R2rOamGnzxupOtkqbo+nutPR
         K/dhSh7k72Vf0GL9AiQnjJTenr1twsd5IHSomGF+2b0XdadfkShPeWLpGrYRmS3I8/
         m4pa6W9Ydikqlvz/4nzfTgbvtBSKbsWiT9bO5qZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 167/225] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
Date:   Wed,  4 May 2022 18:46:45 +0200
Message-Id: <20220504153124.856157629@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index a19a2b9c1e56..83ffa73c9348 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -11,6 +11,7 @@
 #include <linux/statfs.h>
 #include <linux/ethtool.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 
 #include "glob.h"
 #include "smbfsctl.h"
@@ -5005,15 +5006,17 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
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



