Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC7A6AECB1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjCGR5Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjCGR4v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:56:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AD974B2;
        Tue,  7 Mar 2023 09:51:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51A1614B2;
        Tue,  7 Mar 2023 17:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFD5C433D2;
        Tue,  7 Mar 2023 17:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211490;
        bh=BoTlvLsL48kvj8FHmLW/4o2SqJhwQeRNX2r8R2fqQKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ppzqfwidz/zisGC8LhDF4H6fFJDvAgawR4Qq4LUR/Up0osz9QMZRSVSi5h3LFPLd8
         KrJTIDTFVAiETNGHH8agtiBOvvn5zPJ4Y+8JhZbBSRVvyp4bdJeAOobe+/z/x+hu57
         4g52KJtk2ciGcDKbpJF/9I61RsBT+77dFZYRFWx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0879/1001] selftests: seccomp: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:51 +0100
Message-Id: <20230307170100.055969201@linuxfoundation.org>
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

commit 07d42dd854446ba3177ad7a217870a5b4edee165 upstream.

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
 tools/testing/selftests/seccomp/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
+CFLAGS += -Wl,-no-as-needed -Wall $(KHDR_INCLUDES)
 LDFLAGS += -lpthread
 LDLIBS += -lcap
 


