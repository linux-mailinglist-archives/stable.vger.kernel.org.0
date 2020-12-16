Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F9C2DC46A
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 17:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgLPQjZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 11:39:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbgLPQjZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 11:39:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608136678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2+V0CHWruZoWWRZZzUGuPvlWuNpoWHWDINW5JuNDRBw=;
        b=F+/Sm5a00AyhQhR8rz//+6rdmxK25encZqCEW0pcTounXgLIHJygaix2kzRoUnL/HZyeZK
        OBPLcTqp7CylKGVh2k3wXYER/N8KPqCKKgx+U/FTEwlWaPaZ5zV5CUXsgBQMBuZpVEFGup
        3Pq//UEsQtKr7fitXGI0ob1EqBLEqeE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-nGzEJzGaMN-b_NzHUdSKwg-1; Wed, 16 Dec 2020 11:37:57 -0500
X-MC-Unique: nGzEJzGaMN-b_NzHUdSKwg-1
Received: by mail-ej1-f69.google.com with SMTP id h17so7560028ejk.21
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 08:37:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+V0CHWruZoWWRZZzUGuPvlWuNpoWHWDINW5JuNDRBw=;
        b=cAsZ0S1cIqKRsjk3EHB10ou9ksNV2YSrANT6MIOn/fSiQAOh69ZKZJgRPmCO69/a+u
         wSa49UNa22WpUnc7cPoyws6XYA3/kFRbz2v8Q61QsJbBDTgyH7BaSrAZVSqbo/5+WFEI
         CswlRn/xrIhLBtIdv2GCcVw+We6x8h9yNLeF4bguAkiXvmStJZ3MP2xXCyiDmawSTQRB
         25gfYR9OSgcnf8J0bJqtYKZ3DBAHmrlL5ymcgWMQFq4yfhqpuzDG2figAofDrxiFQxCg
         Pv1zitWinFHdQ6oP2Kg41aAFDyoqTA4zDL0WUqogVsiJ2le8AbeNpGcgpJ1OTbT4O1XN
         HRIg==
X-Gm-Message-State: AOAM530HkGhi2uUWzC2+Uic+Iehz8Ednjffg+GcziQEKOYA0OOxHUV7j
        bCnbmLC1wax8PAPt6A2hDxegktWVgHH6AnUZkA5NiqG2gC+1ZWqGaB/TrtG1BnrbY3QulR3C4MB
        lYU8JFdZp69Y+tSZdEGgLuM+XxNOKWez4owz4f1AdJiehp/V8Ks7vlGkUZyK/ZUdGer55
X-Received: by 2002:a50:ec18:: with SMTP id g24mr7439893edr.6.1608136674068;
        Wed, 16 Dec 2020 08:37:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzNAnERvbswd9AoHfPbJXZyKHy0huvwhS1S3FWAepfPQXulq21n26q7QKd6bGoC4D0IdgyL9A==
X-Received: by 2002:a50:ec18:: with SMTP id g24mr7439879edr.6.1608136673855;
        Wed, 16 Dec 2020 08:37:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id qh23sm1739541ejb.71.2020.12.16.08.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 08:37:52 -0800 (PST)
Subject: Re: [PATCH V2] kvm: check tlbs_dirty directly
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>, stable@vger.kernel.org
References: <ea0938d2-f766-99de-2019-9daf5798ccac@redhat.com>
 <20201215145259.18684-1-jiangshanlai@gmail.com> <X9kEAh7z1rmlmyhZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <37657f78-654e-ff81-e1c4-6ec31d6b99cf@redhat.com>
Date:   Wed, 16 Dec 2020 17:37:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X9kEAh7z1rmlmyhZ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15/12/20 19:44, Sean Christopherson wrote:
> Note, you don't actually need to Ccstable@vger.kernel.org  when sending the
> patch.  If/when the patch is merged to Linus' tree, the stable tree maintainers,
> or more accurately their scripts, will automatically pick up the patch and apply
> it to the relevant stable trees.
> 
> You'll probably be getting the following letter from Greg KH any time now:-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

As far as I know, as long as he sees LKML or something else in Cc he 
assumes it's an indication _for the maintainer_.  Don't underestimate 
the power of Greg's mailing list filters. :)

Paolo

