Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA36E360D53
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhDOPBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233802AbhDOO5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B580613D2;
        Thu, 15 Apr 2021 14:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498498;
        bh=N/n7rRcRcoTHYe9gkN1qRO99SpGJ2HiAS1bvON6Hp6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ESqkuIugNNjlJPVJ/gcEszURgTESp+Ln9L6EHXXDQAok4UOWKT28dGLxBaLnf6nH4
         9pesnAT3RInx/wgkNOPSSL2Dd7CvC5xgdldx5NJhU1i4VXY4FzY/CLpShfbb1uyE/A
         RFsvrxzJt8paG1yh4d5/TvXCDe8mjLwlNQBZek1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 59/68] Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
Date:   Thu, 15 Apr 2021 16:47:40 +0200
Message-Id: <20210415144416.403136994@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit ad48c641e7c344ae7aba243d3056a22eaba71bfd which is
commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b upstream.

It is reported to cause problems in older kernels, so revert it for now
until we can figure it out...

Reported-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/r/YG7r0UaivWZL762N@eldamar.lan
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Aurelien Aptel <aaptel@suse.com>
Cc: Steve French <stfrench@microsoft.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/connect.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3607,7 +3607,6 @@ int cifs_setup_cifs_sb(struct smb_vol *p
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;


