Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970AF2D397F
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 05:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgLIEOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 23:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbgLIEOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 23:14:33 -0500
X-Gm-Message-State: AOAM5313E8B5zmztNWxJCXWDtJ//XDwZ1HQqVIHv7mLgTzmCqJ6QaqQT
        CrPY6/3CwaBQEb4NT3SsMsfdA1T2x6Xn+ACuekZiuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607487232;
        bh=USYvEVRFKMhWo44HHpCPxA5x4OBAXwZlC5ZOImqNKmM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ZKBRjJwBStQbr8LHWOCPyZ/v1hrnCiaNwJkXKawSW/OgZzYaK9StFrbdZ6RLFTcPi
         aXr/+LEGbqbhLJ18IxAxS7hb6MKW5gl4jtCu/mnxe5qI7TlVsoSSsBBbeZXEDDpMsu
         EjuJxys6NtPocy5DSzMoNZaD7CP9AIOGIzkQwaxkL8mfGBMJ9CbYVuDZYR6jv6iwJg
         vAu6fGtTVr5KHCQCUJ8GpeldVq71pzCvYhCJqxa4K3haFW/zRNrtPYEveZ29BczTCC
         MwCorY28jVZHFtp1jwC0o8S2kgP0z5fP4LvUc1Zak96BZkrTwWlYuioSH8iU6SJHp/
         VSICaBHVcVj3w==
X-Google-Smtp-Source: ABdhPJy4n87fzt6xqg8kg00DFgOGdqGU4Iu1EFG8YpS57N4ZXBNkzMa7qtIl3ZbSUy1Na2yTh6A73hNzjl/w+OZgnM0=
X-Received: by 2002:a5d:4e87:: with SMTP id e7mr423838wru.70.1607487230626;
 Tue, 08 Dec 2020 20:13:50 -0800 (PST)
MIME-Version: 1.0
References: <cover.1607058304.git.luto@kernel.org> <776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org>
In-Reply-To: <776b448d5f7bd6b12690707f5ed67bcda7f1d427.1607058304.git.luto@kernel.org>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 8 Dec 2020 20:13:40 -0800
X-Gmail-Original-Message-ID: <CALCETrW1Bw_4KwWNOV5xFFWH056BD-cb+ok7vHTeqW7ZswxopQ@mail.gmail.com>
Message-ID: <CALCETrW1Bw_4KwWNOV5xFFWH056BD-cb+ok7vHTeqW7ZswxopQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] membarrier: Explicitly sync remote cores when
 SYNC_CORE is requested
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 3, 2020 at 9:07 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> membarrier() does not explicitly sync_core() remote CPUs; instead, it
> relies on the assumption that an IPI will result in a core sync.  On
> x86, I think this may be true in practice, but it's not architecturally
> reliable.  In particular, the SDM and APM do not appear to guarantee
> that interrupt delivery is serializing.  While IRET does serialize, IPI
> return can schedule, thereby switching to another task in the same mm
> that was sleeping in a syscall.  The new task could then SYSRET back to
> usermode without ever executing IRET.
>
> Make this more robust by explicitly calling sync_core_before_usermode()
> on remote cores.  (This also helps people who search the kernel tree for
> instances of sync_core() and sync_core_before_usermode() -- one might be
> surprised that the core membarrier code doesn't currently show up in a
> such a search.)
>

Fixes: 70216e18e519 ("membarrier: Provide core serializing command,
*_SYNC_CORE")

> Cc: stable@vger.kernel.org
> Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
