Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71A419C30
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbhI0R0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237905AbhI0RYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:24:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C5E2613E8;
        Mon, 27 Sep 2021 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762919;
        bh=Q9BU+vRW1PHvBnNesGxQhgfPeRJFUcEnpF1D1ag+PP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqUzLMPZ5m9FkLV4vBvGUj6yWWx1y2SvnWgkwpX5yVSVdVfzFpgl7OO2noW9+VJ1N
         Yd/agaHNxUFTjE5Tjt0hc/+YylJJ5VB23/3orkEoR76HAS+9943ALACFTUhWbrDM1a
         hszroB8LMvksqLlDU0m2YtpT5zvXISuhreQCtQ7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 101/162] cifs: fix a sign extension bug
Date:   Mon, 27 Sep 2021 19:02:27 +0200
Message-Id: <20210927170236.943554915@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index 9d3bc6784771..ab2734159c19 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3110,7 +3110,7 @@ static void collect_uncached_write_data(struct cifs_aio_ctx *ctx)
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb;
 	struct dentry *dentry = ctx->cfile->dentry;
-	int rc;
+	ssize_t rc;
 
 	tcon = tlink_tcon(ctx->cfile->tlink);
 	cifs_sb = CIFS_SB(dentry->d_sb);
-- 
2.33.0



