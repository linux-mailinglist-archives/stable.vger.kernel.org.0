Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F64B474A
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbiBNJr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:47:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344452AbiBNJrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:47:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A277486C;
        Mon, 14 Feb 2022 01:40:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80DC16102D;
        Mon, 14 Feb 2022 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E2FC340E9;
        Mon, 14 Feb 2022 09:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831633;
        bh=JoG225rAtwc4qcEMiSnLbCERLQ35xdj41ObP079Up2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5MYGB4T6o9wWZ6MMPuIr1LyAo/Fq4tR26kO7BpoXBk2AJ4hforeHVo0jjH43tTwk
         OHAkzMGF21WjW4crQVztvFFcI0PKta5D6QI3/aw35kxXUkhIg8pnpwySlM5AnqaeNI
         ja/Ultv/540fymEyug8Tzp0ksc6nD+Qio8+Jg0G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 046/116] nvme-tcp: fix bogus request completion when failing to send AER
Date:   Mon, 14 Feb 2022 10:25:45 +0100
Message-Id: <20220214092500.294001171@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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
@@ -904,7 +904,15 @@ static inline void nvme_tcp_done_send_re
 
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


