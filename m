Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41DF31C1B0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhBOSin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:38:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230468AbhBOSiQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBDB564E25;
        Mon, 15 Feb 2021 18:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414224;
        bh=/wGOeZzOWLx4B9iOccDB08VpQRLxgPY3+sVDTQkG1rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W1ceJLLe84wKjlB+EKJg6WA3jtQ2AOf7RvToJvGJuG9FqXM/Xi/sGfUKIaGJdppsR
         G69+k5OTM3iZXLe4HqRGdl5F1C8mnEvs9NCT36z1Oa6aNwpzt4nGzGZhHFWdmrAceM
         SZryD0wkHSc2CQAjA1UGeglNMaPMBiKvkCZCtR2nM8FMmii9MmD8WjmnBCHaLMzRoV
         fNDVj17H8YspVBtX08sUaGLvn82qhE/ty/8ZZN3wbXBYhsslTD2vuToOM+6HLjtAJh
         aY3nr5b4ulb9WI2HsSQ2PjuCM7PV9sBSW9libCJU2a+Tz7V7aMX+k1G2ayK5OiDiTh
         dzfblpzpfT5KA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 3/4] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Mon, 15 Feb 2021 13:36:59 -0500
Message-Id: <20210215183700.122100-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183700.122100-1-sashal@kernel.org>
References: <20210215183700.122100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b ]

While debugging another issue today, Steve and I noticed that if a
subdir for a file share is already mounted on the client, any new
mount of any other subdir (or the file share root) of the same share
results in sharing the cifs superblock, which e.g. can result in
incorrect device name.

While setting prefix path for the root of a cifs_sb,
CIFS_MOUNT_USE_PREFIX_PATH flag should also be set.
Without it, prepath is not even considered in some places,
and output of "mount" and various /proc/<>/*mount* related
options can be missing part of the device name.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ab9eeb5ff8e57..67c2e6487479a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4198,6 +4198,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;
-- 
2.27.0

