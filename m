Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB164FD3F
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 01:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLRAcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 19:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLRAcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 19:32:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B2AE004;
        Sat, 17 Dec 2022 16:32:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 228D360C6C;
        Sun, 18 Dec 2022 00:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA59CC433D2;
        Sun, 18 Dec 2022 00:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671323549;
        bh=9avVX4rWz+0DFaSot1tqCO7Hml3sUh4OLO3CAj/xkIs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X2imIY7DDEIdZC0adiZPHv6q3BfQboikn8a6nfwMJkpn8pPjOjfwVuDwm53UtmzEB
         hDeGIH7dn4tKZPkDWLkMWwUJXsvfdzZRnVO7JUBS37WzEfH2RLjymeBHHU2xNK/P5n
         taZqDw2atwi2lPJ5B7vr1XabtAH1BkboTKSLn60M=
Date:   Sat, 17 Dec 2022 16:32:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Sasha Levin <sashal@kernel.org>
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
Subject: Re: [PATCH AUTOSEL 6.1 13/22] proc/vmcore: fix potential memory
 leak in vmcore_init()
Message-Id: <20221217163228.9308c293458ceb680a6ffed8@linux-foundation.org>
In-Reply-To: <20221217152727.98061-13-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
        <20221217152727.98061-13-sashal@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 17 Dec 2022 10:27:14 -0500 Sasha Levin <sashal@kernel.org> wrote:

> From: Jianglei Nie <niejianglei2021@163.com>
> 
> [ Upstream commit 12b9d301ff73122aebd78548fa4c04ca69ed78fe ]
> 
> Patch series "Some minor cleanup patches resent".
> 
> The first three patches trivial clean up patches.
>
> And for the patch "kexec: replace crash_mem_range with range", I got a
> ibm-p9wr ppc64le system to test, it works well.
> 
> This patch (of 4):
> 
> elfcorehdr_alloc() allocates a memory chunk for elfcorehdr_addr with
> kzalloc().  If is_vmcore_usable() returns false, elfcorehdr_addr is a
> predefined value.  If parse_crash_elf_headers() gets some error and
> returns a negetive value, the elfcorehdr_addr should be released with
> elfcorehdr_free().

This is exceedingly minor - a single memory leak per boot, under very
rare circumstances.


With every patch I merge I consider -stable.  Often I'll discuss the
desirability of a backport with the author and with reviewers.  Every
single patch.  And then some damn script comes along and overrides that
quite careful decision.  argh.

Can we please do something like

	if (akpm && !cc:stable)
		dont_backport()

And even go further - if your script thinks it might be something we
should backport and if it didn't have cc:stable then contact the
author, reviewers and committers and ask them to reconsider before we
go and backport it.  This approach will have the advantage of training
people to consider the backport more consistently.


I'd (still) like to have a new patch tag like Not-For-Stable: or
cc:not-stable or something to tell your scripts "yes, we thought about
it and we decided no".
