Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B64BDA02C
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392701AbfJPWIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437936AbfJPV5n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:57:43 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E333121D7D;
        Wed, 16 Oct 2019 21:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263062;
        bh=2m19+YgUmMyrEpYecCFQt1Y2M/nrhbrEdoBxBlyVQxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jlbpxAqAL3BKxDOEiFuPvehIgQTbboWNgkJ7GrMceE+9+Ul37sQ5nOQ155fyyPiqR
         BrKZJCR0A84PeIgZNc66gOaFpVj/1xdic3r2u5kW4ijOixBdkA+aCcyD3jh01MSQrq
         QohTD3Kn4JfOb1WR6bRoMYmTmnc7Ss1Pznq8r47U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.19 64/81] btrfs: fix uninitialized ret in ref-verify
Date:   Wed, 16 Oct 2019 14:51:15 -0700
Message-Id: <20191016214844.557001120@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit c5f4987e86f6692fdb12533ea1fc7a7bb98e555a upstream.

Coverity caught a case where we could return with a uninitialized value
in ret in process_leaf.  This is actually pretty likely because we could
very easily run into a block group item key and have a garbage value in
ret and think there was an errror.  Fix this by initializing ret to 0.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: fd708b81d972 ("Btrfs: add a extent ref verify tool")
CC: stable@vger.kernel.org # 4.19+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ref-verify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/ref-verify.c
+++ b/fs/btrfs/ref-verify.c
@@ -511,7 +511,7 @@ static int process_leaf(struct btrfs_roo
 	struct btrfs_extent_data_ref *dref;
 	struct btrfs_shared_data_ref *sref;
 	u32 count;
-	int i = 0, tree_block_level = 0, ret;
+	int i = 0, tree_block_level = 0, ret = 0;
 	struct btrfs_key key;
 	int nritems = btrfs_header_nritems(leaf);
 


