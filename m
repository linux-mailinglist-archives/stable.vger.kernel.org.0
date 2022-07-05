Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E7566C78
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbiGEMPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbiGEMOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F418E29;
        Tue,  5 Jul 2022 05:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58680619BF;
        Tue,  5 Jul 2022 12:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B66C341C8;
        Tue,  5 Jul 2022 12:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023080;
        bh=3ibA2K3zrXlCUOmjKjECKjcfhQ8LGpRYnMrZvWrQmZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnNuA+Dar7Ih7orUhSeAE5KMM7G/yCA9emlZk+hU4KaDn0QXeQBUPhqJPaulBE5Kx
         yzJwEUkAF8owZV+TOyPy4gMbJxY99e55xZJZdN5VHX28zFqwiKD5izWwROrHB7xLjL
         7B1zZ5wkgiEP+PtXUE5VdedDG3Y12LJyrm6jHJns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 03/98] ksmbd: set the range of bytes to zero without extending file size in FSCTL_ZERO_DATA
Date:   Tue,  5 Jul 2022 13:57:21 +0200
Message-Id: <20220705115617.670005125@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 18e39fb960e6a908ac5230b57e3d0d6c25232368 upstream.

generic/091, 263 test failed since commit f66f8b94e7f2 ("cifs: when
extending a file with falloc we should make files not-sparse").
FSCTL_ZERO_DATA sets the range of bytes to zero without extending file
size. The VFS_FALLOCATE_FL_KEEP_SIZE flag should be used even on
non-sparse files.

Cc: stable@vger.kernel.org
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1018,7 +1018,9 @@ int ksmbd_vfs_zero_data(struct ksmbd_wor
 				     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				     off, len);
 
-	return vfs_fallocate(fp->filp, FALLOC_FL_ZERO_RANGE, off, len);
+	return vfs_fallocate(fp->filp,
+			     FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+			     off, len);
 }
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,


