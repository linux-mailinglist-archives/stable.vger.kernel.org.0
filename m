Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253E1833F6
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 16:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730869AbfHFOaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 10:30:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42257 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730489AbfHFOaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 10:30:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so41689673pgb.9
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 07:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=8aURNyM9/Ye1wwG53oOlkzXvtkizQeODSJiH9nVgXG0=;
        b=HQHR+2FOKymXOLPHb71ljdUtw7d6SR8sttCC6WREABI84NsKWaKC2x+OS2MZaSzefW
         I1PJ7C+eOTj3jeP1eO1XC1a01U/sGTHqNPWINdq76wCxHScWgzlBF3mpbEPEpLUEMtw+
         1I5H3oFpljqdfCkF+IOj7hHShmIJ/oT+K2bGlJTrAHiQ4DfRhQTngzgJuc8C6L7SnSdr
         ePbwYe5bY0tfoX/hrm2B3NP3gZVahK65S9MoRkM9MjPXZSlnfMfy9d0ya1+dkvhIOC6k
         ieEw72Rk0tOmbwG2yFvG2Ex0s1VJylpgaQdkywZ1ZcDcEgfk9fwSDxJLUWJ/56F3MrA6
         TDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=8aURNyM9/Ye1wwG53oOlkzXvtkizQeODSJiH9nVgXG0=;
        b=EH1ot18jjjgFCkDFmrQpytLKU2IJndlcZ7lbWZ68rt01s4iAU9dUdIuXfYC2Z0FCzx
         C1cHrCLvDG+q+OJj1FsQuABBkR3IlkzK6U2MeXRr2dtoEpdEgVh0T7Jf7JHc4mWQCpDb
         703ssIXzABjPwrumeIXZjgpdgaVScRw4FdqfTcm9qAmwPQWHQuHDRcSgTZ4QEiTiLfA5
         oLNsefhypiGTrS5jy3VoUp9O5od24+VkUVSUrthNx9jfAXW24dniB3oz+lDi5yHQHUAq
         3I5gllE7FSDIqJeymj4HMndyk2lzEPOjW41QcDahzqkEi1lladxKS4084TB1oYKS/zEh
         o88w==
X-Gm-Message-State: APjAAAUvAjdQWXi7kzgZZ7XbL65jevRZ3ltjPnaUF2yX35jYAejghA/q
        fCdZXdxOHy+d0ShJneB+BaLnY/zu
X-Google-Smtp-Source: APXvYqyNdiA+wjhQca2uOA0zVHrUw1zh3P5/ttIIjx98GImGfTr6+ex0O0OtkB3fm/cjwPxIhoW1Dg==
X-Received: by 2002:a63:1f03:: with SMTP id f3mr3237884pgf.249.1565101821165;
        Tue, 06 Aug 2019 07:30:21 -0700 (PDT)
Received: from ?IPv6:240b:10:2720:5510:e0e6:163b:d8bf:4871? ([240b:10:2720:5510:e0e6:163b:d8bf:4871])
        by smtp.gmail.com with ESMTPSA id i123sm120412452pfe.147.2019.08.06.07.30.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 07:30:20 -0700 (PDT)
Subject: Re: [PATCH v8 1/9] mtd: cfi_cmdset_0002: Use chip_good() to retry in
 do_write_oneword()
To:     Sasha Levin <sashal@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org
References: <20190805190326.28772-2-ikegami.t@gmail.com>
 <20190806004303.EBEF82147A@mail.kernel.org>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
Message-ID: <9fd8b17b-abb4-114e-d6fb-252430d98432@gmail.com>
Date:   Tue, 6 Aug 2019 23:30:15 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806004303.EBEF82147A@mail.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Thanks for the mail.

On 2019/08/06 9:43, Sasha Levin wrote:
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.2.6, v4.19.64, v4.14.136, v4.9.187, v4.4.187.
>
> v5.2.6: Failed to apply! Possible dependencies:
>      4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
>
> v4.19.64: Failed to apply! Possible dependencies:
>      4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
>      d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
>
> v4.14.136: Failed to apply! Possible dependencies:
>      4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
>      c64d4419a17c ("mtd: cfi_cmdset_0002: Change erase one block to enable XIP once")
>      d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
>      ea092fb3ce66 ("mtd: cfi_cmdset_0002: Fix coding style issues")
>
> v4.9.187: Failed to apply! Possible dependencies:
>      4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
>      c64d4419a17c ("mtd: cfi_cmdset_0002: Change erase one block to enable XIP once")
>      d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
>      ea092fb3ce66 ("mtd: cfi_cmdset_0002: Fix coding style issues")
>
> v4.4.187: Failed to apply! Possible dependencies:
>      4844ef80305d ("mtd: cfi_cmdset_0002: Add support for polling status register")
>      c64d4419a17c ("mtd: cfi_cmdset_0002: Change erase one block to enable XIP once")
>      d9b8a67b3b95 ("mtd: cfi: fix deadloop in cfi_cmdset_0002.c do_write_buffer")
>      ea092fb3ce66 ("mtd: cfi_cmdset_0002: Fix coding style issues")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?

Yes I will do fix the patch for the trees failed to apply if it was 
upstream.

Regards,
Ikegami

>
> --
> Thanks,
> Sasha
