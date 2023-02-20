Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B952C69C91F
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 11:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbjBTK54 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 05:57:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbjBTK5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 05:57:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E708A13DD5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 02:57:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C63660DD0
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E10C433EF;
        Mon, 20 Feb 2023 10:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676890350;
        bh=WzZOQpbbHbYM0sXu2hhsAkV3nCxY0LBAS6QwJbXF9Bc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Up9sk61+6ozjTwwjc1q1wgaxWktQpnIhZ/0gfvKHVEfL8sAO3TK0iHid2lVdOOFJq
         KZiyeGQcU1Hg0dLvmt1gFh0F5q/g+IAt7ltVNozZPtdK4RK5g4x30G0ZVxIKf1Q2ZM
         rl7S3D4f8PZxri9h4D480Uvv5tPJ6pWcdSlhqmW0=
Date:   Mon, 20 Feb 2023 11:52:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     security@kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection
 with KERNEL_IBRS
Message-ID: <Y/NQ6w4UlEuBSTql@kroah.com>
References: <20230220103930.1963742-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230220103930.1963742-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 11:39:30AM +0100, KP Singh wrote:
> With the introduction of KERNEL_IBRS, STIBP is no longer needed
> to prevent cross thread training in the kernel space. When KERNEL_IBRS
> was added, it also disabled the user-mode protections for spectre_v2.
> KERNEL_IBRS does not mitigate cross thread training in the userspace.
> 
> In order to demonstrate the issue, one needs to avoid syscalls in the
> victim as syscalls can shorten the window size due to
> a user -> kernel -> user transition which sets the
> IBRS bit when entering kernel space and clearing any training the
> attacker may have done.
> 
> Allow users to select a spectre_v2_user mitigation (STIBP always on,
> opt-in via prctl) when KERNEL_IBRS is enabled.
> 
> Reported-by: José Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)

As this is posted publicly, there's no need to send it to
security@kernel.org, it doesn't need to be involved.

thanks,

greg k-h
