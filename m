Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427E11C0B3A
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 02:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbgEAAXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 20:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726384AbgEAAXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 20:23:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F99C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:23:34 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c21so3047162plz.4
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 17:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=q6XSSbORtzdGM5wsbVVdblLZLp4drz8TDfwttIDJ1z4=;
        b=r4d1DSiLI7OzhNnrgDQYPizLp5Uolgf7Mc7ZMXQsfzXIivOBc1mAMesjCUhkWWIi2y
         yex588qrp8KlVr1SuLZUCj9OssMwY+aaAfCKjy+x9+JfSDfBS1Y/gdhgJEH3q8iiqNex
         iDvrz7IM41lpzKYWJEv4iBMdnX7oCb0T30GM+GIC5l5Y9epnFFE69w6a4yfNUb5zdep1
         faAEeWjW4wlEC6m2J+TuNWxWVWiWbHwVnhwmwehvckJUO9vNL5ReuvTC8nMM66+/SQYe
         QSm0RTZ8YdH0IZK2Jqm+j2sNapESRzuwTfkfqlKsYv8m5cvyFuWu8KPZsccCLJzeSRtV
         DVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=q6XSSbORtzdGM5wsbVVdblLZLp4drz8TDfwttIDJ1z4=;
        b=i9DW6X+we3D0rVmksTcnwG24EaAXUBPl1LFXNKBe89LottDh7R8bk6j4Z/FIjTHzLV
         /qRhxVARB6QGJgpNR1vQsyo5obXTGsLNxSVoqJIuc3aQ6y7hOJ1Q8Hy7HOGixJlD2SCX
         BeYqA+amsHThbMQP2JvQcOuqpbWMEl65g9GgWc5yVXyMwSJwty1YfGJvIeXJElJQ2nG/
         YcvLv+v876RJ0AngFv2jYAYT/A40/CjC8764Ghdax7xzrXFJFJjFH4HjJOrdzFGTS5/A
         vY7PNdThAWw5wwzmp1/myXyZDFNbGt39RlBKvwUbSwK+V2XTM/urGCWvLy5DfWWXUE+G
         NViw==
X-Gm-Message-State: AGi0PuZjc1NhGU/yTgk3ovG5fOjxgvLus2gSxsfdZbtSx+5dDBO9bUrV
        sJ9vLJZN+SFnHxihQPtWwlv4qg==
X-Google-Smtp-Source: APiQypJVozuXgtmFv1oxaxiVxd1C0J2JT+J68tf0qsuERm2lt0FgWE/aW2WqeSKKnq7hUTr7lXX6cQ==
X-Received: by 2002:a17:90a:fe06:: with SMTP id ck6mr1694160pjb.4.1588292614361;
        Thu, 30 Apr 2020 17:23:34 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:d495:581b:d692:e814? ([2601:646:c200:1ef2:d495:581b:d692:e814])
        by smtp.gmail.com with ESMTPSA id c2sm781538pfp.118.2020.04.30.17.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 17:23:33 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v2 0/2] Replace and improve "mcsafe" with copy_safe()
Date:   Thu, 30 Apr 2020 17:23:31 -0700
Message-Id: <1962EE67-8AD1-409D-963A-4F1E1AB3B865@amacapital.net>
References: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@alien8.de>,
        stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Erwin Tsaur <erwin.tsaur@intel.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CAHk-=wiMs=A90np0Hv5WjHY8HXQWpgtuq-xrrJvyk7_pNB4meg@mail.gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: iPhone Mail (17E262)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On Apr 30, 2020, at 5:10 PM, Linus Torvalds <torvalds@linux-foundation.org=
> wrote:
>=20
> =EF=BB=BFOn Thu, Apr 30, 2020 at 4:52 PM Dan Williams <dan.j.williams@inte=
l.com> wrote:
>>=20
>> You had me until here. Up to this point I was grokking that Andy's
>> "_fallible" suggestion does help explain better than "_safe", because
>> the copy is doing extra safety checks. copy_to_user() and
>> copy_to_user_fallible() mean *something* where copy_to_user_safe()
>> does not.
>=20
> It's a horrible word, btw. The word doesn't actually mean what Andy
> means it to mean. "fallible" means "can make mistakes", not "can
> fault".
>=20
> So "fallible" is a horrible name.

What I was trying to get at was not =E2=80=9Ccan fault=E2=80=9D but =E2=80=9C=
can malfunction=E2=80=9D.  Maybe =E2=80=9Cunreliable=E2=80=9D?  Better words=
 welcome.

>=20
> But anyway, I don't hate something like "copy_to_user_fallible()"
> conceptually. The naming needs to be fixed, in that "user" can always
> take a fault, so it's the _source_ that can fault, not the "user"
> part.

I don=E2=80=99t like this.  =E2=80=9Cuser=E2=80=9D already implied that basi=
cally anything can be wrong with the memory =E2=80=94 it can be unmapped ent=
irely, it can have the wrong permissions, it can have the wrong protection k=
ey, it can have an ECC error, etc.  If the operation you want is =E2=80=9Cco=
py from unreliable kernel memory (but with a definitely valid pointer) to us=
er memory=E2=80=9D, you want copy_unreliable_to_user().

Now maybe copy_to_user() should *always* work this way, but I=E2=80=99m not c=
onvinced. Certainly put_user() shouldn=E2=80=99t =E2=80=94 the result wouldn=
=E2=80=99t even be well defined. And I=E2=80=99m unconvinced that it makes m=
uch sense for the majority of copy_to_user() callers that are also directly a=
ccessing the source structure.

I also tend to think that the probe_kernel stuff should just stay separate. T=
hose are really for two totally separate types of use: either the kernel is t=
rying its best to print an errr message without exploding worse, or it=E2=80=
=99s involved in eBPF or trading hacks in which address is arbitrary and ess=
entially untrusted.
