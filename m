Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D409F4F30A3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiDEJfx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343607AbiDEI5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F4922B17;
        Tue,  5 Apr 2022 01:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DA4E61003;
        Tue,  5 Apr 2022 08:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931B2C385A1;
        Tue,  5 Apr 2022 08:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148781;
        bh=6OQ4XBU3Rd0gro+F3jMJqSQaH/YDj8FH7PqpZ7aqIyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxXdR4EmHcBwgGmV1x9EKM1xwOpXFfs/Sn7ASmECx+ScWSLBvoY3DYrXOybTRtcE3
         FcEBsvVgeAIFHoFbjpgM01DkHuRTKxFi3+JaPeAxjJt9BLV+sL7ydo6q1OiACJPuC/
         Bc82qtHsWmusbK7FkHwrUcjB3UPgf734hDMubzn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Kenta Tada <Kenta.Tada@sony.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0480/1017] selftests/bpf: Extract syscall wrapper
Date:   Tue,  5 Apr 2022 09:23:13 +0200
Message-Id: <20220405070408.546956755@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenta Tada <Kenta.Tada@sony.com>

[ Upstream commit 78a2054156dd6265619b230cc5372b74f9ba5233 ]

Extract the helper to set up SYS_PREFIX for fentry and kprobe selftests
that use __x86_sys_* attach functions.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kenta Tada <Kenta.Tada@sony.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220124141622.4378-2-Kenta.Tada@sony.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/bpf_misc.h  | 19 +++++++++++++++++++
 .../selftests/bpf/progs/test_probe_user.c     | 15 +--------------
 2 files changed, 20 insertions(+), 14 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_misc.h

diff --git a/tools/testing/selftests/bpf/progs/bpf_misc.h b/tools/testing/selftests/bpf/progs/bpf_misc.h
new file mode 100644
index 000000000000..0b78bc9b1b4c
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_misc.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BPF_MISC_H__
+#define __BPF_MISC_H__
+
+#if defined(__TARGET_ARCH_x86)
+#define SYSCALL_WRAPPER 1
+#define SYS_PREFIX "__x64_"
+#elif defined(__TARGET_ARCH_s390)
+#define SYSCALL_WRAPPER 1
+#define SYS_PREFIX "__s390x_"
+#elif defined(__TARGET_ARCH_arm64)
+#define SYSCALL_WRAPPER 1
+#define SYS_PREFIX "__arm64_"
+#else
+#define SYSCALL_WRAPPER 0
+#define SYS_PREFIX ""
+#endif
+
+#endif
diff --git a/tools/testing/selftests/bpf/progs/test_probe_user.c b/tools/testing/selftests/bpf/progs/test_probe_user.c
index 8812a90da4eb..702578a5e496 100644
--- a/tools/testing/selftests/bpf/progs/test_probe_user.c
+++ b/tools/testing/selftests/bpf/progs/test_probe_user.c
@@ -7,20 +7,7 @@
 
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-
-#if defined(__TARGET_ARCH_x86)
-#define SYSCALL_WRAPPER 1
-#define SYS_PREFIX "__x64_"
-#elif defined(__TARGET_ARCH_s390)
-#define SYSCALL_WRAPPER 1
-#define SYS_PREFIX "__s390x_"
-#elif defined(__TARGET_ARCH_arm64)
-#define SYSCALL_WRAPPER 1
-#define SYS_PREFIX "__arm64_"
-#else
-#define SYSCALL_WRAPPER 0
-#define SYS_PREFIX ""
-#endif
+#include "bpf_misc.h"
 
 static struct sockaddr_in old;
 
-- 
2.34.1



