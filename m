Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE863DD8F5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhHBN4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:56:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235732AbhHBNyT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:54:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AD9761155;
        Mon,  2 Aug 2021 13:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912356;
        bh=LLRrbjJ+8SIjP/v9qwB8N5PbdPl0TOslBFqsycMSAdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVBGAROF+4jWd1FtxoRAGXtdUloa68v5IM4PDdcJWSvD4b1VFogpGpciGRmhtpwfz
         Wyd+e9TwOgCFcRIVfLdUHrrQCHfnlZ2rpJC0e5SXcDfli+bF2eJK1mlpm+Zo61/I8u
         o4AACRUNxIVLrMFisyMenuX6UKsRrBx6wOKYRmaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 05/67] btrfs: mark compressed range uptodate only if all bio succeed
Date:   Mon,  2 Aug 2021 15:44:28 +0200
Message-Id: <20210802134339.206023793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

commit 240246f6b913b0c23733cfd2def1d283f8cc9bbe upstream.

In compression write endio sequence, the range which the compressed_bio
writes is marked as uptodate if the last bio of the compressed (sub)bios
is completed successfully. There could be previous bio which may
have failed which is recorded in cb->errors.

Set the writeback range as uptodate only if cb->errors is zero, as opposed
to checking only the last bio's status.

Backporting notes: in all versions up to 4.4 the last argument is always
replaced by "!cb->errors".

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -340,7 +340,7 @@ static void end_compressed_bio_write(str
 	cb->compressed_pages[0]->mapping = cb->inode->i_mapping;
 	btrfs_writepage_endio_finish_ordered(cb->compressed_pages[0],
 			cb->start, cb->start + cb->len - 1,
-			bio->bi_status == BLK_STS_OK);
+			!cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);


