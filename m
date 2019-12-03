Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EC610FE17
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 13:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLCMwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 07:52:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39293 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725957AbfLCMwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 07:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575377571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTqB+4QR8u3g4v2ElB77IyAVy/qzh6SU7ndV5uNvdN4=;
        b=aG5VpbAJFVVBaVuJvg5SoOFJEpEAcjt6eVk2lA9IdP1bwGYBfY8Gp6YGxytzqm8jSvqX5y
        I5xcfdjn7aNe46Ddx9zRtxRAzr1ta4nUiXIZY25h8jElmIY/vIvPuqPspLq8dCQmien7CG
        ufQwJEJ8IpICwAZp4u42h8eMjjN3n+E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-ed5u9Sq9O5WickkGsYn4Mg-1; Tue, 03 Dec 2019 07:52:50 -0500
Received: by mail-wr1-f71.google.com with SMTP id v17so1713433wrm.17
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 04:52:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MTqB+4QR8u3g4v2ElB77IyAVy/qzh6SU7ndV5uNvdN4=;
        b=Qs0iUs/HGUAV5pE2qdxwMjFaL1C+lGx6SIuAxdeMHMn/tweO3W8j0pV8UUZ7BF/Pz3
         YnHFPbXDZBGHushBFksKUX2wgaREPw1lywGEg18khI3vaEaThHxm5mso3BTVVNeOZKvv
         +HHg+VhognZkickfSdi2DLXewwzhgfpgpcJJ4JI6UW+wp+xG2u4k28P+ppDWBQrY9OrC
         J5Pom/KZo6znDCEcr09gtbZAvB3QcrP0HBHfpmlkU9LTxKpiQ1SR3caqTrxc0jgzT8QT
         eyjd0ASLFKI5XjVyTYQYDVlzR5TjXupVwwLZPP0cDDnIXd1QUeJqAIHbc2Kia2TQg4qm
         FJhA==
X-Gm-Message-State: APjAAAVrKmRw+P9U1hSZ9t3uCAYWvsDP+nrKRrqy7D77+26/Ep9aQ2CJ
        hmrDu38ULRCVO7NMp/gd7sa5m1k5Bw21YmwMoslX+CDq0H2EjDR1LOaaOTqrtmSzIps5uvsf4Sk
        D4SDFFr+eZk9QxKy6
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr35371963wmh.81.1575377569323;
        Tue, 03 Dec 2019 04:52:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxuG/MzWGc0GLmRFw8mZJqm66Z6M/JIS/M9I4FOTLfG1kHTMo+mfnl2not3mYUB0iyaWmnhXQ==
X-Received: by 2002:a7b:cc13:: with SMTP id f19mr35371943wmh.81.1575377569095;
        Tue, 03 Dec 2019 04:52:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id l7sm3438356wrq.61.2019.12.03.04.52.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 04:52:48 -0800 (PST)
Subject: Re: [PATCH 4.19 067/306] KVM: nVMX: move check_vmentry_postreqs()
 call to nested_vmx_enter_non_root_mode()
To:     Jack Wang <jack.wang.usish@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1387d9b8-0e08-a22e-6dd1-4b7ea58567b3@redhat.com>
Date:   Tue, 3 Dec 2019 13:52:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CA+res+Qo1mX_UFEqDD+sm80PZeW4bRN8VZeNudMDaQ=5-Ss=0g@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: ed5u9Sq9O5WickkGsYn4Mg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/12/19 13:27, Jack Wang wrote:
>>> Should we simply revert the patch, maybe also
>>> 9fe573d539a8 ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
>>>
>>> Both of them are from one big patchset:
>>> https://patchwork.kernel.org/cover/10616179/
>>>
>>> Revert both patches recover the regression I see on kvm-unit-tests.
>> Greg already included the patches that the bot missed, so it's okay.
>>
>> Paolo
>>
> Sorry, I think I gave wrong information initially, it's 9fe573d539a8
> ("KVM: nVMX: reset cache/shadows when switching loaded VMCS")
> which caused regression.
> 
> Should we revert or there's following up fix we should backport?

Hmm, let's revert all four.  This one, the two follow-ups and 9fe573d539a8.

Paolo

