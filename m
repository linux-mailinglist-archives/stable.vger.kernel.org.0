Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A4931C19E
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbhBOShk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:37:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:33784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230243AbhBOShh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BD9E64E0F;
        Mon, 15 Feb 2021 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414217;
        bh=QCU3pzLQ0hRpTMsZSfrMYcsdc4VS2H5Y1JGXc2aBxTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPUPDRRIbI/AME6kp+JS8WT+IEK3YkFvwpjWY0Urpp1rg1plswbg+GD4xsieSCR2q
         JTCkfOOWTA/V9YkMCTMv8IGvA8dT5nYIf++BJDnpi7pTcn1EJoj7odZz+XrXw7H5l1
         JBdbxGaBnts/kubPaQvZ9uoRkqmwD9mlNc2WXfYpvIs8RoW+e00vjpHCaYqNuNsjnj
         BLAYn/fTL8LcZ9fN+OaMCwKTLM/2btoQRZyiPJrrdGorDlLPAM6OLbia1D8Q2HkQn2
         GnFM93ZGbWIx4mLh9ggkOFDeERDcjoCyz6txVl4JaDG07kTINpcsWhL/P6Pc5tTWYc
         yH6Xsx5TWS27A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 4/6] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Mon, 15 Feb 2021 13:36:49 -0500
Message-Id: <20210215183651.122001-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183651.122001-1-sashal@kernel.org>
References: <20210215183651.122001-1-sashal@kernel.org>
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
index 44f9cce570995..ad3ecda1314d9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4007,6 +4007,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;
-- 
2.27.0

