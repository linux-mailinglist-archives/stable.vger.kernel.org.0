Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01EF938765
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfFGJvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 05:51:47 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35126 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfFGJvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jun 2019 05:51:47 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so948007ioo.2
        for <stable@vger.kernel.org>; Fri, 07 Jun 2019 02:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzIcddQayhEEPiudjCr4DcIP7eVyJxd1lJvVx5vkPsU=;
        b=s/FhmL2H+utdpLVt69/aXDRqe/6Ot6UgLJfdTrWNC6uQ5jni+qE52IP/TeB72imHBf
         r0Ofhy/Cp+jw1YH4PPx41PjXond0yMxdFDaweIfsxpfsfsr6/swifl7We8LXUI7w6S+f
         jGbf8gMvF1Q7R4gRlLQAyACtdkvfQhUk6nx6x5vWoMvP6KHI53pdfjfHbU2IavDcIIIq
         im2znjux7rrc3kJEE6tdibzuToTvZ/M7j2erhXsXDzK4dgWwb7Rapz60xSKRv+zeCeg5
         1NjTfUr6ZXaqnlmHy/C7ekd6eEQz3QoNXsM6vLnYuNkbssq0ylsIHRF+A1nbYQQOUJ6B
         nMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzIcddQayhEEPiudjCr4DcIP7eVyJxd1lJvVx5vkPsU=;
        b=rZKvEB6cdvQIa5K9gXsfHXx5eU9ODoHD5n5yGSHCiP85LNLs/zEe0Kh+wZ3sCL1GIq
         hVYxAmggLVkTRwHbMFdnGYF6/w311VGWTfZ9Ze9Blfb0zC4hplBzy5AJBbmjIPtsdD+w
         00/IfzE+20YA+S5JY5GpL69/2EiFbb2EpzvSC7wP9ROUVk31VS4sOZmDFl/EfmL9698p
         bdoJHWX2q+/2LbnzS5HGGZA/+Zbp7DhfyLGlxrhGU3W4eDatnR33SPnaFa2kmQPxVldQ
         JNFs4pMuXH01pkMqNY+tH1PvBBOavHcALN67XpbukmbBw69OsWrwIokH9VwYjlMPPUv6
         aP7A==
X-Gm-Message-State: APjAAAWYeiDQ0N/SEEPdVNKMTxdSJbErRvzbjn0Q396TOl5SKz0gfjYF
        uXXS077i2BnshND34gahf9dks6XvoPFrvgzxdzqTXQ==
X-Google-Smtp-Source: APXvYqxdsmcz5S4uIclqx1Xkmu/2cTVsHpnI7Z6e/HkXZFF8dHfscniBrKuyFs59B3gaXyti8PKSFJSkIUV8rlicfV8=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr120007iob.49.1559901106728;
 Fri, 07 Jun 2019 02:51:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190606102513.16321-1-ard.biesheuvel@linaro.org> <20190606152621.GA21921@kroah.com>
In-Reply-To: <20190606152621.GA21921@kroah.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 7 Jun 2019 11:51:35 +0200
Message-ID: <CAKv+Gu-Kr7f2E_6OXN3wJiWu4v20Y+xnpfUjyz+Je1UBu4wF-w@mail.gmail.com>
Subject: Re: [PATCH for-4.9-stable] efi/libstub: Unify command line param parsing
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Rolf Eike Beer <eb@emlix.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 6 Jun 2019 at 17:26, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jun 06, 2019 at 12:25:13PM +0200, Ard Biesheuvel wrote:
> > Commit 60f38de7a8d4e816100ceafd1b382df52527bd50 upstream.
> >
> > Merge the parsing of the command line carried out in arm-stub.c with
> > the handling in efi_parse_options(). Note that this also fixes the
> > missing handling of CONFIG_CMDLINE_FORCE=y, in which case the builtin
> > command line should supersede the one passed by the firmware.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Matt Fleming <matt@codeblueprint.co.uk>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: bhe@redhat.com
> > Cc: bhsharma@redhat.com
> > Cc: bp@alien8.de
> > Cc: eugene@hp.com
> > Cc: evgeny.kalugin@intel.com
> > Cc: jhugo@codeaurora.org
> > Cc: leif.lindholm@linaro.org
> > Cc: linux-efi@vger.kernel.org
> > Cc: mark.rutland@arm.com
> > Cc: roy.franz@cavium.com
> > Cc: rruigrok@codeaurora.org
> > Link: http://lkml.kernel.org/r/20170404160910.28115-1-ard.biesheuvel@linaro.org
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > [ardb: fix up merge conflicts with 4.9.180]
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > This fixes the GCC build issue reported by Eike.
> >
> > Note that testing of arm64 stable kernels should cover CONFIG_RANDOMIZE_BASE,
> > since it has a profound impact on how the kernel binary gets put together.
>
> Good idea.  Is that in any arm64 stable kernel configuration?  If not, I
> can ask the Linaro build/test people to add it there.
>

It is not in the defconfig, so it probably doesn't get a lot of coverage.

> And isn't it part of kernel.ci already?  We get the results of that for
> stable releases.
>

kernelci has lost its usefulness for me, since i have to wade through
pages and pages of mips and riscv results before i get to the meat.

> Anyway, thanks for the patch, now queued up.
>
> thanks,
>
> greg k-h
