Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196E349DAA
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 11:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729369AbfFRJna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 05:43:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45716 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfFRJna (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 05:43:30 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so13128158wre.12
        for <stable@vger.kernel.org>; Tue, 18 Jun 2019 02:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7H+CZItQJTM8gOKdEIO6tgbmZC/1DVL8U5ona3SCpCI=;
        b=JYSw0J9LwR9z1olZKP5pOeo7gFsg4wsGqQREgLv5uujdwMQZ13dKmnktQmUj90br2A
         T9+kD4Vo6jJyl+J+sozpDSDFhpphseGt0xai/5Iau93K3Uf8oCND7+ET85vP6B3fIj+u
         6VllquoAFFbhn3DuvR8cZIfHzlq1sWeJFRGnmUvFaA/6RiYmS0gYpzU3WTfOBukcKlDm
         Sh8bInk0jBsRM29bVMSSY2RJQT8UnMV6w/Vq6ZUtRZO3oHaUWUuHiD5ed6Q5nvCen9t3
         qiABAOJVxmrIjA9KzjCWEm8vM+MhBi8vEffEyXNoIhU0EkUZ0O5QPRf+ErPUIVPDDoB8
         vkYg==
X-Gm-Message-State: APjAAAWbQe6Q1MeNOxyuKE5CzU7vQ2fhbcjKTwBeNCl73H3DwdXCUmQB
        mLARC/eBEF9/YxDFxYaywyjAN9/rqKg=
X-Google-Smtp-Source: APXvYqx1u72NgLWUSb0cmYjIEFnfvl7lohvWUsuD8u7IfbzZrWhSU9lechEAXsHLnsuA/1rkasQ/sQ==
X-Received: by 2002:adf:ff84:: with SMTP id j4mr2988875wrr.71.1560851007943;
        Tue, 18 Jun 2019 02:43:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1da0:213e:1763:a1a8? ([2001:b07:6468:f312:1da0:213e:1763:a1a8])
        by smtp.gmail.com with ESMTPSA id x8sm1752029wmc.5.2019.06.18.02.43.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 02:43:27 -0700 (PDT)
Subject: Re: [PATCH 22/43] KVM: nVMX: Don't dump VMCS if virtual APIC page
 can't be mapped
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, stable@vger.kernel.org
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
 <1560445409-17363-23-git-send-email-pbonzini@redhat.com>
 <20190617191724.GA26860@flask> <20190617200700.GA30158@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d59375c-9313-d31a-4af9-d68115e05d55@redhat.com>
Date:   Tue, 18 Jun 2019 11:43:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190617200700.GA30158@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 17/06/19 22:07, Sean Christopherson wrote:
> On Mon, Jun 17, 2019 at 09:17:24PM +0200, Radim Krčmář wrote:
>> 2019-06-13 19:03+0200, Paolo Bonzini:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> ... as a malicious userspace can run a toy guest to generate invalid
>>> virtual-APIC page addresses in L1, i.e. flood the kernel log with error
>>> messages.
>>>
>>> Fixes: 690908104e39d ("KVM: nVMX: allow tests to use bad virtual-APIC page address")
>>> Cc: stable@vger.kernel.org
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> ---
>>
>> Makes me wonder why it looks like this in kvm/queue. :)
> 
> Presumably something is wonky in Paolo's workflow, this happened before.

It's more my non-workflow... when I cannot find a patch for some reason
(deleted by mistake, eaten by Gmane, etc.), I search it with Google and
sometimes spinics.net comes up which mangles the domain.  I should just
subscribe to kvm@vger.kernel.org since Gmane has gotten less reliable,
or set up a Patchew instance for it.

Paolo
