Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAD112EB2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbfLDPkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:40:00 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:43878 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbfLDPj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 10:39:58 -0500
Received: by mail-pj1-f65.google.com with SMTP id g4so3130878pjs.10;
        Wed, 04 Dec 2019 07:39:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j0coACmS6cX4bpqEIAC6FvUjz2tQ6QO1d04l0/4uREE=;
        b=lsvY4NBlwKoCDeXexA6iYMQuVyI8QL3dR5wb5XfIcZ6iT8/3F3Jhp7PHA9+e+1T1HB
         sxNCk09kKv0v/wESWOiW0cWzSe/LrJ39i1EIijj0KHoBfDyIaSFu21h1IJn0xpQh/LFe
         YbE7NVwRLwtf13wV37Q2rA1QN+ZmJPgBb6iGtOVKCxWtpuRXauYmxK6CVFBcyiCIFYcZ
         swSgicuzn71hPEZksrEIZYlVK4McHiHKmXi9cePt6/wpjYkcWB1Q3lf1oiZgD3hNyHpu
         q9JAmR0b/Anbt8liGTZSWOEMM6VH5yqh+uiXiD3EsYbXb5T0D4ghVNNtbr521PVZyqEa
         cdvQ==
X-Gm-Message-State: APjAAAVbVzkvA/7gW3r9GFH8j2aKwaj9h05f0zfHmESgleq3TIWHI9jL
        PkMruGTLovbeosp4f60UDfgye6nziwQ=
X-Google-Smtp-Source: APXvYqwRBUMgY8ItWArwVSMxfB0K+ay+Tb4jg30YdZl3x5bC9Mza98iPkCYSeYJjeRVjeVZUkJBwew==
X-Received: by 2002:a17:90a:778a:: with SMTP id v10mr2140503pjk.26.1575473997542;
        Wed, 04 Dec 2019 07:39:57 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id s27sm8748361pfd.88.2019.12.04.07.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 07:39:56 -0800 (PST)
Date:   Wed, 4 Dec 2019 07:40:48 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
Message-ID: <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain>
References: <20191203204933.1642259-1-paulburton@kernel.org>
 <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi David,

On Wed, Dec 04, 2019 at 11:14:08AM +0000, David Laight wrote:
> From: Paul Burton
> > Sent: 03 December 2019 20:50
> > Our FPU emulator currently uses __get_user() & __put_user() to perform
> > emulated loads & stores. This is problematic because __get_user() &
> > __put_user() are only suitable for naturally aligned memory accesses,
> > and the address we're accessing is entirely under the control of
> > userland.
> > 
> > This allows userland to cause a kernel panic by simply performing an
> > unaligned floating point load or store - the kernel will handle the
> > address error exception by attempting to emulate the instruction, and in
> > the process it may generate another address error exception itself.
> > This time the exception is taken with EPC pointing at the kernels FPU
> > emulation code, and we hit a die_if_kernel() in
> > emulate_load_store_insn().
> 
> Won't this be true of almost all code that uses get_user() and put_user()
> (with or without the leading __).

Only if the address being accessed is under the control of userland to
the extent that it can create an unaligned address. You're right that
may be more widespread though; it needs checking...

We used to have separate get_user_unaligned() & put_user_unaligned()
which would suggest that it's expected that get_user() & put_user()
require their accesses be aligned, but they were removed by commit
3170d8d226c2 ("kill {__,}{get,put}_user_unaligned()") in v4.13.

But perhaps we should just take the second AdEL exception & recover via
the fixups table. We definitely don't right now... Needs further
investigation...

> > Fix this up by using __copy_from_user() instead of __get_user() and
> > __copy_to_user() instead of __put_user(). These replacements will handle
> > arbitrary alignment without problems.
> 
> They'll also kill performance.....

Sure they're heavier, but if you're hitting the FPU emulator you're
already slow - trapping to the kernel for instruction emulation is
hardly a hot path. If you care about performance at all then this is
already a code path to avoid at all costs.

Thanks,
    Paul
