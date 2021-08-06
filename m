Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF073E251D
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244056AbhHFIRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243928AbhHFIQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:16:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E507561163;
        Fri,  6 Aug 2021 08:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237758;
        bh=KxhQ2Lk/yyDZbj6EJ6D+FpbwFeQW/dOuACsTvOBpKnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNfpIBdbqwz5WbsNllkiMTYTW0gGJjAmvYDCLLvEl8xcCVSVCyYVzsJckbzict30J
         ijSDdx8smYrwvs3rSnN4v7B7+cTpCVtKBr4vtibcWmaQv2vipon2brTgWfuEvMxxnu
         sHnmr+hcPsdj0rqw+hEwFM1HLrKxtYRy9IqtyIrM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/16] btrfs: mark compressed range uptodate only if all bio succeed
Date:   Fri,  6 Aug 2021 10:14:52 +0200
Message-Id: <20210806081111.193594472@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081111.144943357@linuxfoundation.org>
References: <20210806081111.144943357@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.de>

[ Upstream commit 240246f6b913b0c23733cfd2def1d283f8cc9bbe ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c71e534ca7ef..919c033b9e31 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -270,8 +270,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_status ?
-					 BLK_STS_OK : BLK_STS_NOTSUPP);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
-- 
2.30.2



