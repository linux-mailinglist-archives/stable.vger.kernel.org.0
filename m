Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE706996D1
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 15:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjBPONB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 09:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjBPOM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 09:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C7A197;
        Thu, 16 Feb 2023 06:12:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB9F3B82844;
        Thu, 16 Feb 2023 14:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745D1C433EF;
        Thu, 16 Feb 2023 14:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676556769;
        bh=9HZ9vYETc82yRvH6hFWcF0ZaI4CRW+Kohg12okAsFPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uJrKmpbdkwkQu3yTbl7rFJ1AOMNa3xMW/3dTxJfbzssqP6KvPyg9Ta26e4jWjALju
         mDJnceG7KM4ZFdGD2YN4DFUP+MZjuPfOAbcki9KZa+KXduC86fUXfrHKRh4jlKavqb
         SEYMx3xzksE1jE/XLzs7G76t1KMxrMosh7+Q5AciDTiaRzuOsictqYMTauaNGU6gYE
         BmBi7+fgxL7qeuzeLk49fofadwN21gjpS7ltehhR7bbVgmU1ZZeazYH6fZDXzZp9d2
         JVQPim2YQNdufCAF9UniqnBPgvMYkJgWbc8kMySNAfB1qO466+xVy37ozNw58gxrZn
         bxjNhdNsKvxqg==
Date:   Thu, 16 Feb 2023 23:12:44 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Yang Jihong <yangjihong1@huawei.com>
Cc:     <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
        <naveen.n.rao@linux.ibm.com>, <anil.s.keshavamurthy@intel.com>,
        <davem@davemloft.net>, <ast@kernel.org>, <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] kprobes: Fix issues related to optkprobe
Message-Id: <20230216231244.54e18b8a8656338eeb43b8cb@kernel.org>
In-Reply-To: <20230216034247.32348-1-yangjihong1@huawei.com>
References: <20230216034247.32348-1-yangjihong1@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 16 Feb 2023 11:42:45 +0800
Yang Jihong <yangjihong1@huawei.com> wrote:

> Fixed optkprobe issues, mainly related to the x86 architecture.
> 
> Yang Jihong (2):
>   x86/kprobes: Fix __recover_optprobed_insn check optimizing logic
>   x86/kprobes: Fix arch_check_optimized_kprobe check within
>     optimized_kprobe range
> 
>  arch/x86/kernel/kprobes/opt.c | 6 +++---
>  include/linux/kprobes.h       | 2 ++
>  kernel/kprobes.c              | 4 ++--
>  3 files changed, 7 insertions(+), 5 deletions(-)

Thanks for updating! These look good to me! 

Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thank you,


> 
> -- 
> 
> Changes since v1:
>   - Remove patch1 since there is already a fix patch.
>   - Add "cc stable" and modify comment for patch2.
>   - Use "kprobe_disarmed" instead of "kprobe_disabled" for patch3.
>   - Add fix commmit and "cc stable" for patch3.
> 
> 2.30.GIT
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
