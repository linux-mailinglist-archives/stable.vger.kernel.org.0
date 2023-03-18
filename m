Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A00696BF952
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 11:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCRKPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 06:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCRKPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 06:15:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FFB2410D;
        Sat, 18 Mar 2023 03:15:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id fm20-20020a05600c0c1400b003ead37e6588so6404969wmb.5;
        Sat, 18 Mar 2023 03:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679134541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/UNgWoj0g/ujTFM4Ms+u1ZVdhi+Be7I9bPF4qnLMhs=;
        b=osyEM8hrCwaVW8M7d99riQCpQc4kSf5sIGHDpZBINEcfro91poej+vdXmHBRoDKEmS
         8dXchbztQXIf7otydjIHzCcB5TD/1hTvhs+pDuyr9JUBPJoM1+y70ztCoi6KGu0cbZta
         eo4RWEqnjAhGoj293BKi1R3fMPTFR55Wqa8ZG5UhY2Mdj/nXkI6PIVeOLi+g+pyUl09Y
         gB+YyjzEXQWIe+owIesZ9C8BJvoig/uHOWCitffcuhjvXcGm9UN43i9Tv/Zr/v6jA8ZN
         +a2j5EjIUsqcKKcMGF1bAvE/3xHX8gT/zagj7lwbzJVXVrr95f66Tw00RjCCto+lY0YC
         +SKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679134541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F/UNgWoj0g/ujTFM4Ms+u1ZVdhi+Be7I9bPF4qnLMhs=;
        b=zNt4RBJUq+0rMyUougvCQfveUt4ZvSxaEMfOqaErwFkhZGlPr7+lNQXxtgZuXNde6W
         bx427WcHE62IstoBaqnugeYx5FEmJd8fHGrOHVMkGZSfu4O0zvxgXndai/8Wkxh5sRGU
         XlHBZ4qRhAVewucjGmIRqunD6MonyJpCiNc/tkgFkPLNBwscQusm4Y5wReTD38eqo0Pe
         rVsipWDS4ukYu8+hub7beDZ9h+gTNXVXRKZp2QbLhj1l/CMPGKs51mxrccRHMCxrtYR1
         qY+799kjLKw4EEj1LNzryndoHCSzJydSkXv2NJInU48Ev05tRalx5xd6o9pyke/HM4IT
         /YtQ==
X-Gm-Message-State: AO0yUKUVrHn4MMrdbcumwFXSqGmsy2pOUDsyK1UgVKYtH8qhe1ZwUnxH
        6MsEYTHsjv2JH5HSUANwOTY=
X-Google-Smtp-Source: AK7set/RZLQJ59PCeA1JThPw2X8Kb4Looy4UYyMqmcaJ1Av5jypBMoYBdqPNpBxgT0xzp8MehnyuJg==
X-Received: by 2002:a05:600c:4691:b0:3ed:33a1:ba8e with SMTP id p17-20020a05600c469100b003ed33a1ba8emr11575252wmo.1.1679134540778;
        Sat, 18 Mar 2023 03:15:40 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003eafc47eb09sm4333965wml.43.2023.03.18.03.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 03:15:40 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 03/15] xfs: don't leak btree cursor when insrec fails after a split
Date:   Sat, 18 Mar 2023 12:15:17 +0200
Message-Id: <20230318101529.1361673-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230318101529.1361673-1-amir73il@gmail.com>
References: <20230318101529.1361673-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit a54f78def73d847cb060b18c4e4a3d1d26c9ca6d upstream.

The recent patch to improve btree cycle checking caused a regression
when I rebased the in-memory btree branch atop the 5.19 for-next branch,
because in-memory short-pointer btrees do not have AG numbers.  This
produced the following complaint from kmemleak:

unreferenced object 0xffff88803d47dde8 (size 264):
  comm "xfs_io", pid 4889, jiffies 4294906764 (age 24.072s)
  hex dump (first 32 bytes):
    90 4d 0b 0f 80 88 ff ff 00 a0 bd 05 80 88 ff ff  .M..............
    e0 44 3a a0 ff ff ff ff 00 df 08 06 80 88 ff ff  .D:.............
  backtrace:
    [<ffffffffa0388059>] xfbtree_dup_cursor+0x49/0xc0 [xfs]
    [<ffffffffa029887b>] xfs_btree_dup_cursor+0x3b/0x200 [xfs]
    [<ffffffffa029af5d>] __xfs_btree_split+0x6ad/0x820 [xfs]
    [<ffffffffa029b130>] xfs_btree_split+0x60/0x110 [xfs]
    [<ffffffffa029f6da>] xfs_btree_make_block_unfull+0x19a/0x1f0 [xfs]
    [<ffffffffa029fada>] xfs_btree_insrec+0x3aa/0x810 [xfs]
    [<ffffffffa029fff3>] xfs_btree_insert+0xb3/0x240 [xfs]
    [<ffffffffa02cb729>] xfs_rmap_insert+0x99/0x200 [xfs]
    [<ffffffffa02cf142>] xfs_rmap_map_shared+0x192/0x5f0 [xfs]
    [<ffffffffa02cf60b>] xfs_rmap_map_raw+0x6b/0x90 [xfs]
    [<ffffffffa0384a85>] xrep_rmap_stash+0xd5/0x1d0 [xfs]
    [<ffffffffa0384dc0>] xrep_rmap_visit_bmbt+0xa0/0xf0 [xfs]
    [<ffffffffa0384fb6>] xrep_rmap_scan_iext+0x56/0xa0 [xfs]
    [<ffffffffa03850d8>] xrep_rmap_scan_ifork+0xd8/0x160 [xfs]
    [<ffffffffa0385195>] xrep_rmap_scan_inode+0x35/0x80 [xfs]
    [<ffffffffa03852ee>] xrep_rmap_find_rmaps+0x10e/0x270 [xfs]

I noticed that xfs_btree_insrec has a bunch of debug code that return
out of the function immediately, without freeing the "new" btree cursor
that can be returned when _make_block_unfull calls xfs_btree_split.  Fix
the error return in this function to free the btree cursor.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 24c7d30e41df..0926363179a7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3190,7 +3190,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3270,7 +3270,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3290,7 +3290,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3375,6 +3375,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
-- 
2.34.1

