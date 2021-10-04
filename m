Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A27EB42154B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 19:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhJDRq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 13:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbhJDRq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 13:46:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90A3C061745;
        Mon,  4 Oct 2021 10:44:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id pi19-20020a17090b1e5300b0019fdd3557d3so479056pjb.5;
        Mon, 04 Oct 2021 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2v3glRkX+dSyZeU+LpE78smFocLlU92ly5f6PxfpGIk=;
        b=exM0K+E4yB1Gke5jtGF93uVyP5I0tk4gMW4/RWH7QH4IyIJc1O3pfnKAxDKzuZ7JET
         Nmvk37dsNFWz4Gma8j3wONGUd26+3pofxU7if1Pf5JnTDou2hO/xkoCf1rue4ZlpZTul
         99xCBJRJgmuQUx4onXyXmWgZ8Lm22WzO03a+DfiJSVuOdckTBB/r6iVBjSU9eyKg+cRm
         t/ecyflTAzFbIoUQLxvkFMy0CrCsg1gVg99ygcEOWdjYdvq5K3bmFJYN/RE6n4s7ios7
         BGofyI7hNUoJfHZmeu5acx+whFmHrwYzm4/uH+/cpviGT56ak5nK3bqm6atd+SBnwAH9
         3l2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2v3glRkX+dSyZeU+LpE78smFocLlU92ly5f6PxfpGIk=;
        b=z7DcIICPDZ2c7nQ7OOjU7omq/Ldnm4v2vwIKpzNokTHRev7yVWmu3/vi15ph39yMW2
         YS8WdSwbSry2x/d26dLyD7Bhaqrw3Qfu4QurhZP3+jZmGpZQDYk8RhIRhI0Yh1VAeh/7
         EWt4v0B/MxifgEs4T3Q/epurAHYL8Ohq3vEUVQ5LhwhpUzqrxYjuLgS2R50AjKMHTuai
         H+yNoWjZ8cmaUlNF9/kMqxaYAJXWIQUaE9Aqp+bAJPeCyWsteqGyecI1U40FQMDK9a8N
         AnIlDoiRDg3wZ8gfx50clpRUPPLYX5hhxSyhtVVxT/slG97uR7if0NOfA2QNOK0Nw+P+
         WhLw==
X-Gm-Message-State: AOAM532e3+Z/rMOjj1aN4LPtDPkI6HUSOoXRi6ffUtHvy86XAcUgrI3T
        zVx8AtfYJngicpSDfPPIo89BfcRV+d0=
X-Google-Smtp-Source: ABdhPJxVsJeHJjtVjulyj7Lvd3dU/a9yFbWHkKKERRqOsy+WcmiF5G5R+5VTY+dk8Jd7jIdkhv4R3w==
X-Received: by 2002:a17:90a:4812:: with SMTP id a18mr37992614pjh.40.1633369477657;
        Mon, 04 Oct 2021 10:44:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p2sm13649148pja.51.2021.10.04.10.44.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 10:44:37 -0700 (PDT)
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
To:     Mark Brown <broonie@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
References: <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk> <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk> <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
 <20211004165127.GZ3544071@ziepe.ca>
 <f481f7cc-6734-59b3-6432-5c2049cd87ea@gmail.com>
 <20211004171301.GA3544071@ziepe.ca> <YVs5gT1rj9HiAW5p@sirena.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8513334a-1de4-bc9c-0157-e792e8ff4871@gmail.com>
Date:   Mon, 4 Oct 2021 10:44:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YVs5gT1rj9HiAW5p@sirena.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/21 10:27 AM, Mark Brown wrote:
> On Mon, Oct 04, 2021 at 02:13:01PM -0300, Jason Gunthorpe wrote:
> 
>> I'm kind of surprised a scheme like this didn't involve a FW call
>> after Linux is done with the CPUs to quiet all the HW and let it
>> sleep, I've built things that way before at least.
> 
> That's a *lot* of code to put in firmware if you can't physically power
> most of the system down.

Indeed, and that also assume it may be possible for firmware to have the
last say, which is not necessarily possible (though that ought to be a
system design issue that would need fixing). It seems reasonable to me
to delegate the powering off of the hardware to the respective Linux
drivers since they ought to be in the best position to make appropriate
decisions for the hardware they control.

Anyway, we are divergin slightly here, how do we go about fixing
.shutdown here?
-- 
Florian
