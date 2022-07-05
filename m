Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF39566DC7
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbiGEM1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237339AbiGEMZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6E3B10;
        Tue,  5 Jul 2022 05:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 675C561983;
        Tue,  5 Jul 2022 12:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDEFC341C7;
        Tue,  5 Jul 2022 12:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023474;
        bh=rsVKk2lESA91fg3Gj3C/Wvb3ZqWorPFEk5GCBGeD4Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZ7N0iJ+yjeCt7wJQqd6KSfLdCH9r9ep4Ix/KVhbcxQB5Ze6D60uDlkIQp2uOrSuC
         31lpg3zbfaN3RhY+EsYopl2Omoc8kC+hH7pF+JDAHcmp+TCsXMaon3wD7dDcEDSVWM
         aNqM0YhQjbjboVN7fJ63sDIKn1Us0tvQLovZN7b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.18 072/102] nvmet-tcp: fix regression in data_digest calculation
Date:   Tue,  5 Jul 2022 13:58:38 +0200
Message-Id: <20220705115620.452354110@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

commit ed0691cf55140ce0f3fb100225645d902cce904b upstream.

Data digest calculation iterates over command mapped iovec. However
since commit bac04454ef9f we unmap the iovec before we handle the data
digest, and since commit 69b85e1f1d1d we clear nr_mapped when we unmap
the iov.

Instead of open-coding the command iov traversal, simply call
crypto_ahash_digest with the command sg that is already allocated (we
already do that for the send path). Rename nvmet_tcp_send_ddgst to
nvmet_tcp_calc_ddgst and call it from send and recv paths.

Fixes: 69b85e1f1d1d ("nvmet-tcp: add an helper to free the cmd buffers")
Fixes: bac04454ef9f ("nvmet-tcp: fix kmap leak when data digest in use")
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -405,7 +405,7 @@ err:
 	return NVME_SC_INTERNAL;
 }
 
-static void nvmet_tcp_send_ddgst(struct ahash_request *hash,
+static void nvmet_tcp_calc_ddgst(struct ahash_request *hash,
 		struct nvmet_tcp_cmd *cmd)
 {
 	ahash_request_set_crypt(hash, cmd->req.sg,
@@ -413,23 +413,6 @@ static void nvmet_tcp_send_ddgst(struct
 	crypto_ahash_digest(hash);
 }
 
-static void nvmet_tcp_recv_ddgst(struct ahash_request *hash,
-		struct nvmet_tcp_cmd *cmd)
-{
-	struct scatterlist sg;
-	struct kvec *iov;
-	int i;
-
-	crypto_ahash_init(hash);
-	for (i = 0, iov = cmd->iov; i < cmd->nr_mapped; i++, iov++) {
-		sg_init_one(&sg, iov->iov_base, iov->iov_len);
-		ahash_request_set_crypt(hash, &sg, NULL, iov->iov_len);
-		crypto_ahash_update(hash);
-	}
-	ahash_request_set_crypt(hash, NULL, (void *)&cmd->exp_ddgst, 0);
-	crypto_ahash_final(hash);
-}
-
 static void nvmet_setup_c2h_data_pdu(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvme_tcp_data_pdu *pdu = cmd->data_pdu;
@@ -454,7 +437,7 @@ static void nvmet_setup_c2h_data_pdu(str
 
 	if (queue->data_digest) {
 		pdu->hdr.flags |= NVME_TCP_F_DDGST;
-		nvmet_tcp_send_ddgst(queue->snd_hash, cmd);
+		nvmet_tcp_calc_ddgst(queue->snd_hash, cmd);
 	}
 
 	if (cmd->queue->hdr_digest) {
@@ -1137,7 +1120,7 @@ static void nvmet_tcp_prep_recv_ddgst(st
 {
 	struct nvmet_tcp_queue *queue = cmd->queue;
 
-	nvmet_tcp_recv_ddgst(queue->rcv_hash, cmd);
+	nvmet_tcp_calc_ddgst(queue->rcv_hash, cmd);
 	queue->offset = 0;
 	queue->left = NVME_TCP_DIGEST_LENGTH;
 	queue->rcv_state = NVMET_TCP_RECV_DDGST;


