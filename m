Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C031C1C0
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 19:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhBOSjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 13:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:34140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhBOSia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 13:38:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB5BE64E2C;
        Mon, 15 Feb 2021 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613414229;
        bh=YDPIPnkoPmhUXThq3QG2LDKdjAdU3GysEmISZjR70c8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbWvIxeaSXZU2HnzghSBnUOKO1eT40bhB2sM3dPuyOXvsme8LbAKzt8ZunwX2tSQY
         Ahb5w9/kIvTw+cETFqKVC/58DDjfWDcno3adjP1rQSK4LlLSXlzo60W/+wd/pHWA/y
         vFVQ0+sGKfDY7i6u2BfxjsJCr5Gc+09Onl6NPPKOR+v7p0/PCOHE1lNEFrQ9mZIac8
         dD4hRvmOLbjvroumrUilHy2XtWT9pbvS76whO4ER0/YOZjfktA5hMxPUKZc7pMQqGN
         +4uR2gBHsEdbI/B2i9GmXJhMkBlchowYU8jDFB+uAu03euLnS6zcPPSO9rBXsB8nG6
         4mc+b8oiWZQgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 2/3] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Mon, 15 Feb 2021 13:37:05 -0500
Message-Id: <20210215183706.122183-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210215183706.122183-1-sashal@kernel.org>
References: <20210215183706.122183-1-sashal@kernel.org>
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
index 6285085195c15..632249ce61eba 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3882,6 +3882,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;
-- 
2.27.0

