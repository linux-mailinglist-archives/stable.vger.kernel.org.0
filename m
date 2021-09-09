Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28B4405257
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351833AbhIIMnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:43:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354381AbhIIMi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:38:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B4A361BB4;
        Thu,  9 Sep 2021 11:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188474;
        bh=wm3vgGq28kagCEy8O6Nt9xmU1mL0EuDDPzYz6pRSOJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nIv4FBR5DKPpFMlgfbCTdb6H04XQ6crPMAbTKWYL5ZTE+ArplHheEmbTk9UUvxpJz
         28WhcLNoR6YFiuENzDPV/d2wN3NO5ZOFadiHlWsogE0DfTgy0kIvRn18HtZGyWrqfg
         eOzhYLAZXMfFaYoasuVp4c4nOMLA/HOW7T3HwdVnGoAmeGRBoWz8cRANJFEFeZiUHZ
         u30WZKdqDpke0a8dD8FX120MsreNGhYmxoSraOm19gJw2hvg4XMGW9Vai1vKXOaBJJ
         q1HnD7wTUNpPcBZ8mcyyUGlCfWXm+w7Fd4MNFHs8X472uz9NFcZpJnCpdIIsFmhl4C
         Aiv8WKyAravMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.10 151/176] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu,  9 Sep 2021 07:50:53 -0400
Message-Id: <20210909115118.146181-151-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit d72c74197b70bc3c95152f351a568007bffa3e11 ]

smb_buf is allocated by small_smb_init_no_tc(), and buf type is
CIFS_SMALL_BUFFER, so we should use cifs_small_buf_release() to
release it in failed path.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/sess.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1a0298d1e7cd..d58c5ffeca0d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -888,7 +888,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2

