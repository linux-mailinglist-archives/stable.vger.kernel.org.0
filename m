Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E926AEA8C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbjCGReq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCGRed (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808FBA2241
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3952AB8199E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84564C4339B;
        Tue,  7 Mar 2023 17:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210227;
        bh=4EGXRIhNIwirYYcJKpnoB+BjpOetxfdncTYyveykGBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rfim67wcB2+z4Cf5I91bjIgBhVyrBX3yWp7/jfRhN+OQp/qoZ1fbhxkWrcJrNHFtB
         x0WxZOYqy1R8+mtg3T8yhfC8bD9DuXofltX90xX5du4T3KwWxUagWdPMj6vfyvFqz/
         1TbktQ4WsaMlxQAKJt8UbYcZDmjPGWIhbeowwxHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "kernelci.org bot" <bot@kernelci.org>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0474/1001] selftests: find echo binary to use -ne options
Date:   Tue,  7 Mar 2023 17:54:06 +0100
Message-Id: <20230307170041.964561849@linuxfoundation.org>
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

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 4ebe33398c40c1118b4d8546978036c0e0032d1b ]

Find the actual echo binary using $(which echo) and use it for
formatted output with -ne.  On some systems, the default echo command
doesn't handle the -e option and the output looks like this (arm64
build):

-ne Emit Tests for alsa

-ne Emit Tests for amd-pstate

-ne Emit Tests for arm64

This is for example the case with the KernelCI Docker images
e.g. kernelci/gcc-10:x86-kselftest-kernelci.  With the actual echo
binary (e.g. in /bin/echo), the output is formatted as expected (x86
build this time):

Emit Tests for alsa
Emit Tests for amd-pstate
Skipping non-existent dir: arm64

Only the install target is using "echo -ne" so keep the $ECHO variable
local to it.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Fixes: 3297a4df805d ("kselftests: Enable the echo command to print newlines in Makefile")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 41b649452560c..9619d0f3b2ffb 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -234,10 +234,11 @@ ifdef INSTALL_PATH
 	@# While building kselftest-list.text skip also non-existent TARGET dirs:
 	@# they could be the result of a build failure and should NOT be
 	@# included in the generated runlist.
+	ECHO=`which echo`; \
 	for TARGET in $(TARGETS); do \
 		BUILD_TARGET=$$BUILD/$$TARGET;	\
-		[ ! -d $(INSTALL_PATH)/$$TARGET ] && echo "Skipping non-existent dir: $$TARGET" && continue; \
-		echo -ne "Emit Tests for $$TARGET\n"; \
+		[ ! -d $(INSTALL_PATH)/$$TARGET ] && $$ECHO "Skipping non-existent dir: $$TARGET" && continue; \
+		$$ECHO -ne "Emit Tests for $$TARGET\n"; \
 		$(MAKE) -s --no-print-directory OUTPUT=$$BUILD_TARGET COLLECTION=$$TARGET \
 			-C $$TARGET emit_tests >> $(TEST_LIST); \
 	done;
-- 
2.39.2



