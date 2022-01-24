Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C94649895A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343727AbiAXSzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:55:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52078 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiAXSwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:52:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB390614BE;
        Mon, 24 Jan 2022 18:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2613C340E5;
        Mon, 24 Jan 2022 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050373;
        bh=W46B476feYqGoB0BzzWIPhXASw9qeqBJiY3JXo5Z8qE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUzn2C5cBpCuTGlw2zb2KlsqeQ/2uu2HPOaZzIbLKmmHdt1Oc15c7TVQGZo63n2n2
         0vdfp4hth7/9f30os2CV6OgNuCjySd36hC2C/lqD0ERP1sAdQ6zziq+YCuMx+vSVTe
         nWM6qo1hFPb7y/LobVPXuRTMrT0ulm3MRv2T4RGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jeroen van Wolffelaar <jeroen@wolffelaar.nl>,
        =?UTF-8?q?Lu=C3=ADs=20Henriques?= <lhenriques@suse.de>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.4 098/114] ext4: set csum seed in tmp inode while migrating to extents
Date:   Mon, 24 Jan 2022 19:43:13 +0100
Message-Id: <20220124183930.140510144@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luís Henriques <lhenriques@suse.de>

commit e81c9302a6c3c008f5c30beb73b38adb0170ff2d upstream.

When migrating to extents, the temporary inode will have it's own checksum
seed.  This means that, when swapping the inodes data, the inode checksums
will be incorrect.

This can be fixed by recalculating the extents checksums again.  Or simply
by copying the seed into the temporary inode.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=213357
Reported-by: Jeroen van Wolffelaar <jeroen@wolffelaar.nl>
Signed-off-by: Luís Henriques <lhenriques@suse.de>
Link: https://lore.kernel.org/r/20211214175058.19511-1-lhenriques@suse.de
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/migrate.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -481,6 +481,17 @@ int ext4_ext_migrate(struct inode *inode
 		ext4_journal_stop(handle);
 		return retval;
 	}
+	/*
+	 * Use the correct seed for checksum (i.e. the seed from 'inode').  This
+	 * is so that the metadata blocks will have the correct checksum after
+	 * the migration.
+	 *
+	 * Note however that, if a crash occurs during the migration process,
+	 * the recovery process is broken because the tmp_inode checksums will
+	 * be wrong and the orphans cleanup will fail.
+	 */
+	ei = EXT4_I(inode);
+	EXT4_I(tmp_inode)->i_csum_seed = ei->i_csum_seed;
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
 	 * Set the i_nlink to zero so it will be deleted later
@@ -524,7 +535,6 @@ int ext4_ext_migrate(struct inode *inode
 		goto out;
 	}
 
-	ei = EXT4_I(inode);
 	i_data = ei->i_data;
 	memset(&lb, 0, sizeof(lb));
 


