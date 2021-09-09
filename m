Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4434F4050C0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349790AbhIIMb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353303AbhIIMUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04EE461AAD;
        Thu,  9 Sep 2021 11:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188237;
        bh=aYEm+ox7E1O6AVgVAzCjTSBJv3lZTPILbTDN7E0G+dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1eI4etGiyllc/eXpKWhbbJqGwT2Q5Kkd7wxfufofvEK8wlYlFsXUp+Dua2R/TH4D
         JIglL2OUKQP2or1n1RqGFzOipM5u8XHvAYFY2g3IATVLGa7XdFcgAC3CijFdlc7S95
         kYxccWK/XvV8LwZ9XIZfM8GWjbV5KCBfPX84PnOls+KGSdp8tHYPUca0FHJtsKUqCP
         MExeedGwsbQNjEJvECJyo+WlzXx0taW5K2tFtnvs/R00hUwlrkow6aLdHghOnQs2H7
         pFpZFUNnz9ZXWJ3CrUn9JyrIXN0O7mlo8Isjpag7G0DodLCqa1qm5Pg/6KmKTbMuGF
         VgyCsDcLJ0+nA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.13 188/219] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu,  9 Sep 2021 07:46:04 -0400
Message-Id: <20210909114635.143983-188-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index a92a1fb7cb52..4c22f73b3123 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -889,7 +889,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2

