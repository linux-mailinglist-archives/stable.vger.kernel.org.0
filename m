Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3BC404D38
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244996AbhIIMBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243466AbhIIL6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F31E613DB;
        Thu,  9 Sep 2021 11:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187945;
        bh=iI3Nf3pgp84K2U+TapAd91phHv3h5a6aFXdCgxuUWqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qA5w2UJab4gw4Oqq50eMmiDM1ZURrvzXlj8aqZEZN8RegWlSU/ZRpHJLoXlYcfJtG
         dOvAMUbWZBeyLaIfkz30M7mVtuLmOSBFyB6XLp6xuOmIXQYBtvCeBaBFjUZpcs911e
         0uR9TZU9o2ZEH/x9eOSwQf//xzW+/d/Jx4MzbHclOGxU1sse/i4/upRndvp9GV0QQ8
         XDSf8BalTqQN+PZWJ94/yhyBof3iVzd3SFGDUrsjD+XlYVe369FhPxFVqjzoKddZMJ
         Kd5cjPhvx2OeQGWK8plNe04/bObOmsmGl+5iNi44Ko3twOtc9EL7NsrZl54dC+urvi
         hwFHyEDqvp4ng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.14 214/252] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu,  9 Sep 2021 07:40:28 -0400
Message-Id: <20210909114106.141462-214-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index c5785fd3f52e..606fd7d6cb71 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -877,7 +877,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2

