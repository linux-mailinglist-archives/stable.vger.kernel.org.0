Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3DC82F19E
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfE3EOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:14:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfE3DQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAA7E2449A;
        Thu, 30 May 2019 03:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186170;
        bh=2nYH1qQ9RxS8QLjCa72oJqTvw0iZyiwzd7aWWj46HsY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6/bn4Q5B9TXpKR3ozBAPkt7h4DHvEKGJUDV60TstWaqDdf3A2y+3FEIJcBVjJzIG
         SOBEQb0Oqv+Q9Tq9VkxE6UxFWOt/AY+cn6rTL610sgRaJjbr/xVYa/j+5llY1yK+dx
         ueE8TrEjPEqF+lF+M+MIDTKOklv8YqAjIJpd14xQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Yu Xu <xuyu@linux.alibaba.com>
Subject: [PATCH 4.19 025/276] NFSv4.2 fix unnecessary retry in nfs4_copy_file_range
Date:   Wed, 29 May 2019 20:03:03 -0700
Message-Id: <20190530030525.712173368@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

commit 45ac486ecf2dc998e25cf32f0cabf2deaad875be upstream.

Currently nfs42_proc_copy_file_range() can not return EAGAIN.

Fixes: e4648aa4f98a ("NFS recover from destination server reboot for copies")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Yu Xu <xuyu@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4file.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -133,15 +133,9 @@ static ssize_t nfs4_copy_file_range(stru
 				    struct file *file_out, loff_t pos_out,
 				    size_t count, unsigned int flags)
 {
-	ssize_t ret;
-
 	if (file_inode(file_in) == file_inode(file_out))
 		return -EINVAL;
-retry:
-	ret = nfs42_proc_copy(file_in, pos_in, file_out, pos_out, count);
-	if (ret == -EAGAIN)
-		goto retry;
-	return ret;
+	return nfs42_proc_copy(file_in, pos_in, file_out, pos_out, count);
 }
 
 static loff_t nfs4_file_llseek(struct file *filep, loff_t offset, int whence)


