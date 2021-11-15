Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437DB451EB1
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347082AbhKPAhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344940AbhKOTZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EAD9636FB;
        Mon, 15 Nov 2021 19:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003235;
        bh=scx3Ei5FRWSh2C2W7fhhL0fG7vSsnywOd4MzGKm8s9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIv2VNQkF/C6tKQcS3MaS/19rR1efFqVsvKR7LobRoumG/MOzRerUkZmMwTdnvSpe
         615byiCgl4lmVUp1TRHaRHxYI/5Rk4/sZrhjOxDOVtzEqkXGy3imRc69jV1seAiGhM
         DPOun23fBaQT5IqSJ4hmD5ohPFXyPExERwhiXDmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daeho Jeong <daehojeong@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.15 861/917] f2fs: include non-compressed blocks in compr_written_block
Date:   Mon, 15 Nov 2021 18:05:56 +0100
Message-Id: <20211115165458.227827331@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
@@ -1530,6 +1530,7 @@ int f2fs_write_multi_pages(struct compre
 	if (cluster_may_compress(cc)) {
 		err = f2fs_compress_pages(cc);
 		if (err == -EAGAIN) {
+			add_compr_block_stat(cc->inode, cc->cluster_size);
 			goto write;
 		} else if (err) {
 			f2fs_put_rpages_wbc(cc, wbc, true, 1);


