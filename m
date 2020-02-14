Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62D1315D3D4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 09:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgBNIch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 03:32:37 -0500
Received: from mail.skyhub.de ([5.9.137.197]:59270 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727965AbgBNIcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 03:32:36 -0500
Received: from zn.tnic (p200300EC2F0D5A00F0C2F03C7F1C4548.dip0.t-ipconnect.de [IPv6:2003:ec:2f0d:5a00:f0c2:f03c:7f1c:4548])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 531281EC0CED;
        Fri, 14 Feb 2020 09:32:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1581669155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=uETgdUpmK7Q1w6DrhS6zC/egrZ5XfrPV6q1WMwuIhUY=;
        b=e4f5bxsXlo8zlR/qTOTdmya+4WX79a+kH89tT8F2hXaJjq/FMuELPkBJcXXAWqAJZM28uR
        C09K4O27b72+EePzpYMfVD9kap4r2XjQi5qqrM6a4C/t81PJrd7pLxV6J03y8tVALCh9TI
        aRwYd23KcmwlcQ/nnzc0+NoQnt4csKE=
Date:   Fri, 14 Feb 2020 09:32:30 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     stable@vger.kernel.org
Cc:     X86 ML <x86@kernel.org>, Yazen Ghannam <Yazen.Ghannam@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/mce/amd: Fix kobject lifetime
Message-ID: <20200214083230.GA13395@zn.tnic>
References: <20200214082801.13836-1-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200214082801.13836-1-bp@alien8.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 14, 2020 at 09:28:01AM +0100, Borislav Petkov wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Accessing the MCA thresholding controls in sysfs concurrently with CPU
> hotplug can lead to a couple of KASAN-reported issues:
> 
>   BUG: KASAN: use-after-free in sysfs_file_ops+0x155/0x180
>   Read of size 8 at addr ffff888367578940 by task grep/4019
> 
> and
> 
>   BUG: KASAN: use-after-free in show_error_count+0x15c/0x180
>   Read of size 2 at addr ffff888368a05514 by task grep/4454
> 
> for example. Both result from the fact that the threshold block
> creation/teardown code frees the descriptor memory itself instead of
> defining proper ->release function and leaving it to the driver core to
> take care of that, after all sysfs accesses have completed.
> 
> Do that and get rid of the custom freeing code, fixing the above UAFs in
> the process.
> 
>   [ bp: write commit message. ]
> 
> Fixes: 95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Cc: <stable@vger.kernel.org>

Damn git-send-email: it read out Cc: stable and added it to the Cc list.
I've added

suppresscc = bodycc

to my .gitconfig.

Sorry stable guys.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
