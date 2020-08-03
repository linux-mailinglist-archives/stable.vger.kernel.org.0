Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D3239FD6
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 08:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgHCGw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 02:52:59 -0400
Received: from www381.your-server.de ([78.46.137.84]:38470 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCGw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 02:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
         s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=pVK4/IazJnPOxJcn8CRUWY1PQenU0p/gHIhF+5bYTg8=; b=V8KsFb9IPUQzD/Krwqf6eJr2pH
        mNBF/s18CWwow44ZowV2SofT1FggnqSXIPnJM5xj8BgAPA68eRFkLh1yLUm43lvdCDnKRfJQxwn3C
        Mnn14jJARyz7AZbId7uIpp1SERYTlDhbMefWndcJC4cU8/qUkhYl/aq+jaWuhzHG1oGyFeAP1NTTe
        bEdOugANVxMR7AinXWe22ZAbqB2xrcl+lrTc0AhfKsSrlMwiyuRKV5JMwlK7o4chkTw4qLOCWIN1G
        DB6/KFahmWLJ+gtN4Z2Hx1gsvmGNNGZTQEaowhgtImdvYamGTonOkt1EcwEChO9eWQg7iIVeIPKTP
        EkqBKpzg==;
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www381.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <lars@metafoo.de>)
        id 1k2UL8-0002u4-M8; Mon, 03 Aug 2020 08:52:54 +0200
Received: from [2001:a61:2517:6d01:9e5c:8eff:fe01:8578]
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1k2UL8-000C4J-GN; Mon, 03 Aug 2020 08:52:54 +0200
Subject: Re: [PATCH] iio: trigger: sysfs: Disable irqs before calling
 iio_trigger_poll()
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jonathan Cameron <jic23@kernel.org>, stable@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200727145714.4377-1-ceggers@arri.de>
 <2272098.D4WoNcAbr4@n95hx1g2>
 <2443aad4-b631-bfe7-e79c-2cb585685a1e@metafoo.de>
 <4871626.01MspNxQH7@n95hx1g2>
From:   Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <a59d204e-aeb0-2649-5e6f-f07815713d1a@metafoo.de>
Date:   Mon, 3 Aug 2020 08:52:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4871626.01MspNxQH7@n95hx1g2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.102.4/25892/Sun Aug  2 17:01:36 2020)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/3/20 8:44 AM, Christian Eggers wrote:
> Hi Lars,
>
> On Monday, 3 August 2020, 08:37:43 CEST, Lars-Peter Clausen wrote:
>> The sysfs IIO trigger uses irq_work to schedule the iio_trigger_poll()
>> and the promise of irq_work is that the callback will run in hard IRQ
>> context. That's the whole point of it.
>>
>> irq_work_run_list(), which shows up in your callgraph, has as
>> BUG_ON(!irqs_disabled())[1], so we should never even get to calling
>> iio_trigger_poll() if IRQs where not disabled at this point. That's the
>> same condition that triggers the WARN_ON() in __handle_irq_event_percpu.
> is my patch sufficient, or would you prefer a different solution?
The code in normal upstream is correct, there is no need to patch it 
since iio_sysfs_trigger_work() always runs with IRQs disabled.
>
>> Are you using a non-upstream kernel? Maybe a RT kernel?
> I use v5.4.<almost-latest>-rt

That explains it. Have a look at 
0200-irqwork-push-most-work-into-softirq-context.patch.

The right fix for this issue is to add the following snippet to the RT 
patchset.

diff --git a/drivers/iio/trigger/iio-trig-sysfs.c 
b/drivers/iio/trigger/iio-trig-sysfs.c
--- a/drivers/iio/trigger/iio-trig-sysfs.c
+++ b/drivers/iio/trigger/iio-trig-sysfs.c
@@ -161,6 +161,7 @@ static int iio_sysfs_trigger_probe(int id)
      iio_trigger_set_drvdata(t->trig, t);

      init_irq_work(&t->work, iio_sysfs_trigger_work);
+    t->work.flags = IRQ_WORK_HARD_IRQ;

      ret = iio_trigger_register(t->trig);
      if (ret)

