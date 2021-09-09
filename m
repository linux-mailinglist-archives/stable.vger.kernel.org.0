Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D578E405740
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357867AbhIINdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356216AbhIIM67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 568D363267;
        Thu,  9 Sep 2021 11:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188725;
        bh=Hf2RRelyE2amnSnIibj8OQSt2FVQFWgfHCv0/xYHdsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fP7HQ3b7y+jgnHoWXg4Cl/tvsvBjB4y3KlFPzeAZcRWOzpIrmgH3pcJXrm5t7zlza
         Kmx11FSAs9X/yabVTFrwFVorOEahrT9MH2kT9N+1Slnjs3UCTpse2cHMGqG0qlUkG4
         SqvvPRPyu/bfnYFOBC6oncJz1y9FxoQVz4ZKX4KQKy6GGnroY3jaQcmwbY1FtBODE0
         XAg9mZklkuXErjrhnTPW2xDyuzqAbeTFnGX/36KLk+mfCE3hsMRaXjP/I9f6upmRie
         92N0J+aqFf0YbdF4kHZ1C0BwT0SgxhS4EQFUz6SPpYIkpACgRSbRnevTIWsJAo5Tj6
         4g2ifNV24FKZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ding Hui <dinghui@sangfor.com.cn>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.19 63/74] cifs: fix wrong release in sess_alloc_buffer() failed path
Date:   Thu,  9 Sep 2021 07:57:15 -0400
Message-Id: <20210909115726.149004-63-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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
index aa23c00367ec..0113dba28eb0 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -602,7 +602,7 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 	return 0;
 
 out_free_smb_buf:
-	kfree(smb_buf);
+	cifs_small_buf_release(smb_buf);
 	sess_data->iov[0].iov_base = NULL;
 	sess_data->iov[0].iov_len = 0;
 	sess_data->buf0_type = CIFS_NO_BUFFER;
-- 
2.30.2

