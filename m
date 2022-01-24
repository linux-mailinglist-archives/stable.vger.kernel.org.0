Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F7C49A9CB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323539AbiAYD2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353984AbiAXVFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1187DC068098;
        Mon, 24 Jan 2022 12:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD0DFB8122A;
        Mon, 24 Jan 2022 20:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DF2C340E5;
        Mon, 24 Jan 2022 20:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054717;
        bh=dwuRJhL0tzbkr5ctUeyXeMSHkHGJOqAsMBmJPPixkaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRrHpauhFJng8Dts2JHZ0YEXb9aI34nkVGr4P7yTevuJ3HHxdqeupnfPcky5QoBDx
         nAtdLX5GO0eGYNwORdaiz9Mz9yZafeFmKJdrO2qmXGAOHspmmrJw2u7sCVqeZy74bc
         cjf5bbCRNkxahX6BDu9hB6XZ1YC5M3Zu6eU1+GaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 480/563] ext4: fast commit may miss tracking unwritten range during ftruncate
Date:   Mon, 24 Jan 2022 19:44:05 +0100
Message-Id: <20220124184041.063143682@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Yin <yinxin.x@bytedance.com>

commit 9725958bb75cdfa10f2ec11526fdb23e7485e8e4 upstream.

If use FALLOC_FL_KEEP_SIZE to alloc unwritten range at bottom, the
inode->i_size will not include the unwritten range. When call
ftruncate with fast commit enabled, it will miss to track the
unwritten range.

Change to trace the full range during ftruncate.

Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Link: https://lore.kernel.org/r/20211223032337.5198-3-yinxin.x@bytedance.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5468,8 +5468,7 @@ int ext4_setattr(struct dentry *dentry,
 				ext4_fc_track_range(handle, inode,
 					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
 					inode->i_sb->s_blocksize_bits,
-					(oldsize > 0 ? oldsize - 1 : 0) >>
-					inode->i_sb->s_blocksize_bits);
+					EXT_MAX_BLOCKS - 1);
 			else
 				ext4_fc_track_range(
 					handle, inode,


