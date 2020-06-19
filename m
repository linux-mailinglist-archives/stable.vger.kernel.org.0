Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D77201503
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390843AbgFSQQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390906AbgFSPCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:02:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C79BD206DB;
        Fri, 19 Jun 2020 15:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578975;
        bh=ZHm2e9kSWCE/+gbErOovveJIiw92+SIMeDzUp+xvYz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2BcyR7u7zaaMrsnasLQSNZSuUhUnLjuxsokrnZw50Iebpyv/DA/vnQ4WyB33w1Q5
         osETVg9xu9BB/O/Cv9cveGvcnHaoENHBNXOPgc5cLMVfzvljcpYnJSdKWW47fJs2K8
         /u8oQLD9/xyTWTqTifryxMGrGQMeQMleF1nHVayA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 229/267] btrfs: fix wrong file range cleanup after an error filling dealloc range
Date:   Fri, 19 Jun 2020 16:33:34 +0200
Message-Id: <20200619141659.700007592@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit e2c8e92d1140754073ad3799eb6620c76bab2078 ]

If an error happens while running dellaloc in COW mode for a range, we can
end up calling extent_clear_unlock_delalloc() for a range that goes beyond
our range's end offset by 1 byte, which affects 1 extra page. This results
in clearing bits and doing page operations (such as a page unlock) outside
our target range.

Fix that by calling extent_clear_unlock_delalloc() with an inclusive end
offset, instead of an exclusive end offset, at cow_file_range().

Fixes: a315e68f6e8b30 ("Btrfs: fix invalid attempt to free reserved space on failure to cow range")
CC: stable@vger.kernel.org # 4.14+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b4f295a058d8..887f9ebc2bc2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1136,8 +1136,8 @@ static noinline int cow_file_range(struct inode *inode,
 	 */
 	if (extent_reserved) {
 		extent_clear_unlock_delalloc(inode, start,
-					     start + cur_alloc_size,
-					     start + cur_alloc_size,
+					     start + cur_alloc_size - 1,
+					     start + cur_alloc_size - 1,
 					     locked_page,
 					     clear_bits,
 					     page_ops);
-- 
2.25.1



