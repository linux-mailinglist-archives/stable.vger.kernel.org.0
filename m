Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B7E6D95DB
	for <lists+stable@lfdr.de>; Thu,  6 Apr 2023 13:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbjDFLh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 07:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbjDFLhZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 07:37:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77C3A5F5;
        Thu,  6 Apr 2023 04:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D10D6468E;
        Thu,  6 Apr 2023 11:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33110C433EF;
        Thu,  6 Apr 2023 11:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680780877;
        bh=xgr17dnXP2bP9LZwc8V5hVCpG2/EpjRC5X6T29T4Hm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlb39mxt6C1itqtEgJqHgPjB0MrZad4l1rFI47w+vseoS3kZ9I9VOxNMzBUZMsDtR
         5M74EJkaVtJH63ktFDZepPOdmCncHdbVz/EYtW03kn61ojFrbswpgeWavCJ8An5GCc
         /9lWWcDB0rtXLy6F9OgNFHEFNsZgJu0RD0o1baveqzUTbN9RBywj7bqxzwnb4XNAMO
         dxCjlfdetl2ex3ATnxxbBQnPm+0egA21OJj/S/MrMmuMn9GwZ4ZMZp6XsFeDrrXzf2
         f0SzyX8udN0I8SX4t+EKukGHV9AwZXt0AvSHnMlRKxMymrcfYs3zn5KJmZ/0to/GgZ
         eQSqTvVEF1CFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, oleg@redhat.com,
        agordeev@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/7] s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling
Date:   Thu,  6 Apr 2023 07:34:20 -0400
Message-Id: <20230406113421.649149-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113421.649149-1-sashal@kernel.org>
References: <20230406113421.649149-1-sashal@kernel.org>
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
index 42e4cd20fbbed..7c635e4328b87 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -500,9 +500,7 @@ long arch_ptrace(struct task_struct *child, long request,
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
@@ -854,9 +852,7 @@ long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
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

