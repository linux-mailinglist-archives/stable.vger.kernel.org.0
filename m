Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3236B49A8
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbjCJPOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbjCJPOS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD196A9DF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63806B822E7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0102C433D2;
        Fri, 10 Mar 2023 15:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460680;
        bh=zxj7K5gdufOISpFE8B0poH6HnGn1xCPHJdbhBBXrvps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzK3r+EqQdQN2Rkl9fSLL83ncMR9M5vZNiJHodbk/xjAtlEl6U/XEJccKDIFrE1Lt
         Okjo25liXeoy960E6dIZ/PwbocS8EglNTgOuOPG07rhlKCT6Lw+Jpn2sXIqb5JRjzX
         QXhrZHxD4DhEJRsyxgj5xG2XZ9rLTV13fqtPgmyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 376/529] io_uring/rsrc: disallow multi-source reg buffers
Date:   Fri, 10 Mar 2023 14:38:39 +0100
Message-Id: <20230310133822.425039048@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit edd478269640b360c6f301f2baa04abdda563ef3 upstream.

If two or more mappings go back to back to each other they can be passed
into io_uring to be registered as a single registered buffer. That would
even work if mappings came from different sources, e.g. it's possible to
mix in this way anon pages and pages from shmem or hugetlb. That is not
a problem but it'd rather be less prone if we forbid such mixing.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -9057,14 +9057,17 @@ static int io_sqe_buffer_register(struct
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file) {
+				ret = -EINVAL;
+				break;
+			}
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
 				ret = -EOPNOTSUPP;
 				break;
 			}


