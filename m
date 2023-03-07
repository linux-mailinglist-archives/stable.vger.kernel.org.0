Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6435E6AEC86
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjCGR4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:56:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbjCGRzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4087695E2A;
        Tue,  7 Mar 2023 09:50:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0F61614B2;
        Tue,  7 Mar 2023 17:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CE0C433EF;
        Tue,  7 Mar 2023 17:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211424;
        bh=Q8iYk+Ga9jrs97zjLZwud8ZuYpIrDkr7mrJnB5eF4cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6N3gaDX9nu4N0NOXfkr9SGP4L4cKFHmdcwnalF7BPKsp9+NisKTkxaQ1+hOVVKTh
         Q5mqsUPdLEv8mwvBLbev24HLQxP3ft13TXH6eUjdk4Ez6WhGqsSTs21z/MREkLFd/8
         J4PcllQ92HA7PBsiNpB04Di/fo4VrNdBc+avVtxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0856/1001] selftests: sched: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:28 +0100
Message-Id: <20230307170058.986573222@linuxfoundation.org>
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

commit 0d2cace5af50806a6b32ab73d367b80e46acda0f upstream.

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
 tools/testing/selftests/sched/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/sched/Makefile
+++ b/tools/testing/selftests/sched/Makefile
@@ -4,7 +4,7 @@ ifneq ($(shell $(CC) --version 2>&1 | he
 CLANG_FLAGS += -no-integrated-as
 endif
 
-CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/  -Wl,-rpath=./ \
+CFLAGS += -O2 -Wall -g -I./ $(KHDR_INCLUDES) -Wl,-rpath=./ \
 	  $(CLANG_FLAGS)
 LDLIBS += -lpthread
 


