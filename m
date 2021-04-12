Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E0C35BD95
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhDLIw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238649AbhDLIuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFB8961241;
        Mon, 12 Apr 2021 08:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217398;
        bh=RHzyIgaGm2DC/Wcqj0hopcLkts+WRN+1fd++KMxCzyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHqytLaecdxMIkH3e7gMqwa4oE7jNGr+tIHU3v7V30zAU8lrnIIauVKg+aNQgsJYB
         +b5H1cUphvOvkGEgNOsVXqLMLONlzdMCvND/euDciltWYH+myepCoiseZxWj5E4+tJ
         UX03mdta7drE2Q1iRYzy1BxJsdfVPEKB1J4//EGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 111/111] Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
Date:   Mon, 12 Apr 2021 10:41:29 +0200
Message-Id: <20210412084007.967910521@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit a2c5e4a083a7e24b35b3eb808b760af6de15bac2 which is
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
@@ -4198,7 +4198,6 @@ int cifs_setup_cifs_sb(struct smb_vol *p
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;


