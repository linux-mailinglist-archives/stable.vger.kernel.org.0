Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082A365D6A1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbjADOz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236020AbjADOzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:55:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9DB1EACF;
        Wed,  4 Jan 2023 06:55:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6BC6175D;
        Wed,  4 Jan 2023 14:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC0CC433F0;
        Wed,  4 Jan 2023 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844145;
        bh=4+asDLO/hYiXl7igLLqD39zSJqLFzA//VD+dBoT82RE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MEzGd3QPx4I0elS9qkY+UUdwE8Bj+DFo7YGz7kmoCOe6nq3MV5CjGkUp5TilfTICW
         v6bXJNij4kqeJVUvbquVM32d5qvCMH0sBjO7FHMjY/NkKB0UTpkigZJZzrKU7BoPL7
         5DPPEZ6cOHTp7ufAFHJkAt9uj1d3RJxmv8EW/FWU=
Date:   Wed, 4 Jan 2023 15:52:03 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lee Jones <lee@kernel.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/2] arm64: efi: Execute runtime services from a
 dedicated stack
Message-ID: <Y7WSk1q1aTkWlsQ9@kroah.com>
References: <20221205201210.463781-1-ardb@kernel.org>
 <20221205201210.463781-2-ardb@kernel.org>
 <Y7VXg5MCRyAJFmus@google.com>
 <CAMj1kXEYDHuRmUPvdMVj1H1fLoOKcr+qG6NDpufxwJa57jsWdg@mail.gmail.com>
 <Y7WQVreh3l9hYarK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WQVreh3l9hYarK@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 02:42:30PM +0000, Lee Jones wrote:
> On Wed, 04 Jan 2023, Ard Biesheuvel wrote:
> 
> > On Wed, 4 Jan 2023 at 11:40, Lee Jones <lee@kernel.org> wrote:
> > >
> > > On Mon, 05 Dec 2022, Ard Biesheuvel wrote:
> > >
> > > > With the introduction of PRMT in the ACPI subsystem, the EFI rts
> > > > workqueue is no longer the only caller of efi_call_virt_pointer() in the
> > > > kernel. This means the EFI runtime services lock is no longer sufficient
> > > > to manage concurrent calls into firmware, but also that firmware calls
> > > > may occur that are not marshalled via the workqueue mechanism, but
> > > > originate directly from the caller context.
> > > >
> > > > For added robustness, and to ensure that the runtime services have 8 KiB
> > > > of stack space available as per the EFI spec, introduce a spinlock
> > > > protected EFI runtime stack of 8 KiB, where the spinlock also ensures
> > > > serialization between the EFI rts workqueue (which itself serializes EFI
> > > > runtime calls) and other callers of efi_call_virt_pointer().
> > > >
> > > > While at it, use the stack pivot to avoid reloading the shadow call
> > > > stack pointer from the ordinary stack, as doing so could produce a
> > > > gadget to defeat it.
> > > >
> > > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > ---
> > > >  arch/arm64/include/asm/efi.h       |  3 +++
> > > >  arch/arm64/kernel/efi-rt-wrapper.S | 13 +++++++++-
> > > >  arch/arm64/kernel/efi.c            | 25 ++++++++++++++++++++
> > > >  3 files changed, 40 insertions(+), 1 deletion(-)
> > >
> > > Could we have this in Stable please?
> > >
> > > Upstream commit: ff7a167961d1b ("arm64: efi: Execute runtime services from a dedicated stack")
> > >
> > > Ard, do we need Patch 2 as well, or can this be applied on its own?
> > >
> > 
> > Thanks for the reminder.
> > 
> > Only patch #1 is needed. It should be applied to v5.10 and later.
> 
> Perfect, thanks Ard.

Now queued up, thanks.

greg k-h
