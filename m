Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3A536D95D4
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbjDFLhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbjDFLg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:36:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D14B455;
        Thu,  6 Apr 2023 04:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5360646C9;
        Thu,  6 Apr 2023 11:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B08C433A1;
        Thu,  6 Apr 2023 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780859;
        bh=AuQed94okVMlXbK/C2TI9oKbtZEPc2oR0xqx1JrqKuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBOMzIJEzJSE+nql7cyJICIKO6efuglxOcnYaVx/PfTRBargUK6/dzwq0eh70jfw6
         PRzcBUDffabhRxypWLCTBdTYvLoV8qJ7CdcbIBxhf1rM8yO7cnPCjuibUjsdGjwyt6
         Fl4yJwsYyHv0jOceVbxu3S9A8IfBJuNEGb5dSc+COfXNbW3mODQxOxp15xxjmDtBOe
         gGnPmfUYEqb00wtdJAwgSPMJ5Q68pfENSc5B2oBVaPTJOHJAwEbDrDaK74w+rY99gG
         /OihRjYB4Ui/DTnDXYKvBsO8FUnGE7m8zlGZ3X6N0rS/wcBq2wEUF6hNlloW8K7Zqm
         CQ6S+7/rrjNuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, oleg@redhat.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 7/8] s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling
Date:   Thu,  6 Apr 2023 07:33:59 -0400
Message-Id: <20230406113400.649038-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113400.649038-1-sashal@kernel.org>
References: <20230406113400.649038-1-sashal@kernel.org>
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
index 3ffa2847c110b..c36289a3ad500 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -503,9 +503,7 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -857,9 +855,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
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

