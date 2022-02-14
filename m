Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 953504B477B
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiBNJlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244971AbiBNJlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC5A65797;
        Mon, 14 Feb 2022 01:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7C16B80DA9;
        Mon, 14 Feb 2022 09:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025F1C340E9;
        Mon, 14 Feb 2022 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831386;
        bh=3QIS+JduvWa+345oQLZSG4xFS4uZ8ucq3Rru6CK+hIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eh/jsido6PGfTh3c0XpeqwIEC+8V7qsi0pHtVVYOoH3Ixe798U3/pWVzcdAKKS0dM
         D089fsSQo7IzlInSNd0SzDdzLar1+IVIGCxJ3/5oq3M7hnXwfw2FMi22xdDQ1nwttr
         z7Fk+pOceF6PGOcICrdAZdU9Bt+j36ca9GMzwAx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 30/71] nvme-tcp: fix bogus request completion when failing to send AER
Date:   Mon, 14 Feb 2022 10:25:58 +0100
Message-Id: <20220214092453.029832946@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
References: <20220214092452.020713240@linuxfoundation.org>
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
@@ -840,7 +840,15 @@ static inline void nvme_tcp_done_send_re
 
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


