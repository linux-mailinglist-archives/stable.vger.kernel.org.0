Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC972A54B9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388114AbgKCVN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbgKCVNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:13:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A2B205ED;
        Tue,  3 Nov 2020 21:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604438018;
        bh=NqUQOzyPiOYE2O8DeQS3aTZsSintQbv5XvPku5QMH98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwoW3yq5Lapr2Lio6DRkAaGp0q9nypc/QZHvrEaEdvZ+hECnJmJAljbu7ltCheTw4
         NRmi0FyFVRd8Lu+yuzeJ+jgMCaZP7+jWbl9EJwDAmiD5CQgpOxBPtjwZBOLOOn6hbQ
         hgLrjT+Y/TDzgZfcWYvANkeeLGagxOZHhVnnekow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 108/125] ext4: fix error handling code in add_new_gdb
Date:   Tue,  3 Nov 2020 21:38:05 +0100
Message-Id: <20201103203213.161004227@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

commit c9e87161cc621cbdcfc472fa0b2d81c63780c8f5 upstream.

When ext4_journal_get_write_access() fails, we should
terminate the execution flow and release n_group_desc,
iloc.bh, dind and gdb_bh.

Cc: stable@kernel.org
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/20200829025403.3139-1-dinghao.liu@zju.edu.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/resize.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -837,8 +837,10 @@ static int add_new_gdb(handle_t *handle,
 
 	BUFFER_TRACE(dind, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dind);
-	if (unlikely(err))
+	if (unlikely(err)) {
 		ext4_std_error(sb, err);
+		goto errout;
+	}
 
 	/* ext4_reserve_inode_write() gets a reference on the iloc */
 	err = ext4_reserve_inode_write(handle, inode, &iloc);


