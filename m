Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01862301ACC
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 10:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbhAXJBM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Sun, 24 Jan 2021 04:01:12 -0500
Received: from aposti.net ([89.234.176.197]:43768 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbhAXJBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 04:01:07 -0500
Date:   Sun, 24 Jan 2021 08:38:13 +0000
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [RE-RESEND PATCH 1/4] usb: musb: Fix runtime PM race
 =?UTF-8?Q?in=0D=0A?= musb_queue_resume_work
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Bin Liu <b-liu@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-Id: <PZJFNQ.QM2LFFEGRUXN3@crapouillou.net>
In-Reply-To: <72e48343-f87e-5fed-809c-41995197019e@gmail.com>
References: <20210123142502.16980-1-paul@crapouillou.net>
        <72e48343-f87e-5fed-809c-41995197019e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sergei,


Le sam. 23 janv. 2021 à 19:41, Sergei Shtylyov 
<sergei.shtylyov@gmail.com> a écrit :
> On 1/23/21 5:24 PM, Paul Cercueil wrote:
> 
>>  musb_queue_resume_work() would call the provided callback if the 
>> runtime
>>  PM status was 'active'. Otherwise, it would enqueue the request if 
>> the
>>  hardware was still suspended (musb->is_runtime_suspended is true).
>> 
>>  This causes a race with the runtime PM handlers, as it is possible 
>> to be
>>  in the case where the runtime PM status is not yet 'active', but the
>>  hardware has been awaken (PM resume function has been called).
> 
>    Awakened. :-)

Oops. Hopefully Bin or Greg can fix it when merging (if I don't need to 
v2, that is to say - feedback welcome).

Cheers,
-Paul

>>  When hitting the race, the resume work was not enqueued, which 
>> probably
>>  triggered other bugs further down the stack. For instance, a telnet
>>  connection on Ingenic SoCs would result in a 50/50 chance of a
>>  segmentation fault somewhere in the musb code.
>> 
>>  Rework the code so that either we call the callback directly if
>>  (musb->is_runtime_suspended == 0), or enqueue the query otherwise.
>> 
>>  Fixes: ea2f35c01d5e ("usb: musb: Fix sleeping function called from 
>> invalid context for hdrc glue")
>>  Cc: stable@vger.kernel.org # v4.9+
>>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  Reviewed-by: Tony Lindgren <tony@atomide.com>
>>  Tested-by: Tony Lindgren <tony@atomide.com>
> [...]
> 
> 
> MBR, Sergei


