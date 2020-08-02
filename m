Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6A4235828
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 17:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHBP00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Aug 2020 11:26:26 -0400
Received: from www381.your-server.de ([78.46.137.84]:57354 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgHBP00 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Aug 2020 11:26:26 -0400
X-Greylist: delayed 1228 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 11:26:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=ktVLBFd43fD/eCb8YK9ZxYTtVy6PozeLeiaxDNrbCIY=; b=DltUqc7xv2cOsxVu3312QuF/pd
        UE8syqqFOb/DmcoMf7oEtX0biJm8eKdxfiJOkowC2kDnCdzrA2g63qtiHMMyFxIiHD/pMPZsLT7Z4
        XL2Md6pDSBeU83RZXfYPzHLHGQ2Vai5ompByyPgMd+3Svx7MugMJJY7Jp7QErHJ7+45uBBdtw9mzd
        Wl2DTYZHEl9UJIlSz+DFpqymt/eFsO8ee8cbKZ2ndcdphGejrb+SjwQsCmaAZ1132A1ukAwIBhcNA
        cOd7d6AiO3MV0BpcQfYFvE6xsLWvGXBuNOD6OU9i4vNk3khMQcMqUnJqfvga+3m2zxRYU+42AQJTo
        OquTh1Ag==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1k2FYd-0002jf-MF; Sun, 02 Aug 2020 17:05:51 +0200
Received: from [2001:a61:2517:6d01:9e5c:8eff:fe01:8578]
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1k2FYd-0001BI-Gc; Sun, 02 Aug 2020 17:05:51 +0200
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling
 iio_trigger_poll()
To:     Jonathan Cameron <jic23@kernel.org>,
        Christian Eggers <ceggers@arri.de>
Cc:     stable@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200727145714.4377-1-ceggers@arri.de>
 <20200801170234.2953b087@archlinux>
From:   Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <28c6add2-311e-5638-e890-53a2248f560a@metafoo.de>
Date:   Sun, 2 Aug 2020 17:05:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200801170234.2953b087@archlinux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.102.4/25891/Sat Aug  1 16:57:39 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/1/20 6:02 PM, Jonathan Cameron wrote:
> On Mon, 27 Jul 2020 16:57:13 +0200
> Christian Eggers <ceggers@arri.de> wrote:
>
>> iio_trigger_poll() calls generic_handle_irq(). This function expects to
>> be run with local IRQs disabled.
> Was there an error or warning that lead to this patch?
> Or can you point to what call in generic_handle_irq is making the
> assumption that we are breaking?
>
> Given this is using the irq_work framework I'm wondering if this is
> a more general problem?
>
> Basically more info please!

There is this series https://lkml.org/lkml/2020/3/6/433 which causes 
generic_handle_irq() to issue an warning if it is called with IRQs on, 
for a IRQ controller that can't handle it.

But I'm not convinced this applies to the IIO code, since this is a 
purely virtual interrupt and is not interfering with any interrupt 
controller hardware.


