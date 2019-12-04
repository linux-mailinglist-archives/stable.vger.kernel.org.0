Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07051112A62
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 12:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfLDLmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 06:42:14 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45865 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727268AbfLDLmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 06:42:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575459732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gGvj6ScV5HRsAf/wEpebkBxHs1qEjrfPikT5XgQ7RxY=;
        b=dhv6l57PaNXH9kRYVftOlb3wdIf36bUEtp//+XwROxOmO8oWn0W1QcDDZ7iUOTmeV0F7ux
        UQTN2Ayo1/v0GhseqTEWp/EMCsNgoBLI0GzPtUIPEImkOt9qgmKfkxyvJi6JNhhJvCFvgI
        hgf0QDMMKXpiI61SoT1J3IaTmZ/Lvxg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-k8P3BlUwNwOmwROxO1cNiQ-1; Wed, 04 Dec 2019 06:42:09 -0500
Received: by mail-wr1-f71.google.com with SMTP id i9so3523149wru.1
        for <stable@vger.kernel.org>; Wed, 04 Dec 2019 03:42:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGvj6ScV5HRsAf/wEpebkBxHs1qEjrfPikT5XgQ7RxY=;
        b=e2TE3ALGlFKF31/187h7xGQYb+JdpEuOZBIDqvLg4QddH7r7pEKk8KD2r2i6TI1hRM
         4tegkXk5d8XGowbxb8kRBvLbOIRRD7GkWAmqEtbL044P8fP83zbKm6RT9cAx7GxdpabN
         pHkWj7b0kSy9uITqpl7qpsm1Tjp2qbw0GDVd4IOl9vJvQ3juWmIrrmhDAwalKOYLfALt
         BEXLyOgcB40D6XdDp9Y+ej74DBEGSMgejtowNpstwZwBfw2JSfT3XvLGVOTEjwUjcVMk
         I4qJvtWgu76B1/t6e4AH9NJjNbpOoQBnGCkxK1A9CYRLNShAlrRsrHmP6mMe5Qhb5r6D
         QaAA==
X-Gm-Message-State: APjAAAVAivkVfL6112/cGgl62o9kAYrlHcWMUPrdmVxGaf2NLVRJKGjE
        NvEMbYddQXHJ/0O5fNb0YlB4v/R6SXwRjL95SKcg4eTWSJXrgGHbQaBkUV09qUBbJuIy446/svH
        ECF0B0Oggp8+j6Yhi
X-Received: by 2002:adf:f491:: with SMTP id l17mr3457288wro.149.1575459728824;
        Wed, 04 Dec 2019 03:42:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwI3D6OXmuQavmjiI4EUh2AsnPcFg9OYIPq92kRLWefqRekueiLpkOmgD3MwTzX6W+O+gwKyw==
X-Received: by 2002:adf:f491:: with SMTP id l17mr3457258wro.149.1575459728512;
        Wed, 04 Dec 2019 03:42:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id z185sm6583513wmg.20.2019.12.04.03.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:42:07 -0800 (PST)
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jack Wang <jack.wang.usish@gmail.com>,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
References: <20191127203114.766709977@linuxfoundation.org>
 <20191127203119.676489279@linuxfoundation.org>
 <CA+res+QKCAn8PsSgbkqXNAF0Ov5pOkj=732=M5seWj+-JFQOwQ@mail.gmail.com>
 <20191202145105.GA571975@kroah.com>
 <bccbfccd-0e96-29c3-b2ba-2b1800364b08@redhat.com>
 <CA+res+SffBsmmeEBYfoDwyLHvL8nqW+O=ZKedWCxccmQ9X6itA@mail.gmail.com>
 <828cf8b7-11ac-e707-57b6-cb598cc37f1b@redhat.com>
 <CA+res+Qo1mX_UFEqDD+sm80PZeW4bRN8VZeNudMDaQ=5-Ss=0g@mail.gmail.com>
 <1387d9b8-0e08-a22e-6dd1-4b7ea58567b3@redhat.com>
 <20191203191655.GC2734645@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <835e996b-711e-f6fb-a489-db3899c053a2@redhat.com>
Date:   Wed, 4 Dec 2019 12:42:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191203191655.GC2734645@kroah.com>
Content-Language: en-US
X-MC-Unique: k8P3BlUwNwOmwROxO1cNiQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/12/19 20:16, Greg Kroah-Hartman wrote:
> On Tue, Dec 03, 2019 at 01:52:47PM +0100, Paolo Bonzini wrote:
>> On 03/12/19 13:27, Jack Wang wrote:
>>>>> Should we simply revert the patch, maybe also
>>>>> 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
>>>>>
>>>>> Both of them are from one big patchset:
>>>>> https://patchwork.kernel.org/cover/10616179/
>>>>>
>>>>> Revert both patches recover the regression I see on kvm-unit-tests.
>>>> Greg already included the patches that the bot missed, so it's okay.
>>>>
>>>> Paolo
>>>>
>>> Sorry, I think I gave wrong information initially, it's 9fe573d539a8
>>> ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
>>> which caused regression.
>>>
>>> Should we revert or there's following up fix we should backport?
>>
>> Hmm, let's revert all four.  This one, the two follow-ups and 9fe573d539a8.
> 
> 4?  I see three patches here, the 2 follow-up patches that I applied to
> the queue, and the "original" backport of b7031fd40fcc ("KVM: nVMX:
> reset cache/shadows when switching loaded VMCS") which showed up in the
> 4.14.157 and 4.19.87 kernels.

The fourth is commit 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when
switching loaded VMCS"), which was also autoselected.

Paolo

