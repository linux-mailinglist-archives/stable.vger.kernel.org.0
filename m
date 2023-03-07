Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC76D6AF267
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbjCGSwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjCGSwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:52:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FC5C8097;
        Tue,  7 Mar 2023 10:40:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8526B8184E;
        Tue,  7 Mar 2023 18:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0208BC433EF;
        Tue,  7 Mar 2023 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214371;
        bh=BjwGdaLYs0pdsmZf0YX6ZKPmNaoc52KbJ38cJ8yp6KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2xJTObO3d2GE+vZ/ocmzidMz/vsXpKEMt4QfnZ61kSC7zW6k/sEf2iA4fBYDiIe9
         PtFmXrzdgH4bsUwrC7dARHyTLZFJxUXxEDmhLsr55g5XanFbBQ88ARgU0FtPyJOUnx
         SZsQGPE1BZLaql9lY4bssiMjXuzUgaDoMkmTVNik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 770/885] selftests: drivers: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:01:44 +0100
Message-Id: <20230307170035.414295107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 07f0148aafe8c95a3a76cd59e9e75b4d78d1d31d upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>  # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/drivers/dma-buf/Makefile        |    2 +-
 tools/testing/selftests/drivers/s390x/uvdevice/Makefile |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/drivers/dma-buf/Makefile
+++ b/tools/testing/selftests/drivers/dma-buf/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I../../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := udmabuf
 
--- a/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
+++ b/tools/testing/selftests/drivers/s390x/uvdevice/Makefile
@@ -11,10 +11,9 @@ else
 TEST_GEN_PROGS := test_uvdevice
 
 top_srcdir ?= ../../../../../..
-khdr_dir = $(top_srcdir)/usr/include
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 
-CFLAGS += -Wall -Werror -static -I$(khdr_dir) -I$(LINUX_TOOL_ARCH_INCLUDE)
+CFLAGS += -Wall -Werror -static $(KHDR_INCLUDES) -I$(LINUX_TOOL_ARCH_INCLUDE)
 
 include ../../../lib.mk
 


