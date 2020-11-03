Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F492A5583
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388510AbgKCVTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730019AbgKCVIl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:41 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12287206B5;
        Tue,  3 Nov 2020 21:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437720;
        bh=RzEuN25/ar48nnIB8Nmiu0Rm9ojCIu5D57M0usXW0lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gcvnIqN4FbOG3J+gP2o/Yg/Xdjj7h4dwy4rcVOrb196f5BMld6J6sR0pnoBrIzmnY
         yMBLkzi3W3kG6MfRiisfECdjEDO3PI5/jvSx4/+7M4/lJa/umJifrWg0RFVicvK4PB
         wknn+62WPtghVdRybldnHe3mArE7CzAqZ8EueU8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 174/191] ext4: fix error handling code in add_new_gdb
Date:   Tue,  3 Nov 2020 21:37:46 +0100
Message-Id: <20201103203248.889470846@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
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
@@ -861,8 +861,10 @@ static int add_new_gdb(handle_t *handle,
 
 	BUFFER_TRACE(dind, "get_write_access");
 	err = ext4_journal_get_write_access(handle, dind);
-	if (unlikely(err))
+	if (unlikely(err)) {
 		ext4_std_error(sb, err);
+		goto errout;
+	}
 
 	/* ext4_reserve_inode_write() gets a reference on the iloc */
 	err = ext4_reserve_inode_write(handle, inode, &iloc);


