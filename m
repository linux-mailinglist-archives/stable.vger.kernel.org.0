Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998EF45310C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 12:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhKPLpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 06:45:34 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:55198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhKPLos (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 06:44:48 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3FF991C0B76; Tue, 16 Nov 2021 12:41:48 +0100 (CET)
Date:   Tue, 16 Nov 2021 12:41:47 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.14 232/849] leds: trigger: use RCU to protect the
 led_cdevs list
Message-ID: <20211116114147.GD16318@amd>
References: <20211115165419.961798833@linuxfoundation.org>
 <20211115165428.044566164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <20211115165428.044566164@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-11-15 17:55:15, Greg Kroah-Hartman wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> [ Upstream commit 2a5a8fa8b23144d14567d6f8293dd6fbeecee393 ]
>=20
> Even with the previous commit 27af8e2c90fb
> ("leds: trigger: fix potential deadlock with libata")
> to this file, we still get lockdep unhappy, and Boqun
> explained the report here:
> https://lore.kernel.org/r/YNA+d1X4UkoQ7g8a@boqun-archlinux
>=20
> Effectively, this means that the read_lock_irqsave() isn't
> enough here because another CPU might be trying to do a
> write lock, and thus block the readers.
>=20
> This is all pretty messy, but it doesn't seem right that
> the LEDs framework imposes some locking requirements on
> users, in particular we'd have to make the spinlock in the
> iwlwifi driver always disable IRQs, even if we don't need
> that for any other reason, just to avoid this deadlock.
>=20
> Since writes to the led_cdevs list are rare (and are done
> by userspace), just switch the list to RCU. This costs a
> synchronize_rcu() at removal time so we can ensure things
> are correct, but that seems like a small price to pay for
> getting lock-free iterations and no deadlocks (nor any
> locking requirements imposed on users.)
>=20
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop. We discussed this with Johannes, and it was not marked
for stable on purpose. Bug is rather obscure and change did not have
enough testing.

Best regards,
								Pavel

> ---
>  drivers/leds/led-triggers.c | 41 +++++++++++++++++++------------------
>  include/linux/leds.h        |  2 +-
>  2 files changed, 22 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 4e7b78a84149b..072491d3e17b0 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -157,7 +157,6 @@ EXPORT_SYMBOL_GPL(led_trigger_read);
>  /* Caller must ensure led_cdev->trigger_lock held */
>  int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *t=
rig)
>  {
> -	unsigned long flags;
>  	char *event =3D NULL;
>  	char *envp[2];
>  	const char *name;
> @@ -171,10 +170,13 @@ int led_trigger_set(struct led_classdev *led_cdev, =
struct led_trigger *trig)
> =20
>  	/* Remove any existing trigger */
>  	if (led_cdev->trigger) {
> -		write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
> -		list_del(&led_cdev->trig_list);
> -		write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock,
> -			flags);
> +		spin_lock(&led_cdev->trigger->leddev_list_lock);
> +		list_del_rcu(&led_cdev->trig_list);
> +		spin_unlock(&led_cdev->trigger->leddev_list_lock);
> +
> +		/* ensure it's no longer visible on the led_cdevs list */
> +		synchronize_rcu();
> +
>  		cancel_work_sync(&led_cdev->set_brightness_work);
>  		led_stop_software_blink(led_cdev);
>  		if (led_cdev->trigger->deactivate)
> @@ -186,9 +188,9 @@ int led_trigger_set(struct led_classdev *led_cdev, st=
ruct led_trigger *trig)
>  		led_set_brightness(led_cdev, LED_OFF);
>  	}
>  	if (trig) {
> -		write_lock_irqsave(&trig->leddev_list_lock, flags);
> -		list_add_tail(&led_cdev->trig_list, &trig->led_cdevs);
> -		write_unlock_irqrestore(&trig->leddev_list_lock, flags);
> +		spin_lock(&trig->leddev_list_lock);
> +		list_add_tail_rcu(&led_cdev->trig_list, &trig->led_cdevs);
> +		spin_unlock(&trig->leddev_list_lock);
>  		led_cdev->trigger =3D trig;
> =20
>  		if (trig->activate)
> @@ -223,9 +225,10 @@ err_add_groups:
>  		trig->deactivate(led_cdev);
>  err_activate:
> =20
> -	write_lock_irqsave(&led_cdev->trigger->leddev_list_lock, flags);
> -	list_del(&led_cdev->trig_list);
> -	write_unlock_irqrestore(&led_cdev->trigger->leddev_list_lock, flags);
> +	spin_lock(&led_cdev->trigger->leddev_list_lock);
> +	list_del_rcu(&led_cdev->trig_list);
> +	spin_unlock(&led_cdev->trigger->leddev_list_lock);
> +	synchronize_rcu();
>  	led_cdev->trigger =3D NULL;
>  	led_cdev->trigger_data =3D NULL;
>  	led_set_brightness(led_cdev, LED_OFF);
> @@ -285,7 +288,7 @@ int led_trigger_register(struct led_trigger *trig)
>  	struct led_classdev *led_cdev;
>  	struct led_trigger *_trig;
> =20
> -	rwlock_init(&trig->leddev_list_lock);
> +	spin_lock_init(&trig->leddev_list_lock);
>  	INIT_LIST_HEAD(&trig->led_cdevs);
> =20
>  	down_write(&triggers_list_lock);
> @@ -378,15 +381,14 @@ void led_trigger_event(struct led_trigger *trig,
>  			enum led_brightness brightness)
>  {
>  	struct led_classdev *led_cdev;
> -	unsigned long flags;
> =20
>  	if (!trig)
>  		return;
> =20
> -	read_lock_irqsave(&trig->leddev_list_lock, flags);
> -	list_for_each_entry(led_cdev, &trig->led_cdevs, trig_list)
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list)
>  		led_set_brightness(led_cdev, brightness);
> -	read_unlock_irqrestore(&trig->leddev_list_lock, flags);
> +	rcu_read_unlock();
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_event);
> =20
> @@ -397,20 +399,19 @@ static void led_trigger_blink_setup(struct led_trig=
ger *trig,
>  			     int invert)
>  {
>  	struct led_classdev *led_cdev;
> -	unsigned long flags;
> =20
>  	if (!trig)
>  		return;
> =20
> -	read_lock_irqsave(&trig->leddev_list_lock, flags);
> -	list_for_each_entry(led_cdev, &trig->led_cdevs, trig_list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(led_cdev, &trig->led_cdevs, trig_list) {
>  		if (oneshot)
>  			led_blink_set_oneshot(led_cdev, delay_on, delay_off,
>  					      invert);
>  		else
>  			led_blink_set(led_cdev, delay_on, delay_off);
>  	}
> -	read_unlock_irqrestore(&trig->leddev_list_lock, flags);
> +	rcu_read_unlock();
>  }
> =20
>  void led_trigger_blink(struct led_trigger *trig,
> diff --git a/include/linux/leds.h b/include/linux/leds.h
> index 329fd914cf243..fa59326b0ad9f 100644
> --- a/include/linux/leds.h
> +++ b/include/linux/leds.h
> @@ -354,7 +354,7 @@ struct led_trigger {
>  	struct led_hw_trigger_type *trigger_type;
> =20
>  	/* LEDs under control by this trigger (for simple triggers) */
> -	rwlock_t	  leddev_list_lock;
> +	spinlock_t	  leddev_list_lock;
>  	struct list_head  led_cdevs;
> =20
>  	/* Link to next registered trigger */

--=20
http://www.livejournal.com/~pavelmachek

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGTmPoACgkQMOfwapXb+vITJQCgnCOylJR0hph3324A9RUi79E7
8T0AmwRk0Zl10OFDLyP9NAo/v1AeZMtx
=xW/S
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
