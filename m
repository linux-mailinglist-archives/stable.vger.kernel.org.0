Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C56669C9FD
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 12:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231174AbjBTLjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 06:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbjBTLjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 06:39:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0947735AC
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 03:39:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9470B80C9C
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3C9C433D2;
        Mon, 20 Feb 2023 11:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676893141;
        bh=hm8lk0BfThkYrc+jYueoIknU/hu0Rfo/GdvM5rxRUyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lmNLlyZaOBBvrWGPapQCtz0cSm90reWXEg+Ro3Rg22ymImJbaNf9A3HUFD/c8KfyD
         nsKI9vZ1MSWLSEdbtzu6TFskYZienGgbIRAAZYlrVvJnGo52qWYLE7Tr0K0aAooFsk
         tgyzN96JB6hL8iIiK0n7dFbW1FLvEhJGOd1piUYnqE9b35IJ5Wap6Td7ycX/SK+0Lq
         lbWzwDOD0Pn6V7fw12TZ4/FGfYXsNG2zgQHKrEc4dVfKZvFcOruT9aW3jBwgL4hC1v
         hCwTIeOPPWQaqgl1BTJ55TNvY2anB2pVwWyPLIF+ZPT/WPfwYRCIN3T2J7ph4W73cG
         JD6Kv/G0sVGgw==
Date:   Mon, 20 Feb 2023 03:38:59 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     KP Singh <kpsingh@kernel.org>, security@kernel.org, pjt@google.com,
        evn@google.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection
 with KERNEL_IBRS
Message-ID: <20230220113859.j2tidqnifzjgyros@treble>
References: <20230220103930.1963742-1-kpsingh@kernel.org>
 <Y/NQ6w4UlEuBSTql@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y/NQ6w4UlEuBSTql@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:52:27AM +0100, Greg KH wrote:
> On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> > With the introduction of KERNEL_IBRS, STIBP is no longer needed
> > to prevent cross thread training in the kernel space. When KERNEL_IBRS
> > was added, it also disabled the user-mode protections for spectre_v2.
> > KERNEL_IBRS does not mitigate cross thread training in the userspace.
> > 
> > In order to demonstrate the issue, one needs to avoid syscalls in the
> > victim as syscalls can shorten the window size due to
> > a user -> kernel -> user transition which sets the
> > IBRS bit when entering kernel space and clearing any training the
> > attacker may have done.
> > 
> > Allow users to select a spectre_v2_user mitigation (STIBP always on,
> > opt-in via prctl) when KERNEL_IBRS is enabled.
> > 
> > Reported-by: José Oliveira <joseloliveira11@gmail.com>
> > Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> > Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: KP Singh <kpsingh@kernel.org>
> > ---
> >  arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
> >  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> As this is posted publicly, there's no need to send it to
> security@kernel.org, it doesn't need to be involved.

Also, since this seems intended to be public, please add lkml to Cc on
the next revision.

-- 
Josh
