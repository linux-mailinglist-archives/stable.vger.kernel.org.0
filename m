Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F2630A69
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiKSC0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235955AbiKSCY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:24:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DD47EC98;
        Fri, 18 Nov 2022 18:15:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5E0A62833;
        Sat, 19 Nov 2022 02:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4DFC43141;
        Sat, 19 Nov 2022 02:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824149;
        bh=AFX8tgM8frLGf+WFAgsTzXemiXR/KqnskXOiEvFImL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joFQDBfE3pOU0Ea6jyzsSyi/6lG1aePCnu0W2l20mqCcNMNb0ZkOu+4BWOu/l1DuK
         NTV/0muiWnhv3gwFHw4CF61jY3qmC0ZuE92lNWndEa/rzdMzsHVUqsy/sHd3Dn2R7l
         yO8mxuiMQoKmRC6fnFaHwHFQ4+NMEfPZuYKy+NSiGlGxZ09P2XWqjOHTgEEGmjCejW
         kDnYfXxCy3gRxCUPnlcCShtricF0vpJ94TTcDA0zJV4TofRGE8XrFWgnqiY81uNfS9
         dEyPpeTz5SZm5BvRUwDj7dnnIOKvga42XRV4Ap73IWmFc6Mfv085WFK+ioupCNDabY
         NUABN0oVLWzwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, eparis@redhat.com,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 5.4 03/11] audit: fix undefined behavior in bit shift for AUDIT_BIT
Date:   Fri, 18 Nov 2022 21:15:35 -0500
Message-Id: <20221119021543.1775315-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021543.1775315-1-sashal@kernel.org>
References: <20221119021543.1775315-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 986d93f55bdeab1cac858d1e47b41fac10b2d7f6 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in kernel/auditfilter.c:179:23
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 audit_register_class+0x9d/0x137
 audit_classes_init+0x4d/0xb8
 do_one_initcall+0x76/0x430
 kernel_init_freeable+0x3b3/0x422
 kernel_init+0x24/0x1e0
 ret_from_fork+0x1f/0x30
 </TASK>

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
[PM: remove bad 'Fixes' tag as issue predates git, added in v2.6.6-rc1]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/audit.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c89c6495983d..a79f8c285a10 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -179,7 +179,7 @@
 #define AUDIT_MAX_KEY_LEN  256
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
-#define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
+#define AUDIT_BIT(nr)  (1U << ((nr) - AUDIT_WORD(nr)*32))
 
 #define AUDIT_SYSCALL_CLASSES 16
 #define AUDIT_CLASS_DIR_WRITE 0
-- 
2.35.1

