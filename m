Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE9D2A542D
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgKCVIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388601AbgKCVIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:08:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E05CE206B5;
        Tue,  3 Nov 2020 21:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437725;
        bh=BQAiSB5HKL8GvcYtruKKpWLmUAS2rG95pW3ourTel+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osWc5Zqvs5cEhHrNTVNfL73dM3/hgR/RNF5emOX/htQE0PMNTllF8AFQSOz+73/He
         L12MqsNR4rd52vZ2JsL3n2/h/MHbOHg3ssxGeq0eVqqUM++/VHWQGAxgRD85NxLaqk
         RTm9GYftb5ZO78EYfZdu+hSAu1qUAQ5lvH+roCXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Constantine Sapuntzakis <costa@purestorage.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.19 176/191] ext4: fix superblock checksum calculation race
Date:   Tue,  3 Nov 2020 21:37:48 +0100
Message-Id: <20201103203249.095741531@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203232.656475008@linuxfoundation.org>
References: <20201103203232.656475008@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Constantine Sapuntzakis <costa@purestorage.com>

commit acaa532687cdc3a03757defafece9c27aa667546 upstream.

The race condition could cause the persisted superblock checksum
to not match the contents of the superblock, causing the
superblock to be considered corrupt.

An example of the race follows.  A first thread is interrupted in the
middle of a checksum calculation. Then, another thread changes the
superblock, calculates a new checksum, and sets it. Then, the first
thread resumes and sets the checksum based on the older superblock.

To fix, serialize the superblock checksum calculation using the buffer
header lock. While a spinlock is sufficient, the buffer header is
already there and there is precedent for locking it (e.g. in
ext4_commit_super).

Tested the patch by booting up a kernel with the patch, creating
a filesystem and some files (including some orphans), and then
unmounting and remounting the file system.

Cc: stable@kernel.org
Signed-off-by: Constantine Sapuntzakis <costa@purestorage.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200914161014.22275-1-costa@purestorage.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -200,7 +200,18 @@ void ext4_superblock_csum_set(struct sup
 	if (!ext4_has_metadata_csum(sb))
 		return;
 
+	/*
+	 * Locking the superblock prevents the scenario
+	 * where:
+	 *  1) a first thread pauses during checksum calculation.
+	 *  2) a second thread updates the superblock, recalculates
+	 *     the checksum, and updates s_checksum
+	 *  3) the first thread resumes and finishes its checksum calculation
+	 *     and updates s_checksum with a potentially stale or torn value.
+	 */
+	lock_buffer(EXT4_SB(sb)->s_sbh);
 	es->s_checksum = ext4_superblock_csum(sb, es);
+	unlock_buffer(EXT4_SB(sb)->s_sbh);
 }
 
 void *ext4_kvmalloc(size_t size, gfp_t flags)


