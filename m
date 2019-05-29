Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDB42DD4A
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfE2Mjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 08:39:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33273 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfE2Mjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 08:39:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id d9so1700511wrx.0;
        Wed, 29 May 2019 05:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:openpgp:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XhPVU0dXsC4tL7sB/NKbgGTlwd+31tHFAkH4MqUhV0c=;
        b=SQiUdeZuYIwgbBaLjUsR9pDqXblMuF8uCrfkL1lmLeCtqfCtQNk0ETelz97ObbVcpW
         r2znenjJUzVMc2i4PEFuDw9rEQBrAx17/o5QgbqU/McbUe8hVrsoi/+XS9w4NkjMcJZG
         O4UbJnJh2Zydd1pMFCdeVFnvrs7WmOJtotKn+cqm4Kx7SSw/b44ECzChsyyI2YPPT2es
         aTcexg2skBrz9Ix5I5ddBwz/YQ452rPBaAS6y06NYLPVn1FruEXQS3Hzaiv2H23iCKCp
         c0X2BN2o1NS5kjYg5jcKNZKlKONYt3KNODgLo94KmhDYc2C88kc6f/404fnoO7diMPJg
         Cixw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:openpgp
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XhPVU0dXsC4tL7sB/NKbgGTlwd+31tHFAkH4MqUhV0c=;
        b=HssUNyZcFMbV0VyHL7StHFw47QwFc7NUWXOkTfV4FAtWN/8w6rZ/aaUu7mSCEI/2Rc
         /JSnQ2I8hyc/k19mEQLdmXr9g6gkXVZBakAIQLeJEVuh7w2GZq50f5JGk9OohN2xGAWd
         MawT+ZqYF+B7RuvubszKb7ITMHnLqwXh7hwOLjgC4g9SiHXOkYaDIg/+fNBEUkmhx68v
         Cvx+J3eNyeBgox9LfqhjGePbGLgEt1gDSK9l9y2FQXXYQ3vEuDnYt7VNUmrtTC4VRiqZ
         74osNr+Nn4fO/89oQJXbih9tdFGlPMv8tbr2qpN/CJcapyhbz69I4jDb2DGXR/G/p8g0
         PUaA==
X-Gm-Message-State: APjAAAVkW82ygtW3rLnVmIlr68Oz08qTyTS2FZ5muDiGRMnWek7FtSJT
        m7LmgWhDHJvqDLhwB65w7Wu73GSLB6A=
X-Google-Smtp-Source: APXvYqx2eUJfXBT/4qBeKhuGwRzJ/3XipvQ8j1xte4QKMAV6E/jcMJZavsN4y9Qvk1vn9yNKnVe3bA==
X-Received: by 2002:adf:c982:: with SMTP id f2mr1339897wrh.235.1559133578145;
        Wed, 29 May 2019 05:39:38 -0700 (PDT)
Received: from [10.32.224.40] (red-hat-inc.vlan560.asr1.mad1.gblx.net. [159.63.51.90])
        by smtp.gmail.com with ESMTPSA id j9sm14253868wrr.90.2019.05.29.05.39.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 05:39:37 -0700 (PDT)
Subject: Re: [PATCH 1/2] MIPS: Bounds check virt_addr_valid
To:     Paul Burton <paul.burton@mips.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>
Cc:     Paul Burton <pburton@wavecomp.com>,
        Julien Cristau <jcristau@debian.org>,
        Yunqiang Su <ysu@wavecomp.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20190528170444.1557-1-paul.burton@mips.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Openpgp: url=http://pgp.mit.edu/pks/lookup?op=get&search=0xE3E32C2CDEADC0DE
Message-ID: <83ccd453-fdfa-98f7-1808-5735b92a4185@amsat.org>
Date:   Wed, 29 May 2019 14:39:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190528170444.1557-1-paul.burton@mips.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/28/19 7:05 PM, Paul Burton wrote:
> The virt_addr_valid() function is meant to return true iff
> virt_to_page() will return a valid struct page reference. This is true
> iff the address provided is found within the unmapped address range
> between PAGE_OFFSET & MAP_BASE, but we don't currently check for that
> condition. Instead we simply mask the address to obtain what will be a
> physical address if the virtual address is indeed in the desired range,
> shift it to form a PFN & then call pfn_valid(). This can incorrectly
> return true if called with a virtual address which, after masking,
> happens to form a physical address corresponding to a valid PFN.
> 
> For example we may vmalloc an address in the kernel mapped region
> starting a MAP_BASE & obtain the virtual address:
> 
>   addr = 0xc000000000002000
> 
> When masked by virt_to_phys(), which uses __pa() & in turn CPHYSADDR(),
> we obtain the following (bogus) physical address:
> 
>   addr = 0x2000
> 
> In a common system with PHYS_OFFSET=0 this will correspond to a valid
> struct page which should really be accessed by virtual address
> PAGE_OFFSET+0x2000, causing virt_addr_valid() to incorrectly return 1
> indicating that the original address corresponds to a struct page.
> 
> This is equivalent to the ARM64 change made in commit ca219452c6b8
> ("arm64: Correctly bounds check virt_addr_valid").
> 
> This fixes fallout when hardened usercopy is enabled caused by the
> related commit 517e1fbeb65f ("mm/usercopy: Drop extra
> is_vmalloc_or_module() check") which removed a check for the vmalloc
> range that was present from the introduction of the hardened usercopy
> feature.
> 
> Signed-off-by: Paul Burton <paul.burton@mips.com>
> References: ca219452c6b8 ("arm64: Correctly bounds check virt_addr_valid")
> References: 517e1fbeb65f ("mm/usercopy: Drop extra is_vmalloc_or_module() check")
> Reported-by: Julien Cristau <jcristau@debian.org>
> Tested-by: YunQiang Su <ysu@wavecomp.com>

Reviewed-by: Philippe Mathieu-Daudé <f4bug@amsat.org>

> URL: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=929366
> Cc: stable@vger.kernel.org # v4.12+
> ---
> 
>  arch/mips/mm/mmap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
> index 2f616ebeb7e0..7755a1fad05a 100644
> --- a/arch/mips/mm/mmap.c
> +++ b/arch/mips/mm/mmap.c
> @@ -203,6 +203,11 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
>  
>  int __virt_addr_valid(const volatile void *kaddr)
>  {
> +	unsigned long vaddr = (unsigned long)vaddr;
> +
> +	if ((vaddr < PAGE_OFFSET) || (vaddr >= MAP_BASE))
> +		return 0;
> +
>  	return pfn_valid(PFN_DOWN(virt_to_phys(kaddr)));
>  }
>  EXPORT_SYMBOL_GPL(__virt_addr_valid);
> 
