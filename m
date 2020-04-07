Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3301A17B8
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 00:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgDGWH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 18:07:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41073 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726395AbgDGWH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 18:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586297247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sBcX0MuRfqdKJ/UDy2UrC0OesweN1b1Dk27ZzjJGB5Y=;
        b=i5x7nUVcUE15gTgNu7HGfc186JHjuWRAMJBdPdt5y02HgtTqwUGTpVHqv00xyDTxa6E/0E
        iNPOnA4NptlPF8XrJERZxclW5ZM2cGerwWXUgmVz06kzm/YDAHNuZU73HUapJ+QEDalllV
        vgo0BjAT6bdamXo4T/CXdd4Vb5p2G0k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-mH292IJ6Pwi1vt2EyMluig-1; Tue, 07 Apr 2020 18:07:26 -0400
X-MC-Unique: mH292IJ6Pwi1vt2EyMluig-1
Received: by mail-wr1-f69.google.com with SMTP id a10so2945171wra.2
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 15:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sBcX0MuRfqdKJ/UDy2UrC0OesweN1b1Dk27ZzjJGB5Y=;
        b=EEwk+RWm7o6ipBtv0VVEuokoBc+9MS2iqt16lLWh0l/fWqcvg/iuNcKfztcJlHaaIe
         C9ZNnVHknK1UEzZOvu06jQyNvuNLdXFkBcw1lSLsWtV74XccawqHd002aB9iMICgWYS6
         gw2ZP/vhDJ1I+LMMQ4ZQkiPVJgN5oANZCqmlhJhvgqaCmLCo7w6Gz7O1u5pbxr5LnINP
         eQ0wqrKEfwQL6dKj32Fp9DK/9oOWqLwAkgEujybcuioiQTUkobKaPVRlowz2yvv8HYHl
         z8yh/bIJzJseJhUJSx5IhuYE7alrDH4Kb4ItZD11c1G58CfkniwrDxElZHevOWMZINor
         SPiA==
X-Gm-Message-State: AGi0PuaNp2pCbMnbCSEsY4CMLkYZGDX6B87ZqUbathRgSSTULmkfztdZ
        44pC0PePt7Tx9JgCH92tttqeB4eYbhE4MB+FChivpiBfD5oI9tWspq+FvXJVvZV3315PMUHf3zJ
        5oVcMlFXLLOZknFn4
X-Received: by 2002:adf:b64f:: with SMTP id i15mr5190281wre.351.1586297244868;
        Tue, 07 Apr 2020 15:07:24 -0700 (PDT)
X-Google-Smtp-Source: APiQypLm4s/z1WuBmAjFihAoIU+l3M3dmlXE9c2JCfBcrBn/lXHVlRvx1DDkIp0weC8LKHXvuX6Bwg==
X-Received: by 2002:adf:b64f:: with SMTP id i15mr5190263wre.351.1586297244650;
        Tue, 07 Apr 2020 15:07:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:bd61:914:5c2f:2580? ([2001:b07:6468:f312:bd61:914:5c2f:2580])
        by smtp.gmail.com with ESMTPSA id w66sm3973000wma.38.2020.04.07.15.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:07:24 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <87eeszjbe6.fsf@nanos.tec.linutronix.de>
 <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2776fced-54c2-40eb-7921-1c68236c7f70@redhat.com>
Date:   Wed, 8 Apr 2020 00:07:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <B85606B0-71B5-4B7D-A892-293CB9C1B434@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/04/20 23:41, Andy Lutomirski wrote:
> 2. Access to bad memory results in #MC.  Sure, #MC is a turd, but
> it’s an *architectural* turd. By all means, have a nice simple PV
> mechanism to tell the #MC code exactly what went wrong, but keep the
> overall flow the same as in the native case.
> 
> I think I like #2 much better. It has another nice effect: a good
> implementation will serve as a way to exercise the #MC code without
> needing to muck with EINJ or with whatever magic Tony uses. The
> average kernel developer does not have access to a box with testable
> memory failure reporting.

I prefer #VE, but I can see how #MC has some appeal.  However, #VE has a
mechanism to avoid reentrancy, unlike #MC.  How would that be better
than the current mess with an NMI happening in the first few
instructions of the #PF handler?

Paolo

