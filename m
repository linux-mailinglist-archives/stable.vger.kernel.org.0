Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BD26AECAA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCGR5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbjCGR4n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:56:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5109DE31;
        Tue,  7 Mar 2023 09:51:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B9D5B819BF;
        Tue,  7 Mar 2023 17:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB17C433EF;
        Tue,  7 Mar 2023 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211481;
        bh=eP+73pVJN2JOL4/U1n4qAQhINBuvjQM1H1Ib7gZxDEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J9L1TbYevx9zKN5PMrZ5ux4o4JE/1q4CCsCttI1JcYAaLGM+cfB+VgTGYHnEPovfE
         1WxLDbLtSltuHx1xAWuiSPJI/94jPJ0ynjU+gAmIxU/E62Kskmqk6XAIff0VyVCEh3
         MuE5+ltB0D4eov38dbPU8JikuUmvf4OY8T3QEJ1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.2 0859/1001] selftests: arm64: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:31 +0100
Message-Id: <20230307170059.119318780@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 7482c19173b7eb044d476b3444d7ee55bc669d03 upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>  # 5.18+
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/arm64/fp/Makefile   |    2 +-
 tools/testing/selftests/arm64/tags/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/arm64/fp/Makefile
+++ b/tools/testing/selftests/arm64/fp/Makefile
@@ -3,7 +3,7 @@
 # A proper top_srcdir is needed by KSFT(lib.mk)
 top_srcdir = $(realpath ../../../../../)
 
-CFLAGS += -I$(top_srcdir)/usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := fp-stress \
 	sve-ptrace sve-probe-vls \
--- a/tools/testing/selftests/arm64/tags/Makefile
+++ b/tools/testing/selftests/arm64/tags/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 TEST_GEN_PROGS := tags_test
 TEST_PROGS := run_tags_test.sh
 


