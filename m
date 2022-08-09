Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B8C58D90B
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 14:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbiHIM7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 08:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237342AbiHIM7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 08:59:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E0ABB15716
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 05:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBecFOB/Bo1T/mXz5cBJlBh2olRYpsGjGSOjfij+x2Q=;
        b=ThQcu0VZyiCzKArVlUkNAUlUPwnoQoCPOUJUkwVAem9NewjJ7erAhdz9MPZEsbxQC6QRmn
        f/dxFEZCEeepvs+mSL6MgVcDwZ6wV8bF3MxqT+YDwrkCKNapAoFnZfmZkSZsD0reN82JZs
        SziPbNyVpIf0I8soEgjZqP3SxtutTDA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-59-0b6RsNKvN4aJhBEYAHbJqQ-1; Tue, 09 Aug 2022 08:59:15 -0400
X-MC-Unique: 0b6RsNKvN4aJhBEYAHbJqQ-1
Received: by mail-ej1-f71.google.com with SMTP id gs35-20020a1709072d2300b00730e14fd76eso3411814ejc.15
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 05:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KBecFOB/Bo1T/mXz5cBJlBh2olRYpsGjGSOjfij+x2Q=;
        b=xDIwgv34PCqFWYGbKnLN/5QPQCueEeiPbwBq0UR0gv3Xuzr3xYr/G9hBH0WiXGJZr9
         J6qKTfp5vR16bPzMVVG6khq93f8EWn9wlYI9H2J+sDqUZ6RQlY5EQmumlnHKFp+QXYXW
         brwgL7XK2pf/OVvIOVRb7sEdxdGapMNa29DO8Nq/xONf7stWBarU+A1ReoPlMIHNgN7/
         VWhsbdAp+CI/xeUyM72LBiuKMX+jj7pxglzgwi1P+dXFnZ3RNeWBUxgO0pA+EFEgebJ/
         ZciqLoRC/cHR8JTGtJLm3KFmae/LRWVFkjCHt36br0q6Ilm7om41aTw/MUnLu6HvHEOY
         bf2w==
X-Gm-Message-State: ACgBeo0v7AnW1YyEMwItj20FUo5Ty4AaIUTbNfWIN+bfBNckovMoSzbH
        yKKy+crYBGB4WmYt7qtwITlVXwQfR/t2iBvq5uJT9QrQ+juLLllfXdR++rnfVxLR58Gcwgs0Qd3
        zHPXSPXhWS0TwSE0l
X-Received: by 2002:a05:6402:1907:b0:43d:e91d:e544 with SMTP id e7-20020a056402190700b0043de91de544mr22039363edz.107.1660049954832;
        Tue, 09 Aug 2022 05:59:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4wUw7Vpw3aM/6l7uafzRR30NIAU8ZjnuvsDJ5chqhOQYeDofcjkztMJTSa6IdTzmsVZH8dFg==
X-Received: by 2002:a05:6402:1907:b0:43d:e91d:e544 with SMTP id e7-20020a056402190700b0043de91de544mr22039348edz.107.1660049954607;
        Tue, 09 Aug 2022 05:59:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b2-20020a1709063ca200b0073095b4b758sm1090273ejh.218.2022.08.09.05.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 05:59:13 -0700 (PDT)
Message-ID: <43e258cc-71ac-bde4-d1f8-9eb9519928d3@redhat.com>
Date:   Tue, 9 Aug 2022 14:59:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Coleman Dietsch <dietschc@csp.edu>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
 <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 11:22, David Woodhouse wrote:
> On Mon, 2022-08-08 at 14:06 -0500, Coleman Dietsch wrote:
>> Stop Xen timer (if it's running) prior to changing the IRQ vector and
>> potentially (re)starting the timer. Changing the IRQ vector while the
>> timer is still running can result in KVM injecting a garbage event, e.g.
>> vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
>> a previous timer but inject the new xen.timer_virq.
> 
> Hm, wasn't that already addressed in the first patch I saw, which just
> called kvm_xen_stop_timer() unconditionally before (possibly) setting
> it up again?

Which patch is that?

Paolo

