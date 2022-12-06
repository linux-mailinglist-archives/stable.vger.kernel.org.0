Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D957644955
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 17:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiLFQe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 11:34:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiLFQem (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 11:34:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4632FC1A;
        Tue,  6 Dec 2022 08:33:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66B8A617D6;
        Tue,  6 Dec 2022 16:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10406C433C1;
        Tue,  6 Dec 2022 16:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670344403;
        bh=tjj3qZj9Emwq0jAd3d/L+wLhfBYyuz9FzS2LZYYSAzs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KNMwZcbyxa1tQJlT6gvYV8TsHwya8sfNbv3+H/bU3G1w92zBhc8lPFh/nuFOMcKor
         pqTeLHfqSgBaDwE3Hsb2ubexhDK/GUJaCXWaRy1rmgx4a/qmUcMBY65/vY/w7FrpIy
         uPSl7iPi9XqFZLU1Sj95nn+pmuhlbQ68esLtGKdg=
Date:   Tue, 6 Dec 2022 17:33:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.82-rc2 review
Message-ID: <Y49u0LhWMDJxc90l@kroah.com>
References: <20221206124052.595650754@linuxfoundation.org>
 <792a6fba-aa15-2e2a-7527-99ab1116a01d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <792a6fba-aa15-2e2a-7527-99ab1116a01d@roeck-us.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 07:11:39AM -0800, Guenter Roeck wrote:
> On 12/6/22 04:42, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.82 release.
> > There are 123 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> arch/riscv/kernel/smp.c: In function 'handle_IPI':
> arch/riscv/kernel/smp.c:195:44: error: 'cpu' undeclared (first use in this function)
>   195 |                         ipi_cpu_crash_stop(cpu, get_irq_regs());
>       |                                            ^~~
> arch/riscv/kernel/smp.c:195:44: note: each undeclared identifier is reported only once for each function it appears in
> arch/riscv/kernel/smp.c:217:22: error: 'old_regs' undeclared (first use in this function)
>   217 |         set_irq_regs(old_regs);
>       |                      ^~~~~~~~
> 
> This is with v5.15.81-124-g9269e46bc838.
> 
> The backport of commit 9b932aadfc47d seems wrong. The original version introduces
> the cpu variable in handle_IPI(). The backport doesn't, and removes old_regs
> instead.
> 
> Backport:
> 
>  void handle_IPI(struct pt_regs *regs)
>  {
> -       struct pt_regs *old_regs = set_irq_regs(regs);
>         unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
>         unsigned long *stats = ipi_data[smp_processor_id()].stats;
> 
> Original:
> 
> void handle_IPI(struct pt_regs *regs)
>  {
> -       unsigned long *pending_ipis = &ipi_data[smp_processor_id()].bits;
> -       unsigned long *stats = ipi_data[smp_processor_id()].stats;
> +       unsigned int cpu = smp_processor_id();
> +       unsigned long *pending_ipis = &ipi_data[cpu].bits;
> +       unsigned long *stats = ipi_data[cpu].stats;
> 
> Upstream includes commit 7ecbc648102f which removes the old_regs variable.
> That doesn't mean it can be removed in the backport.

Yeah, that looks odd.  I've dropped it from both 5.15 and 6.0 now and
will push out a new -rc with that removed.

thanks for testing!

greg k-h
