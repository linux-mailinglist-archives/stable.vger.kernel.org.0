Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49735486AF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352805AbiFMLUl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353273AbiFMLTi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B4B3A70D;
        Mon, 13 Jun 2022 03:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86057B80EAA;
        Mon, 13 Jun 2022 10:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B18C34114;
        Mon, 13 Jun 2022 10:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116865;
        bh=sORjXoBmpNc33OPcD4TrVdybWlMbn5lGfpHxkTVJosw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4EYZU0SVYqP83ypq3UvAPXsiYACL2xL22XT1Abu9fNdKdncn9Jb1SJxYM5fM+iDu
         4V/vgrolELrBi1gpfDugKhGP5M6d6NFMx4H3u3su9nL6XTj1VMPuw7ZDGdUlOlI+Su
         lYs8K5BSRd1mTZIbKq2sQScThCDklvwzG3pREUnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 201/411] NFS: Do not report flush errors in nfs_write_end()
Date:   Mon, 13 Jun 2022 12:07:54 +0200
Message-Id: <20220613094934.686750817@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit d95b26650e86175e4a97698d89bc1626cd1df0c6 ]

If we do flush cached writebacks in nfs_write_end() due to the imminent
expiration of an RPCSEC_GSS session, then we should defer reporting any
resulting errors until the calls to file_check_and_advance_wb_err() in
nfs_file_write() and nfs_file_fsync().

Fixes: 6fbda89b257f ("NFS: Replace custom error reporting mechanism with generic one")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 73415970af38..3233da79d49a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -394,11 +394,8 @@ static int nfs_write_end(struct file *file, struct address_space *mapping,
 		return status;
 	NFS_I(mapping->host)->write_io += copied;
 
-	if (nfs_ctx_key_to_expire(ctx, mapping->host)) {
-		status = nfs_wb_all(mapping->host);
-		if (status < 0)
-			return status;
-	}
+	if (nfs_ctx_key_to_expire(ctx, mapping->host))
+		nfs_wb_all(mapping->host);
 
 	return copied;
 }
-- 
2.35.1



