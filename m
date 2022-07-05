Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9263566D5B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiGEMWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237749AbiGEMTp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A191DA63;
        Tue,  5 Jul 2022 05:16:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C78CFB817C7;
        Tue,  5 Jul 2022 12:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C59CC341C7;
        Tue,  5 Jul 2022 12:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023371;
        bh=S5VZ16MVAsamjg1oH37WupoF04UNs1l/MFw9ZvMgLjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HTy/eALPeCR7mIEMznLJqEYuRLmes8OtTZhNZ49+6vPkCNeIsaCePLBjjEMkwqOOX
         URCfc964BL8FcTOI6/3MZ1qK6KsLs9B1P2H8PfwF11mKbbceVVxxFGcl/bBYozeMKp
         R0yWNIwWyrb8X7/D2RhVgpQg9kxQbipln8Mn8neA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.18 004/102] ksmbd: set the range of bytes to zero without extending file size in FSCTL_ZERO_DATA
Date:   Tue,  5 Jul 2022 13:57:30 +0200
Message-Id: <20220705115618.540113896@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
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
@@ -1015,7 +1015,9 @@ int ksmbd_vfs_zero_data(struct ksmbd_wor
 				     FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				     off, len);
 
-	return vfs_fallocate(fp->filp, FALLOC_FL_ZERO_RANGE, off, len);
+	return vfs_fallocate(fp->filp,
+			     FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
+			     off, len);
 }
 
 int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,


