Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2EF612F24F
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 01:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgACAmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 19:42:40 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45198 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgACAmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 19:42:40 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so22658581pgk.12;
        Thu, 02 Jan 2020 16:42:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:to:cc:cc:cc:subject
         :references:in-reply-to;
        bh=HyioXBGMqcLyFY2JDZv6ThS3RXGTigbfy51ANMut3ps=;
        b=Sc3CyVcU6/AGm54p0XXNxboyeI6gizD/2cRP+H0OctZ/NtP17WDNxbVqFG4tl45MNk
         C9rPUP81qBw1t3zhuXE9HjE8W9EBZGHvqQJtthdYxoBdUZ91CYE8krJDmXRsbjOy0omK
         btZq3HLPFK6MLzhvWqOFP8UnjCHCE+8H7y4khnx8Cn+MRdnd2ayfmFAyjPU+tPFChkp6
         ZgyQIUvevUn9tDMKPtI3KlHsBVl9r8yHXcZ8SwucGD6w9tR6USmGseakzToYwk0e7PDR
         /h/eiV/ZEPqqVMuDtM8o6eggrVRvz7eqVDUx01Mtvj9v1nGZ1/Tahjr9q404qPVmPIHP
         BsDQ==
X-Gm-Message-State: APjAAAU6cN+hhad1hytKACqFsEYEI91/+oe3E8pqbkHND4khySAxwg4p
        rdfw259IEelYGG86LJnbA6Q=
X-Google-Smtp-Source: APXvYqyQ01PVHaEoHE1LVHKgmLKjo0PVf9o02f/5W8ZOiX0AXapPjCsNxxSOPSv2GtC8UFVjo0n2zg==
X-Received: by 2002:a65:56c9:: with SMTP id w9mr89389023pgs.296.1578012159672;
        Thu, 02 Jan 2020 16:42:39 -0800 (PST)
Received: from localhost ([73.93.152.206])
        by smtp.gmail.com with ESMTPSA id o7sm68110625pfg.138.2020.01.02.16.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 16:42:39 -0800 (PST)
Message-ID: <5e0e8dff.1c69fb81.86508.5dbe@mx.google.com>
Date:   Thu, 02 Jan 2020 16:42:38 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     Paul Burton <paulburton@kernel.org>
CC:     linux-mips@vger.kernel.org
CC:     linux-kernel@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable@vger.kernel.org
CC:     linux-mips@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Avoid VDSO ABI breakage due to global register  variable
References:  <20200102045038.102772-1-paulburton@kernel.org>
In-Reply-To:  <20200102045038.102772-1-paulburton@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Paul Burton wrote:
> Declaring __current_thread_info as a global register variable has the
> effect of preventing GCC from saving & restoring its value in cases
> where the ABI would typically do so.
> 
> To quote GCC documentation:
> 
> > If the register is a call-saved register, call ABI is affected: the
> > register will not be restored in function epilogue sequences after the
> > variable has been assigned. Therefore, functions cannot safely return
> > to callers that assume standard ABI.
> 
> When our position independent VDSO is built for the n32 or n64 ABIs all
> functions it exposes should be preserving the value of $gp/$28 for their
> caller, but in the presence of the __current_thread_info global register
> variable GCC stops doing so & simply clobbers $gp/$28 when calculating
> the address of the GOT.
> 
> In cases where the VDSO returns success this problem will typically be
> masked by the caller in libc returning & restoring $gp/$28 itself, but
> that is by no means guaranteed. In cases where the VDSO returns an error
> libc will typically contain a fallback path which will now fail
> (typically with a bad memory access) if it attempts anything which
> relies upon the value of $gp/$28 - eg. accessing anything via the GOT.
> 
> One fix for this would be to move the declaration of
> __current_thread_info inside the current_thread_info() function,
> demoting it from global register variable to local register variable &
> avoiding inadvertently creating a non-standard calling ABI for the VDSO.
> Unfortunately this causes issues for clang, which doesn't support local
> register variables as pointed out by commit fe92da0f355e ("MIPS: Changed
> current_thread_info() to an equivalent supported by both clang and GCC")
> which introduced the global register variable before we had a VDSO to
> worry about.
> 
> Instead, fix this by continuing to use the global register variable for
> the kernel proper but declare __current_thread_info as a simple extern
> variable when building the VDSO. It should never be referenced, and will
> cause a link error if it is. This resolves the calling convention issue
> for the VDSO without having any impact upon the build of the kernel
> itself for either clang or gcc.

Applied to mips-fixes.

> commit bbcc5672b006
> https://git.kernel.org/mips/c/bbcc5672b006
> 
> Signed-off-by: Paul Burton <paulburton@kernel.org>
> Fixes: ebb5e78cc634 ("MIPS: Initial implementation of a VDSO")
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>

Thanks,
    Paul

[ This message was auto-generated; if you believe anything is incorrect
  then please email paulburton@kernel.org to report it. ]
