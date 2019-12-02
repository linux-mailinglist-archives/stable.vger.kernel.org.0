Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2366C10EC16
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 16:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfLBPJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 10:09:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28384 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727446AbfLBPJq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 10:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575299384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JrWTWUHFjaKcgao/Mm9yirqvvQq/ufDoTV+PdlMO1Rs=;
        b=N3tfSKXCcCEI3dSrtk3RmH+Yso9FtWnQmHcUS8UIqWduHUm8zDhcQELMkcfzjC9iXBCMv4
        50lqN4KQv2akM/Pid0tm53LDOffwhbaA9Z96zsFL19VYo7R9zg5UQftlCrDUWiiz7sxAeU
        73+6/01HAn/lpQTY/+wW2yq6qUpqQV8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-ynybHAN0Mw-8FY1sqAUALQ-1; Mon, 02 Dec 2019 10:09:36 -0500
Received: by mail-wm1-f69.google.com with SMTP id p2so3879481wma.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 07:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/8p9Nm2aylmie3h30H/bq+TYA5RUP8AtTYKbK+/M8fY=;
        b=thYLuqXzSUTv03FPoeq7ma6i5GIpC/F5uhysJwnNYAKqQgIHZMFmZPJ11IbHNHel7r
         T9o7yiuMAl0R9du4CwHealKltGMkDo2f+OHko/pkZgg1GorcR/p04EBFNg5XNe1N4iYz
         7ssCAkcKkePSzYSaB6Moc7X7y9hKEwYz30yuWz8v9N4Wuna9gwXbV07IS+Vv9cWM+Jp3
         6g1pPdMRQAQ0A0DSciQMPJuCftGPngPRwnQCD6PM72evJzljud/njXHRNVMeGbE3E9jb
         4s/zdFw+GQlEWBWiPaxl0OG6C9YebPHSUSCyoPL4PWhfpHvImoOloMorrI1v/tCAwlUp
         HzkA==
X-Gm-Message-State: APjAAAVO47o2F6TSzap4C6QMduVdcFI4JD4eG+DPj3pqwkRPLDhLdSkH
        rkYaoCqcAdEhG3Og9HH9Jhs5OPy04JuHjZTIgBXt2DD+g1uYacwfGihHl+LXhGVHqb5rdhNWIRJ
        /6NdBD46vmIr0Yr1J
X-Received: by 2002:a1c:23ca:: with SMTP id j193mr27770524wmj.83.1575299375196;
        Mon, 02 Dec 2019 07:09:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5MjtUvJ0DOIO+/BWPQJSxDGDfVD1QJYwGRyl3C4rXXyDWN3/qdwQ8PAKJviji7XnNbxtIIg==
X-Received: by 2002:a1c:23ca:: with SMTP id j193mr27770474wmj.83.1575299374798;
        Mon, 02 Dec 2019 07:09:34 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id r6sm27242973wrq.92.2019.12.02.07.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Dec 2019 07:09:34 -0800 (PST)
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jack Wang <jack.wang.usish@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
Date:   Mon, 2 Dec 2019 16:09:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202145105.GA571975@kroah.com>
Content-Language: en-US
X-MC-Unique: ynybHAN0Mw-8FY1sqAUALQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/12/19 15:51, Greg Kroah-Hartman wrote:
> On Mon, Dec 02, 2019 at 03:40:04PM +0100, Jack Wang wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> =E4=BA=8E2019=E5=B9=B411=
=E6=9C=8827=E6=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=8810:30=E5=86=99=E9=
=81=93=EF=BC=9A
>>>
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> [ Upstream commit 7671ce21b13b9596163a29f4712cb2451a9b97dc ]
>>>
>>> In preparation of supporting checkpoint/restore for nested state,
>>> commit ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run(=
)")
>>> modified check_vmentry_postreqs() to only perform the guest EFER
>>> consistency checks when nested_run_pending is true.  But, in the
>>> normal nested VMEntry flow, nested_run_pending is only set after
>>> check_vmentry_postreqs(), i.e. the consistency check is being skipped.
>>>
>>> Alternatively, nested_run_pending could be set prior to calling
>>> check_vmentry_postreqs() in nested_vmx_run(), but placing the
>>> consistency checks in nested_vmx_enter_non_root_mode() allows us
>>> to split prepare_vmcs02() and interleave the preparation with
>>> the consistency checks without having to change the call sites
>>> of nested_vmx_enter_non_root_mode().  In other words, the rest
>>> of the consistency check code in nested_vmx_run() will be joining
>>> the postreqs checks in future patches.
>>>
>>> Fixes: ca0bde28f2ed ("kvm: nVMX: Split VMCS checks from nested_vmx_run(=
)")
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Cc: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  arch/x86/kvm/vmx.c | 10 +++-------
>>>  1 file changed, 3 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>> index fe7fdd666f091..bdf019f322117 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -12694,6 +12694,9 @@ static int enter_vmx_non_root_mode(struct kvm_v=
cpu *vcpu, u32 *exit_qual)
>>>         if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_acti=
ve(vcpu))
>>>                 evaluate_pending_interrupts |=3D vmx_has_apicv_interrup=
t(vcpu);
>>>
>>> +       if (from_vmentry && check_vmentry_postreqs(vcpu, vmcs12, exit_q=
ual))
>>> +               return EXIT_REASON_INVALID_STATE;
>>> +
>>>         enter_guest_mode(vcpu);
>>>
>>>         if (!(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)=
)
>>> @@ -12836,13 +12839,6 @@ static int nested_vmx_run(struct kvm_vcpu *vcp=
u, bool launch)
>>>          */
>>>         skip_emulated_instruction(vcpu);
>>>
>>> -       ret =3D check_vmentry_postreqs(vcpu, vmcs12, &exit_qual);
>>> -       if (ret) {
>>> -               nested_vmx_entry_failure(vcpu, vmcs12,
>>> -                                        EXIT_REASON_INVALID_STATE, exi=
t_qual);
>>> -               return 1;
>>> -       }
>>> -
>>>         /*
>>>          * We're finally done with prerequisite checking, and can start=
 with
>>>          * the nested entry.
>>> --
>>> 2.20.1
>>>
>>>
>>>
>> Hi all,
>>
>> This commit caused many kvm-unit-tests regression, cherry-pick
>> following commits from 4.20 fix the regression:
>> d63907dc7dd1 ("KVM: nVMX: rename enter_vmx_non_root_mode to
>> nested_vmx_enter_non_root_mode")
>> a633e41e7362 ("KVM: nVMX: assimilate nested_vmx_entry_failure() into
>> nested_vmx_enter_non_root_mode()")
>=20
> Now queued up, thanks!
>=20
> greg k-h
>=20

Why was it backported anyway?  Can everybody please just stop applying
KVM patches to stable kernels unless CCed to stable@vger.kernel.org?

I thought I had already asked Sasha to opt out of the autoselect
nonsense after catching another bug that would have been introduced.

Paolo

