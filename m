Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9180CA786
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405225AbfJCQys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406371AbfJCQxD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:53:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B12A20862;
        Thu,  3 Oct 2019 16:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121582;
        bh=4hyWZ9KPyne415qCjeglQQpp/ccP8ux7zuW1iEDyABU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYK0+Cut5oVaNYJZ+8t+zm+fGfTqxMh1Mp3Ko1afBVyUbcq1fRUKnGuBibccSPeYZ
         1pdGJ7qVGfUPHVhxAoiPVblzWK+0WsGSL5E2cQuk72P72S+UEvmzu7K9Ncw53kyNdR
         5pTYMfHKtQVMR6gTZXGu3BQtVrXLOI35jCmepuvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.3 331/344] ext4: fix punch hole for inline_data file systems
Date:   Thu,  3 Oct 2019 17:54:56 +0200
Message-Id: <20191003154611.405091207@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit c1e8220bd316d8ae8e524df39534b8a412a45d5e upstream.

If a program attempts to punch a hole on an inline data file, we need
to convert it to a normal file first.

This was detected using ext4/032 using the adv configuration.  Simple
reproducer:

mke2fs -Fq -t ext4 -O inline_data /dev/vdc
mount /vdc
echo "" > /vdc/testfile
xfs_io -c 'truncate 33554432' /vdc/testfile
xfs_io -c 'fpunch 0 1048576' /vdc/testfile
umount /vdc
e2fsck -fy /dev/vdc

Cc: stable@vger.kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4297,6 +4297,15 @@ int ext4_punch_hole(struct inode *inode,
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	if (ext4_has_inline_data(inode)) {
+		down_write(&EXT4_I(inode)->i_mmap_sem);
+		ret = ext4_convert_inline_data(inode);
+		up_write(&EXT4_I(inode)->i_mmap_sem);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.


