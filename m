Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D526D49F4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjDCOml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjDCOmh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:42:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5967D280DE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3900B81D0B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A84AC433EF;
        Mon,  3 Apr 2023 14:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532938;
        bh=bkSJbz6j3QJNEeu4LidlNeNbmyRh5Kn24RDP0gw2b3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VykSyX6rAlKJqJdgKXAlNRznCDPQ8vWlsm/oxKWvJLosbGt/g+T+u+e54c6qhDK4X
         XMwizqRC5/+dUKWxXqcAiBDk/7EzKiwyLMpimnhWXg8x0lZe4gHlnWC2li139Hmjm/
         3NqebwlJa1iIxT5kDLLZPyyhXCUz9xAK/cI6P8b4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eduard Zingerman <eddyz87@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/181] selftests/bpf: Test btf dump for struct with padding only fields
Date:   Mon,  3 Apr 2023 16:10:09 +0200
Message-Id: <20230403140420.781996178@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit d503f1176b14f722a40ea5110312614982f9a80b ]

Structures with zero regular fields but some padding constitute a
special case in btf_dump.c:btf_dump_emit_struct_def with regards to
newline before closing '}'.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221001104425.415768-2-eddyz87@gmail.com
Stable-dep-of: ea2ce1ba99aa ("libbpf: Fix BTF-to-C converter's padding logic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/btf_dump_test_case_padding.c     | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index f2661c8d2d900..7cb522d22a664 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -102,12 +102,21 @@ struct zone {
 	struct zone_padding __pad__;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padding_wo_named_members {
+	long: 64;
+	long: 64;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct padded_implicitly _1;
 	struct padded_explicitly _2;
 	struct padded_a_lot _3;
 	struct padded_cache_line _4;
 	struct zone _5;
+	struct padding_wo_named_members _6;
 } *_)
 {
 	return 0;
-- 
2.39.2



