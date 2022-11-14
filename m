Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21760627E73
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237221AbiKNMsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237256AbiKNMr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:47:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F855EAA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBCA3B80EBC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14CAC433D7;
        Mon, 14 Nov 2022 12:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430074;
        bh=IGVuUwPgjY9AaZnR2/MWF4Zw2btBxNpZ4NYH1Jhzx/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xo/HFu0gKgZvG7AfVuvq+J7XVpAczCwyiickVU5kSiXT/i8XdEQLXDz7NYXZrE+Qq
         NDmxwyY9+EtlkkyGJ/woGSHRWr1PIKgWQqlYf8iTASiiKWKdeGwoSvJdH3VD9g/4J1
         FebeBK+DD8assqDzz87N8b6UEjwJKox8CZtmGfyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/95] capabilities: fix undefined behavior in bit shift for CAP_TO_MASK
Date:   Mon, 14 Nov 2022 13:45:15 +0100
Message-Id: <20221114124443.394687519@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit 46653972e3ea64f79e7f8ae3aa41a4d3fdb70a13 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in security/commoncap.c:1252:2
left shift of 1 by 31 places cannot be represented in type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0x7d/0xa5
 dump_stack+0x15/0x1b
 ubsan_epilogue+0xe/0x4e
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x20c
 cap_task_prctl+0x561/0x6f0
 security_task_prctl+0x5a/0xb0
 __x64_sys_prctl+0x61/0x8f0
 do_syscall_64+0x58/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
 </TASK>

Fixes: e338d263a76a ("Add 64-bit capability support to the kernel")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Reviewed-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/capability.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 2ddb4226cd23..43a44538ec8d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -427,7 +427,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
-- 
2.35.1



