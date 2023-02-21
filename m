Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9483A69E840
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 20:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBUT3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 14:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBUT3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 14:29:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D26565BE;
        Tue, 21 Feb 2023 11:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DD32611B0;
        Tue, 21 Feb 2023 19:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907FDC433EF;
        Tue, 21 Feb 2023 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677007756;
        bh=sDkckEDYPe2T4IYT042I5oTejm2xLWpX6CyfhL+7BPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZNSSlLEA/hq3+t9CR6zYzHdLAfBWlkRAXLv7eT7liibU6pJJwKtU6S+/wQp48YEup
         t1mt0+D6Jm86wzOmwHgj5UPfcIMmDGHvpEy7NT7fXYoF9AHJCq/m6s9jrl9mKURcuK
         FJOSnX5/Q7+qfo+K+2nV5u8OuqHnN/f47xQR9L68=
Date:   Tue, 21 Feb 2023 20:29:13 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/UbiZoR98xouEy5@kroah.com>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230221184908.2349578-1-kpsingh@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 07:49:07PM +0100, KP Singh wrote:
> Setting the IBRS bit implicitly enables STIBP to protect against
> cross-thread branch target injection. With enhanced IBRS, the bit it set
> once and is not cleared again. However, on CPUs with just legacy IBRS,
> IBRS bit set on user -> kernel and cleared on kernel -> user (a.k.a
> KERNEL_IBRS). Clearing this bit also disables the implicitly enabled
> STIBP, thus requiring some form of cross-thread protection in userspace.
> 
> Enable STIBP, either opt-in via prctl or seccomp, or always on depending
> on the choice of mitigation selected via spectre_v2_user.
> 
> Reported-by: José Oliveira <joseloliveira11@gmail.com>
> Reported-by: Rodrigo Branco <rodrigo@kernelhacking.com>
> Reviewed-by: Alexandra Sandulescu <aesa@google.com>
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 33 ++++++++++++++++++++++-----------
>  1 file changed, 22 insertions(+), 11 deletions(-)
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
