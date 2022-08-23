Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD7659D9D5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347776AbiHWKDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352083AbiHWKBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:01:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAEDA30F50;
        Tue, 23 Aug 2022 01:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 032D2B81C28;
        Tue, 23 Aug 2022 08:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54825C433D6;
        Tue, 23 Aug 2022 08:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244521;
        bh=W9WxLmYxGODJ81TG+pLggD5KFLjXaVnyk550yao84Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhbyQToBvU9PEvhS5i0hQG1C9MSVKvMRT4OuIB5bwK5mRKFLE12crKDYsyuQ6MmIJ
         h2qpM1ehIWBsIxzV7c4V9KW3bjLo6Mw++pZ1a4RomYoTTKKXqkPPv5M9zQhGs60h9M
         A4p0bcIXCboFY1fAZv7nQQvLdNfo5opoyPELyWSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 106/244] fs/ntfs3: Fix double free on remount
Date:   Tue, 23 Aug 2022 10:24:25 +0200
Message-Id: <20220823080102.559168824@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit cd39981fb92adf0cc736112f87e3e61602baa415 upstream.

Pointer to options was freed twice on remount
Fixes xfstest generic/361
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/super.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -30,6 +30,7 @@
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/log2.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/nls.h>
 #include <linux/seq_file.h>
@@ -390,7 +391,7 @@ static int ntfs_fs_reconfigure(struct fs
 		return -EINVAL;
 	}
 
-	memcpy(sbi->options, new_opts, sizeof(*new_opts));
+	swap(sbi->options, fc->fs_private);
 
 	return 0;
 }
@@ -901,6 +902,8 @@ static int ntfs_fill_super(struct super_
 	ref.high = 0;
 
 	sbi->sb = sb;
+	sbi->options = fc->fs_private;
+	fc->fs_private = NULL;
 	sb->s_flags |= SB_NODIRATIME;
 	sb->s_magic = 0x7366746e; // "ntfs"
 	sb->s_op = &ntfs_sops;
@@ -1264,8 +1267,6 @@ load_root:
 		goto put_inode_out;
 	}
 
-	fc->fs_private = NULL;
-
 	return 0;
 
 put_inode_out:
@@ -1418,7 +1419,6 @@ static int ntfs_init_fs_context(struct f
 	mutex_init(&sbi->compress.mtx_lzx);
 #endif
 
-	sbi->options = opts;
 	fc->s_fs_info = sbi;
 ok:
 	fc->fs_private = opts;


