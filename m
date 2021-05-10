Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D25D378938
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbhEJL0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238359AbhEJLR3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A117361139;
        Mon, 10 May 2021 11:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645196;
        bh=Ll8FqHKYmyisncPLSUPpnG4ut9uGKguVRFBpQkyUufk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLHa3AAQYCzrePcYOYyP3RyarbnaAL8z4viV8dx8AX3iuQgyMG4aZ8v8XdGTYeaPa
         Kbs1I6NETfvqeBH+++GJLmY9Dx1x8dFbGZe9X+C+QIXv+q5WZ8sk6NOFEdVEQMHXix
         rrPObn7wdtKQVpGEVlkdcElEQRMXDMaFN0MmhrFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.12 376/384] dm persistent data: packed struct should have an aligned() attribute too
Date:   Mon, 10 May 2021 12:22:45 +0200
Message-Id: <20210510102027.171009767@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
 	__le64 keys[];
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


