Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7985E5332AB
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 22:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiEXUyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 16:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241026AbiEXUyh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 16:54:37 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B8B719C6
        for <stable@vger.kernel.org>; Tue, 24 May 2022 13:54:35 -0700 (PDT)
Received: from geek500.localdomain (unknown [82.65.8.64])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp5-g21.free.fr (Postfix) with ESMTPSA id 69C0E5FF93;
        Tue, 24 May 2022 22:54:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1653425673;
        bh=z+3AL2qquLqGmlmNhx0Fx6E/xC1cyjQNcHDdf2pU3yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9uuYvUAE072vyJD5dXBf4PMACYPYp1Yga/leyRNQ7c3X+d9clygeQhoEWc5IxDNG
         j9Y9XMXtpWjPAXJmfYSuZUxwsClzg0yg177UCZGDAKH+6hc5qY9/RPnK3qiqIogOft
         2N7cWM2QjROZOQgG3bJA9Ua4srz4VyHz81eMV4puiaqYzx4h8p17pVIxjxelfu4Pt2
         EhDL+CktJZxCybFO+boHLIDfAH1jdjZd0uNdG7/SRbk0arQUCDHOCMc/rNdmDIbT9T
         ycwdDDVCX8kADs7UDsxpGu8P1Xk2Lc+bT3DLcdTUbQp2dPy9xxUfOOOwW8fms0kH5c
         bFErP5Y1gHdiQ==
From:   Christian Casteyde <casteyde.christian@free.fr>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
Date:   Tue, 24 May 2022 22:54:18 +0200
Message-ID: <2175827.vFx2qVVIhK@geek500.localdomain>
In-Reply-To: <2408578.XAFRqVoOGU@geek500.localdomain>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net> <2585440.lGaqSPkdTl@geek500.localdomain> <2408578.XAFRqVoOGU@geek500.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Conclusion from gitlab discussion

There are three different problems at stake here:

1. First suspend failure after boot is due to TAD driver.
When it is loaded, first suspend deep fails.
This is the root cause of the following sequence.
TAD seems to be not completely functionnal on my laptop, sysfs returns IO=20
errors (missing handlers in dmesg).
After the first failure, every "deep" attempt work.

2.  When suspend deep fails, elogind (used by Slackware 15) falls back to=20
s2idle.
This behaviour is documented in logind.conf man page, and normaly can be=20
configured (side note: I didn't manage to do so, it ignores my configuratio=
n=20
file).

3. When suspend to s2idle, the GPU fails to suspend and need a reset.
This reset must be done in pm_suspend (not totally ok if reset at resume).
However, the laptop indeed goes into s2idle.
In this state, the power button awakes it: this part is handled by the BIOS=
=20
and not the distribution (which shut downs if not suspended).
This is what doesn't work anymore un 5.17.4 and 5.18.

The root cause is therefore the ACPI TAD preventing the first deep suspend =
to=20
complete, then elogind asking for a s2idle in fallback, then s2idle leaving=
=20
the APU in inconsistent state, that can only be fixed by a reset in=20
pm_suspend, and not pm_suspend_noirq or pm_suspend_late.

I will open a separate bug for the ACPI TAD problem. For now I will run=20
without this driver, as deep suspend works fine in this case and s2idle is=
=20
therefore useless for me.

CC


Le lundi 23 mai 2022, 19:03:27 CEST Christian Casteyde a =E9crit :
> I've opened the gitlab entry for this discussion:
> https://gitlab.freedesktop.org/drm/amd/-/issues/2023
>=20
> I confirm I 'm not receiving mails anymore from the mailing list but I'll
> follow gitlab.
>=20
> In reply to the patch proposed by Mario:
> https://patchwork.freedesktop.org/patch/486836/
> With this patch applied on vanilla 5.18 kernel:
> - suspend still fails;
> - after suspend attempt, the screen comes back with only the cursor;
> - switching to a console let me get the following dmesg file.
>=20
> CC
>=20
> Le lundi 23 mai 2022, 15:02:53 CEST Christian Casteyde a =E9crit :
> > Hello
> >=20
> > I've checked with 5.18 the problem is still there.
> > Interestingly, I tried to revert the commit but it was rejected because=
 of
> >=20
> > the change in the test from:
> >         if (!adev->in_s0ix)
> >=20
> > to:
> >       if (amdgpu_acpi_should_gpu_reset(adev))
> >=20
> > in amdgpu_pmops_suspend.
> >=20
> > I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
> > Then I changed to restore test of in_s0ix as it was in 5.17, and it wor=
ks.
> > I tried with a call to amd_gpu_asic_reset without testing at all in_s0i=
x,
> > it works.
> >=20
> > Therefore, my APU wants a reset in amdgpu_pmops_suspend.
> >=20
> > By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as =
was
> > intended in 5.18 original code, commenting out the test of
> > amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
> > This does not work, I got the Fence timeout errors or freezes.
> >=20
> > If I leave  noirq function unchanged (original 5.18 code), and just add=
 a
> > reset in suspend() as was done in 5.17, it works.
> >=20
> > Therefore, my GPU does NOT want to be reset in noirq, the reset must be=
 in
> > suspend.
> >=20
> > In other words, I modified amdgpu_pmops_suspend (partial revert) like t=
his
> > and this works on my laptop:
> >=20
> > static int amdgpu_pmops_suspend(struct device *dev)
> > {
> >=20
> > 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> > 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> >=20
> > +	int r;
> >=20
> > 	if (amdgpu_acpi_is_s0ix_active(adev))
> > =09
> > 		adev->in_s0ix =3D true;
> > =09
> > 	else
> > =09
> > 		adev->in_s3 =3D true;
> >=20
> > -	return amdgpu_device_suspend(drm_dev, true);
> > +	r =3D amdgpu_device_suspend(drm_dev, true);
> > +	if (r)
> > +		return r;
> > +	if (!adev->in_s0ix)
> > +		return amdgpu_asic_reset(adev);
> >=20
> > 	return 0;
> >=20
> > }
> >=20
> > static int amdgpu_pmops_suspend_noirq(struct device *dev)
> > {
> >=20
> > 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> > 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> > =09
> > 	if (amdgpu_acpi_should_gpu_reset(adev))
> > =09
> > 		return amdgpu_asic_reset(adev);
> > =09
> > 	return 0;
> >=20
> > }
> >=20
> > I don't know if other APU want a reset, in the same context, and how to
> > differentiate all the cases, so I cannot go further, but I can test
> > patches
> > if needed.
> >=20
> > CC
> >=20
> > Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a =E9crit :
> > > On 18.05.22 07:54, Kai-Heng Feng wrote:
> > > > On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> > > >=20
> > > > <regressions@leemhuis.info> wrote:
> > > >> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
> > > >>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd=
0da
> > > >>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"=
),
> > > >>> and
> > > >>> the problem disappears so it's really this commit that breaks.
> > > >>=20
> > > >> In that case I'll update the regzbot status to make sure it's visi=
ble
> > > >> as
> > > >> regression introduced in the 5.18 cycle:
> > > >>=20
> > > >> #regzbot introduced: 887f75cfd0da
> > > >>=20
> > > >> BTW: obviously would be nice to get this fixed before 5.18 is
> > > >> released
> > > >> (which might already happen on Sunday), especially as the culprit
> > > >> apparently was already backported to stable, but I guess that won't
> > > >> be
> > > >> easy...
> > > >>=20
> > > >> Which made me wondering: is reverting the culprit temporarily in
> > > >> mainline (and reapplying it later with a fix) a option here?
> > > >=20
> > > > It's too soon to call it's the culprit.
> > >=20
> > > Well, sure, the root-cause might be somewhere else. But from the point
> > > of kernel regressions (and tracking them) it's the culprit, as that's
> > > the change that triggers the misbehavior. And that's how Linus
> > > approaches these things as well when it comes to reverting to fix
> > > regressions -- and he even might...
> > >=20
> > > > The suspend on the system
> > > > doesn't work properly at the first place.
> > >=20
> > > ...ignore things like this, as long as a revert is unlikely to cause
> > > more damage than good.
> > >=20
> > > Ciao. Thorsten
> > >=20
> > > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker'
> > > >> hat)
> > > >>=20
> > > >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > > >> reports and sometimes miss something important when writing mails
> > > >> like
> > > >> this. If that's the case here, don't hesitate to tell me in a publ=
ic
> > > >> reply, it's in everyone's interest to set the public record straig=
ht.




