Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71583118362
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 10:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfLJJS7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 04:18:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727198AbfLJJS6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 04:18:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ys5nveUnuHlqyfAjmjcLopzAQQGr7aebD6b5Em3ISs8=;
        b=IWGsGQJ7AWozFF/Amd43B61F+rgl92alDHJ28/dsrpTr7XugNLhmC6QxyXTBbaD/6Y/k2g
        kUaONLZCbV2Nndsh4ok6ab8GfY7uPH5rMM1Kzyy+zl8R61DczU5bCTYNrNvF+fciRfbU/e
        rvwTpLD7XNYHE16B+HM+HbnY275U/HA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-eAEvEJahOueO_VOKsd3sUw-1; Tue, 10 Dec 2019 04:18:55 -0500
Received: by mail-wr1-f72.google.com with SMTP id c17so8638273wrp.10
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 01:18:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ys5nveUnuHlqyfAjmjcLopzAQQGr7aebD6b5Em3ISs8=;
        b=BSPqMzqdmowz3QWXSU4zMylcRGTbwIr7hvB0aS/YjHSL/k8NNt5zKzGFWOK9wNgb1Z
         TPQejgmyRnfFBKxvqzx1KoDgzzig12IYka/YZfKIy0O7m6J65+tObvOCEVlEVk+KPHkE
         NV8YjmgkBhp/0dwoZW0I/yK1pO4rtoQT0iXHUMEQs5vugRD8QfVka42Nx1NMYVsXaYCi
         hk3vkrwAV2ix5W1BDcAxOeSybi5vY2MGz2cnTMuyALmQ/6677jO1k5u2u1Oyi+iAvlbg
         7GgB7vPAL9kMg++kpYD9pwmB2VfQuWvo66axNtJp5RJrupmf+c2sCBVNd4BpvubwKtIg
         hitw==
X-Gm-Message-State: APjAAAWkivWiebRXuGb3avYB9pdryoILoTSK6LUGWCd6vZO14DEnYVvh
        HOoIt32xi1nmmqQaCWBPuPNMl3feI5wtfYQDCU7Z72BzD7XjWrSXysuuwlzQvUNy+3TglQKjoXe
        t9MT85rDB69mkRJOT
X-Received: by 2002:a1c:a750:: with SMTP id q77mr3754383wme.76.1575969533787;
        Tue, 10 Dec 2019 01:18:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqw4nJ+vwaF+bCpT4bALJsG39v2xr4nUwAmxvKVeYBNvjHHX20eM5yfU1XaBY4K1oQQjOdJ04Q==
X-Received: by 2002:a1c:a750:: with SMTP id q77mr3754346wme.76.1575969533563;
        Tue, 10 Dec 2019 01:18:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id r6sm2437618wrq.92.2019.12.10.01.18.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 01:18:53 -0800 (PST)
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     "Huang, Kai" <kai.huang@intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
 <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
 <2f3d8c9b146301183b891d8a441aa4a5c33b4c9d.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c1012d42-6e60-66c9-80ea-f6c26db37172@redhat.com>
Date:   Tue, 10 Dec 2019 10:18:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <2f3d8c9b146301183b891d8a441aa4a5c33b4c9d.camel@intel.com>
Content-Language: en-US
X-MC-Unique: eAEvEJahOueO_VOKsd3sUw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/19 04:53, Huang, Kai wrote:
> Right. Alghouth both MKTME and SME/SEV reduce physical bits, but they treat
> those reduced bits differently: MKTME treats those as keyID thus they can be
> set, but SME/SEV treats those as reserved bits so you cannot set any of them.
> 
> Maybe the naming of shadow_phys_bits is a little bit confusing here. The purpose
> of it was to determine first reserved bits, but not actual physical address bits
> . Therefore for MKTME it should include the keyID bits, but for SME/SEV it
> should not.

Not just the first reserved bit, but _some_ reserved bit such that all
consecutive bits up to bit 51 are reserved.

Paolo

