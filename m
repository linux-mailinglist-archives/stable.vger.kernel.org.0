Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFC91B099E
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgDTMkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727820AbgDTMkm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6CD82070B;
        Mon, 20 Apr 2020 12:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386442;
        bh=61WFqwITioEntxRH6QDaMEwXKdxo0S5pX28b3CWeGdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWYalH9mBkyV2PM7H99mhox+Qp9z8vtUjuDE+reObChzistMmbgKWfm+L542R9mMS
         PjpQg6iIPjOOINhAW6m36jwybvpE6sP++Z2sx9wTBJfAcVz03NqB2EEVeMCfLjaQiQ
         S0phWhZlJPJshv5uwAflI6eAVayXoaNIPpXG16RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "zhangyi (F)" <yi.zhang@huawei.com>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.5 24/65] jbd2: improve comments about freeing data buffers whose page mapping is NULL
Date:   Mon, 20 Apr 2020 14:38:28 +0200
Message-Id: <20200420121511.700998688@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
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
@@ -997,9 +997,10 @@ restart_loop:
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


