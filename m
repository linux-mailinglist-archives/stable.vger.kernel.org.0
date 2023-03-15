Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084E96BB333
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjCOMmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjCOMl7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:41:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9C8CC2E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:40:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB22661D73
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:40:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE11BC4339C;
        Wed, 15 Mar 2023 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678884047;
        bh=NdxuVkQyGoTB2Km6sCRRjAePWobc0U5Xx8+hyXxwHgU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BUSxm/JPLhOISY7KH0sTzQJngKEsTqPj0Iq0EsouZAhjOaTJ2Y5tLR4El1vpAsl8Q
         uxkkZFyx+RfurnOiEHo0H+LTPswkK+tEpBXR1veJAMVjJk1dGCeBJeqUlCNVYppyiG
         S2Zn+jqjYTXhVDvkjPchnaClZo/YomTw0zYIWxzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 086/141] bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES
Date:   Wed, 15 Mar 2023 13:13:09 +0100
Message-Id: <20230315115742.598212942@linuxfoundation.org>
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 6c20822fada1b8adb77fa450d03a0d449686a4a9 ]

&xdp_buff and &xdp_frame are bound in a way that

xdp_buff->data_hard_start == xdp_frame

It's always the case and e.g. xdp_convert_buff_to_frame() relies on
this.
IOW, the following:

	for (u32 i = 0; i < 0xdead; i++) {
		xdpf = xdp_convert_buff_to_frame(&xdp);
		xdp_convert_frame_to_buff(xdpf, &xdp);
	}

shouldn't ever modify @xdpf's contents or the pointer itself.
However, "live packet" code wrongly treats &xdp_frame as part of its
context placed *before* the data_hard_start. With such flow,
data_hard_start is sizeof(*xdpf) off to the right and no longer points
to the XDP frame.

Instead of replacing `sizeof(ctx)` with `offsetof(ctx, xdpf)` in several
places and praying that there are no more miscalcs left somewhere in the
code, unionize ::frm with ::data in a flex array, so that both starts
pointing to the actual data_hard_start and the XDP frame actually starts
being a part of it, i.e. a part of the headroom, not the context.
A nice side effect is that the maximum frame size for this mode gets
increased by 40 bytes, as xdp_buff::frame_sz includes everything from
data_hard_start (-> includes xdpf already) to the end of XDP/skb shared
info.
Also update %MAX_PKT_SIZE accordingly in the selftests code. Leave it
hardcoded for 64 bit && 4k pages, it can be made more flexible later on.

Minor: align `&head->data` with how `head->frm` is assigned for
consistency.
Minor #2: rename 'frm' to 'frame' in &xdp_page_head while at it for
clarity.

(was found while testing XDP traffic generator on ice, which calls
 xdp_convert_frame_to_buff() for each XDP frame)

Fixes: b530e9e1063e ("bpf: Add "live packet" mode for XDP in BPF_PROG_RUN")
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://lore.kernel.org/r/20230215185440.4126672-1-aleksander.lobakin@intel.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c                            | 29 +++++++++++++++----
 .../bpf/prog_tests/xdp_do_redirect.c          |  7 +++--
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2723623429ac9..570ec242d9002 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -97,8 +97,11 @@ static bool bpf_test_timer_continue(struct bpf_test_timer *t, int iterations,
 struct xdp_page_head {
 	struct xdp_buff orig_ctx;
 	struct xdp_buff ctx;
-	struct xdp_frame frm;
-	u8 data[];
+	union {
+		/* ::data_hard_start starts here */
+		DECLARE_FLEX_ARRAY(struct xdp_frame, frame);
+		DECLARE_FLEX_ARRAY(u8, data);
+	};
 };
 
 struct xdp_test_data {
@@ -116,6 +119,20 @@ struct xdp_test_data {
 #define TEST_XDP_FRAME_SIZE (PAGE_SIZE - sizeof(struct xdp_page_head))
 #define TEST_XDP_MAX_BATCH 256
 
+#if BITS_PER_LONG == 64 && PAGE_SIZE == SZ_4K
+/* tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c:%MAX_PKT_SIZE
+ * must be updated accordingly when any of these changes, otherwise BPF
+ * selftests will fail.
+ */
+#ifdef __s390x__
+#define TEST_MAX_PKT_SIZE 3216
+#else
+#define TEST_MAX_PKT_SIZE 3408
+#endif
+static_assert(SKB_WITH_OVERHEAD(TEST_XDP_FRAME_SIZE - XDP_PACKET_HEADROOM) ==
+	      TEST_MAX_PKT_SIZE);
+#endif
+
 static void xdp_test_run_init_page(struct page *page, void *arg)
 {
 	struct xdp_page_head *head = phys_to_virt(page_to_phys(page));
@@ -132,8 +149,8 @@ static void xdp_test_run_init_page(struct page *page, void *arg)
 	headroom -= meta_len;
 
 	new_ctx = &head->ctx;
-	frm = &head->frm;
-	data = &head->data;
+	frm = head->frame;
+	data = head->data;
 	memcpy(data + headroom, orig_ctx->data_meta, frm_len);
 
 	xdp_init_buff(new_ctx, TEST_XDP_FRAME_SIZE, &xdp->rxq);
@@ -223,7 +240,7 @@ static void reset_ctx(struct xdp_page_head *head)
 	head->ctx.data = head->orig_ctx.data;
 	head->ctx.data_meta = head->orig_ctx.data_meta;
 	head->ctx.data_end = head->orig_ctx.data_end;
-	xdp_update_frame_from_buff(&head->ctx, &head->frm);
+	xdp_update_frame_from_buff(&head->ctx, head->frame);
 }
 
 static int xdp_recv_frames(struct xdp_frame **frames, int nframes,
@@ -285,7 +302,7 @@ static int xdp_test_run_batch(struct xdp_test_data *xdp, struct bpf_prog *prog,
 		head = phys_to_virt(page_to_phys(page));
 		reset_ctx(head);
 		ctx = &head->ctx;
-		frm = &head->frm;
+		frm = head->frame;
 		xdp->frame_cnt++;
 
 		act = bpf_prog_run_xdp(prog, ctx);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index ac70e871d62f8..9ce734a708b20 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -63,12 +63,13 @@ static int attach_tc_prog(struct bpf_tc_hook *hook, int fd)
 }
 
 /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
- * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
+ * SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) - XDP_PACKET_HEADROOM =
+ * 3408 bytes for 64-byte cacheline and 3216 for 256-byte one.
  */
 #if defined(__s390x__)
-#define MAX_PKT_SIZE 3176
+#define MAX_PKT_SIZE 3216
 #else
-#define MAX_PKT_SIZE 3368
+#define MAX_PKT_SIZE 3408
 #endif
 static void test_max_pkt_size(int fd)
 {
-- 
2.39.2



