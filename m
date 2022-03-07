Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027EE4CF740
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiCGJpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239831AbiCGJkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9203B7520D;
        Mon,  7 Mar 2022 01:36:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4192EB810CE;
        Mon,  7 Mar 2022 09:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EE4C340E9;
        Mon,  7 Mar 2022 09:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645727;
        bh=124lfYyWE+LaMgjw4Q4I4/7cB+m2kmkCj43VRGmBnI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPIxhcwRgXOIQy2tC1ntpvJlscSk1+sjAjm/mii8sK/ymH7GrXrqE1c9MTLn4IFbq
         KQ1HlnYiz6bK8jYKHW7w+C2enuIdVE8PyP8ijK+7WXpZKJlFq4b78KJ2ZaLjOo3mdH
         iR+Xccz0DcqderPTsq3s92eFCMGo4g4P7jr189Fg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Yang <sherry.yang@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/262] selftests/seccomp: Fix seccomp failure by adding missing headers
Date:   Mon,  7 Mar 2022 10:16:02 +0100
Message-Id: <20220307091702.888893436@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 21bffcb76ee2fbafc7d5946cef10abc9df5cfff7 ]

seccomp_bpf failed on tests 47 global.user_notification_filter_empty
and 48 global.user_notification_filter_empty_threaded when it's
tested on updated kernel but with old kernel headers. Because old
kernel headers don't have definition of macro __NR_clone3 which is
required for these two tests. Since under selftests/, we can install
headers once for all tests (the default INSTALL_HDR_PATH is
usr/include), fix it by adding usr/include to the list of directories
to be searched. Use "-isystem" to indicate it's a system directory as
the real kernel headers directories are.

Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Tested-by: Sherry Yang <sherry.yang@oracle.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/Makefile b/tools/testing/selftests/seccomp/Makefile
index 0ebfe8b0e147f..585f7a0c10cbe 100644
--- a/tools/testing/selftests/seccomp/Makefile
+++ b/tools/testing/selftests/seccomp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-CFLAGS += -Wl,-no-as-needed -Wall
+CFLAGS += -Wl,-no-as-needed -Wall -isystem ../../../../usr/include/
 LDFLAGS += -lpthread
 
 TEST_GEN_PROGS := seccomp_bpf seccomp_benchmark
-- 
2.34.1



