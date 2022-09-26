Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFA5EA142
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbiIZKrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236301AbiIZKpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8092D564FB;
        Mon, 26 Sep 2022 03:25:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1F0E60B2F;
        Mon, 26 Sep 2022 10:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E69C433C1;
        Mon, 26 Sep 2022 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187949;
        bh=6CQzMC7L2OMYeY0hfewh1McdlzBx6HEsshVCI5I7lzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsgbLL/fjNv9hvIDMUhKfFDrbvvjJg9+fIFGotzNI5t6VDvV7Medfy1uRA75LqNgs
         fY/E6K/FU21s8/pcR/VLwkRTMBThwEievJnHTwSnQEBlgU0K2KPYHQr5SWBFUgQmsZ
         HfhU4vkzVl/tvqf02lCJFSPP4CEiyuWDy7lINUo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 113/120] xfs: fix some memory leaks in log recovery
Date:   Mon, 26 Sep 2022 12:12:26 +0200
Message-Id: <20220926100755.058030217@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 050552cbe06a3a9c3f977dcf11ff998ae1d5c2d5 upstream.

Fix a few places where we xlog_alloc_buffer a buffer, hit an error, and
then bail out without freeing the buffer.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_log_recover.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1347,10 +1347,11 @@ xlog_find_tail(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, buffer,
 				      &rhead_blk, &rhead, &wrapped);
 	if (error < 0)
-		return error;
+		goto done;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EFSCORRUPTED;
+		error = -EFSCORRUPTED;
+		goto done;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -5318,7 +5319,8 @@ xlog_do_recovery_pass(
 			} else {
 				XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW,
 						log->l_mp);
-				return -EFSCORRUPTED;
+				error = -EFSCORRUPTED;
+				goto bread_err1;
 			}
 		}
 


