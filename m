Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A44ACAA84
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393395AbfJCRH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404445AbfJCQgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:36:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C41D92133F;
        Thu,  3 Oct 2019 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120597;
        bh=1/khuy4O3zZHpw9LAei40BNaPZ3LL9+GHfckPbkNiRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Gc/bclxCzp/rOOf6On8di02KCoUAxT6Yk9055nXaUhNIoTc9IyZQtE9VL8nBB3K2
         UvqKUL4CJjXJSFMAeuDI95UvwBzqrgOKQFDyw5VfH/hHFDP3OJKh5oyFSzsdQPBNoL
         EaVoizOgVI6jQ7Iqvxr5QsB1YHOZFD65LUa9QmVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.2 280/313] ovl: Fix dereferencing possible ERR_PTR()
Date:   Thu,  3 Oct 2019 17:54:18 +0200
Message-Id: <20191003154600.644755235@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
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
@@ -227,9 +227,8 @@ static int ovl_d_to_fh(struct dentry *de
 	/* Encode an upper or lower file handle */
 	fh = ovl_encode_real_fh(enc_lower ? ovl_dentry_lower(dentry) :
 				ovl_dentry_upper(dentry), !enc_lower);
-	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
-		goto fail;
+		return PTR_ERR(fh);
 
 	err = -EOVERFLOW;
 	if (fh->len > buflen)


