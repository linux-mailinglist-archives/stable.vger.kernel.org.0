Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B296711FCAB
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 02:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfLPB5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 20:57:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbfLPB5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 20:57:46 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 035702465E;
        Mon, 16 Dec 2019 01:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576461466;
        bh=MHwcVoioXHjOzU1ysPmzOv7/f4b5BoIvig+hcVeAgRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OPvOWMg7Up9OkeUUrTCsj/d7e+6AHGElPtgr5agFGNA8P4hVVfQWY+I9spQtf0BU5
         uueDh1zRCy5dOAn+C2tSYXTz5ilVVMi8c984/tWHgrrYDoHW2N44lssJn0UDLkwFzC
         L6AfJSckCPaF9Ir6XrhZ/GEbPe6cseG5gy0pz3rE=
Date:   Sun, 15 Dec 2019 20:57:44 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     natechancellor@gmail.com, mpe@ellerman.id.au,
        ndesaulniers@google.com, segher@kernel.crashing.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc: Avoid clang warnings around
 setjmp and longjmp" failed to apply to 5.4-stable tree
Message-ID: <20191216015744.GA17708@sasha-vm>
References: <1576429888117116@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576429888117116@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 06:11:28PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From c9029ef9c95765e7b63c4d9aa780674447db1ec0 Mon Sep 17 00:00:00 2001
>From: Nathan Chancellor <natechancellor@gmail.com>
>Date: Mon, 18 Nov 2019 21:57:11 -0700
>Subject: [PATCH] powerpc: Avoid clang warnings around setjmp and longjmp
>
>Commit aea447141c7e ("powerpc: Disable -Wbuiltin-requires-header when
>setjmp is used") disabled -Wbuiltin-requires-header because of a
>warning about the setjmp and longjmp declarations.
>
>r367387 in clang added another diagnostic around this, complaining
>that there is no jmp_buf declaration.
>
>  In file included from ../arch/powerpc/xmon/xmon.c:47:
>  ../arch/powerpc/include/asm/setjmp.h:10:13: error: declaration of
>  built-in function 'setjmp' requires the declaration of the 'jmp_buf'
>  type, commonly provided in the header <setjmp.h>.
>  [-Werror,-Wincomplete-setjmp-declaration]
>  extern long setjmp(long *);
>              ^
>  ../arch/powerpc/include/asm/setjmp.h:11:13: error: declaration of
>  built-in function 'longjmp' requires the declaration of the 'jmp_buf'
>  type, commonly provided in the header <setjmp.h>.
>  [-Werror,-Wincomplete-setjmp-declaration]
>  extern void longjmp(long *, long);
>              ^
>  2 errors generated.
>
>We are not using the standard library's longjmp/setjmp implementations
>for obvious reasons; make this clear to clang by using -ffreestanding
>on these files.
>
>Cc: stable@vger.kernel.org # 4.14+
>Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
>Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>Link: https://lore.kernel.org/r/20191119045712.39633-3-natechancellor@gmail.com

Adjusted for code movement in 793b08e2efff ("powerpc/kexec: Move kexec
files into a dedicated subdir.") and queued for 5.4-4.14.

-- 
Thanks,
Sasha
