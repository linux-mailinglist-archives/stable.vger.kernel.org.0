Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F166AEE77
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjCGSMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjCGSL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:11:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E44AA80E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB6761520
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E864C433EF;
        Tue,  7 Mar 2023 18:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212428;
        bh=BIzull7AXdCQXeCc/4B5HvH5hmqczsOYPlNz0RzBPK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0YWvTebNiTDuiA6PZaPjkCt9s3LBmx+czn3AxAXdChlBHPsgGPi0dpwlQvLyi2V/6
         uBpaNr6pBQ6tsVXQa6jsDj/8GbDcREaMYEbgYsPFQ3duK+rl3AKiJ2ag+ppeYmfX4J
         D4DNLUQII6NCgivWw1YucyfecvcPjSQ4qXUehp+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/885] selftests/xsk: print correct error codes when exiting
Date:   Tue,  7 Mar 2023 17:51:25 +0100
Message-Id: <20230307170008.451069373@linuxfoundation.org>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 085dcccfb7d3dc52ed708fc588587f319541bc83 ]

Print the correct error codes when exiting the test suite due to some
terminal error. Some of these had a switched sign and some of them
printed zero instead of errno.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20230111093526.11682-5-magnus.karlsson@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xskxceiver.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 51e693318b3f0..8d5d9b94b020b 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -350,7 +350,7 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 	umem = calloc(1, sizeof(struct xsk_umem_info));
 	if (!umem) {
 		munmap(bufs, umem_sz);
-		exit_with_error(-ENOMEM);
+		exit_with_error(ENOMEM);
 	}
 	umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 	ret = xsk_configure_umem(umem, bufs, umem_sz);
@@ -936,7 +936,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 		if (ifobj->use_poll) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret < 0)
-				exit_with_error(-ret);
+				exit_with_error(errno);
 
 			if (!ret) {
 				if (!is_umem_valid(test->ifobj_tx))
@@ -963,7 +963,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 				if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 					ret = poll(fds, 1, POLL_TMOUT);
 					if (ret < 0)
-						exit_with_error(-ret);
+						exit_with_error(errno);
 				}
 				ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 			}
@@ -1014,7 +1014,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			if (timeout) {
 				if (ret < 0) {
 					ksft_print_msg("ERROR: [%s] Poll error %d\n",
-						       __func__, ret);
+						       __func__, errno);
 					return TEST_FAILURE;
 				}
 				if (ret == 0)
@@ -1023,7 +1023,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			}
 			if (ret <= 0) {
 				ksft_print_msg("ERROR: [%s] Poll error %d\n",
-					       __func__, ret);
+					       __func__, errno);
 				return TEST_FAILURE;
 			}
 		}
@@ -1322,18 +1322,18 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_SKB) {
 			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
-			exit_with_error(-EINVAL);
+			exit_with_error(EINVAL);
 		}
 	} else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_DRV) {
 			ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
-			exit_with_error(-EINVAL);
+			exit_with_error(EINVAL);
 		}
 	}
 
 	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 }
 
 static void *worker_testapp_validate_tx(void *arg)
@@ -1540,7 +1540,7 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
 
 	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 }
 
 static void testapp_bpf_res(struct test_spec *test)
-- 
2.39.2



