Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9F45C53A
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352539AbhKXNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:42264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354923AbhKXNxc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:53:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C694C6326E;
        Wed, 24 Nov 2021 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759128;
        bh=MyEvijg+7fEi0qn/5mp5Ggd7cijDbTy64fCbsBYCDt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXOi2vUstkKQuoQwiFXVqeDjj0lYuWQIlwJr23LF//Jwg2P3abOa00z3mhii7MRye
         DUdxJpbz5A+kaco6Puj4VWx/gOfUiDl+t89y0mUVG3TdJH8Rv8nKwtYFU7Y6xHUsqg
         /uj3oT6Mhtee6sqjzZYY27YeMG58hElfi8owo3ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <wqu@suse.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/279] btrfs: make 1-bit bit-fields of scrub_page unsigned int
Date:   Wed, 24 Nov 2021 12:57:08 +0100
Message-Id: <20211124115723.653499167@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@googlemail.com>

[ Upstream commit d08e38b62327961295be1c63b562cd46ec97cd07 ]

The bitfields have_csum and io_error are currently signed which is not
recommended as the representation is an implementation defined
behaviour. Fix this by making the bit-fields unsigned ints.

Fixes: 2c36395430b0 ("btrfs: scrub: remove the anonymous structure from scrub_page")
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/scrub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 088641ba7a8e6..62f4bafbe54bb 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -73,8 +73,8 @@ struct scrub_page {
 	u64			physical_for_dev_replace;
 	atomic_t		refs;
 	u8			mirror_num;
-	int			have_csum:1;
-	int			io_error:1;
+	unsigned int		have_csum:1;
+	unsigned int		io_error:1;
 	u8			csum[BTRFS_CSUM_SIZE];
 
 	struct scrub_recover	*recover;
-- 
2.33.0



