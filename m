Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7A2287BB
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390139AbfEWTWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390531AbfEWTWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE2F72054F;
        Thu, 23 May 2019 19:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639360;
        bh=Zn2SzCBZvQOavFqceAiCKkjNO8KtOuQz8mUA0ZXaXMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PavKuH7AmvS0PJ/s5f02/vD/l1hT8AYbjrG7xQw4vDNCX7lGw6sk3Pj5/DLogvvgJ
         Q7NXpjvmuCc3LilkZ+OLAshnfi4PKlkbz/0ekTJgQGs6D8T3gEF13IZY6VNedlSOko
         u4d2Kw37+wle4J7OVYo2dH4+1ksIlWXvWJT//Hgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.0 059/139] fuse: honor RLIMIT_FSIZE in fuse_file_fallocate
Date:   Thu, 23 May 2019 21:05:47 +0200
Message-Id: <20190523181728.363246570@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Bo <bo.liu@linux.alibaba.com>

commit 0cbade024ba501313da3b7e5dd2a188a6bc491b5 upstream.

fstests generic/228 reported this failure that fuse fallocate does not
honor what 'ulimit -f' has set.

This adds the necessary inode_newsize_ok() check.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Fixes: 05ba1f082300 ("fuse: add FALLOCATE operation")
Cc: <stable@vger.kernel.org> # v3.5
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2987,6 +2987,13 @@ static long fuse_file_fallocate(struct f
 		}
 	}
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    offset + length > i_size_read(inode)) {
+		err = inode_newsize_ok(inode, offset + length);
+		if (err)
+			return err;
+	}
+
 	if (!(mode & FALLOC_FL_KEEP_SIZE))
 		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 


