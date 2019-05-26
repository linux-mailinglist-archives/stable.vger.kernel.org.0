Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 416D22A8F7
	for <lists+stable@lfdr.de>; Sun, 26 May 2019 09:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfEZHce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 May 2019 03:32:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34746 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfEZHce (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 May 2019 03:32:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id e19so4794358wme.1;
        Sun, 26 May 2019 00:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVuD9ss56U9sjpvXxMwharf1LQEDo1M9zASmKf39Kxc=;
        b=VgeAfWFVOr0qHBa6VhzD0GN+zu2A0bPjA+1k0a1YA5Prod7bgvZ/Xej/Cj+XiGZ7DY
         kunaYdG+VhIDNLFM0Jy8pQypVsjjow9tbmaylB4kECl9vM3D7mkFQcC8DMcsFRfB4rWw
         93dkIhvXixORMnFOs1EF0tVefsc4X+yIgnTO5JVV+XEUNXuMECpX9ImeEBgXf1eBMqdf
         /ULYdtiLHeDOx2h9gEEfYszAEVosODd/5BOCjHV7EmoSTGpRUOqW/Q7UoiQx0ErMkPPF
         dYxG1gXDOV5+v8bGxzoxHPUFAF7nl2O/ps9QJ3xmhH8+D1hDAxqaWQfDxXnhIp/pm2KS
         l7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVuD9ss56U9sjpvXxMwharf1LQEDo1M9zASmKf39Kxc=;
        b=IrnfG6RviiSP4/jCdq6DKQfWmNmjuuWqhNgDCxo4CT7v9qar9VuUP5mp5I7pfwggMG
         LQjf8Lq0k9REWmWAaRzL+7KZfgSllBTffVcL14nUABPTOXLo7K4JIoCthDA1utaEiDDs
         XikMUCwuoj2z9oyib3xYwdxq5iM6pdFc8s2RRiE03lt5y5BsZP7T4/SQOPRKVy/zu/Jk
         31pTUq6xzU8wQiUJSszr4WezDQ08eNtTPhb/2ATaksb7uXqIvCoV+VWb4mbqWST4xnai
         7/9q5Y4IoZlScj9EL9qZzRtLkLM1sGaVJyDpE97j4kow1Q2hgnL6nqm6BS5vSbyGICmx
         zHPw==
X-Gm-Message-State: APjAAAViLIRU18AgePDXFm/Zu+cJNdBnDC2pmgkcdLGrYW+415/nKL0o
        C9EBmcSvguaOuIy36yH4IvjrJRKhIoqc7kH4CKkPl9bi
X-Google-Smtp-Source: APXvYqzm9M8KkLfk/5hX5ZOaMKIyu/5pNqFSW/xUrcHVPcp1Ji/Id0uJb78l351nF6cjuLNGQw+LH1l7WPcPa1JNBWw=
X-Received: by 2002:a1c:80d7:: with SMTP id b206mr22505025wmd.48.1558855951958;
 Sun, 26 May 2019 00:32:31 -0700 (PDT)
MIME-Version: 1.0
References: <CADqhmmcCA_UjV899cHn8SOTSp89BvjMgnd5TcijCWqp6KnhdJw@mail.gmail.com>
 <20190401160629.GA20725@kroah.com> <20190401165853.GA1929@kroah.com>
In-Reply-To: <20190401165853.GA1929@kroah.com>
From:   Evalds Iodzevics <evalds.iodzevics@gmail.com>
Date:   Sun, 26 May 2019 10:32:29 +0300
Message-ID: <CADqhmmeCYNpYpCCG6Y0t+0gxacK-834Bshc+bLmav7ei+Xzx9g@mail.gmail.com>
Subject: Re: missing patch
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, sorry for super long delay i was a little bit busy but i finally
got time to work this out in full.
This applies to 4.4 and 4.9.

Intel requires CPUID eax=1 for microcode operations, microcode
routines use sync_core() for this.
Back in December of 2016 Andy Lutomirski submitted few patches
https://lore.kernel.org/lkml/cover.1481307769.git.luto@kernel.org/

Second patch does not apply to 4.4 and 4.9 as it is revert

Unfortunately only the first one got backported to 4.4 and 4.9 and
broke microcode early loading on 32 bit platforms because it always
jumps past cpuid in sync_core() as data structure boot_cpu_data are
not populated so early in code.

Thanks to Your recent backport of 4167709bbf826512a52ebd6aafda2be104adaec9
the only place that uses sync_core() is
arch/x86/include/microcode_intel.h it should use native_cpuid_eax(1)
as in original Boris submitt.
To make this work we should apply
5dedade6dfa243c130b85d1e4daba6f027805033 witch defines
native_cpuid_eax and others.

As for c198b121b1a1d7a7171770c634cd49191bac4477 i think it is a good
idea to include this as sync_core in present state behaves differently
depending on call time, those compiler warnings can be ignored, on
older compiler they are not generated and this compiles fine. I tested
it on GCC 5.5

On Mon, Apr 1, 2019 at 7:59 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Apr 01, 2019 at 06:06:29PM +0200, Greg KH wrote:
> > On Sat, Mar 30, 2019 at 06:13:16PM +0200, Evalds Iodzevics wrote:
> > > Hi back in the December of 2016 there was commit
> > > "1c52d859cb2d417e7216d3e56bb7fea88444cec9"
> > >
> > > witch was followed shortly by  "c198b121b1a1d7a7171770c634cd49191bac4477"
> > >
> > > Unfortunately only the first commit was later included in long-term kernel
> > > branches such as 4.4 and 4.9 witch left some of microcode functionality
> > > broken on 32 bit systems
> > >
> > > I guess it should be easily fixed by including
> > > "c198b121b1a1d7a7171770c634cd49191bac4477" in those branches
> >
> > Now queued up, thanks!
>
> Hm, no, it causes a bunch of build warnings that look like things are
> about to break:
> arch/x86/kernel/alternative.o: warning: objtool: do_sync_core()+0x1b: unsupported instruction in callable function
> arch/x86/kernel/alternative.o: warning: objtool: text_poke_early()+0x83: unsupported instruction in callable function
> arch/x86/kernel/alternative.o: warning: objtool: apply_alternatives()+0x366: unsupported instruction in callable function
> arch/x86/kernel/alternative.o: warning: objtool: text_poke()+0x196: unsupported instruction in callable function
>
> So I'm going to drop this patch from both trees now.  Can you provide a
> working backported version, or find what else needs to be applied as
> well for this patch?
>
> thanks,
>
> greg k-h
