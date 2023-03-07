Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF896AF205
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjCGStg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjCGStN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:49:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFBEBE5E7;
        Tue,  7 Mar 2023 10:37:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F378CE1CA1;
        Tue,  7 Mar 2023 18:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CFDC433D2;
        Tue,  7 Mar 2023 18:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214210;
        bh=XpzhoalVVCwrw3ou+mCujUyRNexW3OJJx1ZZztCmxnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVPYiUBptXbGNbJAlLu5kqe6l0vRftmEf2W7kkMkcB4S3w6ZwQjEn5BpyvYqUrlkd
         ONXubK0x5CUwbSc7gaDNXqZDQHsGe4ZLnwKkR47w0V1mRUye0GebTGLEIS6uSGxYBp
         Ddi5RCrx3wh0A9qqRTb6g60mZcnHtgTCuvGELHXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 758/885] selftests: media_tests: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:01:32 +0100
Message-Id: <20230307170034.874638165@linuxfoundation.org>
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

commit f2f9592b736087f695230410fb8dc1afd3cafbbb upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/media_tests/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/media_tests/Makefile
+++ b/tools/testing/selftests/media_tests/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 #
-CFLAGS += -I../ -I../../../../usr/include/
+CFLAGS += -I../ $(KHDR_INCLUDES)
 TEST_GEN_PROGS := media_device_test media_device_open video_device_test
 
 include ../lib.mk


