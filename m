Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F12228A88
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbfEWTQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387579AbfEWTQI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:16:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B73E20863;
        Thu, 23 May 2019 19:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638967;
        bh=IoKpUfohM1tePM/64BXsiJUSHeovw9D5HJOR0CqCOj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4BzG+Aj06ewLHMUiDgL7ND8yGiOnp0GLD7sfRLiUGGmLuhQUNet19J1YzRFHkajn
         NU6//ix97BHnIKIlCX4QcR2N/mebotAMPAb2cSwqfAwObOkwOUzQN4YgoC3OdgXMz4
         cu9tgxf4DYxAxy/tCVnpd2cuXrr9g/Iz2tm4iNbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Bo <bo.liu@linux.alibaba.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 047/114] fuse: honor RLIMIT_FSIZE in fuse_file_fallocate
Date:   Thu, 23 May 2019 21:05:46 +0200
Message-Id: <20190523181735.980642690@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
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
@@ -2975,6 +2975,13 @@ static long fuse_file_fallocate(struct f
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
 


