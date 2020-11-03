Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D772A56A2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgKCV3V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:29:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:34368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733096AbgKCU7T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 118352053B;
        Tue,  3 Nov 2020 20:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437158;
        bh=XbiyG2+4XCbltU0Pwl003nOHv4xzDOODOFq4L/u/11g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9G8ul4QVDKf0FouHksQ88Mh4O+wGU9/B7teNg/mgmM/uRHWnnIWZIG+6PVjgti6J
         qMtgT8xSfesxhuDze2SKQVB8367eITmPLzRm0zmgmpIanKI+wGwEqb5SMei07gjsH6
         YFR2Mxs/5NEj4SaXw9xt/HGEwvxP9GUMMmQd4f8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 172/214] ubifs: mount_ubifs: Release authentication resource in error handling path
Date:   Tue,  3 Nov 2020 21:37:00 +0100
Message-Id: <20201103203306.858426937@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit e2a05cc7f8229e150243cdae40f2af9021d67a4a upstream.

Release the authentication related resource in some error handling
branches in mount_ubifs().

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: <stable@vger.kernel.org>  # 4.20+
Fixes: d8a22773a12c6d7 ("ubifs: Enable authentication support")
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ubifs/super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -1313,7 +1313,7 @@ static int mount_ubifs(struct ubifs_info
 
 	err = ubifs_read_superblock(c);
 	if (err)
-		goto out_free;
+		goto out_auth;
 
 	c->probing = 0;
 
@@ -1325,18 +1325,18 @@ static int mount_ubifs(struct ubifs_info
 		ubifs_err(c, "'compressor \"%s\" is not compiled in",
 			  ubifs_compr_name(c, c->default_compr));
 		err = -ENOTSUPP;
-		goto out_free;
+		goto out_auth;
 	}
 
 	err = init_constants_sb(c);
 	if (err)
-		goto out_free;
+		goto out_auth;
 
 	sz = ALIGN(c->max_idx_node_sz, c->min_io_size) * 2;
 	c->cbuf = kmalloc(sz, GFP_NOFS);
 	if (!c->cbuf) {
 		err = -ENOMEM;
-		goto out_free;
+		goto out_auth;
 	}
 
 	err = alloc_wbufs(c);
@@ -1611,6 +1611,8 @@ out_wbufs:
 	free_wbufs(c);
 out_cbuf:
 	kfree(c->cbuf);
+out_auth:
+	ubifs_exit_authentication(c);
 out_free:
 	kfree(c->write_reserve_buf);
 	kfree(c->bu.buf);


