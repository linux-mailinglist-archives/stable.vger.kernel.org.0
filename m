Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1CA192B18
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgCYO2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:28:54 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:41916 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727566AbgCYO2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 10:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585146532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JqpwltFL/SwS1UhlcIi0MOoODF8Cpbq1cMt7ik4CiTE=;
        b=eCJzh0B+mr7vKWlmwWwcLSOEXGOTZJf9mYzK6cdKHKCllG4l9Ec4FaU3u60DDtJfszD+41
        SJn7MzXpw6J+olXnt1sxu0qY8yueTRGm709MPfBNyPsq/ZZ2mDEGJ7eLkvU8eQN53zsTKL
        /rOuwAH/HsStfKcvSLAAn4HMy8eOaCo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-Xh-tGqPVPomG34DhCv4tFA-1; Wed, 25 Mar 2020 10:28:49 -0400
X-MC-Unique: Xh-tGqPVPomG34DhCv4tFA-1
Received: by mail-wm1-f72.google.com with SMTP id m4so949449wmi.5
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 07:28:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JqpwltFL/SwS1UhlcIi0MOoODF8Cpbq1cMt7ik4CiTE=;
        b=nIUCL8d7n94+/6fC5aaHSyIYjqKQdiviEWqSbGXg2xAOiuIPbhrd52zQolk7sUXY7Z
         6lLfut2q9wooN5n0MJmdNxGwBwrtV7K1BgZ52pUeE0Sk5rO138EQsiESOlyI2tPMOl27
         W7+G+XIl9+eGzNt57YxpA3uaiBn4PBsTlVwknyGTqZu3W1c67RBijkazHEzOL219MLvI
         A/BiWLHaH6ORnvunyJ0Vgqhmpm9nFqBbxxMGYWbDnaPD5CLPiHxKmgcHHC8zNcF2vW04
         +wTsjJNfrfuN4CTvxN8NwEvpIgSQfVplGGe3HcnTrTWgl03TvxYvhcJjdCPfCujePfqB
         U+sA==
X-Gm-Message-State: ANhLgQ0WC4n3MyHFi1P7MK/JtONiFpHMgAq4hBEtWdIrq8pincm64PYZ
        kv2WOGY6WSMcXpxZ6ymnV+uzTbsqhbjIr+2T47RhzcfX9NiOp6uVfs6TRqNUMC76MjMoEacGgrf
        2AzrOglQUiCTKb9mZ
X-Received: by 2002:a7b:c050:: with SMTP id u16mr4024617wmc.68.1585146527996;
        Wed, 25 Mar 2020 07:28:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtps1lqlEjeVqhmoxqx06a7QnIYlVTNWJazZkk/ssQW3dTzHNkG7M+s2wksPvvsb7XCMHkt2A==
X-Received: by 2002:a7b:c050:: with SMTP id u16mr4024590wmc.68.1585146527811;
        Wed, 25 Mar 2020 07:28:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v7sm9590018wml.18.2020.03.25.07.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:28:47 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Yubo Xie <yuboxie@microsoft.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
Subject: Re: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong time unit
In-Reply-To: <039e126f-f00d-d7e1-aa92-c049c9e3333b@gmail.com>
References: <20200324151935.15814-1-yuboxie@microsoft.com> <87ftdx7nxv.fsf@vitty.brq.redhat.com> <039e126f-f00d-d7e1-aa92-c049c9e3333b@gmail.com>
Date:   Wed, 25 Mar 2020 15:28:45 +0100
Message-ID: <87lfno5x0i.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tianyu Lan <ltykernel@gmail.com> writes:

>>> @@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
>>>   
>>>   static u64 read_hv_sched_clock_msr(void)
>>>   {
>>> -	return read_hv_clock_msr() - hv_sched_clock_offset;
>>> +	return (read_hv_clock_msr() - hv_sched_clock_offset)
>>> +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
>>>   }
>> 
>> kvmclock seems to have the same (pre-patch) code ...
>
>
> kvm sched clock gets time from pvclock_clocksource_read() and
> the time unit is nanosecond. So there is such issue in KVM code.
>

Ah, true, kvmclock is always 1Ghz so it's reading 'naturally' converts
to ns.

-- 
Vitaly

