Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FA5667694
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbjALOdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbjALOc4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:32:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4565A8BB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:24:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 773C4B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AE0C433EF;
        Thu, 12 Jan 2023 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533460;
        bh=mqZchY+OtGrBo6CJuxAM/N2nwSMXzb7e52XNewtdEW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBtFMMHEJzrNdT2AFrKsCxC1h+2VqxJ2w6+c+wKA3EKBSiw4nVqvVr3tF4bAc6Ttc
         gYtVqN7O1Ilf29S9XSQJxzIYL+pFrPeR4viPKukJ+1MrQvMATM6rQd5z70prgSf6ey
         ymcQYiQuFa8ZbacRQZkht78yi0zA5GTpZ4Ekk9s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Gaurav Kohli <gauravkohli@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 486/783] x86/hyperv: Remove unregister syscore call from Hyper-V cleanup
Date:   Thu, 12 Jan 2023 14:53:22 +0100
Message-Id: <20230112135546.719826789@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Gaurav Kohli <gauravkohli@linux.microsoft.com>

[ Upstream commit 32c97d980e2eef25465d453f2956a9ca68926a3c ]

Hyper-V cleanup code comes under panic path where preemption and irq
is already disabled. So calling of unregister_syscore_ops might schedule
out the thread even for the case where mutex lock is free.
hyperv_cleanup
	unregister_syscore_ops
			mutex_lock(&syscore_ops_lock)
				might_sleep
Here might_sleep might schedule out this thread, where voluntary preemption
config is on and this thread will never comes back. And also this was added
earlier to maintain the symmetry which is not required as this can comes
during crash shutdown path only.

To prevent the same, removing unregister_syscore_ops function call.

Signed-off-by: Gaurav Kohli <gauravkohli@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1669443291-2575-1-git-send-email-gauravkohli@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 01860c0d324d..70fd21ebb9d5 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -453,8 +453,6 @@ void hyperv_cleanup(void)
 {
 	union hv_x64_msr_hypercall_contents hypercall_msr;
 
-	unregister_syscore_ops(&hv_syscore_ops);
-
 	/* Reset our OS id */
 	wrmsrl(HV_X64_MSR_GUEST_OS_ID, 0);
 
-- 
2.35.1



