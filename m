Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA6D1A320C
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgDIJnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 05:43:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726734AbgDIJnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 05:43:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586425415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nIzy0tnj6FqxJz87TqjmoYX4nTo+jUF+UzNkvXq35po=;
        b=SWVeLr8Mw9d+Vf7DX+yL47ZVmVs7ldLf3IR5TJvD3tWW6DwLTBcSDy8Z+sbENUr8kf4L5F
        qP4fpbim5cqZR1roBqpLZ2UXWnorGBnv1p8iH279YzYOYr6GvZM+te5jip8JR0lhAt6yc7
        XEaKFKKHoYTxBqJmbMWk4zxgMgemuew=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-5oLUFPKtNZm16CRDiNZnWg-1; Thu, 09 Apr 2020 05:43:33 -0400
X-MC-Unique: 5oLUFPKtNZm16CRDiNZnWg-1
Received: by mail-wm1-f70.google.com with SMTP id f81so1660964wmf.2
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 02:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nIzy0tnj6FqxJz87TqjmoYX4nTo+jUF+UzNkvXq35po=;
        b=Af931PGRcpbalVdazvqyTRPYZL4wfFgS1MFdcY0Tn6+3tPA/1CfkEX81taigKRxlL0
         RYSOPl5kERXE2vNpTKNf5lT/Ps4qTWkSigJq6RscZ+YXLmNCzCCn84Loe2mHpVSL4wFW
         jJDZ/VkS+mvn45OKr/HQTYVm/roIrW+K03T3yHP5yUsvMhZXg+9uu6FHIUZ5dFNu1clc
         nQCn/MNjSC+YHHj/OfqPMImpKEddDp87QSGZw4+YmtWIyoPAiCnOTmfnK+qrxkHRNwSU
         JBt1iLwnAEDiURqO1X5II99x/reDQAeGmNYjUwCveHKwVhmsmJLOFPCe33Tzf7iJwm2A
         9kqQ==
X-Gm-Message-State: AGi0PuaDw+SQbQ5ZPZGI1ExemZZEr3oOrMrSrnfzfv0SnhAJ7yekpBdd
        7/CtU4cE9Qw8386+OxldSHECb9/aZWCdnuDQUJlHeCs91rXhxrJnbkR6/5I9YQENNZMsIMiqe5K
        4PAbYBCspyR7xVtKj
X-Received: by 2002:a1c:a7d7:: with SMTP id q206mr5695594wme.45.1586425411856;
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypJgQiZCrWZvCGiHqYLqjts+lmOUoOTw70VVOHDzOH/wMxfRJcVDU494OZ3lliAXWnRamte4kQ==
X-Received: by 2002:a1c:a7d7:: with SMTP id q206mr5695574wme.45.1586425411623;
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bddb:697c:bea8:abc? ([2001:b07:6468:f312:bddb:697c:bea8:abc])
        by smtp.gmail.com with ESMTPSA id g3sm25430861wrw.47.2020.04.09.02.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 02:43:31 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <20200407172140.GB64635@redhat.com>
 <772A564B-3268-49F4-9AEA-CDA648F6131F@amacapital.net>
 <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <ce81c95f-8674-4012-f307-8f32d0e386c2@redhat.com>
 <874ktukhku.fsf@nanos.tec.linutronix.de>
 <274f3d14-08ac-e5cc-0b23-e6e0274796c8@redhat.com>
 <20200408153413.GA11322@linux.intel.com>
 <ce28e893-2ed0-ea6f-6c36-b08bb0d814f2@redhat.com>
 <87d08hc0vz.fsf@nanos.tec.linutronix.de>
 <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <47a7593e-e035-1b48-c6d7-cd6f78a2f6e2@redhat.com>
Date:   Thu, 9 Apr 2020 11:43:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CALCETrWG2Y4SPmVkugqgjZcMfpQiq=YgsYBmWBm1hj_qx3JNVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09/04/20 06:50, Andy Lutomirski wrote:
> The big problem is that #VE doesn't exist on AMD, and I really think
> that any fancy protocol we design should work on AMD.  I have no
> problem with #VE being a nifty optimization to the protocol on Intel,
> but it should *work* without #VE.

Yes and unfortunately AMD does not like to inject a non-existing
exception.  Intel only requires the vector to be <=31, but AMD wants the
vector to correspond to an exception.

However, software injection is always possible and AMD even suggests
that you use software injection for ICEBP and, on older processors, the
INT instruction.

Paolo

