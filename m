Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9B324D8C
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhBYKEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234896AbhBYKAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:00:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 295AE64F22;
        Thu, 25 Feb 2021 09:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246934;
        bh=QCU3pzLQ0hRpTMsZSfrMYcsdc4VS2H5Y1JGXc2aBxTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zj3qsV8E+GcXVvnz6wCB3gpT0GFDe766VIhmfjmb4AodGlR1pfSCkpD61tlI5nNWN
         SOHrw6dEkK7bZgQh91WqS9fVSl/Cjv5l+Bu5drVori+mi65SWQWaxear7APLtxo16s
         ruuSuxJVnmFc0JZnPiVBfLHcTHJsBUhrhYcTilc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/23] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Date:   Thu, 25 Feb 2021 10:53:52 +0100
Message-Id: <20210225092517.539987047@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092516.531932232@linuxfoundation.org>
References: <20210225092516.531932232@linuxfoundation.org>
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



