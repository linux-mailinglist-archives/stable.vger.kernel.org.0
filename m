Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D646AECA3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjCGR5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCGR4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B45AA42C2;
        Tue,  7 Mar 2023 09:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BC10B819BB;
        Tue,  7 Mar 2023 17:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5258C433D2;
        Tue,  7 Mar 2023 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211472;
        bh=BRL9o4GMA03Od+W6mr3WvQm47Go0VaSPNiurBmTaY+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSHt+CEiQIUv5fmwk7pjOf165i6wy4GShtlV9FRUuAoHuaDZcU2KReMjpakWfxXyJ
         CqQmtZy5cqSFICjwQPo3Ns/qMy6p5nJUVmQ3L8vvWflDw+yvgvE0FGMcQkGGgVx1aI
         bRf5uOzM4QaKjfGUjkImLzdFOQS78X72NDK/B62s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.2 0874/1001] selftests: ipc: Fix incorrect kernel headers search path
Date:   Tue,  7 Mar 2023 18:00:46 +0100
Message-Id: <20230307170059.828291014@linuxfoundation.org>
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

commit ecf9fdb5c2a9d63c732acccb6318feb73dd1589f upstream.

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
 tools/testing/selftests/ipc/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ipc/Makefile
+++ b/tools/testing/selftests/ipc/Makefile
@@ -10,7 +10,7 @@ ifeq ($(ARCH),x86_64)
 	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
 endif
 
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := msgque
 


