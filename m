Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5818835BCD6
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237599AbhDLIpt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:45:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237703AbhDLIpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:45:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E270461220;
        Mon, 12 Apr 2021 08:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217093;
        bh=Gt20V2s5jj6Up8T6Kx2mBVp/43wT6Z9lSPTgr8Wk9iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=su6YiCZEhXlOx4ApCgofCnognUQ4gK9BZZOHBtLNRGPKA/SNFO/diYQnDeZKoirN5
         jnw42Sk4uM3iWqW/P2x+Dpx6XH911WMmk4gZiF3r8d4M/cJXdfHOo3+AXo9M6vPh1/
         hX3NMef6HF6TnU2+iAlWFzCYOHn+auSpyiqv/Dpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Salvatore Bonaccorso <carnil@debian.org>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 66/66] Revert "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath."
Date:   Mon, 12 Apr 2021 10:41:12 +0200
Message-Id: <20210412084000.268096707@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 7496d7034a4e1b715c2baf6fe976bbaf7a361106 which is
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
@@ -3882,7 +3882,6 @@ int cifs_setup_cifs_sb(struct smb_vol *p
 		cifs_sb->prepath = kstrdup(pvolume_info->prepath, GFP_KERNEL);
 		if (cifs_sb->prepath == NULL)
 			return -ENOMEM;
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_USE_PREFIX_PATH;
 	}
 
 	return 0;


