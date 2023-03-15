Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434906BB372
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233087AbjCOMoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbjCOMo2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:44:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786F83402D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A58B81E05
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5FDC433EF;
        Wed, 15 Mar 2023 12:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884183;
        bh=ONp2cR4MDoiAvgT71lLa+4PovnEWURkrUFh8PM9dmSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qn9ZCqbZ85XpW0mZPX4mvKiL+q+/WT2/jvUC3nvT8T72VzqLIoj0/+42YlaRh6yUc
         TCTydMH/S9W4s9DJ5KsXLXTIMjg/LRE5Sp74BNSf3Q7jcY+aykXVj2bb3KmvH65DyA
         mBUkZVqdAR3v0lc/hAmZTXN4jpef8isiJArSkOPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.2 139/141] Revert "bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES"
Date:   Wed, 15 Mar 2023 13:14:02 +0100
Message-Id: <20230315115744.227398385@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

From: Martin KaFai Lau <martin.lau@kernel.org>

commit 181127fb76e62d06ab17a75fd610129688612343 upstream.

This reverts commit 6c20822fada1b8adb77fa450d03a0d449686a4a9.

build bot failed on arch with different cache line size:
https://lore.kernel.org/bpf/50c35055-afa9-d01e-9a05-ea5351280e4f@intel.com/

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bpf/test_run.c                                       |   29 +++------------
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c |    7 +--
 2 files changed, 9 insertions(+), 27 deletions(-)

--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -97,11 +97,8 @@ reset:
 struct xdp_page_head {
 	struct xdp_buff orig_ctx;
 	struct xdp_buff ctx;
-	union {
-		/* ::data_hard_start starts here */
-		DECLARE_FLEX_ARRAY(struct xdp_frame, frame);
-		DECLARE_FLEX_ARRAY(u8, data);
-	};
+	struct xdp_frame frm;
+	u8 data[];
 };
 
 struct xdp_test_data {
@@ -119,20 +116,6 @@ struct xdp_test_data {
 #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
-#if BITS_PER_LONG == 64 && PAGE_SIZE == SZ_4K
-/* tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
- * must be updated accordingly when any of these changes, otherwise BPF
- * selftests will fail.
- */
-#ifdef __s390x__
-#define TEST_MAX_PKT_SIZE 3216
-#else
-#define TEST_MAX_PKT_SIZE 3408
-#endif
-static_assert(SKB_WITH_OVERHEAD(TEST_XDP_FRAME_SIZE - XDP_PACKET_HEADROOM) ==
-	      TEST_MAX_PKT_SIZE);
-#endif
-
 static void xdp_test_run_init_page(struct page *page, void *arg)
 {
 	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
@@ -149,8 +132,8 @@ static void xdp_test_run_init_page(struc
 	headroom -= meta_len;
 
 	new_ctx = &head->ctx;
-	frm = head->frame;
-	data = head->data;
+	frm = &head->frm;
+	data = &head->data;
 	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
 
 	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
@@ -240,7 +223,7 @@ static void reset_ctx(struct xdp_page_he
 	head->ctx.data = head->orig_ctx.data;
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, head->frame);
+	xdp_update_frame_from_buff(&head->ctx, &head->frm);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
@@ -302,7 +285,7 @@ static int xdp_test_run_batch(struct xdp
 		head = phys_to_virt(page_to_phys(page));
 		reset_ctx(head);
 		ctx = &head->ctx;
-		frm = head->frame;
+		frm = &head->frm;
 		xdp->frame_cnt++;
 
 		act = bpf_prog_run_xdp(prog, ctx);
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -63,13 +63,12 @@ static int attach_tc_prog(struct bpf_tc_
 }
 
 /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
- * SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - XDP_PACKET_HEADROOM =
- * 3408 bytes for 64-byte cacheline and 3216 for 256-byte one.
+ * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
  */
 #if defined(__s390x__)
-#define MAX_PKT_SIZE 3216
+#define MAX_PKT_SIZE 3176
 #else
-#define MAX_PKT_SIZE 3408
+#define MAX_PKT_SIZE 3368
 #endif
 static void test_max_pkt_size(int fd)
 {


