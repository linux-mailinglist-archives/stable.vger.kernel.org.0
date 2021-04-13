Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E288D35DE46
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhDMMK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 08:10:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47459 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231194AbhDMMK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 08:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618315808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IejbyFfCDRcQHvrp95I002DIsHzvqj1xPZXqmhdrA0w=;
        b=KNNvM7UagoEEMvxSGPFVUVAx6iSRUBkSUeYKERY5AvpDzGzoPYm1sCsy/+umhKHm4LurtB
        4y95VtjQbTkjNwqzH7Mb5QEFg+yYsxdFQ09Gc3OyRfFAxAxkk3rKp1eMsiyeOkmwVfsCnP
        FWJbEbqP042UKZNh3dFot309eGZHelY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-2NsTvvrWPdS-Tb0HmhV3lA-1; Tue, 13 Apr 2021 08:10:06 -0400
X-MC-Unique: 2NsTvvrWPdS-Tb0HmhV3lA-1
Received: by mail-ej1-f72.google.com with SMTP id zj19so2061523ejb.22
        for <stable@vger.kernel.org>; Tue, 13 Apr 2021 05:10:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IejbyFfCDRcQHvrp95I002DIsHzvqj1xPZXqmhdrA0w=;
        b=gWUN8qcFIw/scr+KFTnBvNsF6joTIgyzx+MlGwlQA71iIbYp7O1yg/Pi77PdXtWOWV
         5V5oH1dL8cOdsiTm42TI9cGfRB3pMi25FIFa39ScJ9ZF3BDP2PeHjpFCvejuE1DRwJaa
         O6a8fGHa0MNQrIcs9+ZwVIhNdhMlUl25JFzuHF8FdbfJhaixs5EcC2IGcNHm/I8+M/58
         Ice/KHbzxTHQqZwDwfveisfvoJl8owwTlu5vqFxyuaf33uJB378JFP19Q0s2NhCT4bri
         BcKKxd6L4deCQydIaf3dd7cGJtFUfCwlU93SADHqBAdZh/YdU/zYtiV9os3b4PxyMq1t
         wAJQ==
X-Gm-Message-State: AOAM5328qVTuljQ7MGFPYr/A3B1F9+LUE9KFcfMaPVoyiCiaV9pPiZ+4
        tqWi/h3huTRzquuQ+ENLUFdaj+WiGzWFlNc3zP4kNv4Q4uplGSFJABzjzKQzVHoMKuEXPkfEIi1
        whEroshiMHWYcUPI6
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr33763385edw.118.1618315805188;
        Tue, 13 Apr 2021 05:10:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycmV2QAbm9DlXfnBjiF9ZhAdQwdu4MVStSRMH+QxWL7LXWAF2rJqHbnqsSyAdHn0tU18Kjeg==
X-Received: by 2002:a05:6402:4d1:: with SMTP id n17mr33763368edw.118.1618315805046;
        Tue, 13 Apr 2021 05:10:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r17sm9327924edt.70.2021.04.13.05.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 05:10:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: x86: Fix split-irqchip vs interrupt injection
 window request
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai+lkml@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Filippo Sironi <sironi@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        "v4.7+" <stable@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
References: <20201127112114.3219360-1-pbonzini@redhat.com>
 <20201127112114.3219360-3-pbonzini@redhat.com>
 <CAJhGHyCdqgtvK98_KieG-8MUfg1Jghd+H99q+FkgL0ZuqnvuAw@mail.gmail.com>
 <YHS/BxMiO6I1VOEY@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a9e11b1-9cd6-b9a4-d9ea-f2f4d0983084@redhat.com>
Date:   Tue, 13 Apr 2021 14:10:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YHS/BxMiO6I1VOEY@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/04/21 23:43, Sean Christopherson wrote:
> where kvm_arch_interrupt_allowed() checks EFLAGS.IF (and an edge case related to
> nested virtualization).  KVM also captures EFLAGS.IF in vcpu->run->if_flag.
> For whatever reason, QEMU checks both vcpu->run flags before injecting an IRQ,
> maybe to handle a case where QEMU itself clears EFLAGS.IF?

It's mostly obsolete code (that will be deprecated in the next version 
and removed in about a year) so I wouldn't read much into it.  if_flag 
itself is obsolete; it is not provided by SEV-ES, and a useless subset 
of ready_for_interrupt_injection.

Paolo

