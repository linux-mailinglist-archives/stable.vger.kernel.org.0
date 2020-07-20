Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E463226A13
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgGTPzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbgGTPzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB5D12065E;
        Mon, 20 Jul 2020 15:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260524;
        bh=RFsfywAtYx/DgJXRzwO7LJohgfSzhyyehseVmJch2n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fgk/68aHPHXkvPfxdxIi1poNLpvjkjRVkli8oai1lBU/8WLRhmlIu/k0l0EAJJilu
         XV36ucjb/L7CKtAJ9kja22ihxv43uUB2l4q7eXFXz62Eo3Zu7yzaR/kHVe2SO4NbJq
         CPnlqq9c2QySSm5Aew6gKzQWB1BDmEie2OXU6BSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        youngjun <her0gyugyu@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4.19 103/133] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Mon, 20 Jul 2020 17:37:30 +0200
Message-Id: <20200720152808.713104576@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
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
@@ -1310,14 +1310,23 @@ static int ovl_get_lower_layers(struct s
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


