Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3FA328431
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhCAQbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233907AbhCAQ0n (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:26:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BC5C64EDF;
        Mon,  1 Mar 2021 16:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615722;
        bh=1pQvcjsLn1hyuWuG3IYWJqdnk198cx+QlxgmKMLq+pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a32xYpQRDMVwfmBQ+OxW+CJjpTwfQwukvTl3wCKYIoqW//71xb4D3OMjmMw0cwqZR
         5IoqFMSF4GBanhDxbV96tIbTZDamgs30ZoW82R4NCUzw5jn77Wnl0ga7OzMP9nHJms
         2njbXuL+P6sjSQRkdvswcehhjJ8h8MXK4inBC/pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 007/134] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161013.942524168@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index af78de9ef036c..8508dc8270593 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3488,6 +3488,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;
-- 
2.27.0



