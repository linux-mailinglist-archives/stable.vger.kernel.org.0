Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5670C339E4F
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 14:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhCMNdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 08:33:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:55974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233581AbhCMNc3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Mar 2021 08:32:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4416C64EF6;
        Sat, 13 Mar 2021 13:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615642348;
        bh=BfoIJX46zNdUXpRN4acNSjSTni43ysY3KsIeFa45XQw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o6KG9lgKj3BTmDZbPBZKmVgbtVz4ImuHHkZTloBYfNLfl03seE7sMfmiTUpQr7Lba
         q+YymWf7S4J32wIM3a1B3S5DEsTTvUlmQpoXimh191joCZ/fDixZsG+P+ESHjEzszq
         TK8ad4re3Gb3zhBYxYWllJD3p3GOiyUw/S+o4Zps=
Date:   Sat, 13 Mar 2021 14:32:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manoj Gupta <manojgupta@google.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        clang-built-linux@googlegroups.com, ndesaulniers@google.com,
        jiancai@google.com, dianders@google.com, llozano@google.com,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] scripts/recordmcount.{c,pl}: support
 -ffunction-sections .text.* section names
Message-ID: <YEy+6nDgy+ARup/y@kroah.com>
References: <CAH=QcsjHmWdLU6u-imNYWU2v=9ieP8bOk22FLERUd+rVUeqZNw@mail.gmail.com>
 <20210312221749.1248947-1-manojgupta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312221749.1248947-1-manojgupta@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 02:17:49PM -0800, Manoj Gupta wrote:
> From: Joe Lawrence <joe.lawrence@redhat.com>
> 
> commit 9c8e2f6d3d361439cc6744a094f1c15681b55269 upstream.
> 
> When building with -ffunction-sections, the compiler will place each
> function into its own ELF section, prefixed with ".text".  For example,
> a simple test module with functions test_module_do_work() and
> test_module_wq_func():
> 
>   % objdump --section-headers test_module.o | awk '/\.text/{print $2}'
>   .text
>   .text.test_module_do_work
>   .text.test_module_wq_func
>   .init.text
>   .exit.text
> 
> Adjust the recordmcount scripts to look for ".text" as a section name
> prefix.  This will ensure that those functions will be included in the
> __mcount_loc relocations:
> 
>   % objdump --reloc --section __mcount_loc test_module.o
>   OFFSET           TYPE              VALUE
>   0000000000000000 R_X86_64_64       .text.test_module_do_work
>   0000000000000008 R_X86_64_64       .text.test_module_wq_func
>   0000000000000010 R_X86_64_64       .init.text
> 
> Link: http://lkml.kernel.org/r/1542745158-25392-2-git-send-email-joe.lawrence@redhat.com
> 
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> 
> [Manoj: Resolve conflict on 4.4.y/4.9.y because of missing 42c269c88dc1]
> Signed-off-by: Manoj Gupta <manojgupta@google.com>
> ---
> 
> Changes v1 -> v2:
>   Change "nc" to "Manoj"

Now queued up, thanks.

greg k-h
