Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB0F419B2C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhI0RPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236195AbhI0ROg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1B4561356;
        Mon, 27 Sep 2021 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762628;
        bh=U2giO394aD4Eh7yULfXla1jItF9UrRLtY1LvMcBdE1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=unyec0+rtibIuGK5OI0eH3yX334qjpdMrllUkz7CuLhcb2RwK0yCj5sGODUV/MZO2
         8CwIOTXacsxfOzXzDy2M8u9zKHHm7jG0MIicnpd0uvyyxfuB+GwMcmbf1uaUhZczC4
         wzqg/PhOySlhC4US3GggDbrT4vi3vGJTj/2tHByw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/103] cifs: fix a sign extension bug
Date:   Mon, 27 Sep 2021 19:02:35 +0200
Message-Id: <20210927170227.960522155@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit e946d3c887a9dc33aa82a349c6284f4a084163f4 ]

The problem is the mismatched types between "ctx->total_len" which is
an unsigned int, "rc" which is an int, and "ctx->rc" which is a
ssize_t.  The code does:

	ctx->rc = (rc == 0) ? ctx->total_len : rc;

We want "ctx->rc" to store the negative "rc" error code.  But what
happens is that "rc" is type promoted to a high unsigned int and
'ctx->rc" will store the high positive value instead of a negative
value.

The fix is to change "rc" from an int to a ssize_t.

Fixes: c610c4b619e5 ("CIFS: Add asynchronous write support through kernel AIO")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f46904a4ead3..67139f9d583f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3039,7 +3039,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct dentry *dentry = ctx->cfile->dentry;
-	int rc;
+	ssize_t rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
 	cifs_sb = CIFS_SB(dentry->d_sb);
-- 
2.33.0



