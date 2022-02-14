Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331A34B4A8F
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347319AbiBNK1o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347938AbiBNK0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:26:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51AC8091B;
        Mon, 14 Feb 2022 01:57:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF4360FA2;
        Mon, 14 Feb 2022 09:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E05C340E9;
        Mon, 14 Feb 2022 09:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832654;
        bh=saiZqjZcHJGpeZpPA0bHrcwnllIhia1FLnu2M+Iq5Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzo1APez4K60Qqh3xCmjD5cpfmd9StcEo08AmuoQbbdyzH4WY7kqi0bA2l2/pbiGX
         Opk/Cl9Zo32lk4ByX0MyC7RcDpPDMBjFnmkUQbphKfinOMZqHxvZHnlYF26cv9+Hg4
         IxzxbLoJrWypNGM7x5H5XpBfRYaTf12SsAb1nMFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.16 084/203] nvme-tcp: fix bogus request completion when failing to send AER
Date:   Mon, 14 Feb 2022 10:25:28 +0100
Message-Id: <20220214092513.128502574@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit 63573807b27e0faf8065a28b1bbe1cbfb23c0130 upstream.

AER is not backed by a real request, hence we should not incorrectly
assume that when failing to send a nvme command, it is a normal request
but rather check if this is an aer and if so complete the aer (similar
to the normal completion path).

Cc: stable@vger.kernel.org
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -913,7 +913,15 @@ static inline void nvme_tcp_done_send_re
 
 static void nvme_tcp_fail_request(struct nvme_tcp_request *req)
 {
-	nvme_tcp_end_request(blk_mq_rq_from_pdu(req), NVME_SC_HOST_PATH_ERROR);
+	if (nvme_tcp_async_req(req)) {
+		union nvme_result res = {};
+
+		nvme_complete_async_event(&req->queue->ctrl->ctrl,
+				cpu_to_le16(NVME_SC_HOST_PATH_ERROR), &res);
+	} else {
+		nvme_tcp_end_request(blk_mq_rq_from_pdu(req),
+				NVME_SC_HOST_PATH_ERROR);
+	}
 }
 
 static int nvme_tcp_try_send_data(struct nvme_tcp_request *req)


