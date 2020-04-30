Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773BE1C0321
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 18:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD3Qv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 12:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgD3Qv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 12:51:58 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC2DC24957
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588265518;
        bh=Qh9yGfu7EKu8YBjyZn57LidMIeIdE9hqIfI7Nfz5zto=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=QeXgo2HjaR2hNtEE2xocEmx6P0/rGxVCYEXrgl9rxQXjfxBAxyhTRZMcsOv38xXDB
         SgUgZJ1yjS12rsghyc5F04viou3erFd7vznmcrv0rCmjGhRE9hFQvJlks/mkJhEdAx
         HSjH7PPsGNy1kNoKXFogu1GzA1laBKyCY7c+5v4I=
Received: by mail-wm1-f45.google.com with SMTP id u16so2761909wmc.5
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 09:51:57 -0700 (PDT)
X-Gm-Message-State: AGi0PuYLRsVZN9vsAhgbY9geX3q3rbS8Xaos8QRIbZ3IdGjeFxEtqSsx
        PGsN4mhIMgHCpzlck5NP8L1gvAjKG3AXNkixZOawqg==
X-Google-Smtp-Source: APiQypIwzIih6qzG1E5/i+OpsglU4R3LqlrtKcQTjqR7B2k+mg5tCDSXpdynOS/JVqaM9P2DnRTopkyMsvqVuCFJ0bE=
X-Received: by 2002:a1c:23d4:: with SMTP id j203mr4175179wmj.49.1588265515945;
 Thu, 30 Apr 2020 09:51:55 -0700 (PDT)
MIME-Version: 1.0
References: <158823509800.2094061.9683997333958344535.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
In-Reply-To: <CAHk-=wh6d59KAG_6t+NrCLBz-i0OUSJrqurric=m0ZG850Ddkw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 30 Apr 2020 09:51:44 -0700
X-Gmail-Original-Message-ID: <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
Message-ID: <CALCETrVP5k25yCfknEPJm=XX0or4o2b2mnzmevnVHGNLNOXJ2g@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 30, 2020 at 7:03 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 30, 2020 at 1:41 AM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > With the above realizations the name "mcsafe" is no longer accurate and
> > copy_safe() is proposed as its replacement. x86 grows a copy_safe_fast()
> > implementation as a default implementation that is independent of
> > detecting the presence of x86-MCA.
>
> How is this then different from "probe_kernel_read()" and
> "probe_kernel_write()"? Other than the obvious "it does it for both
> reads and writes"?
>
> IOW, wouldn't it be sensible to try to match the naming and try to
> find some unified model for all these things?
>
> "probe_kernel_copy()"?

I don't like this whole concept.

If I'm going to copy from memory that might be bad but is at least a
valid pointer, I want a function to do this.  If I'm going to copy
from memory that might be entirely bogus, that's a different
operation.  In other words, if I'm writing e.g. filesystem that is
touching get_user_pages()'d persistent memory, I don't want to panic
if the memory fails, but I do want at least a very loud warning if I
follow a wild pointer.

So I think that probe_kernel_copy() is not a valid replacement for
memcpy_mcsafe().

--Andy
