Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA6612AA6CB
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 18:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727550AbgKGRGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 12:06:08 -0500
Received: from mout.gmx.net ([212.227.15.15]:50213 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbgKGRGI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Nov 2020 12:06:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1604768751;
        bh=Gu0WHITa0criXSqANy2S1d1UtRU7iAxv438rr4aOewU=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=QlA7eViqDE4BJp/uod6GWfIibxEw0X/Af7089XXhdesg7jGPSv+HBEvcFNLzHwBPv
         5w3feqSzysWuSq4rNX4InKiEcpXV0MGjn++U8O5YW/9AAwnoKnW3JqNvMjnypQwG+x
         xkHGUfZG1B8ZLjRLoU95zCZ7Gy+gVS7Nc/Xv/0I0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([188.174.243.132]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MfHEP-1k8QEf49RD-00grVP; Sat, 07
 Nov 2020 18:05:51 +0100
Message-ID: <c35f88c5eb00c69fa74bbc7225316307a5eb38d8.camel@gmx.de>
Subject: Re: [tip: locking/urgent] futex: Handle transient "ownerless"
 rtmutex state correctly
From:   Mike Galbraith <efault@gmx.de>
To:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Cc:     Gratian Crisan <gratian.crisan@ni.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86 <x86@kernel.org>
Date:   Sat, 07 Nov 2020 18:05:50 +0100
In-Reply-To: <160469801844.397.7418241151599681987.tip-bot2@tip-bot2>
References: <87a6w6x7bb.fsf@ni.com>
         <160469801844.397.7418241151599681987.tip-bot2@tip-bot2>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZiuJpoFJYDSR3qK2/20rrBaJA+nWuFyZ+EthNZWpgv9Uw3F0lUt
 ai/drL6/+w8HYHW8pGHpcR9RfEVPIn7VWZuiNqplOsou85AQdwmP65ymQD706F0jbUPzr50
 U9VW2InHnT80E8OdDSnluA+eQ++jg5ohyPBt8lGugZTl8auy7WelopmOyqGPjTryXdlccyq
 ghE2l9/0R5ZP3rcjuYDyA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Kx50ttsafBs=:/6qke+AmwAAMFP7RyqRuTZ
 jubrDnTO3UXJYxzwEmX+vqlc5LQaiyRbPkAXdu46+rbUnPJ9ACpgBDoXocinlxyMmMK9IBlF+
 hrjpcyxz0XGA4qKu7t/fxnaE75tvNLY0dxMSGbAmAOwPcCtvBNKaGnrriQZxZ6wqO036DsLSu
 cUYABAV9hZSMsxnSPtRLEfK9ViMJeVz9GclQGF4TapNxaPT2aEfdHVsb7EqQ7mWyWX7KOKmgG
 FLXPoh2mZliusRg/fG1UOPSei7owE6ZmBZHiFg6K7EgYKvLZVC4ncWGiyPadusgCMv7CVjXEi
 bkSz/3kBE0d/v9uWPDV1vN/wH8CuDopb9yd62IIMoB+MC88e6phlKH6v+da0mkokVK8SPhvnu
 Z+BkmTIkGiWx5ckZmVIuSUzUoNDbkf8O0+FAcUn/eEJI1pNTXsNagz6Ma8C/BAWFRJ4DoC8yL
 HZLMrm6+U+tcAH5Q4lB0sEPhJNO/5tDaJk5Z+98nxVUxBssQfjkc8UJEEaQwxCOIp6s7ElqCx
 cY34TJS5yzuIDwew/l649PI2R5pvOYPerHN6idoaD60R3oujCbTCAROP41uT2m7YqvbpAyKco
 3WOeQRdxLJiiF+ln/WtzQ51JLDLvyZPhaD2gJMp3PaWdXvJ6V9fQEwl+IOc/2YwbX3AGfLlDg
 odJuNe5sVaoVy90E4djg90lJTjmwO1+5UiR32RscbXmAUUDzWHMTU7UadxmsMBxggRJ/UHFgi
 X2/izC2UmBzYUx8OoUZXhbOofrwgaW7E72uIyqqBthqZE3Bc2T1PMvplielFGfFkc077fYXX5
 ulmIiB0Lx8VwVAbjEwFCViFt+/LZoB8tv+AQThP48QWrTwMkzY20u3Boa/4nG+IfyDg4ZxWQn
 cDqKJ3RaaCSfTZT6HbYQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-11-06 at 21:26 +0000, tip-bot2 for Mike Galbraith wrote:
>
> ---
>  kernel/futex.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index f8614ef..7406914 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2380,10 +2380,22 @@ retry:
>  		}
>
>  		/*
> -		 * Since we just failed the trylock; there must be an owner.
> +		 * The trylock just failed, so either there is an owner or
> +		 * there is a higher priority waiter than this one.
>  		 */
>  		newowner =3D rt_mutex_owner(&pi_state->pi_mutex);
> -		BUG_ON(!newowner);
> +		/*
> +		 * If the higher priority waiter has not yet taken over the
> +		 * rtmutex then newowner is NULL. We can't return here with
> +		 * that state because it's inconsistent vs. the user space
> +		 * state. So drop the locks and try again. It's a valid
> +		 * situation and not any different from the other retry
> +		 * conditions.
> +		 */
> +		if (unlikely(!newowner)) {
> +			ret =3D -EAGAIN;
                        ^^^

My box just discovered an unnoticed typo.  That 'ret' should read 'err'
so we goto retry, else fbomb_v2 proggy will trigger gripeage.

[   44.089233] fuse: init (API version 7.32)
[   78.485163] ------------[ cut here ]------------
[   78.485171] WARNING: CPU: 1 PID: 4557 at kernel/futex.c:2482 fixup_pi_s=
tate_owner.isra.17+0x125/0x350
[   78.485171] ------------[ cut here ]------------
[   78.485174] WARNING: CPU: 2 PID: 4559 at kernel/futex.c:1486 do_futex+0=
x920/0xaf0
<snip>

	-Mike

