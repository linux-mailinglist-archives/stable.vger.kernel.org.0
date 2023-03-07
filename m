Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480836AF143
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjCGSl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjCGSle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:41:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D27596625
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C40406154A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D404EC433D2;
        Tue,  7 Mar 2023 18:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213930;
        bh=YTUJLvMddYqETv4VWZZPM9evhw7Q3EgGxqYOUlciBl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAmLGzJJxQyAAX8LwmrbPf9Y3jgWLetZncpsYdr+ryBRckKtPTQ26KEblplP49FoD
         wHf9SThKMet1lWuoYR3aKsNIodmW6fOK9ZBoEeAySVWZE/gr4MEGygnyJ8yE/aSPpL
         0lXq7e64zr+MPxpc4dc0xDKGQ34ejvFvHll92wpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heming Zhao <heming.zhao@suse.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 664/885] io_uring: fix fget leak when fs dont support nowait buffered read
Date:   Tue,  7 Mar 2023 17:59:58 +0100
Message-Id: <20230307170031.018747379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 54aa7f2330b82884f4a1afce0220add6e8312f8b upstream.

Heming reported a BUG when using io_uring doing link-cp on ocfs2. [1]

Do the following steps can reproduce this BUG:
mount -t ocfs2 /dev/vdc /mnt/ocfs2
cp testfile /mnt/ocfs2/
./link-cp /mnt/ocfs2/testfile /mnt/ocfs2/testfile.1
umount /mnt/ocfs2

Then umount will fail, and it outputs:
umount: /mnt/ocfs2: target is busy.

While tracing umount, it blames mnt_get_count() not return as expected.
Do a deep investigation for fget()/fput() on related code flow, I've
finally found that fget() leaks since ocfs2 doesn't support nowait
buffered read.

io_issue_sqe
|-io_assign_file  // do fget() first
  |-io_read
  |-io_iter_do_read
    |-ocfs2_file_read_iter  // return -EOPNOTSUPP
  |-kiocb_done
    |-io_rw_done
      |-__io_complete_rw_common  // set REQ_F_REISSUE
    |-io_resubmit_prep
      |-io_req_prep_async  // override req->file, leak happens

This was introduced by commit a196c78b5443 in v5.18. Fix it by don't
re-assign req->file if it has already been assigned.

[1] https://lore.kernel.org/ocfs2-devel/ab580a75-91c8-d68a-3455-40361be1bfa8@linux.alibaba.com/T/#t

Fixes: a196c78b5443 ("io_uring: assign non-fixed early for async work")
Cc: <stable@vger.kernel.org>
Reported-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230228045459.13524-1-joseph.qi@linux.alibaba.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1597,7 +1597,7 @@ int io_req_prep_async(struct io_kiocb *r
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 
 	/* assign early for deferred execution for non-fixed file */
-	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE))
+	if (def->needs_file && !(req->flags & REQ_F_FIXED_FILE) && !req->file)
 		req->file = io_file_get_normal(req, req->cqe.fd);
 	if (!def->prep_async)
 		return 0;


