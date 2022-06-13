Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C451354923E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380351AbiFMN6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379993AbiFMNwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:52:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E1055B7;
        Mon, 13 Jun 2022 04:33:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCB1CCE1166;
        Mon, 13 Jun 2022 11:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35D4C34114;
        Mon, 13 Jun 2022 11:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120009;
        bh=SvdoKDO845DJKIMOR1OY8H7Us3qIkHAwANgwu9W1094=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0Zed07+u81k1isGWmGszON1FnoYyS4wvimZj32UHC6WbbUwTmk23Zr4lV/AqaP8c
         nxCDWD8+dioE2sNvQaQ7GpE1WGjE02aWxaYmRiK6Vu3UI7d2YkYyAxCTHHWNooJTXX
         Zq6QcOPQDM0fOMKyt4W2sTxss4BOuzk4qk205bjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Lina Wang <lina.wang@mediatek.com>,
        Song Liu <songliubraving@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 198/339] selftests net: fix bpf build error
Date:   Mon, 13 Jun 2022 12:10:23 +0200
Message-Id: <20220613094932.671794098@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lina Wang <lina.wang@mediatek.com>

[ Upstream commit cf67838c4422eab826679b076dad99f96152b4de ]

bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
including path.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Lina Wang <lina.wang@mediatek.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20220606064517.8175-1-lina.wang@mediatek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index f91bf14bbee7..8a69c91fcca0 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -2,6 +2,7 @@
 
 CLANG ?= clang
 CCINCLUDE += -I../../bpf
+CCINCLUDE += -I../../../lib
 CCINCLUDE += -I../../../../../usr/include/
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
@@ -10,5 +11,4 @@ all: $(TEST_CUSTOM_PROGS)
 $(OUTPUT)/%.o: %.c
 	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
 
-clean:
-	rm -f $(TEST_CUSTOM_PROGS)
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
-- 
2.35.1



