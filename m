Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F12B6AEE99
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjCGSNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbjCGSNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:13:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF44B9BA77
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:08:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8700AB819BA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C257EC4339B;
        Tue,  7 Mar 2023 18:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212528;
        bh=/gXLjJrSdJ8V+i+NJPjzu4J4scImOg5kv0BpxiEY7T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bY1NjGU6zXDg85deHvAtCuP7laezSB2eU2lCF+S9QrARSFzW7XW2MJ8CIj95xCPhR
         UzDRR2agzShnQb9wdCycObebAdfRxTXqUyovcW70V+gKvW6nUgpnSOY5uKuEGmJLAr
         9A2IcptvtAbYdKqrs1HHn7D3msWfiGY/Pso0kIHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Artem Savkov <asavkov@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 182/885] selftests/bpf: Use consistent build-id type for liburandom_read.so
Date:   Tue,  7 Mar 2023 17:51:56 +0100
Message-Id: <20230307170009.899849165@linuxfoundation.org>
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

From: Artem Savkov <asavkov@redhat.com>

[ Upstream commit 61fc5e66f755db24d27ba37ce1ee4873def1a074 ]

lld produces "fast" style build-ids by default, which is inconsistent
with ld's "sha1" style. Explicitly specify build-id style to be "sha1"
when linking liburandom_read.so the same way it is already done for
urandom_read.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20221104094016.102049-1-asavkov@redhat.com
Stable-dep-of: 2514a31241e1 ("selftests/bpf: Fix vmtest static compilation error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e6cf21fad69f0..5a8fd8b3fb4a5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -182,14 +182,15 @@ endif
 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 	$(call msg,LIB,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^ $(LDLIBS)   \
-		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -fPIC -shared -o $@
+		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
+		     -fPIC -shared -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
 		     liburandom_read.so $(LDLIBS)			       \
-		     -fuse-ld=$(LLD) -Wl,-znoseparate-code		       \
-		     -Wl,-rpath=. -Wl,--build-id=sha1 -o $@
+		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
+		     -Wl,-rpath=. -o $@
 
 $(OUTPUT)/sign-file: ../../../../scripts/sign-file.c
 	$(call msg,SIGN-FILE,,$@)
-- 
2.39.2



