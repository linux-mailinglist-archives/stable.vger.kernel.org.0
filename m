Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12110615A00
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbiKBDXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiKBDWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:22:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7489125E89
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F1563CE1F1A
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37520C433D6;
        Wed,  2 Nov 2022 03:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359344;
        bh=fDrx7TTXpCz0mKQJO3yNsT+ibc3h//sUeoj7ldowWoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tw5nLJLrxSFyD1Kj0CMUW4nLTClKWuMcWXEQVEbvVExZtFFuh1GX26wponOqzY3Mu
         kFW4XfClHwAVWto00ujuSgoeboJICooPpzntxGXgAe3wkXUlS1jZvRXTtKPsazQlgL
         SnZrChhtb1wiRm+CDv46bixOAkippUjgHlG+xlMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 24/64] xfs: clear XFS_DQ_FREEING if we cant lock the dquot buffer to flush
Date:   Wed,  2 Nov 2022 03:33:50 +0100
Message-Id: <20221102022052.595212086@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chandan Babu R <chandan.babu@oracle.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit c97738a960a86081a147e7d436138e6481757445 upstream.

In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
can't lock the dquot buf to flush the dquot.  This prevents the AIL from
blocking on the dquot, but it also forgets to clear the FREEING flag on
its way out.  A subsequent purge attempt will see the FREEING flag is
set and bail out, which leads to dqpurge_all failing to purge all the
dquots.

(copy-pasting from Dave Chinner's identical patch)

This was found by inspection after having xfs/305 hang 1 in ~50
iterations in a quotaoff operation:

[ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
[ 8872.302538] Call Trace:
[ 8872.303193]  __schedule+0x2d2/0x780
[ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
[ 8872.305198]  schedule+0x6e/0xe0
[ 8872.306021]  schedule_timeout+0x14d/0x300
[ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
[ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
[ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
[ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
[ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
[ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
[ 8872.314163]  xfs_quota_disable+0x3a/0x60
[ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
[ 8872.316196]  ? __do_sys_newstat+0x51/0x80
[ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
[ 8872.318266]  do_syscall_64+0x46/0x90
[ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8872.320490] RIP: 0033:0x7f46b5490f2a
[ 8872.321414] Code: Bad RIP value.

Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
flag to go away on the dquot that leaked it via -EAGAIN.

Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_qm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,6 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
+			dqp->dq_flags &= ~XFS_DQ_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);


