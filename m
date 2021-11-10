Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2B44C81B
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhKJS6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233989AbhKJS5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CFC7619FA;
        Wed, 10 Nov 2021 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636570214;
        bh=lEqspUV7rcw4dwELpIRFYPtY7p3pQMXa7RX4y5Ua81U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zifd3pP7oa3dx7nOAjFHqPhSQ0id0rZpW6u4C8r0qLQwf4hzMn51+vF4S3mNW+Z8x
         XJTT4LEFoP/pB93tsMkU8hQIR8aP1v/RhEFE61IZwIYf1kPUhmXJg1BV6la/OwpAWx
         Bim8uneQaYUePoPo5q06J5n9VWuoODJjStthXDrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 14/26] btrfs: fix lzo_decompress_bio() kmap leakage
Date:   Wed, 10 Nov 2021 19:44:13 +0100
Message-Id: <20211110182004.150674453@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182003.700594531@linuxfoundation.org>
References: <20211110182003.700594531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2cf3f8133bda2a0945cc4c70e681ecb25b52b913 upstream.

Commit ccaa66c8dd27 reinstated the kmap/kunmap that had been dropped in
commit 8c945d32e604 ("btrfs: compression: drop kmap/kunmap from lzo").

However, it seems to have done so incorrectly due to the change not
reverting cleanly, and lzo_decompress_bio() ended up not having a
matching "kunmap()" to the "kmap()" that was put back.

Also, any assert that the page pointer is not NULL should be before the
kmap() of said pointer, since otherwise you'd just oops in the kmap()
before the assert would even trigger.

I noticed this when trying to verify my btrfs merge, and things not
adding up.  I'm doing this fixup before re-doing my merge, because this
commit needs to also be backported to 5.15 (after verification from the
btrfs people).

Fixes: ccaa66c8dd27 ("Revert 'btrfs: compression: drop kmap/kunmap from lzo'")
Cc: David Sterba <dsterba@suse.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/lzo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -357,9 +357,10 @@ int lzo_decompress_bio(struct list_head
 		ASSERT(cur_in / sectorsize ==
 		       (cur_in + LZO_LEN - 1) / sectorsize);
 		cur_page = cb->compressed_pages[cur_in / PAGE_SIZE];
-		kaddr = kmap(cur_page);
 		ASSERT(cur_page);
+		kaddr = kmap(cur_page);
 		seg_len = read_compress_length(kaddr + offset_in_page(cur_in));
+		kunmap(cur_page);
 		cur_in += LZO_LEN;
 
 		/* Copy the compressed segment payload into workspace */


