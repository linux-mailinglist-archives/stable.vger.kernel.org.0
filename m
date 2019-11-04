Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9679FEEC9F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730448AbfKDV66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730858AbfKDV65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:58:57 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0B5E21744;
        Mon,  4 Nov 2019 21:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904735;
        bh=uub7qoWJO07kCGY9mnSTpLi4SKi0+yvY+LER2AED5r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHMh3Fqzv2CHqgMj8AEMjp+t6zK64VKBu6AOKvkYepMpjdfhm50U4OSD4o8Yg1lZd
         hFCAgc3Yy5E/mA7MCxi6UtZqKFlTTCij1SEq15qQAm+8hYnA7F3jy2odPSmpmEoepC
         d6aTJadOFx+/eqbaHgVOt57N7GQVuaSUVDGBGIrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/149] ext4: disallow files with EXT4_JOURNAL_DATA_FL from EXT4_IOC_SWAP_BOOT
Date:   Mon,  4 Nov 2019 22:44:05 +0100
Message-Id: <20191104212139.867962840@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 6e589291f4b1b700ca12baec5930592a0d51e63c ]

A malicious/clueless root user can use EXT4_IOC_SWAP_BOOT to force a
corner casew which can lead to the file system getting corrupted.
There's no usefulness to allowing this, so just prohibit this case.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index abb6fcff0a1d3..783c54bb2ce75 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -132,6 +132,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 
 	if (inode->i_nlink != 1 || !S_ISREG(inode->i_mode) ||
 	    IS_SWAPFILE(inode) || IS_ENCRYPTED(inode) ||
+	    (EXT4_I(inode)->i_flags & EXT4_JOURNAL_DATA_FL) ||
 	    ext4_has_inline_data(inode)) {
 		err = -EINVAL;
 		goto journal_err_out;
-- 
2.20.1



