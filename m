Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8280C40542C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355576AbhIIM5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:57:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354393AbhIIMvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B6076322C;
        Thu,  9 Sep 2021 11:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188624;
        bh=FwCJDxS2o/rIPFeTfezYzRrapeG4sI24aIt9JPu/XhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRVaivI1+QVJJx73qf0zJUDSb3Fnlc1R+1pLLRwNw+z9VfawVLTrSqLDvieHw/53X
         Do+mBWuPqnLh5/sKof4SPSjbNs4cSm6abYMQ+5BLi+G4T2IpBkJIpqOn93KmzW1szZ
         7G7dRRtRvNgnHv75r0XFBpP4OYbjzBIWH8SDekwY3k+Zs65d6HlnTcRkNxuSr/f0MK
         lb5wNme5zQmDZzVM0HznH9gaKoqF9ukcCPFJo0k+kkkLKioun5dmow4ilA0DEUMoqJ
         LGGggFxBLtgCU3GGE347wsbkILKbVhnyXhqTt7MSHA89/XaRW1dgOKAl3Kah+oLE8T
         LrsnulCtvI9fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.4 092/109] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu,  9 Sep 2021 07:54:49 -0400
Message-Id: <20210909115507.147917-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
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
index 85bd644f9773..30f841a880ac 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -610,7 +610,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2

