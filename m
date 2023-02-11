Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D93693169
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjBKOEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 09:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBKOEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 09:04:49 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687B725B9A;
        Sat, 11 Feb 2023 06:04:48 -0800 (PST)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pQqUe-0007sk-UO; Sat, 11 Feb 2023 15:04:44 +0100
Message-ID: <6fa20ee8-7471-017d-55c1-e4dbe127b81a@leemhuis.info>
Date:   Sat, 11 Feb 2023 15:04:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] Fix page corruption caused by racy check in __free_pages
Content-Language: en-US, de-DE
To:     David Chen <david.chen@nutanix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>
References: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
From:   "Linux regression tracking #adding (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1676124288;894866cf;
X-HE-SMSGID: 1pQqUe-0007sk-UO
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[TLDR: I'm adding this report to the list of tracked Linux kernel
regressions; the text you find below is based on a few templates
paragraphs you might have encountered already in similar form.
See link in footer if these mails annoy you.]

On 09.02.23 18:48, David Chen wrote:
> When we upgraded our kernel, we started seeing some page corruption like
> the following consistently:
> 
>  BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
>  page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x1304ca
>  flags: 0x17ffffc0000000()
>  raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
>  raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
>  page dumped because: nonzero mapcount
>  CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O      5.10.158-1.nutanix.20221209.el7.x86_64 #1
>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
>  Call Trace:
>   dump_stack+0x74/0x96
>   bad_page.cold+0x63/0x94
>   check_new_page_bad+0x6d/0x80
>   rmqueue+0x46e/0x970
>   get_page_from_freelist+0xcb/0x3f0
>   ? _cond_resched+0x19/0x40
>   __alloc_pages_nodemask+0x164/0x300
>   alloc_pages_current+0x87/0xf0
>   skb_page_frag_refill+0x84/0x110
>   ...
>
> Sometimes, it would also show up as corruption in the free list pointer and
> cause crashes.
> 
> After bisecting the issue, we found the issue started from e320d3012d25:
> 
> 	if (put_page_testzero(page))
> 		free_the_page(page, order);
> 	else if (!PageHead(page))
> 		while (order-- > 0)
> 			free_the_page(page + (1 << order), order);
> 
> So the problem is the check PageHead is racy because at this point we
> already dropped our reference to the page. So even if we came in with
> compound page, the page can already be freed and PageHead can return
> false and we will end up freeing all the tail pages causing double free.
> 
> Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Chunwei Chen <david.chen@nutanix.com>

Thanks for the report and the patch. To be sure the issue doesn't fall
through the cracks unnoticed, I'm adding it to regzbot, the Linux kernel
regression tracking bot:

#regzbot ^introduced e320d3012d25
#regzbot title mm: page corruption caused by racy check in __free_pages
#regzbot ignore-activity

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
That page also explains what to do if mails like this annoy you.
