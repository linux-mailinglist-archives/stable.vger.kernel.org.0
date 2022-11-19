Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3166B630A3B
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiKSCYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236144AbiKSCWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:22:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8A9C7231;
        Fri, 18 Nov 2022 18:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDB58B825B6;
        Sat, 19 Nov 2022 02:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC54AC433D7;
        Sat, 19 Nov 2022 02:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824108;
        bh=w+z7ParHoUP/56qjdPm41IFmHvoOCWlANcPXR+UNbG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DsN7nt3kk2qDdH5hdlq234Vn1JSWuJZ3bvC0WjPRyt5E4vsuAAR7Cjeq0Amp8hPm1
         qeIvtFaVF9rfzUwsu/ZQpR5rmWPZDU6hoO5bo2B8PnGsdSxZCzabIy2vM8pqEsLQ4n
         S7fepmH911MWjr8/fXpDJfwR1atsvQ0pH55ucAC+vSB9MGY9io6abLSgMM1WYWRr63
         5adXItUW5QAWL7pdB+brhIuzazwAOojey2wKftvc5cN/iO0OnLHDSDB98N+UJdKSFr
         QpEIcz11ikuwChawn7uxOmVbn/mBG/4YZiL7MFrLsAt7cctiWv14MAMpYmBg4LB0Oj
         x8vl7ZMGojxTw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, eparis@redhat.com,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 5.10 04/18] audit: fix undefined behavior in bit shift for AUDIT_BIT
Date:   Fri, 18 Nov 2022 21:14:45 -0500
Message-Id: <20221119021459.1775052-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021459.1775052-1-sashal@kernel.org>
References: <20221119021459.1775052-1-sashal@kernel.org>
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
index cd2d8279a5e4..cb4e8e6e86a9 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -182,7 +182,7 @@
 #define AUDIT_MAX_KEY_LEN  256
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
-#define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
+#define AUDIT_BIT(nr)  (1U << ((nr) - AUDIT_WORD(nr)*32))
 
 #define AUDIT_SYSCALL_CLASSES 16
 #define AUDIT_CLASS_DIR_WRITE 0
-- 
2.35.1

