Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2E82E404D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437942AbgL1OVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437902AbgL1OVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 899AA2063A;
        Mon, 28 Dec 2020 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165269;
        bh=O/P785hr0xbbym5kCpKjzJy8UPJQsYyr69+MfA5v6b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4Jqt2fui5ov8PNoIsLfZElKXIUM2sSPeDA+jREqZsd2NNoidrD2HTGjOk+9zqSYR
         Dlj+Htza+7/Qf/QHuLMvitCzJwM0Xkb7WK3bBKXPlnxewFNO9grgFIEffvYtU+KRor
         2pv74URGn5qpBj0F0iDF/C0Y0ZqpMjbg0Gys51Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 471/717] NFS/pNFS: Fix a typo in ff_layout_resend_pnfs_read()
Date:   Mon, 28 Dec 2020 13:47:49 +0100
Message-Id: <20201228125043.538601752@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 52104f274e2d7f134d34bab11cada8913d4544e2 ]

Don't bump the index twice.

Fixes: 563c53e73b8b ("NFS: Fix flexfiles read failover")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index 24bf5797f88ae..fd0eda328943b 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -1056,7 +1056,7 @@ static void ff_layout_resend_pnfs_read(struct nfs_pgio_header *hdr)
 	u32 idx = hdr->pgio_mirror_idx + 1;
 	u32 new_idx = 0;
 
-	if (ff_layout_choose_any_ds_for_read(hdr->lseg, idx + 1, &new_idx))
+	if (ff_layout_choose_any_ds_for_read(hdr->lseg, idx, &new_idx))
 		ff_layout_send_layouterror(hdr->lseg);
 	else
 		pnfs_error_mark_layout_for_return(hdr->inode, hdr->lseg);
-- 
2.27.0



