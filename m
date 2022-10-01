Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C135F1C2A
	for <lists+stable@lfdr.de>; Sat,  1 Oct 2022 14:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJAMeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Oct 2022 08:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJAMet (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Oct 2022 08:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D0B29CBF
        for <stable@vger.kernel.org>; Sat,  1 Oct 2022 05:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664627686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZdi4pkGgcpbGzaboCY/MebG3XWkH7xC5AZfZa6cchY=;
        b=KqjUAnyfrbtFZNuPltHV2AfmaaXiHdm5RxPssQHS6gXNLOgeezKdksj0KGcz3HhJp3L2ii
        e+UkpmLJKJEMGYaQtym0UaeJVuWR7y0jwzdF1H3xvV76+mo3vHJaO6wr4pqZS70GAjp7Vy
        Facwx0KoTKgpeDcWyrSLUcpMGalt/NU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-Kz7ZkCxgPHK9YGP4LimKjg-1; Sat, 01 Oct 2022 08:34:45 -0400
X-MC-Unique: Kz7ZkCxgPHK9YGP4LimKjg-1
Received: by mail-ed1-f71.google.com with SMTP id r11-20020a05640251cb00b004516feb8c09so5435850edd.10
        for <stable@vger.kernel.org>; Sat, 01 Oct 2022 05:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fZdi4pkGgcpbGzaboCY/MebG3XWkH7xC5AZfZa6cchY=;
        b=KHe6IdF/+9vaN8/zzsaSI9aVnS5W3PfnZOnotBSv0jWXlPNbCnJed+zPR8d9gJKC2G
         8g9GQ0anZv0QrKWXJOpL4PBsMLwy01yJvD+pCHEC+RPoiFiZ59OKBFr2qzUnwgO2RwVr
         EcGKdJ/W01IEvo5QnQDxozO1tfIcTQrOriVq5l+D4gYnY7PoDJlg4X4W6h0lqYNTEVYV
         Xt6G74f71jyLUIJrg8TNpy2V8OBSzKDQs0Sx0yUD3vE/LdTIcXLi0B1nKpmtBhy8G4B2
         t7Rnf2zZFGpRs0RoRicbcOod5JYzsiHO0Ia/fQ7u4mbEA6C2fyxM4Kp+rLzwtq7tH7jl
         wyxA==
X-Gm-Message-State: ACrzQf2g1Rq+JXDMvAh4++B9QaJCqFHkDRglSxx5W094u9eiOtskVJgC
        RuGW9Ps0UpSEyLHuhBagvbpMXaYt1UTrN7WUsSZHpj9wUnO2dZUMMTQTJNh7s2RLs0F/pPHUBnd
        +dO+lcd5CZKE062IC
X-Received: by 2002:aa7:cc8e:0:b0:457:23db:f0cc with SMTP id p14-20020aa7cc8e000000b0045723dbf0ccmr11553565edt.122.1664627684356;
        Sat, 01 Oct 2022 05:34:44 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5E2M2+0VAkVEUIPXKI4uS+9F4UcgVmEXN4GUafJR2CwUm2d+C6grswZwpB45bmackhFjpvhw==
X-Received: by 2002:aa7:cc8e:0:b0:457:23db:f0cc with SMTP id p14-20020aa7cc8e000000b0045723dbf0ccmr11553551edt.122.1664627684174;
        Sat, 01 Oct 2022 05:34:44 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id ck15-20020a0564021c0f00b00456ced2b26csm3486406edb.8.2022.10.01.05.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Oct 2022 05:34:43 -0700 (PDT)
Message-ID: <87e6a933-bfa6-8e1a-7f71-d6a08a299568@redhat.com>
Date:   Sat, 1 Oct 2022 14:34:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: Regression on 5.19.12, display flickering on Framework laptop
Content-Language: en-US, nl
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Slade Watkins <srw@sladewatkins.net>,
        Jerry Ling <jiling@cern.ch>
References: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
 <YzZynE2FAMNQKm2E@kroah.com> <YzaFq7fzw5TbrJyv@kroah.com>
 <03147889-B21C-449B-B110-7E504C8B0EF4@sladewatkins.net>
 <aa8b9724-50c6-ae2e-062d-3791144ac97e@cern.ch>
 <e3e2915d-1411-a758-3991-48d6c2688a1e@leemhuis.info>
From:   Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <e3e2915d-1411-a758-3991-48d6c2688a1e@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 10/1/22 12:07, Thorsten Leemhuis wrote:
> On 30.09.22 14:26, Jerry Ling wrote:
>>
>> looks like someone has done it:
>> https://bbs.archlinux.org/viewtopic.php?pid=2059823#p2059823
>>
>> and the bisect points to:
>>
>> |# first bad commit: [fc6aff984b1c63d6b9e54f5eff9cc5ac5840bc8c]
>> drm/i915/bios: Split VBT data into per-panel vs. global parts Best, Jerry |
> 
> FWIW, that's 3cf050762534 in mainline. Adding Ville, its author to the
> list of recipients.
> 
> Did anyone check if a revert on top of 5.19.12 works easily and solves
> the problem?
> 
> And does anybody known if mainline affected, too?

Sorry for jumping in the middle of the thread. I believe that this is also
reported by Fedora users on a Lenovo Carbon X1 (gen 9) as:

https://bugzilla.redhat.com/show_bug.cgi?id=2130699

So it would be good to add a:

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2130699

tag to the commit which ends up fixing this.

Regards,

Hans





> 
> Ciao, Thorsten
> 
> 
>> On 9/30/22 07:11, Slade Watkins wrote:
>>> Hey Greg,
>>>
>>>> On Sep 30, 2022, at 1:59 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Fri, Sep 30, 2022 at 06:37:48AM +0200, Greg KH wrote:
>>>>> On Thu, Sep 29, 2022 at 10:26:25PM -0400, Jerry Ling wrote:
>>>>>> Hi,
>>>>>>
>>>>>> It has been reported by multiple users across a handful of distros
>>>>>> that
>>>>>> there seems to be regression on Framework laptop (which presumably
>>>>>> is not
>>>>>> that special in terms of mobo and display)
>>>>>>
>>>>>> Ref:
>>>>>> https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171
>>>>> Can anyone do a 'git bisect' to find the offending commit?
>>>> Also, this works for me on a gen 12 framework laptop:
>>>>     $ uname -a
>>>>     Linux frame 5.19.12 #68 SMP PREEMPT_DYNAMIC Fri Sep 30 07:02:33
>>>> CEST 2022 x86_64 GNU/Linux
>>>>
>>>> so there's something odd with the older hardware?
>>>>
>>>> greg k-h
>>> Could be. Running git bisect for 5.19.11 and 5.19.12 (as suggested by
>>> the linked forum thread) returned nothing on gen 11 for me.
>>>
>>> This is very odd,
>>> -srw
>>
>>
> 

