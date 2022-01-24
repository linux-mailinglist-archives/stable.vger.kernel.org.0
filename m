Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD749957C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441994AbiAXUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:52:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41888 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391418AbiAXUrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5136A60C13;
        Mon, 24 Jan 2022 20:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB93C340E5;
        Mon, 24 Jan 2022 20:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057261;
        bh=9mf3EP2FFGL21FYhRGtSiDPke0nxmISoiIGuIKuqdFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Xw6HLPRNOBQNoFvXRMv9mfKa99ISim7xKw0b1cder/EQWBKl3PDFvLPrgfiALwa9
         QrSklFyBdVQ3yHvK6Lyi7bJa6j9/GwE3YiSCv4KJNT/n+GC6Xa7GrL1CF5at0U3r9u
         mt0i4AhROuF4O2Ewj4FMDj2fx1IA1Lv8ZMcK883s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Yin <yinxin.x@bytedance.com>,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 721/846] ext4: fast commit may miss tracking unwritten range during ftruncate
Date:   Mon, 24 Jan 2022 19:43:58 +0100
Message-Id: <20220124184125.887304707@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
@@ -5414,8 +5414,7 @@ int ext4_setattr(struct user_namespace *
 				ext4_fc_track_range(handle, inode,
 					(attr->ia_size > 0 ? attr->ia_size - 1 : 0) >>
 					inode->i_sb->s_blocksize_bits,
-					(oldsize > 0 ? oldsize - 1 : 0) >>
-					inode->i_sb->s_blocksize_bits);
+					EXT_MAX_BLOCKS - 1);
 			else
 				ext4_fc_track_range(
 					handle, inode,


