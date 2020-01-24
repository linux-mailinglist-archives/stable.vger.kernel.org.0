Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A260148B86
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389227AbgAXPys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 10:54:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52790 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389172AbgAXPys (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 10:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579881287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NVWDSNWG2YBJMb5h9YSxyXIldji6NzcE4XoLI2HHWzc=;
        b=ORo8l2ZPHj7RLVaazQFnFG0u98y4Y8jUhaOZPdiLFSvQZ8aipGGzusazUbPNoZxyHEJahy
        17Swyz7ak1l6M4hMj007+esD0o/13h14YSVNPGzX5GMX1OBM3Gx09YYdntlOD+1XMf4/tt
        LDxfolWF6XPs5ZmpkF6eDYZNcmD+0o8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-xwmuehwJPsKYg30D1TkObw-1; Fri, 24 Jan 2020 10:54:45 -0500
X-MC-Unique: xwmuehwJPsKYg30D1TkObw-1
Received: by mail-wr1-f69.google.com with SMTP id o6so1541497wrp.8
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 07:54:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NVWDSNWG2YBJMb5h9YSxyXIldji6NzcE4XoLI2HHWzc=;
        b=YxMBnKpCXMrgowytukajgzeVWZyaarKYOqac8uAk3m4L+I27zwRtpF0BkuOEu7jT+U
         rNe0YrjE04v7srGi4wAb7ENA/FJUECCAHS2ogsKl5/Ecqp/edN0JvocB0lIoXtzgWHc+
         hc+FCJIY9iela1CsHFHV2ef0c8rc+Wz4voermbsFdOr/0/N4mgWQG7fCnbMAMbdWB+kP
         xO7Un2KbN32CP7+r44wGIrKgCCSiTcADmRbYh7L/nJT+Py7OIA1aoK+iyPbpBb6BiAH1
         8IXSD3lDkImEfnqPsJQON7TaNgDiduf+uL2rKhlGjyXqZkTyOJJHkB0hoZuAnThHZPfM
         i4tw==
X-Gm-Message-State: APjAAAX3Qfjed58n/UtuKJc4v4saeqJRlUhFSJrNXHbD3SDRKcqh34ok
        yvHasm74GBPS+ecLI5n9eURLXXof8giwRPp5WDHQTrJa76qSSatG8tE/ZlY4r/gesogZw7fAaZv
        BDf3c4FRXFngcgZLK
X-Received: by 2002:a1c:b4c3:: with SMTP id d186mr4074204wmf.140.1579881284294;
        Fri, 24 Jan 2020 07:54:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqzogXgz6eTRvTJTnIRAJ0NJbB5DE5bi6k5zNhAyU8p2PLfZwHBI0nZO2cDrzJW3xMW3fb0Xdg==
X-Received: by 2002:a1c:b4c3:: with SMTP id d186mr4074179wmf.140.1579881284027;
        Fri, 24 Jan 2020 07:54:44 -0800 (PST)
Received: from dhcp-44-196.space.revspace.nl ([2a0e:5700:4:11:6eb:1143:b8be:2b8])
        by smtp.gmail.com with ESMTPSA id t12sm7536527wrs.96.2020.01.24.07.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 07:54:43 -0800 (PST)
Subject: Re: [v3] x86/tsc: Unset TSC_KNOWN_FREQ and TSC_RELIABLE flags on
 Intel Bay Trail SoC
To:     Thomas Gleixner <tglx@linutronix.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        vipul kumar <vipulk0511@gmail.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Vipul Kumar <vipul_kumar@mentor.com>
References: <1579617717-4098-1-git-send-email-vipulk0511@gmail.com>
 <87eevs7lfd.fsf@nanos.tec.linutronix.de>
 <CADdC98RJpsvu_zWehNGDDN=W11rD11NSPaodg-zuaXsHuOJYTQ@mail.gmail.com>
 <878slzeeim.fsf@nanos.tec.linutronix.de>
 <CADdC98TE4oNWZyEsqXzr+zJtfdTTOyeeuHqu1u04X_ktLHo-Hg@mail.gmail.com>
 <20200123144108.GU32742@smile.fi.intel.com>
 <df04f43d-8c6d-7602-cb50-535b85cf2aaa@redhat.com>
 <87iml11ccf.fsf@nanos.tec.linutronix.de>
 <c06260e3-bd19-bf3c-89f7-d36bdb9a5b20@redhat.com>
 <87ftg5131x.fsf@nanos.tec.linutronix.de>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <37321319-e110-81f5-2488-cedf000da04d@redhat.com>
Date:   Fri, 24 Jan 2020 16:54:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87ftg5131x.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 1/24/20 12:55 PM, Thomas Gleixner wrote:
> Hans,
> 
> Hans de Goede <hdegoede@redhat.com> writes:
>> On 1/24/20 9:35 AM, Thomas Gleixner wrote:
>>> Where does that number come from? Just math?
>>
>> Yes just math, but perhaps the Intel folks can see if they can find some
>> datasheet to back this up ?
> 
> Can you observe the issue on one of the machines in your zoo as well?

I haven't tried yet. Looking at the thread sofar the problem was noticed on
a system with a Celeron N2930, I don't have access to one of those, I
do have access to a system with a closely related N2840 I will give that
a try as well as see if I can reproduce this on one of the tablet
oriented Z3735x SoCs.

I'll report back when I have had a chance to test this.

Regards,

Hans

