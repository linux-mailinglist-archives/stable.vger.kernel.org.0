Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4245D4F30AA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiDEIyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241053AbiDEIcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C479BB7C46;
        Tue,  5 Apr 2022 01:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73963B81BC0;
        Tue,  5 Apr 2022 08:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D122DC385A2;
        Tue,  5 Apr 2022 08:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147174;
        bh=6o/TkJM30UgnjB0qSBpxgAHQb1Ios5+9zW0+eXZ9Xo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agm8c1D6B9MJ+VQ9+qfhjgWJoBGcwDQDG+0qqYL49pbDShrcq0sWRNseUJwzS0ZR2
         Wd4bNMtKUESiiNbXhQ5+S6pSJhHsVXdMU2925DJUULLNoJEwVZXwBUA3+xWF0LO3G+
         AQRMy4jzqVHgAq6ppF9Qc74qhBJOp4K3XXY4DSnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.17 1028/1126] loop: fix ioctl calls using compat_loop_info
Date:   Tue,  5 Apr 2022 09:29:35 +0200
Message-Id: <20220405070437.653961215@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Carlos Llamas <cmllamas@google.com>

commit f941c51eeac7ebe0f8ec30943bf78e7f60aad039 upstream.

Support for cryptoloop was deleted in commit 47e9624616c8 ("block:
remove support for cryptoloop and the xor transfer"), making the usage
of loop_info->lo_encrypt_type obsolete. However, this member was also
removed from the compat_loop_info definition and this breaks userspace
ioctl calls for 32-bit binaries and CONFIG_COMPAT=y.

This patch restores the compat_loop_info->lo_encrypt_type member and
marks it obsolete as well as in the uapi header definitions.

Fixes: 47e9624616c8 ("block: remove support for cryptoloop and the xor transfer")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220329201815.1347500-1-cmllamas@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c      |    1 +
 include/uapi/linux/loop.h |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1592,6 +1592,7 @@ struct compat_loop_info {
 	compat_ulong_t	lo_inode;       /* ioctl r/o */
 	compat_dev_t	lo_rdevice;     /* ioctl r/o */
 	compat_int_t	lo_offset;
+	compat_int_t	lo_encrypt_type;        /* obsolete, ignored */
 	compat_int_t	lo_encrypt_key_size;    /* ioctl w/o */
 	compat_int_t	lo_flags;       /* ioctl r/o */
 	char		lo_name[LO_NAME_SIZE];
--- a/include/uapi/linux/loop.h
+++ b/include/uapi/linux/loop.h
@@ -45,7 +45,7 @@ struct loop_info {
 	unsigned long	   lo_inode; 		/* ioctl r/o */
 	__kernel_old_dev_t lo_rdevice; 		/* ioctl r/o */
 	int		   lo_offset;
-	int		   lo_encrypt_type;
+	int		   lo_encrypt_type;		/* obsolete, ignored */
 	int		   lo_encrypt_key_size; 	/* ioctl w/o */
 	int		   lo_flags;
 	char		   lo_name[LO_NAME_SIZE];
@@ -61,7 +61,7 @@ struct loop_info64 {
 	__u64		   lo_offset;
 	__u64		   lo_sizelimit;/* bytes, 0 == max available */
 	__u32		   lo_number;			/* ioctl r/o */
-	__u32		   lo_encrypt_type;
+	__u32		   lo_encrypt_type;		/* obsolete, ignored */
 	__u32		   lo_encrypt_key_size;		/* ioctl w/o */
 	__u32		   lo_flags;
 	__u8		   lo_file_name[LO_NAME_SIZE];


