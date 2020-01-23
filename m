Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72F21469F7
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 14:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAWNyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 08:54:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60629 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727022AbgAWNyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jan 2020 08:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579787694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQ3Ow20PKV371NO5YgbOYBtfdI39/lSB5zP8TflCC5o=;
        b=Lf9Rf62n9QzqHRQOcWyLYVsSWv6tqIUYLHlYClTF1KI9L1Pzgl0EWpQY32qBmCYbZRq9T5
        uuaOOtnST28OkCubrpYoPQ9vhW9WTjePJU8Gisa8hCKLVliv2snBgG5IOkauNi27ZWgPu6
        6obsZfQD3SLnfgHGTxJnisct0J9ZjZ0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-qSTlXrkKN_69_zWS5vmx_w-1; Thu, 23 Jan 2020 08:54:52 -0500
X-MC-Unique: qSTlXrkKN_69_zWS5vmx_w-1
Received: by mail-wr1-f70.google.com with SMTP id w6so1757439wrm.16
        for <stable@vger.kernel.org>; Thu, 23 Jan 2020 05:54:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RQ3Ow20PKV371NO5YgbOYBtfdI39/lSB5zP8TflCC5o=;
        b=QQaqwWq/lZNeqNZQP25gsLN/4IMkJ6r2oABU/FEEdQv7A+cl+C8Li2ug4g29GXkzAS
         xAeuGjftzND12zfAaFpsfqr/R69rZjOLGLlZ/RILHUhbzW57B5BhsaYdCXRVBscbY6/z
         LxvcSnG9K13He5l+dhf6FPNYpVrwaUbh470nodbTbskvBiwoxjv843yZpn4FV81W8JXx
         0HhA3x/9YrpXVTcns3tYClaYj6uiCy9DdrkMiQPspbPurfEIwodNa85rUkUHUULNiOiv
         i8OtZXmFHeCIqKW6eSRBdfiWaHhEKBk/SI0XYV+m2/3QlWrhA3SBSrkt5nRv/wF7xeBS
         mzcg==
X-Gm-Message-State: APjAAAWXSkkvNFfVBgC0hag65MG9IEmuPufisIwZWJO3g9I7k2lafiDz
        2I0L21haEDN5fp5oKU11l5xxb+zC9kkIg9yjhyrFDH9iACGeeDIkIoOMaTKTs/2AZI7CMty99Ch
        YkVwoX2xVM5i/n4af
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr4402299wmm.143.1579787691645;
        Thu, 23 Jan 2020 05:54:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKDd2Y0rsZeFLVbKo5pHH20OQcIqSfL1QyTrAtoWCMveHeMEIT2dWY+aPKw92HxHMLD6QraQ==
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr4402279wmm.143.1579787691407;
        Thu, 23 Jan 2020 05:54:51 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id k8sm3102469wrl.3.2020.01.23.05.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 05:54:50 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: use raw clock values consistently
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     mtosatti@redhat.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
 <1579702953-24184-3-git-send-email-pbonzini@redhat.com>
 <87r1zqqode.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ed5b7a36-b9a0-5436-c704-58c65966b7c2@redhat.com>
Date:   Thu, 23 Jan 2020 14:54:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <87r1zqqode.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23/01/20 14:43, Vitaly Kuznetsov wrote:
>> +
>> +static s64 get_kvmclock_base_ns(void)
>> +{
>> +	/* Count up from boot time, but with the frequency of the raw clock.  */
>> +	return ktime_to_ns(ktime_add(ktime_get_raw(), pvclock_gtod_data.offs_boot));
>> +}
>> +#else
>> +static s64 get_kvmclock_base_ns(void)
>> +{
>> +	/* Master clock not used, so we can just use CLOCK_BOOTTIME.  */
>> +	return ktime_get_boottime_ns();
>> +}
>>  #endif
> But we could've still used the RAW+offs_boot version, right? And this is
> just to basically preserve the existing behavior on !x86.

Yes, there's no reason to restrict the pvclock_gtod notifier to x86_64.
 But this is stable material so I kept it easy.

>>
>> -	getboottime64(&boot);
>> +	wall_nsec = ktime_get_real_ns() - get_kvmclock_ns(kvm);
> 
> There are not that many hosts with more than 50 years uptime and likely
> none running Linux with live kernel patching support so I bet noone will
> ever see this overflowing, however, as wall_nsec is u64 and we're
> dealing with kvmclock here I'd suggest to add a WARN_ON().

You're off by a factor of 10, 2^64 nanoseconds are about 584 years
(584*365*10^9*86400). :)

Paolo

