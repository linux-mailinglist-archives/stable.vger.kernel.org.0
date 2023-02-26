Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6DA6A32BA
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 17:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjBZQLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 11:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBZQLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 11:11:23 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6E218146;
        Sun, 26 Feb 2023 08:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Dz6wvhhZodWOX7hNA0c1gSql4IyZN9lBKSgUgMAtsLA=; b=cg8mJ2QZHJeWo9G29AGtRwycwX
        gOYuitq/SEVfc5FOLq1a7unoogXL9+eZidG3CIuaCL3ap1LjNEshAouvpmKzaKZdhduDkvWZOaJJk
        8cx69rKdB+g7Jom9djfrvimbM9gA3qbv7gi9mekj7LlEzf4Cm34VWbUirMloZGjO6+XFmVT0eAwPT
        BCOsNDFUCejWpK+B3f9OHK+miLyscOKzkoSZRNmMJHtTlJmU3jjIDtPbSwKLs8i3Kz55FZQ92x1Lp
        tw6dCLIgGDtnUByB8aGBqk7dChnunJPgns7kub9/oP0vNavILiW5iSJg3Pzz37OxR+8gsfGOiS6Cq
        y6SiMo3Q==;
Received: from [152.254.196.162] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pWJcJ-00FweO-SJ; Sun, 26 Feb 2023 17:11:16 +0100
Message-ID: <4753106d-b370-5393-2908-4067f3c306e5@igalia.com>
Date:   Sun, 26 Feb 2023 13:11:09 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4] panic: Fixes the panic_print NMI backtrace setting
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     bhe@redhat.com, pmladek@suse.com, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, dyoung@redhat.com,
        d.hatayama@jp.fujitsu.com, feng.tang@intel.com,
        hidehiro.kawai.ez@hitachi.com, keescook@chromium.org,
        mikelley@microsoft.com, vgoyal@redhat.com, kernel-dev@igalia.com,
        kernel@gpiccoli.net, stable@vger.kernel.org
References: <20230210203510.1734835-1-gpiccoli@igalia.com>
 <20230225214454.5eb25ff8a937a99d357c44ad@linux-foundation.org>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20230225214454.5eb25ff8a937a99d357c44ad@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/02/2023 02:44, Andrew Morton wrote:
> On Fri, 10 Feb 2023 17:35:10 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:
> [...] 
>> Notice that while at it, I got rid of the "crash_kexec_post_notifiers"
>> local copy in panic(). This was introduced by commit b26e27ddfd2a
>> ("kexec: use core_param for crash_kexec_post_notifiers boot option"),
>> but it is not clear from comments or commit message why this local copy
>> is required.
>>
>> My understanding is that it's a mechanism to prevent some concurrency,
>> in case some other CPU modify this variable while panic() is running.
>> I find it very unlikely, hence I removed it - but if people consider
>> this copy needed, I can respin this patch and keep it, even providing a
>> comment about that, in order to be explict about its need.
> 
> Only two sites change crash_kexec_post_notifiers, in
> arch/powerpc/kernel/fadump.c and drivers/hv/hv_common.c.  Yes, it's
> very unlikely that this will be altered while panic() is running and
> the consequences will be slight anyway.
> 
> But formally, we shouldn't do this, especially in a -stable
> backportable patch.  So please, let's have the minimal bugfix for now
> and we can look at removing that local at a later time?
> 

Thanks Andrew, I agree with you! I just sent a V5 with the bugfix alone,
not changing this local/global variable behavior.

Cheers,


Guilherme
