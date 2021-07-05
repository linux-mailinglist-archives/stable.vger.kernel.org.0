Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A7A3BBF4B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhGEPcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhGEPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CBA61997;
        Mon,  5 Jul 2021 15:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498951;
        bh=U/Wk3xklJzSoSp+qrIP77EGaiACD/fE7Vvq6NiNz9cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PzaB1+P9j2UtYj9H79VtpSFfWzLzAQcAt+rzCQKtajcCpurn0qpWM0T4Bd1Rr+7n8
         aAavToladcggHXCaoCRYd/J4CBFBHud4CUmvLqa7AhmlQJGF6kcbYBrBZmJDZzmkE8
         X0Uk3X42t3JxTmX0DG6gtZRw4puGUFXnwGgIkUTOYrRl0T9wtVDZW5CIRDRShL3BuX
         FqvmqpYm32M/9xlWhQTDMno2PbzfaNR0luw8E/zuJhDhSLuRBJJnyH6YM8Ym9gN90t
         igEO6Xz/BBpze38XfYKOePEvfbd16hRk0Uq5G7jAfXQQa20YMvSR/JFrydZFbTDIAf
         ICa96HY0tMg8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 42/59] cifs: fix SMB1 error path in cifs_get_file_info_unix
Date:   Mon,  5 Jul 2021 11:27:58 -0400
Message-Id: <20210705152815.1520546-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

[ Upstream commit e39df24169a2ceb0d359eb3a05ff982711f2eb32 ]

We were trying to fill in uninitialized file attributes in the error case.

Addresses-Coverity: 139689 ("Uninitialized variables")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1dfa57982522..f60f068d33e8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -367,9 +367,12 @@ cifs_get_file_info_unix(struct file *filp)
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, inode->i_sb);
 		rc = 0;
-	}
+	} else
+		goto cifs_gfiunix_out;
 
 	rc = cifs_fattr_to_inode(inode, &fattr);
+
+cifs_gfiunix_out:
 	free_xid(xid);
 	return rc;
 }
-- 
2.30.2

