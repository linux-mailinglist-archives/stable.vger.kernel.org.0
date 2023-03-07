Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6946F6AE96F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjCGRYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbjCGRXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:23:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01004A02B6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:19:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C7F9B819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07D3C433EF;
        Tue,  7 Mar 2023 17:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209555;
        bh=LAqsQrN1qAGjAmWviYfjpxz5jvtkAjxLb3LrVEOcbGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNXlKzBwTAXQWCeGdjrCvNmo6ARL1Th4enR86pQRXHxExQIk22p2iFxvzzyxT+SiR
         HmCDAHYqn/htm0zTAaQd0FueMqfwt5FPuTIyk4FJyG1tn/hLq8fh5/A01J7N1IKqum
         8BS/IpoDvlXnSKsyne6VYFN3EETfAp+Bw6va3od0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0225/1001] selftests/bpf: Fix vmtest static compilation error
Date:   Tue,  7 Mar 2023 17:49:57 +0100
Message-Id: <20230307170031.648037025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Daniel T. Lee <danieltimlee@gmail.com>

[ Upstream commit 2514a31241e1e9067d379e0fbdb60e4bc2bf4659 ]

As stated in README.rst, in order to resolve errors with linker errors,
'LDLIBS=-static' should be used. Most problems will be solved by this
option, but in the case of urandom_read, this won't fix the problem. So
the Makefile is currently implemented to strip the 'static' option when
compiling the urandom_read. However, stripping this static option isn't
configured properly on $(LDLIBS) correctly, which is now causing errors
on static compilation.

    # LDLIBS=-static ./vmtest.sh
    ld.lld: error: attempted static link of dynamic object liburandom_read.so
    clang: error: linker command failed with exit code 1 (use -v to see invocation)
    make: *** [Makefile:190: /linux/tools/testing/selftests/bpf/urandom_read] Error 1
    make: *** Waiting for unfinished jobs....

This commit fixes this problem by configuring the strip with $(LDLIBS).

Fixes: 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230125100440.21734-1-danieltimlee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c22c43bbee194..2323a2b98b815 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -181,14 +181,15 @@ endif
 # do not fail. Static builds leave urandom_read relying on system-wide shared libraries.
 $(OUTPUT)/liburandom_read.so: urandom_read_lib1.c urandom_read_lib2.c
 	$(call msg,LIB,,$@)
-	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $^ $(LDLIBS)   \
+	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS))   \
+		     $^ $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -fPIC -shared -o $@
 
 $(OUTPUT)/urandom_read: urandom_read.c urandom_read_aux.c $(OUTPUT)/liburandom_read.so
 	$(call msg,BINARY,,$@)
 	$(Q)$(CLANG) $(filter-out -static,$(CFLAGS) $(LDFLAGS)) $(filter %.c,$^) \
-		     liburandom_read.so $(LDLIBS)			       \
+		     liburandom_read.so $(filter-out -static,$(LDLIBS))	     \
 		     -fuse-ld=$(LLD) -Wl,-znoseparate-code -Wl,--build-id=sha1 \
 		     -Wl,-rpath=. -o $@
 
-- 
2.39.2



