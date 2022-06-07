Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39077540840
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348859AbiFGR4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349374AbiFGR4N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:56:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905C93614C;
        Tue,  7 Jun 2022 10:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11029B820C3;
        Tue,  7 Jun 2022 17:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C8BC385A5;
        Tue,  7 Jun 2022 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623590;
        bh=uYiciictdrSEQB12gEqhK2G+ukdTSz3fit8pE6wltZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5l4xstNpuhNUVk7H9qZZrqU0Jn8doux1oCHqaruQIAsfgeJ6C/fSStTv+Vvzs5M6
         wVvdYIUajqEcIBjuTQbHgPFcUXfYhLkmUnNxf3PhvS3KvxG1rv0Gcz9MkTMA5HQ9qI
         rcmwb8njTFrTlWQRk3gezrxn8k1JB/IX1xMvdFNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 020/667] fs/ntfs3: Update valid size if -EIOCBQUEUED
Date:   Tue,  7 Jun 2022 18:54:45 +0200
Message-Id: <20220607164935.401052201@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 52e00ea6b26e45fb8159e3b57cdde8d3f9bdd8e9 upstream.

Update valid size if write is still in I/O queue.
Fixes xfstest generic/240
Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -757,6 +757,7 @@ static ssize_t ntfs_direct_IO(struct kio
 	loff_t vbo = iocb->ki_pos;
 	loff_t end;
 	int wr = iov_iter_rw(iter) & WRITE;
+	size_t iter_count = iov_iter_count(iter);
 	loff_t valid;
 	ssize_t ret;
 
@@ -770,10 +771,13 @@ static ssize_t ntfs_direct_IO(struct kio
 				 wr ? ntfs_get_block_direct_IO_W
 				    : ntfs_get_block_direct_IO_R);
 
-	if (ret <= 0)
+	if (ret > 0)
+		end = vbo + ret;
+	else if (wr && ret == -EIOCBQUEUED)
+		end = vbo + iter_count;
+	else
 		goto out;
 
-	end = vbo + ret;
 	valid = ni->i_valid;
 	if (wr) {
 		if (end > valid && !S_ISBLK(inode->i_mode)) {


