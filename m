Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C070519FF59
	for <lists+stable@lfdr.de>; Mon,  6 Apr 2020 22:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDFUme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 16:42:34 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43597 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgDFUmd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Apr 2020 16:42:33 -0400
Received: by mail-pg1-f194.google.com with SMTP id s4so572694pgk.10
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 13:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=KpXibZi6Btj16gC41T+0t49MWAlKN4EvW+f2e9BTI4M=;
        b=LPFZgf7glUE3tmytdqro5zcHhKLNIL7cB2vz7+vhw9o6W1eS0loavqe6Asm9/A5mzn
         qHWtSWUDie4Py9vlLNvLGoVOyvNbW50/2lHTv1a7zTqIsEar9IzSwffDfQq8zgtPbNs4
         707ZeUPKaetLr05mg7Moz908MXLOLjWebdhYuo0okHeY1wGHECeJGHURWe7Lsc3gf+lz
         a3G1PfG6z0SNmxx1nlcVwjXWCTb5QS/oejP7HKYXsnr8xQRADm1IETEd7R7NCB4/EI2C
         FE5Hi1nMcwP8WjJN0Pu5hU2FVQ71GmuhFjxd/9X0WDmVaaf1lDJODo3O3KHQvCm6oQX2
         J2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=KpXibZi6Btj16gC41T+0t49MWAlKN4EvW+f2e9BTI4M=;
        b=alCwmK4RGVBmJqxOXJIqvv72utMQ+/WVJPvCRrghhFPyZfdYue/UbVVB4JaZyINcpZ
         A3YztXfLHM9lOO1k64GKUqAoAYJzn72xt4R0BMfEn2flwbNi5PwK8Gkyuw0Mo34zr0n5
         wAkoUHJGV1VO7SVPvAA3NLU3r/MpxQFf6eqvT6kRDwLJuzemYqDNm1QQKAFiPbcDGYYN
         hVyI3MiyadiTpcoiZjVp0SHw3rUwjxLGh/060zBFOm0J+ulryTuLbAup4BVYoTObjflf
         GCgY2dslBwWCQmWs92fgmZqp0cZMji/hPzpDS00O8SzlpPNWQil17ZZZAlRkeEzdbkar
         VrJg==
X-Gm-Message-State: AGi0PuahyUxFukvK0W0VelSG1HdqwrnDbEYhh6u0R81M6fO+dYXd+Cqi
        lXKBAUy/17dizW36YTdMgd+o+cNiFbQ=
X-Google-Smtp-Source: APiQypJTOnZGfKSNw8aBJNQMWCDma2FyfW6+gOjVB4KO5f8w+l6IhGAPbXAcPGrJ0kxbxmQBNcqH+A==
X-Received: by 2002:aa7:96c8:: with SMTP id h8mr1243020pfq.49.1586205751040;
        Mon, 06 Apr 2020 13:42:31 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:54d3:a29c:f391:9a0d? ([2601:646:c200:1ef2:54d3:a29c:f391:9a0d])
        by smtp.gmail.com with ESMTPSA id r13sm1562176pgj.9.2020.04.06.13.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 13:42:30 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
Date:   Mon, 6 Apr 2020 13:42:28 -0700
Message-Id: <FFD7EE84-05FB-46E4-8CA5-18DD49081B5B@amacapital.net>
References: <6875DD55-2408-4216-B32A-9487A4FDEFD8@amacapital.net>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
In-Reply-To: <6875DD55-2408-4216-B32A-9487A4FDEFD8@amacapital.net>
To:     Peter Zijlstra <peterz@infradead.org>
X-Mailer: iPhone Mail (17E255)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Apr 6, 2020, at 1:32 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>=20
> =EF=BB=BF
>> On Apr 6, 2020, at 1:25 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>=20
>> =EF=BB=BFOn Mon, Apr 06, 2020 at 03:09:51PM -0400, Vivek Goyal wrote:
>>>> On Mon, Mar 09, 2020 at 09:22:15PM +0100, Peter Zijlstra wrote:
>>>>> On Mon, Mar 09, 2020 at 08:05:18PM +0100, Thomas Gleixner wrote:
>>>>>> Andy Lutomirski <luto@kernel.org> writes:
>>>>>=20
>>>>>>> I'm okay with the save/restore dance, I guess.  It's just yet more
>>>>>>> entry crud to deal with architecture nastiness, except that this
>>>>>>> nastiness is 100% software and isn't Intel/AMD's fault.
>>>>>>=20
>>>>>> And we can do it in C and don't have to fiddle with it in the ASM
>>>>>> maze.
>>>>>=20
>>>>> Right; I'd still love to kill KVM_ASYNC_PF_SEND_ALWAYS though, even if=

>>>>> we do the save/restore in do_nmi(). That is some wild brain melt. Also=
,
>>>>> AFAIK none of the distros are actually shipping a PREEMPT=3Dy kernel
>>>>> anyway, so killing it shouldn't matter much.
>>>=20
>>> It will be nice if we can retain KVM_ASYNC_PF_SEND_ALWAYS. I have anothe=
r
>>> use case outside CONFIG_PREEMPT.
>>>=20
>>> I am trying to extend async pf interface to also report page fault error=
s
>>> to the guest.
>>=20
>> Then please start over and design a sane ParaVirt Fault interface. The
>> current one is utter crap.
>=20
> Agreed. Don=E2=80=99t extend the current mechanism. Replace it.
>=20
> I would be happy to review a replacement. I=E2=80=99m not really excited t=
o review an extension of the current mess.  The current thing is barely, if a=
t all, correct.

I read your patch. It cannot possibly be correct.  You need to decide what h=
appens if you get a memory failure when guest interrupts are off. If this ha=
ppens, you can=E2=80=99t send #PF, but you also can=E2=80=99t just swallow t=
he error. The existing APF code is so messy that it=E2=80=99s not at all obv=
ious what your code ends up doing, but I=E2=80=99m pretty sure it doesn=E2=80=
=99t do anything sensible, especially since the ABI doesn=E2=80=99t have a s=
ensible option.

I think you should inject MCE and coordinate with Tony Luck to make it sane.=
 And, in the special case that the new improved async PF mechanism is enable=
d *and* interrupts are on, you can skip the MCE and instead inject a new imp=
roved APF.

But, as it stands, I will NAK any guest code that tries to make #PF handle m=
emory failure. Sorry, it=E2=80=99s just too messy to actually analyze all th=
e cases.=
