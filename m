Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525EE4CF624
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiCGJeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237611AbiCGJdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:33:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A3C6212A;
        Mon,  7 Mar 2022 01:29:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E36E2611DA;
        Mon,  7 Mar 2022 09:29:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCA9C340F6;
        Mon,  7 Mar 2022 09:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645376;
        bh=124lfYyWE+LaMgjw4Q4I4/7cB+m2kmkCj43VRGmBnI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0LXI4BK0iILlol2XtVFJAiJ+j3G/hU+i4OUu5SV72T18J2uwvMIbK4UfD6a6+VLGv
         Gh3zzN1vi4nfv1kh4RpO5105X92aibxJzMK+CtsPL0nv39RWzJRQvMD8cf5NU5yc8K
         HdWOV8+AVfgG76lx3sSkZDASEfnLoK37XjzgPs8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Yang <sherry.yang@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/105] selftests/seccomp: Fix seccomp failure by adding missing headers
Date:   Mon,  7 Mar 2022 10:18:14 +0100
Message-Id: <20220307091644.501985901@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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



