Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8911B64FEAB
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 12:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiLRL2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 06:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiLRL2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 06:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5DF559E;
        Sun, 18 Dec 2022 03:28:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D08BB80502;
        Sun, 18 Dec 2022 11:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3BAC433D2;
        Sun, 18 Dec 2022 11:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671362897;
        bh=rKarePoInVMhPInoT0xrFhG2KjCel5on4231oJ7+bAI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gqh0jI0pE8fyC8WRZDI+j+AtDfYNnA7r5CSE0Whv2lcHXFaXYxSYWQpdBli1OIqwn
         rUtlz4qwZmKAqR/n/7klvlHb6gxXOc7TYsyeFMzwfdJahq2D+u2/uRNbxFDiK80EVB
         yDetXjJE3wvX0aTnaqqOXfkXvx0aXtmXDslyQisVOTsaj7RtAZxEG/dH6zakiyQ1vj
         IIBa3kSoRLko8KfwlmxGZed2oq8aM6jQOcabYfaUX+lFzeDOnfF08Y/LbzK3fe50fE
         RPt9m8pPTEaYYxViC7Ku4b2q3PrNBkvANs+TEEprTvaUtetHLaLI+XodfYzC6yJGWn
         jzLxCLl2Ij5Kw==
Date:   Sun, 18 Dec 2022 06:28:16 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>,
        Baoquan He <bhe@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Lifu <chenlifu@huawei.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Li Chen <lchen@ambarella.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Petr Mladek <pmladek@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 6.1 13/22] proc/vmcore: fix potential memory leak
 in vmcore_init()
Message-ID: <Y575UCk+lwfJ2CoE@sashalap>
References: <20221217152727.98061-1-sashal@kernel.org>
 <20221217152727.98061-13-sashal@kernel.org>
 <20221217163228.9308c293458ceb680a6ffed8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221217163228.9308c293458ceb680a6ffed8@linux-foundation.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 17, 2022 at 04:32:28PM -0800, Andrew Morton wrote:
>On Sat, 17 Dec 2022 10:27:14 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Jianglei Nie <niejianglei2021@163.com>
>>
>> [ Upstream commit 12b9d301ff73122aebd78548fa4c04ca69ed78fe ]
>>
>> Patch series "Some minor cleanup patches resent".
>>
>> The first three patches trivial clean up patches.
>>
>> And for the patch "kexec: replace crash_mem_range with range", I got a
>> ibm-p9wr ppc64le system to test, it works well.
>>
>> This patch (of 4):
>>
>> elfcorehdr_alloc() allocates a memory chunk for elfcorehdr_addr with
>> kzalloc().  If is_vmcore_usable() returns false, elfcorehdr_addr is a
>> predefined value.  If parse_crash_elf_headers() gets some error and
>> returns a negetive value, the elfcorehdr_addr should be released with
>> elfcorehdr_free().
>
>This is exceedingly minor - a single memory leak per boot, under very
>rare circumstances.
>
>
>With every patch I merge I consider -stable.  Often I'll discuss the
>desirability of a backport with the author and with reviewers.  Every
>single patch.  And then some damn script comes along and overrides that
>quite careful decision.  argh.
>
>Can we please do something like
>
>	if (akpm && !cc:stable)
>		dont_backport()

Yup, I already had it set for 'akpm && mm/ && !cc:stable', happy to
remove the 'mm/' restriction if you're doing the same for the rest of
the patches you review.

>And even go further - if your script thinks it might be something we
>should backport and if it didn't have cc:stable then contact the
>author, reviewers and committers and ask them to reconsider before we
>go and backport it.  This approach will have the advantage of training
>people to consider the backport more consistently.

This is what this mail is all about: I haven't queued up the patch yet,
it gives folks week+ to review, and all it takes is a simple "no" for me
to drop it.

>I'd (still) like to have a new patch tag like Not-For-Stable: or
>cc:not-stable or something to tell your scripts "yes, we thought about
>it and we decided no".

No objections on my part.

-- 
Thanks,
Sasha
