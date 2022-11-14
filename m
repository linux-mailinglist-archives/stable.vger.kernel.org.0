Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C825628034
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiKNNDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbiKNNDx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8A520181
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7957661186
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C16C433C1;
        Mon, 14 Nov 2022 13:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431030;
        bh=kA2q5YNvbrCo9Tt+vzxaCI0Zr1L+aqaVS7iOlD4xI8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuVUN3GyeISSRhmEfO8MPd89YgjwmggWWXQ2A8/Jjj3k1YiFKaMNhxVeu1sxL9dgN
         pP+Q7gwx4SnFo7HMsr/1gwG9mHGw1jtNmaT/j8ATzMbf4bEFy7aHKzqxcVD1xIEsU2
         nY+PdE5DmCxM7KHvvg1kFjQl29Y4RHLEGV9Y4qbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 044/190] capabilities: fix undefined behavior in bit shift for CAP_TO_MASK
Date:   Mon, 14 Nov 2022 13:44:28 +0100
Message-Id: <20221114124500.723673594@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index 463d1ba2232a..3d61a0ae055d 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -426,7 +426,7 @@ struct vfs_ns_cap_data {
  */
 
 #define CAP_TO_INDEX(x)     ((x) >> 5)        /* 1 << 5 == bits in __u32 */
-#define CAP_TO_MASK(x)      (1 << ((x) & 31)) /* mask for indexed __u32 */
+#define CAP_TO_MASK(x)      (1U << ((x) & 31)) /* mask for indexed __u32 */
 
 
 #endif /* _UAPI_LINUX_CAPABILITY_H */
-- 
2.35.1



