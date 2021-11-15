Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DC14512BE
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347279AbhKOTji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244997AbhKOTSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BD6463432;
        Mon, 15 Nov 2021 18:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000800;
        bh=1jCnc26xKrTr006HnUX61S8OomUXORDVPrneoLe/0Kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YvCi0OIsjOz0pVghqJcsP8GapPJ/pAcwLqD+OaOL1QiVz1cELr6mCcR9IGZv3VPv4
         XPxnq80pnGJ9Dxy7MPK3Z983v9cp9A7Oe9rFNSzdGiDXiE5egaTwuBKW03BB1KdPa3
         K0kJ2P18XV+LlB/88GR7kBN62UJv/U8SEhrr40j0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.14 797/849] f2fs: include non-compressed blocks in compr_written_block
Date:   Mon, 15 Nov 2021 18:04:40 +0100
Message-Id: <20211115165447.198392963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daeho Jeong <daehojeong@google.com>

commit 09631cf3234d32156e7cae32275f5a4144c683c5 upstream.

Need to include non-compressed blocks in compr_written_block to
estimate average compression ratio more accurately.

Fixes: 5ac443e26a09 ("f2fs: add sysfs nodes to get runtime compression stat")
Cc: stable@vger.kernel.org
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1476,6 +1476,7 @@ int f2fs_write_multi_pages(struct compre
 	if (cluster_may_compress(cc)) {
 		err = f2fs_compress_pages(cc);
 		if (err == -EAGAIN) {
+			add_compr_block_stat(cc->inode, cc->cluster_size);
 			goto write;
 		} else if (err) {
 			f2fs_put_rpages_wbc(cc, wbc, true, 1);


