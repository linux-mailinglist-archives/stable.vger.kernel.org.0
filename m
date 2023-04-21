Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B106EAE0A
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbjDUPa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 11:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232692AbjDUPa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 11:30:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35055B88
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 08:30:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1682091025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xEaKSb6kzghj6GbIyCFmRJNgNbt+xpz/j9G8XDw9JgM=;
        b=OkH3XNfywnHu/cTFNUxVKPydCfCu04p8CfEZADChb9Y/RiMLcsmIk2jjvWclNeLLWtdmOy
        zGvK62Rl3gYGfbyOXOR//uqymEfo0QCDB8Fc3JaGyNxso5xHninq/KiVTTHQHaMTX5L7pg
        tmfBINma9kJDSJ506ccoSsn03r7CMB6YeVKWQ0bsaBX3Gajcm0bAANNer2qfSlYYT1cPa2
        32nNYSpQ0pjrVbGb8TH4vSoek1gOX14bViOMxj+oAxCAZADSvZvSropiADkmfRSRWOiG/c
        O2P3jc7Bmh68d18vTlnJs3zMMJH5QmQMGMrP6QfFcB+7GXsY/NPvQkBPU4QuKg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1682091025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xEaKSb6kzghj6GbIyCFmRJNgNbt+xpz/j9G8XDw9JgM=;
        b=CeeYzkF18lgZSyxdhFUDzd8a32zAPoQhp+5YEImkqIdwkWbcnvIOSxE2im+3m0An7Hct3S
        zB9s5rI2bEyueIDw==
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
In-Reply-To: <ZEKFWx_68PX3pk3g@kroah.com>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de> <87pm7x3d8b.ffs@tglx>
 <ZEKFWx_68PX3pk3g@kroah.com>
Date:   Fri, 21 Apr 2023 17:30:24 +0200
Message-ID: <87ildp2qy7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21 2023 at 14:45, Greg KH wrote:
> On Fri, Apr 21, 2023 at 09:29:08AM +0200, Thomas Gleixner wrote:
>> On Wed, Apr 19 2023 at 09:25, Sebastian Andrzej Siewior wrote:
>> > On 2023-04-18 18:25:48 [+0200], Greg KH wrote:
>> >> > Could this be please backported to 5.15 and earlier? It is already part
>> >> > of the 6.X kernels. I asked about this by the end of January and I'm
>> >> > kindly asking again ;)
>> >> 
>> >> I thought this was only an issues when using the out-of-tree RT patches
>> >> with these kernels, right?  Or is it relevant for 5.15.y from kernel.org
>> >> without anything else?
>> >
>> > The out-of-tree RT patches make extensive use of the code. Since it is
>> > upstream code, I assumed it should go via the official stable trees.
>> > Without RT, the code is limited the rt_mutex_lock() used by I2C and the
>> > RCU booster-mutex.
>> 
>> Which is a reason to route it through the upstream stable trees, no?
>
> I do not understand.  Why would we take a patch in the stable tree
> because an out-of-tree change requires it?

The change is to the rtmutex core which _IS_ used in tree by futex, RCU
and some drivers.

Just because the problem was observed on RT it does not make the
mainline usage of RTMUTEXes magically unaffected. The missing acquire
semantics are required there too.

Thanks,

        tglx
