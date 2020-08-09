Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741B823FF96
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 19:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgHIRp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 13:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgHIRp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Aug 2020 13:45:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58AA92067C;
        Sun,  9 Aug 2020 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596995156;
        bh=rTpo/phmT1OzvgYXBKfuEB38QjP5FPg3isb1JEqbFxU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LHT4mJVDR6wffysh9KH2O7142l0WwRZ5ojTdZQRCCTWZP3l2hSS8ja2JHRzV0FZAz
         s3J7FnsC0tWqAGunURaHXnhNeE/+By5lIj28ngc+jlgk2kiNCsaS2cR3oaqf6eW2KG
         H/uOHh5bjaumkH/u9p/QkrFKbKScHeuEtdYx6bPY=
Date:   Sun, 9 Aug 2020 13:45:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg KH <greg@kroah.com>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] MIPS: VZ: Only include loongson_regs.h for CPU_LOONGSON64
Message-ID: <20200809174555.GG2975990@sasha-vm>
References: <1596891052-24052-1-git-send-email-chenhc@lemote.com>
 <20200808153123.GC369184@kroah.com>
 <2b2937d0-eae6-a489-07bd-c40ded02ce89@flygoat.com>
 <20200809070235.GA1098081@kroah.com>
 <5ffc7bb1-8e3f-227a-7ad0-cec5fc32a96a@redhat.com>
 <20200809173822.GF2975990@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200809173822.GF2975990@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 09, 2020 at 01:38:22PM -0400, Sasha Levin wrote:
>On Sun, Aug 09, 2020 at 07:23:28PM +0200, Paolo Bonzini wrote:
>>On 09/08/20 09:02, Greg KH wrote:
>>>>>>diff --git a/arch/mips/kvm/vz.c b/arch/mips/kvm/vz.c
>>>>>>index 3932f76..a474578 100644
>>>>>>--- a/arch/mips/kvm/vz.c
>>>>>>+++ b/arch/mips/kvm/vz.c
>>>>>>@@ -29,7 +29,9 @@
>>>>>>  #include <linux/kvm_host.h>
>>>>>>  #include "interrupt.h"
>>>>>>+#ifdef CONFIG_CPU_LOONGSON64
>>>>>>  #include "loongson_regs.h"
>>>>>>+#endif
>>>>>The fix for this should be in the .h file, no #ifdef should be needed in
>>>>>a .c file.
>>>>The header file can only be reached when CONFIG_CPU_LOONGSON64 is
>>>>selected...
>>>>Otherwise the include path of this file won't be a part of CFLAGS.
>>>That sounds like you should fix up the path of this file in the
>>>#include line as well :)
>>>
>>
>>There is more #ifdef CONFIG_CPU_LOONGSON64 in arch/mips/kvm/vz.c, and
>>more #include "loongson_regs.h" in arch/mips.  So while I agree with
>>Greg that this idiom is quite unusual, it seems to be the expected way
>>to use this header.  I queued the patch.
>
>Where is that header coming from anyway? I can't find it in the tree,
>nor anything that would generate it.

Woops, nevermind - sorry for the noise.

-- 
Thanks,
Sasha
