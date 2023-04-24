Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34CC6ECDB1
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbjDXNZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjDXNZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D3C5BAD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CAF26223C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F32C433D2;
        Mon, 24 Apr 2023 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342746;
        bh=sbvEeEAH1fOXzYJuYw5C2KbyDNDubiZlIU+RDaCnxW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ei5p29r8rEg5LkaFrSWsuPJ/w0w0kJ7adANWtamODusMPCDgAlDcqaDCgoSEfScLg
         zIa9JEUGzz9EMf1EA+xXaZ+U8jGwQK8MN/3wzso0gFkS/Rt0Up10tXltl1qbI7+CA1
         lmPbGVVhQuMYmYO39Q+XH027MPjcwH6Yl76K0NtI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 41/98] s390/ptrace: fix PTRACE_GET_LAST_BREAK error handling
Date:   Mon, 24 Apr 2023 15:17:04 +0200
Message-Id: <20230424131135.465840102@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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



