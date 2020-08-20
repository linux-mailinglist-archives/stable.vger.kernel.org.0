Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73F2624BD15
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgHTM6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728208AbgHTM54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 08:57:56 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E4EC061385
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 05:57:55 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BXPnp5gctz9sTN;
        Thu, 20 Aug 2020 22:57:50 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1597928271;
        bh=MGxd9s2W6OeMizI2dQ6n3Kkt0bIh7n4yoMfhByTa3Fs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=qc5jgOlcaahvMe5b4oUe0zO7SgWD/C81qYT5K5pv1fWYC3qayShFs4nccIq01PCeD
         4hF0v36lRbmoMyE587WJeG6JiLgE167kwwZaDNoSbFlAMC1I62EgMpQJllIhAJ9mEU
         iwaI51BuhljJWY6wNRqwL2SgPi44trgTOHxmjoFfO1lI/roesKICLK3P6ZIUeeKGlv
         Jt8dKmQpC40qKAbMHrEoxM6uFTZ/AJWjcJeU6H66HAZSebvSKL8U16jDn3QpezXXdC
         gNFVtUx7pRc9M5HTri8WFXiZyZpvaFeHBcV373zHSjeXQjsONK7V92VvFpP7J/96wO
         nDykW9BjyFU/Q==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     Vasant Hegde <hegdevasant@linux.vnet.ibm.com>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: Re: [PATCH v2] powerpc/pseries: Do not initiate shutdown when system is running on UPS
In-Reply-To: <20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com>
References: <20200820061844.306460-1-hegdevasant@linux.vnet.ibm.com>
Date:   Thu, 20 Aug 2020 22:57:46 +1000
Message-ID: <871rk1iiet.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Vasant Hegde <hegdevasant@linux.vnet.ibm.com> writes:
> As per PAPR we have to look for both EPOW sensor value and event modifier=
 to
> identify type of event and take appropriate action.
>
> Sensor value =3D 3 (EPOW_SYSTEM_SHUTDOWN) schedule system to be shutdown =
after
>                   OS defined delay (default 10 mins).
>
> EPOW Event Modifier for sensor value =3D 3:
>    We have to initiate immediate shutdown for most of the event modifier =
except
>    value =3D 2 (system running on UPS).
>
> Checking with firmware document its clear that we have to wait for predef=
ined
> time before initiating shutdown. If power is restored within time we shou=
ld
> cancel the shutdown process. I think commit 79872e35 accidently enabled
> immediate poweroff for EPOW_SHUTDOWN_ON_UPS event.

It's not that clear to me :)

LoPAPR v1.1 section 10.2.2 includes table 136 "EPOW Action Codes":

  SYSTEM_SHUTDOWN 3
=20=20
  The system must be shut down. An EPOW-aware OS logs the EPOW error
  log information, then schedules the system to be shut down to begin
  after an OS defined delay internal (default is 10 minutes.)

And then in section 10.3.2.2.8 there is table 146 "Platform Event Log
Format, Version 6, EPOW Section", which includes the "EPOW Event
Modifier":

  For EPOW sensor value =3D 3
  0x01 =3D Normal system shutdown with no additional delay
  0x02 =3D Loss of utility power, system is running on UPS/Battery
  0x03 =3D Loss of system critical functions, system should be shutdown
  0x04 =3D Ambient temperature too high
  All other values =3D reserved

There is also section 7.3.6.4 which includes a note saying:

  2. The report that a system needs to be shutdown due to running under
  a UPS would be given by the platform as an EPOW event with EPOW event
  modifier being given as, 0x02 =3D Loss of utility power, system is
  running on UPS/Battery, as described in section Section 10.3.2.2.8=E2=80=
=9A
  =E2=80=9CPlatform Event Log Format, EPOW Section=E2=80=9A=E2=80=9D on pag=
e 308.


So the only mention of the 10 minutes is in relation to all
SYSTEM_SHUTDOWN events. ie. according to that we should not be doing an
immediate shutdown for any of the events.

> We have user space tool (rtas_errd) on LPAR to monitor for EPOW_SHUTDOWN_=
ON_UPS.
> Once it gets event it initiates shutdown after predefined time. Also star=
ts
> monitoring for any new EPOW events. If it receives "Power restored" event
> before predefined time it will cancel the shutdown. Otherwise after
> predefined time it will shutdown the system.

What event are you referring to as the "Power restored" event? AFAICS
PAPR just says we "may" receive an EPOW_RESET.

I can't see anything else about what we're supposed to do if power is
restored.

Anyway I'm not opposed to the change, but I don't think it's correct to
say that PAPR defines the behaviour.

Rather we used to implement a certain behaviour, and we have at least
one customer who relies on that old behaviour and dislikes the new
behaviour. It's also generally good to defer decisions like this to
userspace, so that administrators can customise the behaviour.

Anyway I'll massage the change log a bit to incorporate some of the
above and apply it.

cheers

> Fixes: 79872e35 (powerpc/pseries: All events of EPOW_SYSTEM_SHUTDOWN must=
 initiate shutdown)
> Cc: stable@vger.kernel.org # v4.0+
> Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
> ---
> Changes in v2:
>   - Updated patch description based on mpe, Tyrel comment.
>
> -Vasant
>  arch/powerpc/platforms/pseries/ras.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platform=
s/pseries/ras.c
> index f3736fcd98fc..13c86a292c6d 100644
> --- a/arch/powerpc/platforms/pseries/ras.c
> +++ b/arch/powerpc/platforms/pseries/ras.c
> @@ -184,7 +184,6 @@ static void handle_system_shutdown(char event_modifie=
r)
>  	case EPOW_SHUTDOWN_ON_UPS:
>  		pr_emerg("Loss of system power detected. System is running on"
>  			 " UPS/battery. Check RTAS error log for details\n");
> -		orderly_poweroff(true);
>  		break;
>=20=20
>  	case EPOW_SHUTDOWN_LOSS_OF_CRITICAL_FUNCTIONS:
> --=20
> 2.26.2
