Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98199566C8F
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbiGEMQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbiGEMOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:14:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B5C18E3C;
        Tue,  5 Jul 2022 05:11:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 198C8B817D6;
        Tue,  5 Jul 2022 12:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5864DC341C8;
        Tue,  5 Jul 2022 12:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023094;
        bh=tXppN8BcPgQ4XAzOGRUOpzB7tCna+gCnSSASx3UTd4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s7JLUr8VKGBed3yfF2d9fNSVJZHxKZZ8Sc6yE0TYqJteIJqrddqDZuYM/ImeAQGqb
         XPA5AARg3MBGrN9A0jZE7DvPNPsz4wN5A2z43KGe6gNTCyps9quQgrJVBpsinqytvg
         Z27XeXRr3ovHfLdWHY5FFYrnfLnknXwzDXTZdr0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 05/98] ksmbd: use vfs_llseek instead of dereferencing NULL
Date:   Tue,  5 Jul 2022 13:57:23 +0200
Message-Id: <20220705115617.728426832@linuxfoundation.org>
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 067baa9a37b32b95fdeabccde4b0cb6a2cf95f96 upstream.

By not checking whether llseek is NULL, this might jump to NULL. Also,
it doesn't check FMODE_LSEEK. Fix this by using vfs_llseek(), which
always does the right thing.

Fixes: f44158485826 ("cifsd: add file operations")
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1051,7 +1051,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_fi
 	*out_count = 0;
 	end = start + length;
 	while (start < end && *out_count < in_count) {
-		extent_start = f->f_op->llseek(f, start, SEEK_DATA);
+		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
 			if (extent_start != -ENXIO)
 				ret = (int)extent_start;
@@ -1061,7 +1061,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_fi
 		if (extent_start >= end)
 			break;
 
-		extent_end = f->f_op->llseek(f, extent_start, SEEK_HOLE);
+		extent_end = vfs_llseek(f, extent_start, SEEK_HOLE);
 		if (extent_end < 0) {
 			if (extent_end != -ENXIO)
 				ret = (int)extent_end;


