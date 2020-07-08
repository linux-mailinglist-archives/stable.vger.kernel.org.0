Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD082185A4
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 13:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgGHLKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 07:10:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:38098 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728620AbgGHLKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 07:10:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=14f1mTpd7HVDpOyXYxD6GElv4scdvE+XkzizMQMoy8M=;
        b=JBWuSHlDHc6tlqTDU9X4CaPApIaLAIzczwe7ZqgY0DTzN6hwDHD1nkOVuPcLi+BNNSO5j3
        A9dhUlM5EECF61MS3AXqDzBEvAAKa2Rx5k6lMe4KNLVIws5HzHsrTGqls/AxPx26Y4ygbO
        npScT5N33loz6wqxDRdblYF7+AeUtmA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-EZAncx8mMm6uPqF5pCEM9Q-1; Wed, 08 Jul 2020 07:10:05 -0400
X-MC-Unique: EZAncx8mMm6uPqF5pCEM9Q-1
Received: by mail-wr1-f69.google.com with SMTP id c6so32442007wru.7
        for <stable@vger.kernel.org>; Wed, 08 Jul 2020 04:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=14f1mTpd7HVDpOyXYxD6GElv4scdvE+XkzizMQMoy8M=;
        b=no963VV8ydOEptzcI+UVa9/wrKS68QJhuaMt8Z7OGe07cPKq1qs2d8c9tByFi4TaTK
         qKJDu+HSDW6aBnbar6bLzdJhbJmARrzWzTDMjHTgc0ZLi8oqimmROcGTLVmtaIJ3jhQ+
         sfQub6ezgl/D99muI1bQb73NwNfJfZcCCTaRfzqWF2KO9f3bSl26M0L7A7SHwX6yuXpR
         XS0XqaRLTjowdEFfbb3bopl7ha2r2ZdEDlotYC+Ors6KvPlZnxlhJRc42u9prY+H1rNT
         VdlRjbeqdSFlbF7TfVsSqAjzlBNtSRRiCBoQipYpBV6afjG/pvgkrb9irMeX/wivbla0
         cMzw==
X-Gm-Message-State: AOAM533MgGVRGM70Hq8N/LEJPehHKb/+6Idzt250blJneKum/nTjWIzX
        LMjxsvB9WIbo1egr7U5WNNyowXKW2Bq/3AHcYJvLlT7Q11oTZJg2mCEQlPiSXx0TOJ6nP1XOnCM
        k6xmz1DWwRkrjA0GW
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr54529519wrx.50.1594206604360;
        Wed, 08 Jul 2020 04:10:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyS9IXWXY8AsLX9C3rrryHKZ4q/47XveQNN7O/2+yEMRnuw24+Agts1i9nEHB/Ycwubh37ATw==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr54529504wrx.50.1594206604189;
        Wed, 08 Jul 2020 04:10:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id j6sm5766924wma.25.2020.07.08.04.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:10:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "# v3 . 10+" <stable@vger.kernel.org>
References: <20200417163843.71624-1-pbonzini@redhat.com>
 <20200417163843.71624-2-pbonzini@redhat.com>
 <CANRm+CyWKbSU9FZkGoPx2nff-Se3Qcfn1TXXw8exy-6nuZrirg@mail.gmail.com>
 <57a405b3-6836-83f0-ed97-79f637f7b456@redhat.com>
 <CANRm+CzpFt5SwnQzJjRGp3T_Q=Ws3OWBx4FPmMK79qOx1v3NBQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7507de6a-799e-4f71-012d-ddaa39178284@redhat.com>
Date:   Wed, 8 Jul 2020 13:10:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CzpFt5SwnQzJjRGp3T_Q=Ws3OWBx4FPmMK79qOx1v3NBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/07/20 11:08, Wanpeng Li wrote:
>>>> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>>> This commit incurs the linux guest fails to boot once add --overcommit
>>> cpu-pm=on or not intercept hlt instruction, any thoughts?
>> Can you write a selftest?
> Actually I don't know what's happening here(why not intercept hlt
> instruction has associated with this commit), otherwise, it has
> already been fixed. :)

I don't understand, what has been fixed and where?

Paolo

