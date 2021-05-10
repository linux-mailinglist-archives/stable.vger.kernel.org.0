Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9081F378306
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhEJKlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232753AbhEJKkA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:40:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF95F61959;
        Mon, 10 May 2021 10:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642652;
        bh=Iu+n9JsXKTp3CbzqBVUQxZ1DMRkaPClel+mrPh+YlV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6TLQ2tDKJqYQwkUk1LEDMT0eCkuWi7gLhPAWRZ1eJxfZ4m6KQtyMnOXeIpIkSTWr
         NFpIzZEyeVmcGLGImzEaHc561L4PDy80x2FGzVGe7qm0fclU4NuDiKpZbezHmxbLZo
         OwITwbffDE/P5tCZebdq1SyB7yHkNS1lbjy7uYSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 181/184] dm persistent data: packed struct should have an aligned() attribute too
Date:   Mon, 10 May 2021 12:21:15 +0200
Message-Id: <20210510101956.049174862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

commit a88b2358f1da2c9f9fcc432f2e0a79617fea397c upstream.

Otherwise most non-x86 architectures (e.g. riscv, arm) will resort to
byte-by-byte access.

Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-internal.h   |    4 ++--
 drivers/md/persistent-data/dm-space-map-common.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -34,12 +34,12 @@ struct node_header {
 	__le32 max_entries;
 	__le32 value_size;
 	__le32 padding;
-} __packed;
+} __attribute__((packed, aligned(8)));
 
 struct btree_node {
 	struct node_header header;
 	__le64 keys[0];
-} __packed;
+} __attribute__((packed, aligned(8)));
 
 
 /*
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -33,7 +33,7 @@ struct disk_index_entry {
 	__le64 blocknr;
 	__le32 nr_free;
 	__le32 none_free_before;
-} __packed;
+} __attribute__ ((packed, aligned(8)));
 
 
 #define MAX_METADATA_BITMAPS 255
@@ -43,7 +43,7 @@ struct disk_metadata_index {
 	__le64 blocknr;
 
 	struct disk_index_entry index[MAX_METADATA_BITMAPS];
-} __packed;
+} __attribute__ ((packed, aligned(8)));
 
 struct ll_disk;
 
@@ -86,7 +86,7 @@ struct disk_sm_root {
 	__le64 nr_allocated;
 	__le64 bitmap_root;
 	__le64 ref_count_root;
-} __packed;
+} __attribute__ ((packed, aligned(8)));
 
 #define ENTRIES_PER_BYTE 4
 
@@ -94,7 +94,7 @@ struct disk_bitmap_header {
 	__le32 csum;
 	__le32 not_used;
 	__le64 blocknr;
-} __packed;
+} __attribute__ ((packed, aligned(8)));
 
 enum allocation_event {
 	SM_NONE,


