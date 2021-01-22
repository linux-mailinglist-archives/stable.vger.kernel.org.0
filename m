Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E2300D0F
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 21:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbhAVT6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbhAVOM6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:12:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA44623A9D;
        Fri, 22 Jan 2021 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324611;
        bh=6dIwbg9PrVsaU+rxtbOxi+oDFnBEXfpg6jEir043JsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FxdRByquexFKXSVJ0vIS1DURRrb4cFNRSowb4j1F3v0b3TWOpw7ePM9YTsu0bcG1L
         0qVy7nPrIRxaEEmjuB0taRBcmgaFhGpNzDo/McT3eYItwfuPEALwP7jlqFXt7hyBzh
         qVin/89vCWXCDrm85TW03yVeHlvo1dlypndwsIOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Andreas Dilger <adilger@dilger.ca>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.4 15/31] ext4: fix superblock checksum failure when setting password salt
Date:   Fri, 22 Jan 2021 15:08:29 +0100
Message-Id: <20210122135732.482751798@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
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
@@ -675,7 +675,10 @@ encryption_policy_out:
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


