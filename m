Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1FD6AEC41
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjCGRxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjCGRxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:53:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF134BE88
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:47:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A18D9B819BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D95C433D2;
        Tue,  7 Mar 2023 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211265;
        bh=cg2VCJwPMxOmyOUeU6hKGROdwX1cla5R959KbgbZWX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogeOWFUn5vdZETJnj26LSSCbl08seuZQji/LDxwRH6/gexNUER0GTgTroobqrXBOW
         QGA7qXcSHMZzjlCBhLmoOp3BMqiUubgo7wDQdRPbw6M6vEmPpUKRRMhyu+gqj79mWk
         Rhc5p7ArQpKUFFmt16yWsxaVo4WXiH9oF7bC8drA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.2 0807/1001] f2fs: fix kernel crash due to null io->bio
Date:   Tue,  7 Mar 2023 17:59:39 +0100
Message-Id: <20230307170056.750466790@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 267c159f9c7bcb7009dae16889b880c5ed8759a8 upstream.

We should return when io->bio is null before doing anything. Otherwise, panic.

BUG: kernel NULL pointer dereference, address: 0000000000000010
RIP: 0010:__submit_merged_write_cond+0x164/0x240 [f2fs]
Call Trace:
 <TASK>
 f2fs_submit_merged_write+0x1d/0x30 [f2fs]
 commit_checkpoint+0x110/0x1e0 [f2fs]
 f2fs_write_checkpoint+0x9f7/0xf00 [f2fs]
 ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
 __checkpoint_and_complete_reqs+0x84/0x190 [f2fs]
 ? preempt_count_add+0x82/0xc0
 ? __pfx_issue_checkpoint_thread+0x10/0x10 [f2fs]
 issue_checkpoint_thread+0x4c/0xf0 [f2fs]
 ? __pfx_autoremove_wake_function+0x10/0x10
 kthread+0xff/0x130
 ? __pfx_kthread+0x10/0x10
 ret_from_fork+0x2c/0x50
 </TASK>

Cc: stable@vger.kernel.org # v5.18+
Fixes: 64bf0eef0171 ("f2fs: pass the bio operation to bio_alloc_bioset")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -655,6 +655,9 @@ static void __f2fs_submit_merged_write(s
 
 	f2fs_down_write(&io->io_rwsem);
 
+	if (!io->bio)
+		goto unlock_out;
+
 	/* change META to META_FLUSH in the checkpoint procedure */
 	if (type >= META_FLUSH) {
 		io->fio.type = META_FLUSH;
@@ -663,6 +666,7 @@ static void __f2fs_submit_merged_write(s
 			io->bio->bi_opf |= REQ_PREFLUSH | REQ_FUA;
 	}
 	__submit_merged_bio(io);
+unlock_out:
 	f2fs_up_write(&io->io_rwsem);
 }
 


