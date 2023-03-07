Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A246AE9BE
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjCGR1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCGR05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:26:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3155C95BE7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3036B819AD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D50BC4339C;
        Tue,  7 Mar 2023 17:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209719;
        bh=ycTdLei3H6ceagp6v1mkeCsHyVLlHjxH41J8Uoj9SVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pckutTVXK4O8Mvnucnd5z75IA+HAYgFa7ES9+v/s1DMF28qEVpzg6IxBe6OuZYokY
         tYZxDYAuZ38E+KkIqhpaNMNlZdh80GXyCCSh9kMEzzrUiJREuoFq/Fcgvu9JO5k/EE
         whYWCFNWqjJpMYqKL7XItiYBNUQCf8KSJniL/wuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0309/1001] selftests/bpf: Fix xdp_do_redirect on s390x
Date:   Tue,  7 Mar 2023 17:51:21 +0100
Message-Id: <20230307170034.957914224@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 06c1865b0b0c7820ea53af2394dd7aff31100295 ]

s390x cache line size is 256 bytes, so skb_shared_info must be aligned
on a much larger boundary than for x86. This makes the maximum packet
size smaller.

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/r/20230128000650.1516334-11-iii@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 6c20822fada1 ("bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
index a50971c6cf4a5..ac70e871d62f8 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
@@ -65,7 +65,11 @@ static int attach_tc_prog(struct bpf_tc_hook *hook, int fd)
 /* The maximum permissible size is: PAGE_SIZE - sizeof(struct xdp_page_head) -
  * sizeof(struct skb_shared_info) - XDP_PACKET_HEADROOM = 3368 bytes
  */
+#if defined(__s390x__)
+#define MAX_PKT_SIZE 3176
+#else
 #define MAX_PKT_SIZE 3368
+#endif
 static void test_max_pkt_size(int fd)
 {
 	char data[MAX_PKT_SIZE + 1] = {};
-- 
2.39.2



