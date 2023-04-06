Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAA66D9537
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237045AbjDFLcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237789AbjDFLcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:32:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158993EA;
        Thu,  6 Apr 2023 04:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FFF364656;
        Thu,  6 Apr 2023 11:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A505C4339B;
        Thu,  6 Apr 2023 11:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780712;
        bh=sbvEeEAH1fOXzYJuYw5C2KbyDNDubiZlIU+RDaCnxW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INHoFENAPTiQ3P5B/wf7oUlXul4ZkbCh3V8HS98wxMbiqIXzydNVAqvoYfd7PDdwr
         Gf3yrbAsmFKBNL4ukhanJntQerVVAw8ZejFAKzc+StyxFt5zpe26UtSSVQJYwzmOa+
         OMsNWND1d12vFevw1sZD0keeypa1DZ4e7seOav4ji/bR347IiF7KeyKeIZzHDlL1hn
         lKY+db0cwIZAhv1ova2HhYq6jsU1WikpJdkyNtM8VEfRctfjmU8wjxvXL8RwPPKOOI
         UF+EgIaG64hEnqBLOn2ZJMYAkXS4dadu5Cliyku+W9yitfVVGv2MpuI2VCAfBTQLfg
         7yhMTqBjdLFIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, oleg@redhat.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 09/17] s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling
Date:   Thu,  6 Apr 2023 07:31:23 -0400
Message-Id: <20230406113131.648213-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113131.648213-1-sashal@kernel.org>
References: <20230406113131.648213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit f9bbf25e7b2b74b52b2f269216a92657774f239c ]

Return -EFAULT if put_user() for the PTRACE_GET_LAST_BREAK
request fails, instead of silently ignoring it.

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/ptrace.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 53e0209229f87..092b16b4dd4f6 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -474,9 +474,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned long __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned long __user *)data);
 	case PTRACE_ENABLE_TE:
 		if (!MACHINE_HAS_TE)
 			return -EIO;
@@ -824,9 +822,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 		}
 		return 0;
 	case PTRACE_GET_LAST_BREAK:
-		put_user(child->thread.last_break,
-			 (unsigned int __user *) data);
-		return 0;
+		return put_user(child->thread.last_break, (unsigned int __user *)data);
 	}
 	return compat_ptrace_request(child, request, addr, data);
 }
-- 
2.39.2

