Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2CD2010AE
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393900AbgFSPcf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:32:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393897AbgFSPce (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:32:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D26020757;
        Fri, 19 Jun 2020 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580754;
        bh=ctnKrlZlC9i41gZd4wzwt14jBTE8bLOOurempFZmoAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cmhx8AY62PN4C0wpW8E/iYDpZcxkORVSvPptDbA7nPhzOMFAXSAI3GYMImUsM76sI
         8mtzom4s4Dp1sq3EYPiNsL12I+BXmAVNTcHjli5YRB/EpEOf8HLK9Dq7EPXrJ1Z0cm
         FKdR7xtTlrKaLhchlGnqJoqwknb3K2+PsgfcVgcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.7 370/376] f2fs: dont leak filename in f2fs_try_convert_inline_dir()
Date:   Fri, 19 Jun 2020 16:34:48 +0200
Message-Id: <20200619141727.806071516@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit ff5f85c8d62a487bde415ef4c9e2d0be718021df upstream.

We need to call fscrypt_free_filename() to free the memory allocated by
fscrypt_setup_filename().

Fixes: b06af2aff28b ("f2fs: convert inline_dir early before starting rename")
Cc: <stable@vger.kernel.org> # v5.6+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/inline.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -559,12 +559,12 @@ int f2fs_try_convert_inline_dir(struct i
 	ipage = f2fs_get_node_page(sbi, dir->i_ino);
 	if (IS_ERR(ipage)) {
 		err = PTR_ERR(ipage);
-		goto out;
+		goto out_fname;
 	}
 
 	if (f2fs_has_enough_room(dir, ipage, &fname)) {
 		f2fs_put_page(ipage, 1);
-		goto out;
+		goto out_fname;
 	}
 
 	inline_dentry = inline_data_addr(dir, ipage);
@@ -572,6 +572,8 @@ int f2fs_try_convert_inline_dir(struct i
 	err = do_convert_inline_dir(dir, ipage, inline_dentry);
 	if (!err)
 		f2fs_put_page(ipage, 1);
+out_fname:
+	fscrypt_free_filename(&fname);
 out:
 	f2fs_unlock_op(sbi);
 	return err;


