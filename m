Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0057D32D41A
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241087AbhCDNZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:25:39 -0500
Received: from mout.gmx.net ([212.227.17.21]:53011 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241086AbhCDNZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 08:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614864208;
        bh=gJRe0AoMraU9x0n2REXSwjSEb1jWncPwJ3G/GKIwfjs=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=HNVvTiJqcs1KdrYfJZ6MoP2TDpy5sRZooSu80R6dbAL6LIYZrtYp3/+fDWfWBYvwB
         eCBc/Cz49FufyTgY8ij+UR+C0AE/bww2XCWJZ/EblB5DqFDP8TAQDHo3KRueDvDCsI
         NFA0RBrQronuDe0edGMb2IGZ250NuWo4SB1kIVjk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.191.219.128]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MwQXN-1laZDp3ABB-00sMMR; Thu, 04
 Mar 2021 14:23:28 +0100
Message-ID: <a751252ee17f64ec82e44ae2d64fc217e3849202.camel@gmx.de>
Subject: Re: futex breakage in 4.9 stable branch
From:   Mike Galbraith <efault@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, lwn@lwn.net,
        jslaby@suse.cz, Thomas Gleixner <tglx@linutronix.de>
Date:   Thu, 04 Mar 2021 14:23:27 +0100
In-Reply-To: <YEDckK+g7VosvtGK@kroah.com>
References: <161408880177110@kroah.com>
         <66826ac72356b00814f51487dd1008298e52ed9b.camel@decadent.org.uk>
         <YDygp3WYafzcgt+s@kroah.com> <YD0kkNH+I4xyoTwy@decadent.org.uk>
         <5d9c74ad033e898111e5a1e931b266912487b595.camel@gmx.de>
         <YEDckK+g7VosvtGK@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:XfLjWg1thbqE+db4lHtlw6iuHTz/QTcBIgtlFq7H0imWU6KMjHm
 wcDRBPTtMo8d5tKmboELi2JAhJRhkCsTTZiOXLqiVk4EnSLTbin7eWBwBPrdTK0Id3+gatE
 n9LXE8iucbiPSaWWSV2SnbPhwp3EYNQyS8AGV+Hpvn65gmxFDz76h531ZTMbhuCIY8+nP3u
 Diis1q9lzwrI3NIvPNqEw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IMWncCc3n+U=:4FWa8MNVvKgKGYwFqiCSmM
 VDGpq/mdJ7r+T1YHXR5YiUZpH01wWhb1hdU4dsmPtmVyU1wxbYCCAiFAhGZ6uq8Ix9ctVET2X
 Nx4Ruzh545TYaiv3XOJTS/3/JUlUXx0CH5kh9udiCcyJNA1djFa8vlDN1S6KtA5J+f/rYZm7q
 9Sm90jlReliyMLvSo8DkbxcTWPYSb2X9bQUB0D3VdGAnqD13ZMCBNLq2RB9yvlcSaRkwJRaiX
 d5/QSD6mpDedvGf+fom4/IrAOIJEMyuYYhXjKo4dg4f27jZ1O/dNnQeAAu9HahvvuOmePqiZO
 guyM9w4GdFl+LVlguD+Rf8hkfVo5fp97NWJCdLcDwiRSdx5qkBFu6U+7GQXgQ9jawm1fHCEYJ
 xI0qsXTeiE6eQF8GKXHZs/Zowy3yqACBbVxkSZ9VldVVbb+uz3lbkuacExx84ohMOrgkYO2ZP
 +CjqHm6rz7Gk0j/lcxvmr3eVtb2ScgfgHcKr2snZ6VB97rQCH2u+FiCUVhgnT7T1tSomXQjsF
 7lmP3cN6VXSvEjTY304spwOYhkrmZjNfYz7+XYYl3k6Da/mQ1SfC+EzmZ7pzx2a1uxCusfmHT
 d7ze7uJaEG/8mhkuIVMm0I7o+BXsWtaD/W68iAOyclOBAAxm2mLXliNFh7skqIMT0eSr+9Nyp
 di6oPQ+yGgcNFy3RgKvEYSks3Ag/6raz2Rus7LZlQd1CWhFKlxo3++UWyOTe0qVMkLv8P1ss/
 iqnMbnaWy1D0sOGNiJFPw+dhFfRjcRwuZzeMzR8KsjPSoJbDIQZFpbUZwSwutn16F/3UlKI2E
 D9nhSAUW8pv9spsgWT/ftKiqKjewA6eXezmNt795TP3msXeefzC7ITWuNHPTuW1M7fyNhRvyx
 YM8kTBDIHZAaVGyEOhjQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-03-04 at 14:11 +0100, Greg Kroah-Hartman wrote:
> On Thu, Mar 04, 2021 at 10:12:56AM +0100, Mike Galbraith wrote:
>
> > futex: fix 4.4-stable 34c8e1c2c025 backport inspired lockdep complaint
> >
> > 1. 34c8e1c2c025 "futex: Provide and use pi_state_update_owner()" was b=
ackported
> > to stable, leading to the therein assertion that pi_state->pi_mutex.wa=
it_lock
> > be held triggering in 4.4-stable.  Fixing that leads to lockdep moan p=
art 2.
> >
> > 2: b4abf91047cf "rtmutex: Make wait_lock irq safe" is absent in 4.4-st=
able, but
> > wake_futex_pi() nonetheless managed to acquire an unbalanced raw_spin_=
lock()
> > raw_spin_inlock_irq() pair, which inspires lockdep to moan after afore=
mentioned
> > assert has been appeased.
> >
> > With this applied, futex tests pass, and no longer inspire lockdep gri=
peage.
> >
> > Not-Signed-off-by: Mike Galbraith <efault@gmx.de>
> > ---
> >  kernel/futex.c |    6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -874,8 +874,12 @@ static void free_pi_state(struct futex_p
> >  	 * and has cleaned up the pi_state already
> >  	 */
> >  	if (pi_state->owner) {
> > +		unsigned long flags;
> > +
> > +		raw_spin_lock_irqsave(&pi_state->pi_mutex.wait_lock, flags);
> >  		pi_state_update_owner(pi_state, NULL);
> >  		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
> > +		raw_spin_unlock_irqrestore(&pi_state->pi_mutex.wait_lock, flags);
> >  	}
> >
> >  	if (current->pi_state_cache)
> > @@ -1406,7 +1410,7 @@ static int wake_futex_pi(u32 __user *uad
> >  	if (pi_state->owner !=3D current)
> >  		return -EINVAL;
> >
> > -	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> > +	raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
> >  	new_owner =3D rt_mutex_next_owner(&pi_state->pi_mutex);
> >
> >  	/*
> >
>
> Care to sign-off on it so that if this is correct, I can apply it?  :)

Consider it signed off iff Thomas acks it.  I think it's correct.. just
like the guys who have installed every other bug in the damn things,
just a wee bit less over-confident :)

	-Mike

