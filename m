Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C97851C426
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 09:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfENHuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 03:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725881AbfENHuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 May 2019 03:50:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B7D2086A;
        Tue, 14 May 2019 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557820206;
        bh=2hYvjl0agVugFiEaz+VAjZeVDOvB29I05dwS1wphxew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVAbOq97ogNjMcBSLf9RCSG16YChQuTEBmtDJR1olrZkZ/i2YskfgnTWqQAEkYtQ9
         cqFC9LIt9Ikedby/n2mzXo63wyCyf6EoiOFo6A8v9rQPRSDBdtpmB/6Xg3xkHja5oU
         AQqIznT4koM0toFuiMVYlu339f2z6fM/gXNfZxsQ=
Date:   Tue, 14 May 2019 09:50:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@kernel.org, Alistair Strachan <astrachan@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Carlos O'Donell <carlos@redhat.com>,
        "H. J. Lu" <hjl.tools@gmail.com>, Borislav Petkov <bp@suse.de>,
        Laura Abbott <labbott@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        kernel-team@android.com, stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH for 4.4, 4.9 and 4.14] x86/vdso: Pass --eh-frame-hdr to
 the linker
Message-ID: <20190514075004.GD27017@kroah.com>
References: <20190514073429.17537-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514073429.17537-1-nobuhiro1.iwamatsu@toshiba.co.jp>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 04:34:29PM +0900, Nobuhiro Iwamatsu wrote:
> From: Alistair Strachan <astrachan@google.com>
> 
> commit cd01544a268ad8ee5b1dfe42c4393f1095f86879 upstream.
> 
> Commit
> 
>   379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")
> 
> accidentally broke unwinding from userspace, because ld would strip the
> .eh_frame sections when linking.
> 
> Originally, the compiler would implicitly add --eh-frame-hdr when
> invoking the linker, but when this Makefile was converted from invoking
> ld via the compiler, to invoking it directly (like vmlinux does),
> the flag was missed. (The EH_FRAME section is important for the VDSO
> shared libraries, but not for vmlinux.)
> 
> Fix the problem by explicitly specifying --eh-frame-hdr, which restores
> parity with the old method.
> 
> See relevant bug reports for additional info:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=201741
>   https://bugzilla.redhat.com/show_bug.cgi?id=1659295
> 
> Fixes: 379d98ddf413 ("x86: vdso: Use $LD instead of $CC to link")
> Reported-by: Florian Weimer <fweimer@redhat.com>
> Reported-by: Carlos O'Donell <carlos@redhat.com>
> Reported-by: "H. J. Lu" <hjl.tools@gmail.com>
> Signed-off-by: Alistair Strachan <astrachan@google.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Tested-by: Laura Abbott <labbott@redhat.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Carlos O'Donell <carlos@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: kernel-team@android.com
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: stable <stable@vger.kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: X86 ML <x86@kernel.org>
> Link: https://lkml.kernel.org/r/20181214223637.35954-1-astrachan@google.com
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  arch/x86/entry/vdso/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

This is already in the 4.14 stable queue.

Sasha, how did you tools miss it for 4.4 and 4.9?

thanks,

greg k-h
