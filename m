Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E0E3E24F8
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243799AbhHFIPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243807AbhHFIPV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:15:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CB1F611C9;
        Fri,  6 Aug 2021 08:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237705;
        bh=Olj8U6qDY/0/Zk1iAPG4XVogvHeHpOr84NOsOsS3m6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Zxjexp0UHSo9rXZv+4waD/698AHUDeW3whreDxc8zRMYSUNY3iwa9lbi1YP4kPVw
         2rtvJy93zmxans4gPplpuz2w9av+DmiVWsbVvYLYGAESmysSlUkTCGM05gqn2/EmWF
         D/kEGDj7QxazolzuF4mqVZFJ6GV2tev9AoISXV5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 1/7] btrfs: mark compressed range uptodate only if all bio succeed
Date:   Fri,  6 Aug 2021 10:14:40 +0200
Message-Id: <20210806081109.371219550@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081109.324409899@linuxfoundation.org>
References: <20210806081109.324409899@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

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
 fs/btrfs/compression.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index d4d8b7e36b2f..2534e44cfd40 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -290,7 +290,7 @@ static void end_compressed_bio_write(struct bio *bio)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 bio->bi_error ? 0 : 1);
+					 !cb->errors);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
-- 
2.30.2



