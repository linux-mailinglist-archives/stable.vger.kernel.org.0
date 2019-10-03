Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B5DCA433
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389130AbfJCQXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389500AbfJCQW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5660F21783;
        Thu,  3 Oct 2019 16:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119777;
        bh=zXEalkm8rJRBxulIy0Cx5EepPxkMB05/CthgptWVr4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v0mTswhY3eXmeQ4FEFazeIYvsv5FddkepuLN/tAEZM41nou9tv03pH7i7EQnJTb8b
         DkTlCGJrrO4jJcsrxTFXeT84RndGbXIUQidfsZ+g9IHtcNEZyFtz/mopPWwEvybMW9
         pHGf3ZcUygoUE1L4Bb8gv6h6SslN41yNTyfCFdck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 188/211] ovl: Fix dereferencing possible ERR_PTR()
Date:   Thu,  3 Oct 2019 17:54:14 +0200
Message-Id: <20191003154528.237113726@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit 97f024b9171e74c4443bbe8a8dce31b917f97ac5 upstream.

if ovl_encode_real_fh() fails, no memory was allocated
and the error in the error-valued pointer should be returned.

Fixes: 9b6faee07470 ("ovl: check ERR_PTR() return value from ovl_encode_fh()")
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Cc: <stable@vger.kernel.org> # v4.16+
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/export.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -230,9 +230,8 @@ static int ovl_d_to_fh(struct dentry *de
 	/* Encode an upper or lower file handle */
 	fh = ovl_encode_real_fh(enc_lower ? ovl_dentry_lower(dentry) :
 				ovl_dentry_upper(dentry), !enc_lower);
-	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
-		goto fail;
+		return PTR_ERR(fh);
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)


