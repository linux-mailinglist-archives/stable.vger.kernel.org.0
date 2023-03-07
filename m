Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF36AF239
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjCGSvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbjCGSvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:51:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8200DA7A90;
        Tue,  7 Mar 2023 10:39:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 252D3B8199A;
        Tue,  7 Mar 2023 18:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F84FC433EF;
        Tue,  7 Mar 2023 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214376;
        bh=vzoO0ggHTVXXNGr8OWxNs62Y23D1MI52XDxpWAhQXZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHajCyYWDVaqV/ckyfSPashUIIbKuUDQNc2jegA4leYS5VPCHk+u0URmdrYjbwLPv
         UuJ0EZHu4Yun07igbFlywW/2I+X1B6He0PNkg/3KoNtflYG9WMihPMQKFfIjsP2/cq
         QFpX7mXxwS2eKlM2f9FpNHENobjoZfl5LC8yToTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 772/885] selftests: vm: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:01:46 +0100
Message-Id: <20230307170035.501303719@linuxfoundation.org>
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

commit 8eb3751c73bec746f61fb6bada60d1074d92b8c3 upstream.

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
 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -23,7 +23,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed
 # LDLIBS.
 MAKEFLAGS += --no-builtin-rules
 
-CFLAGS = -Wall -I $(top_srcdir) -I $(top_srcdir)/usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
+CFLAGS = -Wall -I $(top_srcdir) $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
 LDLIBS = -lrt -lpthread
 TEST_GEN_FILES = compaction_test
 TEST_GEN_FILES += gup_test


