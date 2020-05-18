Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790811D8B16
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 00:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgERWkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 18:40:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47395 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727831AbgERWkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 18:40:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589841630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zk6i9dtggpOFkaugjj5c+MXBxvEu5wGUbXo96pP70JY=;
        b=RDlcq7jFqxo7yKmyGOWm4jGSX3UuYOQpdKML5cCJEh1NdSMzVhSMsUlUauB93wwLRhJL7G
        0Qxe3bFIysSPvknAnaYK9rIGjh9v5PeytYae2slH2mCSrnhTDagUSZ78yj2Lr4LyA9WvER
        GGiAd9Om/CWGFpNQ51UhwrJ11WEXnTU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-i9Xn6am6MOymflsaxzkgmw-1; Mon, 18 May 2020 18:40:29 -0400
X-MC-Unique: i9Xn6am6MOymflsaxzkgmw-1
Received: by mail-wr1-f70.google.com with SMTP id p13so5162380wrt.1
        for <stable@vger.kernel.org>; Mon, 18 May 2020 15:40:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zk6i9dtggpOFkaugjj5c+MXBxvEu5wGUbXo96pP70JY=;
        b=HNY0dZOlac1as1AtSUN+Zo+1dtbolJgTpoWOd6b2yX7pjxLZzisNtaIP52376sqEDa
         E2KB6/xPwWA97ns6qK0Blv2ZB+wYEXIjbpC8x+JpRGKKAMsu9yfuVvM5AvJqKmIRk4P9
         6DEYSoVGFI8wfw3TLii4vZkKBe05/2V0dwGg60g+nY745fGJdftaCTp9U2JkrE1nA+Ht
         VmBu0pKL516ziPv5PMe2Ts7HLhU85kQAA/XCDdca1o1YBaKlKjzUxQxXTtpWkFyWn6a7
         eVbbmCnFs7Bp7JGdxzV+0EShmNbuEbgBCswzX0VPDPyybnsq26KYqg8k16WH2goPaLsZ
         DDLQ==
X-Gm-Message-State: AOAM532vN4dC9Mmzqmn6IUODh+L8bAYynYe9rko3VxEQpLXDBxMWlJLj
        6AgYhaTFwOwrHVzYG12Tkn+RzMcrCl9wE70CmqzSqDbOq8hWzaVhLyospr7vzyN/vIPT2k2S8YM
        dB7rYl7xqTnJ08jZq
X-Received: by 2002:a1c:541e:: with SMTP id i30mr1672178wmb.120.1589841627822;
        Mon, 18 May 2020 15:40:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQY8kAtkTYp0bwDBDlqhZOjSveAZMvd9tWu4uC7M+9koEfu2GVNcldVgZco9vgHy07saywwg==
X-Received: by 2002:a1c:541e:: with SMTP id i30mr1672157wmb.120.1589841627542;
        Mon, 18 May 2020 15:40:27 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w82sm1264494wmg.28.2020.05.18.15.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 15:40:26 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: respect singlestep when emulating instruction
To:     Felipe Franciosi <felipe@nutanix.com>
Cc:     kvm@vger.kernel.org, stable@vger.kernel.org
References: <20200518213620.2216-1-felipe@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <babce5c7-16d6-7f46-1fd2-21b4b9bac83c@redhat.com>
Date:   Tue, 19 May 2020 00:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518213620.2216-1-felipe@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18/05/20 23:36, Felipe Franciosi wrote:
>  		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>  			kvm_rip_write(vcpu, ctxt->eip);
> -			if (r && ctxt->tf)
> +			if ((r && ctxt->tf) || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))
>  				r = kvm_vcpu_do_singlestep(vcpu);

Almost:

	if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP))

This is because if r == 0 you have to exit to userspace with KVM_EXIT_MMIO
and KVM_EXIT_IO before completing execution of the instruction.  Once
this is done, you'll get here again and you'll be able to go through
kvm_vcpu_do_singlestep.

Thanks,

Paolo

