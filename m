Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60A0610BCC
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 10:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiJ1IHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 04:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ1IHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 04:07:12 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0B414D1DE;
        Fri, 28 Oct 2022 01:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1666944413; bh=x/5w/cGYdibUL64Yl4ECGE+0k1q6HN5SEpULyLqnnTY=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=M07rrsMbhbuAELDz/7pjFJXp6LxO55xMMKZZzmTms1N3NFUoRV0FUYBa0FBEUMW+s
         1/cLEsSXpsmeHZV77wIoA1FHjW1rI6Sf2BYSAkdueNh6c+3g2wEabdPczoMI9ZgNmv
         YysqkBrPDZFP1rNy6frNCv5Sfn4dSDy8XeVhBcGlDDrGBmI6qAY7D4q5dGaAdupqoL
         UCJZIqtsjamsUGaQCWcIsmutNpKzXSoM/14Uq+u9aRfoWbj3uSAMEXevNbxLUMs87b
         e21/0EWHTKNm7ucaP58PJrWMfC9QXcuFz4CBAVCp5gXld8Yq7BxszvbdTT/BrH6bTj
         28owU4M1GdCIQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.2.83] ([84.162.5.241]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MqJm5-1pR0zm2vzP-00nN7V; Fri, 28
 Oct 2022 10:06:53 +0200
Message-ID: <4ff347e8-1ef4-e006-01db-3d420213f6e3@gmx.de>
Date:   Fri, 28 Oct 2022 10:06:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 v2 1/2] serial: core: move RS485 configuration tasks
 from drivers into core
Content-Language: en-US
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lukas Wunner <lukas@wunner.de>, stable@vger.kernel.org,
        =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Roosen Henri <Henri.Roosen@ginzinger.com>,
        linux-serial@vger.kernel.org,
        Daisuke Mizobuchi <mizo@atmark-techno.com>
References: <20221017051737.51727-1-dominique.martinet@atmark-techno.com>
 <Y1lmM7Qu1yscuaIU@kroah.com> <Y1nPFe6IaRI7j6fE@atmark-techno.com>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
In-Reply-To: <Y1nPFe6IaRI7j6fE@atmark-techno.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:7kcgS7x37TR5Kk8FR4wt1f1+cw/bPg19ZJA0AU6Ho4uaFKe1+l/
 FDTK18fNl4Kv7ymaYJHwSgbkVF3+IRATd0eKFbnXy8H+14D7E/StIe8n4y0YUrljBA5ECp7
 ZwWe+8QfODDsCBhrK+P/WjnbBv3M1J+ezPTqyz66m6oBFY46deM1KohhRWaIYPG7j8TWqxM
 GiloMO0wK6mf2rrDLFsBA==
UI-OutboundReport: notjunk:1;M01:P0:2yiIC+5nqmc=;FRIoq7hVgVvG/SWJ41HrD3u+pO6
 rLfz/DJ8c4zrm95jodpW2/52f9Z/e8z1rZqSJBbhfItJBGLT6ZJ07ZCknxQZNqOR7SmOu7vnY
 SWwXYjSdJrSoAE8n8pJioyBjNwDzK7zkUuGW8tAvWFqBJ9UZw12TaBq+iGPQBxaKlC77CmEzm
 W7tlQ3dpXjypckBZYB1tr8xHZaqoF5yjcf0m5brJSLUXmNwgLMn9+ttb0SajJoCkwJ2Bd1L31
 iKMaf33croNTyIMeV3uLvFww5W4K3jUA6jaavTdS8rfvc3Ii0eBjkFgnj23283iytcln1QK/v
 VK7KA2MCGDGTMT0EW7SKHzTQWNltL1fdRIv3BiwHkiCZQ7kGk0D2EGO57c9560paZ7/ZSmp8j
 ZyAVJFkUsQ60kJfwOWFdxZl1ARMNfGtURRorKWA6yN+8B4vQCscFFyqnPkGXJ9OOcQCZ7AmWl
 DRcqXDo7GSqYcwqoNpdxB7I42jrF3NEV77DQib5rhDjK4M4m2jr5zo73ZqVbofply9MChPqzu
 PJV7GfbB/qldkuKeb1j8D++rWaJt09vxOePQQuf84J7lEb6oCZpYTof035C9AB5RArvWp5zrW
 XbZZVcoSFR2tOOI6pUo5IukjjsEd4bZRjcCA2VFnui9TJCCVL1GkyZ8CJ1rRrjU5/6lUpnpLU
 07TkwDxH2pdZIT1FICkqqRL285bY9ryk5Row4QZ9YAr9qgT0CEneaZOztu6LoP5+ILd46LawQ
 /jQDtKZX0rVV9Qz03hM0Shq3RkLhJAbd4XIDeluJpC9GWUGzyQboExIhS13ydkgUb4RCHKjP3
 1PcPka9nX0AmORfQ3ul0nzo0HeVprRpos7+aBUJTgUXU3qaBq9JacDOmU3iEUr+y5Q1DrzWYw
 CPQK38WfdNVIxQ6PmQ6vVaM1E/IwSGCkhvmq5Jc9pCIudq6SEAxSWCVAdApTephyswnIlHyb5
 xS+7uQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27.10.22 02:21, Dominique Martinet wrote:
> Greg Kroah-Hartman wrote on Wed, Oct 26, 2022 at 06:54:11PM +0200:
>> On Mon, Oct 17, 2022 at 02:17:36PM +0900, Dominique Martinet wrote:
>>> From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>>>
>>> Several drivers that support setting the RS485 configuration via users=
pace
>>> implement one or more of the following tasks:
>>>
>>> - in case of an invalid RTS configuration (both RTS after send and RTS=
 on
>>>   send set or both unset) fall back to enable RTS on send and disable =
RTS
>>>   after send
>>>
>>> - nullify the padding field of the returned serial_rs485 struct
>>>
>>> - copy the configuration into the uart port struct
>>>
>>> - limit RTS delays to 100 ms
>>>
>>> Move these tasks into the serial core to make them generic and to prov=
ide
>>> a consistent behaviour among all drivers.
>>>
>>> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
>>> Link: https://lore.kernel.org/r/20220410104642.32195-2-LinoSanfilippo@=
gmx.de
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> [ Upstream commit 0ed12afa5655512ee418047fb3546d229df20aa1 ]
>>> Signed-off-by: Daisuke Mizobuchi <mizo@atmark-techno.com>
>>> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.co=
m>
>>> ---
>>> Follow-up of https://lkml.kernel.org/r/20221017013807.34614-1-dominiqu=
e.martinet@atmark-techno.com
>>
>> I need a 5.15.y version of this series before I can take the 5.10.y
>> version.
>
> Thanks for the probing, I did not know about this rule (but it makes
> sense); I've just sent a 5.15 version:
> https://lkml.kernel.org/r/20221027001943.637449-1-dominique.martinet@atm=
ark-techno.com
>
> I'd really appreciate if Lino could take a look and confirm we didn't
> botch this too much -- we've tested the 5.10 version and it looks ok,
> but this is different enough from the original patch to warrant a check
> from the author.

Concerning the part I authored (patch 1) I do not see any changes, so

Acked-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

However the part Lukas authored (patch 2) seems to be the one that has bee=
n adjusted
a lot, so maybe you rather/also want to have his ack?

Best Regards,
Lino



