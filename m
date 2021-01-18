Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4659E2FAA1B
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393756AbhART06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390433AbhARLiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:38:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B3FE2222A;
        Mon, 18 Jan 2021 11:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969805;
        bh=9WDmxl/CUD42kTmVZNq2QHjPCFpT1qSSXntCIXC47dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=022MLbVtGLhUAoqEOAuEHGCFlWs4KlPJccg4PwcFmXdNlgAHHWM0NLCfttsk8p2M8
         7RhMA+eLYnHrcBF0anBC8MFnhGPw5EZuR76P0JKbZ6e6GDkL9K9b9xYU5wcDPkYQXi
         S/ukTcl88d+fczZpSQnJ6/3juy5i9be/ZF3ftrLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 33/43] ext4: fix superblock checksum failure when setting password salt
Date:   Mon, 18 Jan 2021 12:34:56 +0100
Message-Id: <20210118113336.550144567@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
References: <20210118113334.966227881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit dfd56c2c0c0dbb11be939b804ddc8d5395ab3432 upstream.

When setting password salt in the superblock, we forget to recompute the
superblock checksum so it will not match until the next superblock
modification which recomputes the checksum. Fix it.

CC: Michael Halcrow <mhalcrow@google.com>
Reported-by: Andreas Dilger <adilger@dilger.ca>
Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201216101844.22917-8-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ioctl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1092,7 +1092,10 @@ resizefs_out:
 			err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 			if (err)
 				goto pwsalt_err_journal;
+			lock_buffer(sbi->s_sbh);
 			generate_random_uuid(sbi->s_es->s_encrypt_pw_salt);
+			ext4_superblock_csum_set(sb);
+			unlock_buffer(sbi->s_sbh);
 			err = ext4_handle_dirty_metadata(handle, NULL,
 							 sbi->s_sbh);
 		pwsalt_err_journal:


