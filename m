Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FAFC14DF85
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 17:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgA3Q7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 11:59:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727191AbgA3Q7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 11:59:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580403564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nlUA1IKN2cUYvXuRuh2BytPjl+ySCJ3Aq0SPrrQxCvA=;
        b=UsBGCkjoeMPhQZLvK/mKTBD/oZaq5vPRuvjrmQFmmSIXiOHvH1eAziCC5bfumDwajeEvWY
        FH+iR/s8Y5Tcc434KbTtVIRlwKaWObRbr0BAENv2y4VHcJxb0fxsfGcNNdsQEYlY1VKj52
        N5lG8gNeM2AdxRzB+iKKubrK0Piq3GA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-5bFwnSgjNoKvxcpKiuYaXQ-1; Thu, 30 Jan 2020 11:59:22 -0500
X-MC-Unique: 5bFwnSgjNoKvxcpKiuYaXQ-1
Received: by mail-wr1-f71.google.com with SMTP id v17so1976374wrm.17
        for <stable@vger.kernel.org>; Thu, 30 Jan 2020 08:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nlUA1IKN2cUYvXuRuh2BytPjl+ySCJ3Aq0SPrrQxCvA=;
        b=AOR+DSP+r2APTMpPzrtVlrp2T3myehCVuYO9xqKdt1g+NMcH8Vgt2Yz6YFkvYQL8NX
         AD7A+UA+SXlKBPRtNDN+pcIcgKZLnLgPn+SYw/a+b2SC8A2bD1MA7oLJW97twP4xq46z
         5a80Hfvix+ebQh8xy1sERzspO4yrq8nqjOrhcDAncZ4i6vUMhA9T2LYoRxVvCEBAWwnr
         ujs7bz/GmT5vXEwl6nMRvr/akR1nDqRgTey/W2tdczA2x/N39GmP7LsQx0R77/6bkiW0
         2tjM82Vd9nx1Xc0/lcpMxE/c0oID9Hg7F+u5Or5UVw5h5m10Qwx0+WYTQ60tjGgm9o9b
         ducA==
X-Gm-Message-State: APjAAAV4GCr56wM6NjU9rs+IL4nbew6bbLxVTE69i65vRyS5rVv7arJH
        Nmeu3yoCyxbpDt8SA3w70DBZcoLDqYQ2H7rleXPVLhqx1z8ScRRsvpCuReSQHyu+HOJodyg+m6c
        XxyGR5+DZzp482yLB
X-Received: by 2002:a1c:5441:: with SMTP id p1mr6906139wmi.161.1580403561389;
        Thu, 30 Jan 2020 08:59:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqzX9ob7+CHM2PASRpn8fpyDa6B7wCY8FUhuovM+3oQy+vsvytWtJplNLkyT56BPVHoKIpn4qA==
X-Received: by 2002:a1c:5441:: with SMTP id p1mr6906122wmi.161.1580403561156;
        Thu, 30 Jan 2020 08:59:21 -0800 (PST)
Received: from shalem.localdomain (2001-1c00-0c0c-fe00-7e79-4dac-39d0-9c14.cable.dynamic.v6.ziggo.nl. [2001:1c00:c0c:fe00:7e79:4dac:39d0:9c14])
        by smtp.gmail.com with ESMTPSA id q10sm6898638wme.16.2020.01.30.08.59.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 08:59:20 -0800 (PST)
Subject: Re: [PATCH 3/3] x86/tsc_msr: Make MSR derived TSC frequency more
 accurate
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20200130115255.20840-1-hdegoede@redhat.com>
 <20200130115255.20840-3-hdegoede@redhat.com>
 <20200130134310.GX14914@hirez.programming.kicks-ass.net>
 <b77be8c0-7107-bece-5947-a625e556e129@redhat.com>
 <01feee20ee5d4b83ab218c14fc35accb@AcuMS.aculab.com>
 <8a8fd7a1-945e-4541-f0bc-387fae7c6822@redhat.com>
 <CAHp75VftbK+7uzBCQ6F5FFgJ4qq0f9pB1Qo7m0LwbBROYsrrYw@mail.gmail.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <a76e05b7-112a-3140-e97a-2e03fc21e5f5@redhat.com>
Date:   Thu, 30 Jan 2020 17:59:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAHp75VftbK+7uzBCQ6F5FFgJ4qq0f9pB1Qo7m0LwbBROYsrrYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 30-01-2020 17:52, Andy Shevchenko wrote:
> On Thu, Jan 30, 2020 at 6:04 PM Hans de Goede <hdegoede@redhat.com> wrote:
>> On 30-01-2020 17:02, David Laight wrote:
> 
>> I have no idea. Andy if you can find any docs on the MSR_FSB_FREQ values
>> for Merriefield (BYT MID) and Moorefield (CHT MID) that would be great,
>> if not I suggest we stick with what we have.
> 
> First of all, Merrifield (Silvermont based Atom for phones, FYI: Intel
> Edison uses it) and Moorefield (Airmont) have nothing to do with code
> names Baytrail and Cherrytrail respectively.
> So, please don't confuse people.

Ok, sorry, I've prepped a v2 of this patch in my local tree with
the following changelog:

Changes in v2:
-Do not refer to Merrifield / Moorefield as BYT / CHT, they only share the
  CPU core design and otherwise are significantly different

> I'll try to find some information.

OK, I'll wait a bit with sending out the v2 then.

Regards,

Hans

