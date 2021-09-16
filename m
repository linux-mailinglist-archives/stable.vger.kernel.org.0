Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFEE40E1F2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241419AbhIPQdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241474AbhIPQbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31E66137D;
        Thu, 16 Sep 2021 16:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809154;
        bh=fYi5Vj0hvNhaeRT8uo3OjxcwrFslV1ekSpdFtnZZzBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BM7e5RlM3MJB3GDrUbdBaLHhsfOm+Z7/tJCpgqLD+Wf3dEL7M43ccHgbDBTBmnosw
         UEqwRHEYaO+9CjkW4I7YsP17xiSiCPBWvRNsxotTD8RqK6YjtaA0A0M5CbPlYlcYoG
         fYaBMMbpeNxZ9LKKlJlHIn15n57c631zndbWxV1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 051/380] io_uring: place fixed tables under memcg limits
Date:   Thu, 16 Sep 2021 17:56:48 +0200
Message-Id: <20210916155805.717753236@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0bea96f59ba40e63c0ae93ad6a02417b95f22f4d upstream.

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7195,11 +7195,11 @@ static struct io_rsrc_data *io_rsrc_data
 {
 	struct io_rsrc_data *data;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
 	if (!data)
 		return NULL;
 
-	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL);
+	data->tags = kvcalloc(nr, sizeof(*data->tags), GFP_KERNEL_ACCOUNT);
 	if (!data->tags) {
 		kfree(data);
 		return NULL;
@@ -7477,7 +7477,7 @@ static bool io_alloc_file_tables(struct
 {
 	unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
 
-	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
+	table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL_ACCOUNT);
 	if (!table->files)
 		return false;
 
@@ -7485,7 +7485,7 @@ static bool io_alloc_file_tables(struct
 		unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
 
 		table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
-					GFP_KERNEL);
+					GFP_KERNEL_ACCOUNT);
 		if (!table->files[i])
 			break;
 		nr_files -= this_files;


