Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4624568117B
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237311AbjA3ONx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbjA3ONl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4893FA253
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:13:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12676102E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD385C433EF;
        Mon, 30 Jan 2023 14:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088019;
        bh=wo77f1gol9r3kJlnjUy3gjDY0jKGeZscQov/Gooo0dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qpGr45tUMUIxd7DEysbANLILjjEBz+pqGC4gnPXeQ/rl2pGDyWsuN2a6Hgch9E/kF
         CDqCU5K/td6MiOFoO3tDsYMWPPtM8An3QGGrx9OX3vZKTQffbl6lI9etnr4uhReSqZ
         sEAktn0kHF+ZTmUahlpWrQvPjRVqN06oPxHEwTu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/204] selftests/net: toeplitz: fix race on tpacket_v3 block close
Date:   Mon, 30 Jan 2023 14:50:52 +0100
Message-Id: <20230130134320.160061031@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 903848249a781d76d59561d51676c95b3a4d7162 ]

Avoid race between process wakeup and tpacket_v3 block timeout.

The test waits for cfg_timeout_msec for packets to arrive. Packets
arrive in tpacket_v3 rings, which pass packets ("frames") to the
process in batches ("blocks"). The sk waits for req3.tp_retire_blk_tov
msec to release a block.

Set the block timeout lower than the process waiting time, else
the process may find that no block has been released by the time it
scans the socket list. Convert to a ring of more than one, smaller,
blocks with shorter timeouts. Blocks must be page aligned, so >= 64KB.

Fixes: 5ebfb4cc3048 ("selftests/net: toeplitz test")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20230118151847.4124260-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/toeplitz.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/toeplitz.c b/tools/testing/selftests/net/toeplitz.c
index c5489341cfb8..8ce96028341d 100644
--- a/tools/testing/selftests/net/toeplitz.c
+++ b/tools/testing/selftests/net/toeplitz.c
@@ -213,7 +213,7 @@ static char *recv_frame(const struct ring_state *ring, char *frame)
 }
 
 /* A single TPACKET_V3 block can hold multiple frames */
-static void recv_block(struct ring_state *ring)
+static bool recv_block(struct ring_state *ring)
 {
 	struct tpacket_block_desc *block;
 	char *frame;
@@ -221,7 +221,7 @@ static void recv_block(struct ring_state *ring)
 
 	block = (void *)(ring->mmap + ring->idx * ring_block_sz);
 	if (!(block->hdr.bh1.block_status & TP_STATUS_USER))
-		return;
+		return false;
 
 	frame = (char *)block;
 	frame += block->hdr.bh1.offset_to_first_pkt;
@@ -233,6 +233,8 @@ static void recv_block(struct ring_state *ring)
 
 	block->hdr.bh1.block_status = TP_STATUS_KERNEL;
 	ring->idx = (ring->idx + 1) % ring_block_nr;
+
+	return true;
 }
 
 /* simple test: sleep once unconditionally and then process all rings */
@@ -243,7 +245,7 @@ static void process_rings(void)
 	usleep(1000 * cfg_timeout_msec);
 
 	for (i = 0; i < num_cpus; i++)
-		recv_block(&rings[i]);
+		do {} while (recv_block(&rings[i]));
 
 	fprintf(stderr, "count: pass=%u nohash=%u fail=%u\n",
 		frames_received - frames_nohash - frames_error,
@@ -255,12 +257,12 @@ static char *setup_ring(int fd)
 	struct tpacket_req3 req3 = {0};
 	void *ring;
 
-	req3.tp_retire_blk_tov = cfg_timeout_msec;
+	req3.tp_retire_blk_tov = cfg_timeout_msec / 8;
 	req3.tp_feature_req_word = TP_FT_REQ_FILL_RXHASH;
 
 	req3.tp_frame_size = 2048;
 	req3.tp_frame_nr = 1 << 10;
-	req3.tp_block_nr = 2;
+	req3.tp_block_nr = 16;
 
 	req3.tp_block_size = req3.tp_frame_size * req3.tp_frame_nr;
 	req3.tp_block_size /= req3.tp_block_nr;
-- 
2.39.0



