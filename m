Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531DA3C4B92
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239672AbhGLG6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:58:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238403AbhGLG5H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:57:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E4B61361;
        Mon, 12 Jul 2021 06:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072859;
        bh=Vz/8nZG8zcT/Di9vwI6Q5i3RZv9Eig3ce4H3Fe2Gr2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NczqGdAvF5ldHovSiv1UKgD1gbUa+5AXYwGiH2O89SGyYU0cyjmXF7k/sifyRiOq
         7pgWR4yBZ1Ilo+GJN7a3j8feRNs43wRencQ1qRuZqxIt9rzj4+8hMWVTWCIl8Qh30d
         3U6GSkEtATF9YXuzJHelaRiH5loipQptYQcEZvnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 046/700] btrfs: compression: dont try to compress if we dont have enough pages
Date:   Mon, 12 Jul 2021 08:02:09 +0200
Message-Id: <20210712060931.196287208@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Sterba <dsterba@suse.com>

commit f2165627319ffd33a6217275e5690b1ab5c45763 upstream.

The early check if we should attempt compression does not take into
account the number of input pages. It can happen that there's only one
page, eg. a tail page after some ranges of the BTRFS_MAX_UNCOMPRESSED
have been processed, or an isolated page that won't be converted to an
inline extent.

The single page would be compressed but a later check would drop it
again because the result size must be at least one block shorter than
the input. That can never work with just one page.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -598,7 +598,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {


