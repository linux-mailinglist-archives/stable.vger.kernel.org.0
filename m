Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83FD6AF231
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCGSvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjCGSuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:50:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7410FBE5FE;
        Tue,  7 Mar 2023 10:39:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBA52CE1C8B;
        Tue,  7 Mar 2023 18:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0B9C433EF;
        Tue,  7 Mar 2023 18:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214353;
        bh=OdR0SnU//r0C2769peoKvBncLS04a8g6uhuhQAWfadk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMmVxIs8sR4GZHDFs0NO3oeInyAo9WTmt5859hm7Kt7uiBE6eTPKta1MY5dfIEn11
         mcV5M/w6M8w8uwfTlgTmWWuctAP7SeC0YTjWr5QnEmIFc/yJjVeZy6jh4i5ai8VHHr
         WRfaucAyKfjjvbHXXMRU6QM5wmEafrqeZSS/tvWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 767/885] selftests: perf_events: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:01:41 +0100
Message-Id: <20230307170035.271065272@linuxfoundation.org>
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

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 465cbb1b9a9fd5f6907adb2d761facaf1a46bfbe upstream.

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
 tools/testing/selftests/perf_events/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/perf_events/Makefile
+++ b/tools/testing/selftests/perf_events/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -I../../../../usr/include
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := sigtrap_threads remove_on_exec


