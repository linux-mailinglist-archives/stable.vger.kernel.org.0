Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AED8524BC68
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgHTMpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:45:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727995AbgHTJpl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:45:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 359E62078D;
        Thu, 20 Aug 2020 09:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916717;
        bh=zaaLhM7eXhB5eLTe5jjJ0F3sXCMNEnnwrBathX/5my4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFg+0ermQvq0iJRkW6Z0F4L+vY7Vd9uWMysmJAnPpqD21WoYO6eL/kuCCs1bYTzUB
         y6e+aXPDvgcTFPCMYDv2C9Zq+8rZDn+xCncqFYdPjoK9ZAahstobLR1P5/jjfzbfYf
         uK1nHwSaoDdZfvWqsRP15OMPN45NYh0zYceB7F8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 022/152] btrfs: dont WARN if we abort a transaction with EROFS
Date:   Thu, 20 Aug 2020 11:19:49 +0200
Message-Id: <20200820091554.781504175@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit f95ebdbed46a4d8b9fdb7bff109fdbb6fc9a6dc8 upstream.

If we got some sort of corruption via a read and call
btrfs_handle_fs_error() we'll set BTRFS_FS_STATE_ERROR on the fs and
complain.  If a subsequent trans handle trips over this it'll get EROFS
and then abort.  However at that point we're not aborting for the
original reason, we're aborting because we've been flipped read only.
We do not need to WARN_ON() here.

CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ctree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3166,7 +3166,7 @@ do {								\
 	/* Report first abort since mount */			\
 	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
 			&((trans)->fs_info->fs_state))) {	\
-		if ((errno) != -EIO) {				\
+		if ((errno) != -EIO && (errno) != -EROFS) {		\
 			WARN(1, KERN_DEBUG				\
 			"BTRFS: Transaction aborted (error %d)\n",	\
 			(errno));					\


