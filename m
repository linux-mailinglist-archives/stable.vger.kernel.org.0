Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28ABF68AA27
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 14:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbjBDNcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 08:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233723AbjBDNcE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 08:32:04 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8585338E8F;
        Sat,  4 Feb 2023 05:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1675517484; bh=JmNQMhDVYE6HTRGGF7ip3u8xIrOvPY8fxYH0WA8Xc3o=;
        h=X-UI-Sender-Class:Date:Subject:To:References:From:In-Reply-To;
        b=Nl9idx2+J7BR8+6Ji9RTods7QTPkL8EUdZ/6zRugiYE7XbAjXI0mE46N5r5XQ65vR
         V213nAb61LdHeuv5nMxx8JshW4Gm/BlgX9KZ/S9Xd8xjB6nIWBAxy0GQsAfby5aPnZ
         tQYCCKbRJAtRkyJYq0jZAk46BtHN3XZZOx0gN/d7t4ygtlVeR0eC6v29b8YosiaHBe
         L7ZscKyJDWutm++r3mTBxaBAE6jKWd1/omynFiJ1vXm8rNgZEJmQHVnnx80pgdR9es
         5ZDDceKKkshsO2j7wNVDz20pADD66vDbnawcQuD/uJPKBNiHYSoJillLwwIg3aqtsP
         hUHSE8xHQqiAA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([92.116.151.109]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N79u8-1oYg0u0AO4-017Sf4; Sat, 04
 Feb 2023 14:31:24 +0100
Message-ID: <5fcd25ee-07bb-6eab-3e73-22680a0104bf@gmx.de>
Date:   Sat, 4 Feb 2023 14:31:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCHv2] fbcon: Check font dimension limits
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Daniel Vetter <daniel@ffwll.ch>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Sanan Hasanov <sanan.hasanov@knights.ucf.edu>
References: <20230129151740.x5p7jj2pbuilpzzt@begin>
 <Y9kq4ZoBs8LkEtqs@kroah.com>
From:   Helge Deller <deller@gmx.de>
In-Reply-To: <Y9kq4ZoBs8LkEtqs@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mFA08GgcKqDGyKWP6edsJPY+2S/tECSNGrcGyR90v+m7m2pcCMB
 73i0y88ik/5FFH0DqwYUjJBWn5/4qDUooAMFHJQcfg5EUoGiU166QbTTdZ29/qElgYJbPrJ
 wvdGyyrIM4vod0QU8YtFAbLO3XpRSNAs28BWZDgPJg7d0P6kiaWX/AZ7KJ8oaLnUbCVBf1F
 9d89/7iD18mjri/B0QQYg==
UI-OutboundReport: notjunk:1;M01:P0:Jep8DGUR1Jw=;v4xqMDz47w93YWvJczXEDaP8KBV
 /lWn4l7hUyuvxqm34NE9BDV/0TmjdzVWgi9J3gmXk5Rt/IkVipmo368S5CQWny2mhyjneCept
 A4zaSYSi81C5raDAk7shEseDldv8jhjDvaVNQMTHZ109PgrLwbsPsLnzPzkc0u1DYB5dF1PXt
 xYJdWQ+fzbKnHbZy0lkVVlYqcqIj9In62JXgUnC1QGc7IY8FoIJONY20RnWzMk5ytJAMLKkzz
 RJ1LEtp7GcImoo1fys+ARig69fBRbcJRCTRdMtXL/p0LnNqv0MrFyH9TPtsjMgasbIRqfQ6yN
 4TBmskzm2ERw6CukOAJFxYu3u+ChIGureU9HND/yZjcWSL+BB+PuqCBvq1BcOQbWVU7MJtrGK
 TXZXocov5/oblUw/EudaPiiysalOE+qPcL04NPBCo/zSDLghem/wGscJjKPQTTdwwxtzLQKWt
 +8H6zD4keiwg2xAZz5QfqxXN1EE5INXRkkPraq+yq3IiMhhNs09a4NjOi8IFRPqr/Gc7PXr30
 o52S1y+G2pYFfDjwtMPYbiu70CO4QhCvOZ682DJ6RwtvF1Bldp1gmx95sslffVx9Hdnm01wF5
 XHuFl1jeXVjTyz08N0WjSyT+TaBBu8MeyVsnAw0eE82a+3BIPOZBCIAm7T/iNHzDXQZD9gjd6
 hPUf1nbrkcJp+Xh4NtSCcm0Rc5mMwOEuug0AZ4H2USLdNNP3fuLqI+4vQsnLDjn+enhDNjyUa
 ytns0zNx2JZ+eobMjB5E0IeVKKWcObdG482CwqOVB26TXwVHUYcI3GPSxPSItA3DNyNCtvv0u
 Gp9XBSVmm3UKFD4erLObca00bDc9XR1I9apLtVrau7lA7lQCBaG9S6aRDFWP/aU6/18+B2Ebo
 ThY9drGSNj+dXcBIXJt/Mh39NS46HXD4pO5j/eNNj8hKehDXfWk+GJRL3GXiDzoUD4sXKZUdE
 tXVYAvT5noZsGD41EjmSgQWKWodRMhbSQApq/PMtK/4MXkjMA/LhYrDpUvggtNwQwNNFaA==
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/23 15:51, Greg KH wrote:
> On Sun, Jan 29, 2023 at 04:17:40PM +0100, Samuel Thibault wrote:
>> blit_x and blit_y are u32, so fbcon currently cannot support fonts
>> larger than 32x32.
>>
>> The 32x32 case also needs shifting an unsigned int, to properly set bit
>> 31, otherwise we get "UBSAN: shift-out-of-bounds in fbcon_set_font",
>> as reported on:
>>
>> http://lore.kernel.org/all/IA1PR07MB98308653E259A6F2CE94A4AFABCE9@IA1PR=
07MB9830.namprd07.prod.outlook.com
>> Kernel Branch: 6.2.0-rc5-next-20230124
>> Kernel config: https://drive.google.com/file/d/1F-LszDAizEEH0ZX0HcSR06v=
5q8FPl2Uv/view?usp=3Dsharing
>> Reproducer: https://drive.google.com/file/d/1mP1jcLBY7vWCNM60OMf-ogw-ur=
QRjNrm/view?usp=3Dsharing
>>
>> Reported-by: Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
>> Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
>> Fixes: 2d2699d98492 ("fbcon: font setting should check limitation of dr=
iver")
>> Cc: stable@vger.kernel.org
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

applied to fbdev git tree.

Thanks!
Helge
