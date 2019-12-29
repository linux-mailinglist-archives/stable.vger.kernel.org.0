Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD312CA82
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfL2S7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:59:16 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:37871 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbfL2S7Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 13:59:16 -0500
Received: by mail-pj1-f44.google.com with SMTP id m13so7228435pjb.2;
        Sun, 29 Dec 2019 10:59:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tAjd1uiPZsuPFI/UJM6eJ4os9/hBTboJTt1j2UJRT1M=;
        b=CZARm84kbG98zgPD5UEbtdUgulL4TlM3icq008J2nAAx+xWwAu+V2hFdpFhNXfRidJ
         rkVYLty8+lKTh6WWWjKpTE0wHpdl2Cq0gZdYryQFVmlVKTqviKTVl93wzhZxEZhg2Vu3
         GfQzxGDwgoazbEkXTYmlDmccSvWGP8ataVVjw9xiQ1ApTKVOvbxTed2MrHojaaxH+qIA
         DP4s1B05quEMoVNMVhjOF83ExM3F/7N1OuOyxBSQSmBrrQr/43PXrteGwPULwXmRc7mM
         jQD2QroDMdMEDGNMt52dIEzShskUrMgQX3NQIvAjraxfIWOFBjQtPXGh5L1rtZNL4Nd0
         82Gw==
X-Gm-Message-State: APjAAAWvphhCHwDDYC/yex8bMfGNHoyLznxTp0/QuXRGNEKdfYkMLPO3
        EsgrKaKNqANMvj35WvWeT6c=
X-Google-Smtp-Source: APXvYqwNnq8UfTWxUB2h/uWEnMcyWZc+0Mp6MkMobyfFljo3YKHA1N3Eon4lNDmSua+qHM/hvsx2bw==
X-Received: by 2002:a17:902:8f96:: with SMTP id z22mr62219611plo.11.1577645954756;
        Sun, 29 Dec 2019 10:59:14 -0800 (PST)
Received: from localhost ([2601:646:8a00:9810:5af3:56d9:f882:39d4])
        by smtp.gmail.com with ESMTPSA id v13sm48565741pgc.54.2019.12.29.10.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 10:59:13 -0800 (PST)
Date:   Sun, 29 Dec 2019 11:01:23 -0800
From:   Paul Burton <paulburton@kernel.org>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] MIPS: Use __copy_{to,from}_user() for emulated FP
 loads/stores
Message-ID: <20191229190123.ju24cz7thuvybejs@lantea.localdomain>
References: <20191203204933.1642259-1-paulburton@kernel.org>
 <f5e09155580d417e9dcd07b1c20786ed@AcuMS.aculab.com>
 <20191204154048.eotzglp4rdlx4yzl@lantea.localdomain>
 <e220ba9a19da41abba599b5873afa494@AcuMS.aculab.com>
 <alpine.LFD.2.21.1912260251520.3762799@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.21.1912260251520.3762799@eddie.linux-mips.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Maciej,

On Thu, Dec 26, 2019 at 03:01:06AM +0000, Maciej W. Rozycki wrote:
> On Wed, 4 Dec 2019, David Laight wrote:
> > > We used to have separate get_user_unaligned() & put_user_unaligned()
> > > which would suggest that it's expected that get_user() & put_user()
> > > require their accesses be aligned, but they were removed by commit
> > > 3170d8d226c2 ("kill {__,}{get,put}_user_unaligned()") in v4.13.
> > > 
> > > But perhaps we should just take the second AdEL exception & recover via
> > > the fixups table. We definitely don't right now... Needs further
> > > investigation...
> > 
> > get/put_user can fault because the user page is absent (etc).
> > So there must be code to 'expect' a fault on those instructions.
> 
>  As I recall we only emulate unaligned accesses with a subset of integer 
> load/store instructions (and then only if TIF_FIXADE is set, which is the 
> default), and never with FP load/store instructions.  Consequently I see 
> no point in doing this in the FP emulator either and I think these ought 
> to just send SIGBUS instead.  Otherwise you'll end up with user code that 
> works differently depending on whether the FP hardware is real or 
> emulated, which is really bad.

That might simplify things here, but it's incorrect. I'm fairly certain
the intent is that emulate_load_store_insn() handles all non-FP loads &
stores (though looking at it we're missing some instructions added in
r6). More importantly though we've been emulating FP loads & stores
since v3.10 which introduced the change alongside microMIPS support in
commit 102cedc32a6e ("MIPS: microMIPS: Floating point support."). The
commit contains no description of why, and I'm not aware of any reason
microMIPS specifically would need this so I suspect that commit bundled
this change for no good reason...

It's also worth noting that some hardware will handle unaligned FP
loads/stores, which means having the emulator reject them will result in
more of a visible difference to userland. ie. on some hardware they'll
work just fine, but on some you'd get SIGBUS. So I do think emulating
them makes some sense - just as for non-FP loads & stores it lets
userland not care whether the hardware will handle them, so long as it's
not performance critical code. If we knew that had never been used then
perhaps we could enforce the alignment requirement (and maybe that's
what you recall doing), but since we've been emulating them for the past
6 years it's too late for that now.

Thanks,
    Paul
