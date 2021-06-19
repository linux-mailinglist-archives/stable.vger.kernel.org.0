Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8473AD802
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 08:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhFSGEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Jun 2021 02:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbhFSGEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Jun 2021 02:04:40 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0017C061574;
        Fri, 18 Jun 2021 23:02:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id h1so5786123plt.1;
        Fri, 18 Jun 2021 23:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=6wKXgd/ZhGiTUrwlorOP1aKdH3EvNfTZEGLOVoYRfnA=;
        b=HqTuCzfRgtpxdtQsv5eXBAj6MY60ow4aM/DQATcTOrV/s2Z1lom+u5+UgkGJyFUMrR
         sBm4Hw8mpm1b2NWuVNjV5HlFClau9nEewZt/h5Noo7Rxilij1QenUcYn5TMTv2ep4BZh
         dezXiQiqQdwaClkPIiahsQD+wZr7r1cZzkkO94gYiK7GiRmDf84djWdzNhK6Dgtb4qgY
         OFedJiTkHTSjVlGO0m4koiJ3G1Q/py26GcIKMZ7f2d4P4OipQ7ebZz3xK/obxcf2M4EW
         TENafsgnBHGZNkqqvs4TCdkFQy6vdlx6ZMaNPOSS9IhtgLW2s2dztU5ieTx1F7/KHX/y
         Gsfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=6wKXgd/ZhGiTUrwlorOP1aKdH3EvNfTZEGLOVoYRfnA=;
        b=nnoUKQ1K4qhdtmlbSWTp3pzedw/7Pgmsb6iKAj2ly6Q/0egV+V5QYwllyhmK7/aLJH
         CTG/mZsXfH/un6rImrP83fiUev/S32rMtTfP0K3BX9jDSl97JQpRrH2ahVsySOiG8RDr
         Idtkp26MqyidxBwN3L+Pjy94B5Gl0x7PVfRXw4ZG1GLXrY4rMmQAhw6eGogQPvfGNy2x
         ZS8vitztEQ5f8Vps3c53Tk+do4adpVYic2eXEmI79Hl5LFe9nJWYZs/dhLLOR5Fan8MT
         HKBzV48zlwEuwbR61Y3ahv7xTOCIaeQXWhb3EMJQj/uWFJB/TWSF1bBggwCvvJxnVFP7
         /XGQ==
X-Gm-Message-State: AOAM532To7KAGTq9seqtrjGvGg1UL3GlyvF2WMEkaB9z8ukzqKm7Q3uQ
        GVcgzF7c50HHZgs/9Epb0jM=
X-Google-Smtp-Source: ABdhPJyKMGe6svO1edmje4gRVg+O1L9zIRT6wzOtEKvbi1F4rLOfCjfJ9mjTw5mzRepW9QleX5pgcQ==
X-Received: by 2002:a17:902:b218:b029:11a:bf7b:1a80 with SMTP id t24-20020a170902b218b029011abf7b1a80mr8106460plr.82.1624082548020;
        Fri, 18 Jun 2021 23:02:28 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id s123sm9246118pfb.78.2021.06.18.23.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 23:02:27 -0700 (PDT)
Date:   Sat, 19 Jun 2021 16:02:21 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 8/8] membarrier: Rewrite sync_core_before_usermode() and
 improve documentation
To:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Hansen <dave.hansen@intel.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>
References: <cover.1623813516.git.luto@kernel.org>
        <07a8b963002cb955b7516e61bad19514a3acaa82.1623813516.git.luto@kernel.org>
        <827549827.10547.1623941277868.JavaMail.zimbra@efficios.com>
        <26196903-4aee-33c4-bed8-8bf8c7b46793@kernel.org>
        <593983567.12619.1624033908849.JavaMail.zimbra@efficios.com>
        <1d617df2-57fa-4953-9c75-6de3909a6f14@www.fastmail.com>
        <639092151.13266.1624046981084.JavaMail.zimbra@efficios.com>
In-Reply-To: <639092151.13266.1624046981084.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Message-Id: <1624080924.z61zvzi4cq.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Excerpts from Mathieu Desnoyers's message of June 19, 2021 6:09 am:
> ----- On Jun 18, 2021, at 3:58 PM, Andy Lutomirski luto@kernel.org wrote:
>=20
>> On Fri, Jun 18, 2021, at 9:31 AM, Mathieu Desnoyers wrote:
>>> ----- On Jun 17, 2021, at 8:12 PM, Andy Lutomirski luto@kernel.org wrot=
e:
>>>=20
>>> > On 6/17/21 7:47 AM, Mathieu Desnoyers wrote:
>>> >=20
>>> >> Please change back this #ifndef / #else / #endif within function for
>>> >>=20
>>> >> if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE)) {
>>> >>   ...
>>> >> } else {
>>> >>   ...
>>> >> }
>>> >>=20
>>> >> I don't think mixing up preprocessor and code logic makes it more re=
adable.
>>> >=20
>>> > I agree, but I don't know how to make the result work well.
>>> > membarrier_sync_core_before_usermode() isn't defined in the !IS_ENABL=
ED
>>> > case, so either I need to fake up a definition or use #ifdef.
>>> >=20
>>> > If I faked up a definition, I would want to assert, at build time, th=
at
>>> > it isn't called.  I don't think we can do:
>>> >=20
>>> > static void membarrier_sync_core_before_usermode()
>>> > {
>>> >    BUILD_BUG_IF_REACHABLE();
>>> > }
>>>=20
>>> Let's look at the context here:
>>>=20
>>> static void ipi_sync_core(void *info)
>>> {
>>>     [....]
>>>     membarrier_sync_core_before_usermode()
>>> }
>>>=20
>>> ^ this can be within #ifdef / #endif
>>>=20
>>> static int membarrier_private_expedited(int flags, int cpu_id)
>>> [...]
>>>                if (!IS_ENABLED(CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE))
>>>                         return -EINVAL;
>>>                 if (!(atomic_read(&mm->membarrier_state) &
>>>                       MEMBARRIER_STATE_PRIVATE_EXPEDITED_SYNC_CORE_READ=
Y))
>>>                         return -EPERM;
>>>                 ipi_func =3D ipi_sync_core;
>>>=20
>>> All we need to make the line above work is to define an empty ipi_sync_=
core
>>> function in the #else case after the ipi_sync_core() function definitio=
n.
>>>=20
>>> Or am I missing your point ?
>>=20
>> Maybe?
>>=20
>> My objection is that an empty ipi_sync_core is a lie =E2=80=94 it doesn=
=E2=80=99t sync the core.
>> I would be fine with that if I could have the compiler statically verify=
 that
>> it=E2=80=99s not called, but I=E2=80=99m uncomfortable having it there i=
f the implementation is
>> actively incorrect.
>=20
> I see. Another approach would be to implement a "setter" function to popu=
late
> "ipi_func". That setter function would return -EINVAL in its #ifndef CONF=
IG_ARCH_HAS_MEMBARRIER_SYNC_CORE
> implementation.

I still don't get the problem with my suggestion. Sure the=20
ipi is a "lie", but it doesn't get used. That's how a lot of
ifdef folding works out. E.g.,

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index b5add64d9698..54cb32d064af 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -5,6 +5,15 @@
  * membarrier system call
  */
 #include "sched.h"
+#ifdef CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE
+#include <asm/sync_core.h>
+#else
+static inline void membarrier_sync_core_before_usermode(void)
+{
+	compiletime_assert(0, "architecture does not implement membarrier_sync_co=
re_before_usermode");
+}
+
+#endif
=20
 /*
  * For documentation purposes, here are some membarrier ordering
