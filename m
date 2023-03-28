Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE766CC454
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbjC1PDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233776AbjC1PDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:03:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FBCEB4A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59A1DB81D78
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE391C433D2;
        Tue, 28 Mar 2023 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015722;
        bh=mjOBt0hwl4VEkVOuBgR29W11lOITYRPWxwYwBi1U/4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w+B7AXl4HSYPBd4dcaSQhcf6rfoJbhLCdI7tko3725IZzmv4KCtrLzqsavOJtl9Uk
         s/gtnIaT+Xi2yyhw+sExhQUh/zdjxSGzJ6gLCs3BN+9DYBI3jNjPqCfhT2+pq2bpeE
         pE4lRNE2OVZs0M/pxoUa/vv68q1/b/weMS6vHbmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Vyukov <dvyukov@google.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/224] riscv: Bump COMMAND_LINE_SIZE value to 1024
Date:   Tue, 28 Mar 2023 16:41:57 +0200
Message-Id: <20230328142622.406537616@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alex@ghiti.fr>

[ Upstream commit 61fc1ee8be26bc192d691932b0a67eabee45d12f ]

Increase COMMAND_LINE_SIZE as the current default value is too low
for syzbot kernel command line.

There has been considerable discussion on this patch that has led to a
larger patch set removing COMMAND_LINE_SIZE from the uapi headers on all
ports.  That's not quite done yet, but it's gotten far enough we're
confident this is not a uABI change so this is safe.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Link: https://lore.kernel.org/r/20210316193420.904-1-alex@ghiti.fr
[Palmer: it's not uabi]
Link: https://lore.kernel.org/linux-riscv/874b8076-b0d1-4aaa-bcd8-05d523060152@app.fastmail.com/#t
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/uapi/asm/setup.h | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 arch/riscv/include/uapi/asm/setup.h

diff --git a/arch/riscv/include/uapi/asm/setup.h b/arch/riscv/include/uapi/asm/setup.h
new file mode 100644
index 0000000000000..66b13a5228808
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/setup.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+
+#ifndef _UAPI_ASM_RISCV_SETUP_H
+#define _UAPI_ASM_RISCV_SETUP_H
+
+#define COMMAND_LINE_SIZE	1024
+
+#endif /* _UAPI_ASM_RISCV_SETUP_H */
-- 
2.39.2



