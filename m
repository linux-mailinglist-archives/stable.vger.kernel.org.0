Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23528695528
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 01:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjBNAGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 19:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBNAGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 19:06:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2CEC974E;
        Mon, 13 Feb 2023 16:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AEF5B815D7;
        Tue, 14 Feb 2023 00:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC84C433D2;
        Tue, 14 Feb 2023 00:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676333197;
        bh=7w+QCpSPJLTXIjjwLzAaojQaLQkv4JGlLYFaWApxh2Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atX5FSy3oMqM0KJX4C9JKBaYToW3bt9BZfi4iTetnG8kgxG1NORadoz221vwE5XHR
         VXyIxXQ26X2Xhpwf30nLLhfmhXLQPCYJ8LoSVKpJlU1iXN6UZVmAhM+IPOgswpbuZK
         ttbnaBBayDQOLKM1/mBoP+bItXrsH/ZLt8ztlmSEGyJdFOA9D2bCoJPLFLFC/tco9G
         j5/9RkiWU8Fe5GTDu2rdHQcIGj962P3YwhVIPm4N+9zpxT/fxwXunUSrjZb8RwkKXe
         0p3NVE7Ob6NNeUoEDtZ/ZOrlnhFzEdsccpjZmK2ihBlfHxm17p9P2t0Kz8qUg5Uu1d
         QGDYjtDmmIEmw==
Date:   Mon, 13 Feb 2023 19:06:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Sathvika Vasireddy <sv@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        christophe.leroy@csgroup.eu, npiggin@gmail.com,
        naveen.n.rao@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 6.1 17/38] powerpc/85xx: Fix unannotated
 intra-function call warning
Message-ID: <Y+rQjJr2CyQhfIZN@sashalap>
References: <20230209111459.1891941-1-sashal@kernel.org>
 <20230209111459.1891941-17-sashal@kernel.org>
 <288e133f-f740-6818-8125-8079217ab822@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <288e133f-f740-6818-8125-8079217ab822@linux.ibm.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 04:55:54PM +0530, Sathvika Vasireddy wrote:
>Hi Sasha,
>
>On 09/02/23 16:44, Sasha Levin wrote:
>>From: Sathvika Vasireddy <sv@linux.ibm.com>
>>
>>[ Upstream commit 8afffce6aa3bddc940ac1909627ff1e772b6cbf1 ]
>>
>>objtool throws the following warning:
>>   arch/powerpc/kernel/head_85xx.o: warning: objtool: .head.text+0x1a6c:
>>   unannotated intra-function call
>>
>>Fix the warning by annotating KernelSPE symbol with SYM_FUNC_START_LOCAL
>>and SYM_FUNC_END macros.
>>
>>Reported-by: kernel test robot <lkp@intel.com>
>>Signed-off-by: Sathvika Vasireddy <sv@linux.ibm.com>
>>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>Link: https://lore.kernel.org/r/20230128124138.1066176-1-sv@linux.ibm.com
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  arch/powerpc/kernel/head_85xx.S | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>>diff --git a/arch/powerpc/kernel/head_85xx.S b/arch/powerpc/kernel/head_85xx.S
>>index 52c0ab416326a..d3939849f4550 100644
>>--- a/arch/powerpc/kernel/head_85xx.S
>>+++ b/arch/powerpc/kernel/head_85xx.S
>>@@ -862,7 +862,7 @@ _GLOBAL(load_up_spe)
>>   * SPE unavailable trap from kernel - print a message, but let
>>   * the task use SPE in the kernel until it returns to user mode.
>>   */
>>-KernelSPE:
>>+SYM_FUNC_START_LOCAL(KernelSPE)
>>  	lwz	r3,_MSR(r1)
>>  	oris	r3,r3,MSR_SPE@h
>>  	stw	r3,_MSR(r1)	/* enable use of SPE after return */
>>@@ -879,6 +879,7 @@ KernelSPE:
>>  #endif
>>  	.align	4,0
>>+SYM_FUNC_END(KernelSPE)
>>  #endif /* CONFIG_SPE */
>>  /*
>
>Please drop this patch because objtool enablement patches for powerpc 
>are not a part of kernel v6.1.

Ack, I'll drop this and the other one you've pointed out. Thanks!

-- 
Thanks,
Sasha
