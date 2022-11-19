Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F00630ABE
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 03:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiKSCat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 21:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiKSC3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 21:29:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5768F3DC;
        Fri, 18 Nov 2022 18:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1D91ECE222D;
        Sat, 19 Nov 2022 02:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C72BC43148;
        Sat, 19 Nov 2022 02:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668824209;
        bh=ZPFpSGAUpCDifML/rOSuKUEhAL9wU3icO/OLBtp5L8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IjbuJ4xv2fkqIHPMe7H0DTvvfWSg8JPm91vXdu8RGq2P6oyyxTyyA/mXyeHdOZqd/
         yAXyA8vYZItXWG+qctrOziwCErl0Qmn23FkvYwtkZurwczuerwOmK2RZIvtnmujcZL
         at6+CcbDIvZoS9HB7xP1uGAQobgKfRlBLI/34t5DhI/H71llS277TAWVl7UVyHPMGh
         QDUOR4vtpt+imeHvkDdY1RWdjsGBI8DuYo4UxDtbwk3GLMsDM2moyVaKj5z0rOJELI
         3f7t6u0brVkwVsT9BeujFJJ1iV3vSAhL91S6lz9LkskPOfo4y+2u2s07eadFp7w5Ol
         Ef190G2GUXK2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaosheng Cui <cuigaosheng1@huawei.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>, eparis@redhat.com,
        linux-audit@redhat.com
Subject: [PATCH AUTOSEL 4.9 2/4] audit: fix undefined behavior in bit shift for AUDIT_BIT
Date:   Fri, 18 Nov 2022 21:16:43 -0500
Message-Id: <20221119021645.1775682-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221119021645.1775682-1-sashal@kernel.org>
References: <20221119021645.1775682-1-sashal@kernel.org>
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
index 208df7b44e90..d7ac6b9be18e 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -170,7 +170,7 @@
 #define AUDIT_MAX_KEY_LEN  256
 #define AUDIT_BITMASK_SIZE 64
 #define AUDIT_WORD(nr) ((__u32)((nr)/32))
-#define AUDIT_BIT(nr)  (1 << ((nr) - AUDIT_WORD(nr)*32))
+#define AUDIT_BIT(nr)  (1U << ((nr) - AUDIT_WORD(nr)*32))
 
 #define AUDIT_SYSCALL_CLASSES 16
 #define AUDIT_CLASS_DIR_WRITE 0
-- 
2.35.1

