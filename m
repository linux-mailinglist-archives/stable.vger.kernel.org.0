Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6A1B3D2E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgDVKMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgDVKMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:12:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F822070B;
        Wed, 22 Apr 2020 10:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550356;
        bh=Ys5RXvrrC1EnMRzQHHXyl4T21fdl1y6NreroSyuQrOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v9yswd7bq/GdPWR009dLNWz9rBQDu9MNa0XWyN1NJKrTsQ6fkCbQVwD5ZstbSpfUL
         BAIhQg/O9ZpXeBBnH32+wuHvHsG34aL77+h4gUNOsYd+BA7DGRNav+JXDQQfJ7WQSp
         jNcdtw4R0KGmGtGzj4GJEQplKUrHbc8+ChpG+qPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 114/199] jbd2: improve comments about freeing data buffers whose page mapping is NULL
Date:   Wed, 22 Apr 2020 11:57:20 +0200
Message-Id: <20200422095109.065097450@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit 780f66e59231fcf882f36c63f287252ee47cc75a upstream.

Improve comments in jbd2_journal_commit_transaction() to describe why
we don't need to clear the buffer_mapped bit for freeing file mapping
buffers whose page mapping is NULL.

Link: https://lore.kernel.org/r/20200217112706.20085-1-yi.zhang@huawei.com
Fixes: c96dceeabf76 ("jbd2: do not clear the BH_Mapped flag when forgetting a metadata buffer")
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/commit.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -994,9 +994,10 @@ restart_loop:
 			 * journalled data) we need to unmap buffer and clear
 			 * more bits. We also need to be careful about the check
 			 * because the data page mapping can get cleared under
-			 * out hands, which alse need not to clear more bits
-			 * because the page and buffers will be freed and can
-			 * never be reused once we are done with them.
+			 * our hands. Note that if mapping == NULL, we don't
+			 * need to make buffer unmapped because the page is
+			 * already detached from the mapping and buffers cannot
+			 * get reused.
 			 */
 			mapping = READ_ONCE(bh->b_page->mapping);
 			if (mapping && !sb_is_blkdev_sb(mapping->host->i_sb)) {


