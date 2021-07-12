Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB233C5082
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbhGLHdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242557AbhGLHbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C8EE60230;
        Mon, 12 Jul 2021 07:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074936;
        bh=LTOdPU0kQVBKBTi9HigZm4Qg5izj/Yg/7Qzq6v93EJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu46+WN445aFnJCRv06IaDkAQci0gvQTEJUW2wKnmDT4yO2O2zBwO6hHnA/bV3SQo
         rSaU++My0V9TCBI18Hbvu+wKMg7aR+SdbCETioRQolI97dPH1xeP7qXEh+EtPL0fI7
         MJtj3YZ9gViYWYc2JFRp2aEKKGlSeTij6Za+9QX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 049/800] btrfs: compression: dont try to compress if we dont have enough pages
Date:   Mon, 12 Jul 2021 08:01:12 +0200
Message-Id: <20210712060920.291772615@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
@@ -603,7 +603,7 @@ again:
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {


