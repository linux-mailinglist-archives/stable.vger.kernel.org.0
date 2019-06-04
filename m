Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09ED034A95
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 16:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfFDOlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 10:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727182AbfFDOlJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 10:41:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13429212F5;
        Tue,  4 Jun 2019 14:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559659268;
        bh=qkfK8PkrEXnoH0+ACEoFUpW4f/cD8YPnz/7noPDhtf0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QaKVuwVbxH+ciAL569z6NgFnLJkP31Ruoc6LyTwk56NA/YJhk1cNXHgFYInfmVohf
         D3Vr5alzxYXFCheVrgEWANqIu7+NXhFLOjJ+uALaEpidaF7/quvpXm9CKyRDTct5j+
         Ly/F3BlqyT40R2KegHPTwxDvdNhcUKE5Ws6kFJbU=
Date:   Tue, 4 Jun 2019 16:41:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefan Agner <stefan@agner.ch>
Cc:     stable@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Martin Sebor <msebor@gcc.gnu.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH BACKPORT 4.19 1/2] Compiler Attributes: add support for
 __copy (gcc >= 9)
Message-ID: <20190604144106.GA29518@kroah.com>
References: <20190604132441.15383-1-stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190604132441.15383-1-stefan@agner.ch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 03:24:40PM +0200, Stefan Agner wrote:
> From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> 
> [ Upstream commit c0d9782f5b6d7157635ae2fd782a4b27d55a6013 ]
> 
> >From the GCC manual:
> 
>   copy
>   copy(function)
> 
>     The copy attribute applies the set of attributes with which function
>     has been declared to the declaration of the function to which
>     the attribute is applied. The attribute is designed for libraries
>     that define aliases or function resolvers that are expected
>     to specify the same set of attributes as their targets. The copy
>     attribute can be used with functions, variables, or types. However,
>     the kind of symbol to which the attribute is applied (either
>     function or variable) must match the kind of symbol to which
>     the argument refers. The copy attribute copies only syntactic and
>     semantic attributes but not attributes that affect a symbol’s
>     linkage or visibility such as alias, visibility, or weak.
>     The deprecated attribute is also not copied.
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html
> 
> The upcoming GCC 9 release extends the -Wmissing-attributes warnings
> (enabled by -Wall) to C and aliases: it warns when particular function
> attributes are missing in the aliases but not in their target, e.g.:
> 
>     void __cold f(void) {}
>     void __alias("f") g(void);
> 
> diagnoses:
> 
>     warning: 'g' specifies less restrictive attribute than
>     its target 'f': 'cold' [-Wmissing-attributes]
> 
> Using __copy(f) we can copy the __cold attribute from f to g:
> 
>     void __cold f(void) {}
>     void __copy(f) __alias("f") g(void);
> 
> This attribute is most useful to deal with situations where an alias
> is declared but we don't know the exact attributes the target has.
> 
> For instance, in the kernel, the widely used module_init/exit macros
> define the init/cleanup_module aliases, but those cannot be marked
> always as __init/__exit since some modules do not have their
> functions marked as such.
> 
> Cc: <stable@vger.kernel.org> # 4.14+
> Suggested-by: Martin Sebor <msebor@gcc.gnu.org>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  include/linux/compiler-gcc.h   | 4 ++++
>  include/linux/compiler_types.h | 4 ++++
>  2 files changed, 8 insertions(+)

Thanks for this, and the 4.14 updated series, I've applied them all now.

greg k-h
