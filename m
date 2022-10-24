Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10660B8B3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiJXTxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbiJXTv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:51:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C83619018;
        Mon, 24 Oct 2022 11:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CC11B8159F;
        Mon, 24 Oct 2022 12:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2270C433D6;
        Mon, 24 Oct 2022 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614904;
        bh=LpiUvsiYqsEHApJ9nSrkZUrMrXWWj4Ku9RYWHfSqT6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBQQ1W3s/9gh6/UEAEOBDGSnEHbeURP0imrLPlrSAZJfp1Qn/emWLbjSUE/TmIEAY
         r/frSH74wzRJJ+L4lpPiFCuSMx90VmBR/H9l28sFg/KmztG/w94rzLGi2L8iS3zftJ
         Ivtq0+cyc2a7MdUimEvrs4c9EwUrN2rhbZO1o+d8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yogev Cohen <yogev@lightbitslabs.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 048/530] nvme-multipath: fix possible hang in live ns resize with ANA access
Date:   Mon, 24 Oct 2022 13:26:32 +0200
Message-Id: <20221024113047.191473289@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 72e3b8883a36e80ebfa41015c7b6926ce31ace05 upstream.

When we revalidate paths as part of ns size change (as of commit
e7d65803e2bb), it is possible that during the path revalidation, the
only paths that is IO capable (i.e. optimized/non-optimized) are the
ones that ns resize was not yet informed to the host, which will cause
inflight requests to be requeued (as we have available paths but none
are IO capable). These requests on the requeue list are waiting for
someone to resubmit them at some point.

The IO capable paths will eventually notify the ns resize change to the
host, but there is nothing that will kick the requeue list to resubmit
the queued requests.

Fix this by always kicking the requeue list, and if no IO capable path
exists, these requests will be queued again.

A typical log that indicates that IOs are requeued:
--
nvme nvme1: creating 4 I/O queues.
nvme nvme1: new ctrl: "testnqn1"
nvme nvme2: creating 4 I/O queues.
nvme nvme2: mapped 4/0/0 default/read/poll queues.
nvme nvme2: new ctrl: NQN "testnqn1", addr 127.0.0.1:8009
nvme nvme1: rescanning namespaces.
nvme1n1: detected capacity change from 2097152 to 4194304
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
block nvme1n1: no usable path - requeuing I/O
nvme nvme2: rescanning namespaces.
--

Reported-by: Yogev Cohen <yogev@lightbitslabs.com>
Fixes: e7d65803e2bb ("nvme-multipath: revalidate paths during rescan")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Cc: <stable@vger.kernel.org> # v5.15+
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/multipath.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -159,6 +159,7 @@ void nvme_mpath_revalidate_paths(struct
 
 	for_each_node(node)
 		rcu_assign_pointer(head->current_path[node], NULL);
+	kblockd_schedule_work(&head->requeue_work);
 }
 
 static bool nvme_path_is_disabled(struct nvme_ns *ns)


