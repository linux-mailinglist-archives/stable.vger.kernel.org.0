Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CC127A500
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 03:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgI1BCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Sep 2020 21:02:42 -0400
Received: from crapouillou.net ([89.234.176.41]:48806 "EHLO crapouillou.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1BCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Sep 2020 21:02:42 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Sep 2020 21:02:41 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1601254367; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uU9mEhp+bofOdqwM+UmLX04vTcdRLkBuJKUG0hs8TDk=;
        b=kb0XHpdJ2nM/+kdvGWkHKWf79KrlAV78MrWa/VnHxVCIAQ4Qe/7LynhiYK4J0I8JoKiTtQ
        G2uqVi2BK39a5Etx0Q2xkkFIIgtscjAwjGYPheZr5meefwYjiF41gS99cNr9x80EoMb6Tc
        3HJgFVz3JjYqdMuZVEx3+UySHVSwv7U=
Date:   Mon, 28 Sep 2020 02:52:35 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] usb: musb: Fix runtime PM race in musb_queue_resume_work
To:     Bin Liu <b-liu@ti.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>, od@zcrc.me,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Message-Id: <NRFCHQ.NJA64RB57HU9@crapouillou.net>
In-Reply-To: <20200817105926.GF2994@atomide.com>
References: <20200809125359.31025-1-paul@crapouillou.net>
        <20200817105926.GF2994@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Le lun. 17 ao=FBt 2020 =E0 13:59, Tony Lindgren <tony@atomide.com> a=20
=E9crit :
> * Paul Cercueil <paul@crapouillou.net> [200809 12:54]:
>>  musb_queue_resume_work() would call the provided callback if the=20
>> runtime
>>  PM status was 'active'. Otherwise, it would enqueue the request if=20
>> the
>>  hardware was still suspended (musb->is_runtime_suspended is true).
>>=20
>>  This causes a race with the runtime PM handlers, as it is possible=20
>> to be
>>  in the case where the runtime PM status is not yet 'active', but the
>>  hardware has been awaken (PM resume function has been called).
>>=20
>>  When hitting the race, the resume work was not enqueued, which=20
>> probably
>>  triggered other bugs further down the stack. For instance, a telnet
>>  connection on Ingenic SoCs would result in a 50/50 chance of a
>>  segmentation fault somewhere in the musb code.
>>=20
>>  Rework the code so that either we call the callback directly if
>>  (musb->is_runtime_suspended =3D=3D 0), or enqueue the query otherwise.
>=20
> Yes we should use is_runtime_suspended, thanks for fixing it.
> Things still work for me so:
>=20
> Reviewed-by: Tony Lindgren <tony@atomide.com>
> Tested-by: Tony Lindgren <tony@atomide.com>

Bin, can you take this patch?

Thanks,
-Paul


