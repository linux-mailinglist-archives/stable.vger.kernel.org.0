Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6F1262595
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 05:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgIIDEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 23:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIDEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 23:04:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2972C061573;
        Tue,  8 Sep 2020 20:04:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id c196so1012769pfc.0;
        Tue, 08 Sep 2020 20:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C+IfSGe94xucF1QhV7eqJ/jdABpcZgXKQwlmBQeviCo=;
        b=WUiHeb9P7f0IMWcOhpKSdim26wdrz0WACI9DJVJS9Rf6ALf9F9cAk6XMc0pK8KO1ic
         YBTSW1kPediH4nT+Mbw19eVe2kh19tIigjpwfsLHNXh5mfTzb4iFHb6ORjRTSwaDkfvH
         CsrgnHiEeOsLSfwy1J1AarsWh8Ag7iv7YBXNNXOWcgdYA9Z7TqmZyrJoQcL5ExAsLgWE
         DmOcLzVpNyKFWvZY3IJUO+mU0qDedOnSkU5c9n9ee4hK/lhciJ9jC4pwvKV1xywuSR+4
         IAlvMIyyy5x6plgIBiAyuHe7iWEHX8qKoPYDLqhxbsaJpVKhOLouZYLYXTOnSqdXsgBO
         rBVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C+IfSGe94xucF1QhV7eqJ/jdABpcZgXKQwlmBQeviCo=;
        b=DRRok6kywTHAT6h+WU4uWndF7WcMn9NosdLRd7lFwyZc28Np5XCcStgiY21VMKZFBW
         HNpjriuZ84u8HgFvWXbjfUWPe/p1dLOJt+cPDPkDb0UIpJYfFA6XJx3ykXZS1W8m3xDk
         iTLzk6UFQXmElqNcO1hrGyCThPUglRchO34wP01t1cO8VlZVxPLABX8VcyQjdpRvQpEp
         EzjqLX2ALfIDsqy40er02VNogISDQA4Dhm+8UY2M4VQ+lGqTUAN1pJfI0TrS1yZCkIpB
         fzvoPw3+fYDpjwGqOafJVdsR/VxOmvcAZw50B8HyrHTPhOvqtXh5CnNMKGXywAgflwgm
         i8ag==
X-Gm-Message-State: AOAM533UAnFMHp4lpZHScGFhQqFWcRE59GXw+5hcGxmf223ljQg2dVsw
        +jzBxPSQZZV4E3QFXsYMuHo=
X-Google-Smtp-Source: ABdhPJwmc2Z0m7EDOxBIMnUo+vv6gABQGHJl1aUKYXH43c2UF//wN0cGJBCTsBPCw/kIMCqlXnpFMQ==
X-Received: by 2002:a63:f70e:: with SMTP id x14mr1338922pgh.407.1599620654326;
        Tue, 08 Sep 2020 20:04:14 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u10sm738927pfn.122.2020.09.08.20.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 20:04:13 -0700 (PDT)
Subject: Re: [PATCH stable 4.19 v2 0/2] arm64: entry: Place an SB sequence
 following an ERET instruction
To:     linux-arm-kernel@lists.infradead.org
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
References: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <282ca27e-474c-ea1f-beba-52f361f16b20@gmail.com>
Date:   Tue, 8 Sep 2020 20:04:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <1598294112-19197-1-git-send-email-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/24/2020 11:35 AM, Florian Fainelli wrote:
> Changes in v2:
> 
> - included missing preliminary patch to define the SB barrier instruction
> 
> Will Deacon (2):
>    arm64: Add support for SB barrier and patch in over DSB; ISB sequences
>    arm64: entry: Place an SB sequence following an ERET instruction

Does anybody at ARM or Android care about those changes? If so, would 
you be willing to review these?

Thanks

> 
>   arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
>   arch/arm64/include/asm/barrier.h    |  4 ++++
>   arch/arm64/include/asm/cpucaps.h    |  3 ++-
>   arch/arm64/include/asm/sysreg.h     |  6 ++++++
>   arch/arm64/include/asm/uaccess.h    |  3 +--
>   arch/arm64/include/uapi/asm/hwcap.h |  1 +
>   arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>   arch/arm64/kernel/cpuinfo.c         |  1 +
>   arch/arm64/kernel/entry.S           |  2 ++
>   arch/arm64/kvm/hyp/entry.S          |  1 +
>   arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
>   11 files changed, 47 insertions(+), 3 deletions(-)
> 

-- 
Florian
