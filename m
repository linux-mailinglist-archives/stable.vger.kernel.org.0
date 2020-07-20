Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809FC2267D3
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388349AbgGTQPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:15:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387612AbgGTQO5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:14:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7BE42064B;
        Mon, 20 Jul 2020 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261697;
        bh=QbPG9rSXRiATsoXetHNIz+YI8PZk1SZ+694pRJ3V0wA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJ6XTzzVNn02QujVEsA2QWHWJ7Yr8yjDnhJn3En094gZcSygfC+MOqyu2MsAiu072
         QpYHrm4n8bZ+ZYXBgKjqQV8yLifhPgXJqZN3FX7cUYc9iAjjf5fz5HcAv1jhNPs6/t
         5a1cg1+rDZUKgGU5sMVCnCYGfXJUqRAYWouztG6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        youngjun <her0gyugyu@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 179/244] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Mon, 20 Jul 2020 17:37:30 +0200
Message-Id: <20200720152834.354881741@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: youngjun <her0gyugyu@gmail.com>

commit 24f14009b8f1754ec2ae4c168940c01259b0f88a upstream.

When "ovl_is_inuse" true case, trap inode reference not put.  plus adding
the comment explaining sequence of ovl_is_inuse after ovl_setup_trap.

Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers detection")
Cc: <stable@vger.kernel.org> # v4.19+
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: youngjun <her0gyugyu@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/overlayfs/super.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1450,14 +1450,23 @@ static int ovl_get_layers(struct super_b
 		if (err < 0)
 			goto out;
 
+		/*
+		 * Check if lower root conflicts with this overlay layers before
+		 * checking if it is in-use as upperdir/workdir of "another"
+		 * mount, because we do not bother to check in ovl_is_inuse() if
+		 * the upperdir/workdir is in fact in-use by our
+		 * upperdir/workdir.
+		 */
 		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
 		if (err)
 			goto out;
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
-			if (err)
+			if (err) {
+				iput(trap);
 				goto out;
+			}
 		}
 
 		mnt = clone_private_mount(&stack[i]);


