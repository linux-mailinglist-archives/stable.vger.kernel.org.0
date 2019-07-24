Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8526173B5B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392199AbfGXT7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391817AbfGXT7P (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:59:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 215AE20665;
        Wed, 24 Jul 2019 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998354;
        bh=h9luB06a6KM7378fcf9ADqkZceMuBNqNbM32s08vcMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5jmrW5/txHJltp5WxTaE0EuYxtZcjbIuX+rp5BCOMnjg59Ms0myIpJdQ5155Yyuv
         xzBIW+79WwT3llmfcoJEpvw43I3yxF6PE0/llPNRkOOiyOqkaHkITIGVGmNZjjsIjf
         I3nY7RWsdmjw1r354j70GKHpVxa0Fpc3oK8XbjpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.1 335/371] Btrfs: add missing inode version, ctime and mtime updates when punching hole
Date:   Wed, 24 Jul 2019 21:21:27 +0200
Message-Id: <20190724191748.945805433@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 179006688a7e888cbff39577189f2e034786d06a upstream.

If the range for which we are punching a hole covers only part of a page,
we end up updating the inode item but we skip the update of the inode's
iversion, mtime and ctime. Fix that by ensuring we update those properties
of the inode.

A patch for fstests test case generic/059 that tests this as been sent
along with this fix.

Fixes: 2aaa66558172b0 ("Btrfs: add hole punching")
Fixes: e8c1c76e804b18 ("Btrfs: add missing inode update when punching hole")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2713,6 +2713,11 @@ out_only_mutex:
 		 * for detecting, at fsync time, if the inode isn't yet in the
 		 * log tree or it's there but not up to date.
 		 */
+		struct timespec64 now = current_time(inode);
+
+		inode_inc_iversion(inode);
+		inode->i_mtime = now;
+		inode->i_ctime = now;
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			err = PTR_ERR(trans);


