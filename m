Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409CD531091
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 15:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbiEWNDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 09:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbiEWNDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 09:03:30 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501FC62C5
        for <stable@vger.kernel.org>; Mon, 23 May 2022 06:03:28 -0700 (PDT)
Received: from geek500.localdomain (unknown [82.65.8.64])
        (Authenticated sender: casteyde.christian@free.fr)
        by smtp5-g21.free.fr (Postfix) with ESMTPSA id C7D665FFA6;
        Mon, 23 May 2022 15:03:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1653311006;
        bh=0z3zL/WZHRAKaLiAQMOG4o179eNPYBkTLCSIymjxibY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g18WtXd2bLJ9zeIbshtgIkBV248tIir5K2ZBjZyYU9TtzTEYMTPE+lYVV7NFdmHCZ
         JlR8A8eJl/UpH/rHtCQZXNaSCSKiwgxkD32f+eMCKl/9Vu4Dsh3yJX9aXzsf/BhUvA
         r1EBKsDJVNrzE8EiSw3PIRQ4Va1bdsmhLFEqKJMma7t6fxCgAano6uEGhuhEHVtUr9
         vbTqfe0/asN4JSf5Jvg+2U7OilKWQC9u8fkW6kr7xL/RKuHbnCbqYvNSF3Hb3RJ5Dq
         w4z8h29RLpe40oK4EFLloEpAlWhIydxLFpQ/yJTXyf8RkjwO9y40jd2A39ybYhOoyh
         4sBodO4/00Hlg==
From:   Christian Casteyde <casteyde.christian@free.fr>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        alexander deucher <alexander.deucher@amd.com>,
        gregkh@linuxfoundation.org,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since 5.17.4 (works 5.17.3)
Date:   Mon, 23 May 2022 15:02:53 +0200
Message-ID: <2585440.lGaqSPkdTl@geek500.localdomain>
In-Reply-To: <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net> <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com> <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
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

Hello

I've checked with 5.18 the problem is still there.
Interestingly, I tried to revert the commit but it was rejected because of =
the=20
change in the test from:
        if (!adev->in_s0ix)=20
to:
      if (amdgpu_acpi_should_gpu_reset(adev))

in amdgpu_pmops_suspend.

I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
Then I changed to restore test of in_s0ix as it was in 5.17, and it works.
I tried with a call to amd_gpu_asic_reset without testing at all in_s0ix, i=
t=20
works.

Therefore, my APU wants a reset in amdgpu_pmops_suspend.

By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as was=
=20
intended in 5.18 original code, commenting out the test of=20
amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
This does not work, I got the Fence timeout errors or freezes.

If I leave  noirq function unchanged (original 5.18 code), and just add a=20
reset in suspend() as was done in 5.17, it works.

Therefore, my GPU does NOT want to be reset in noirq, the reset must be in=
=20
suspend.

In other words, I modified amdgpu_pmops_suspend (partial revert) like this =
and=20
this works on my laptop:

static int amdgpu_pmops_suspend(struct device *dev)
{
	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
+	int r;

	if (amdgpu_acpi_is_s0ix_active(adev))
		adev->in_s0ix =3D true;
	else
		adev->in_s3 =3D true;
=2D	return amdgpu_device_suspend(drm_dev, true);
+	r =3D amdgpu_device_suspend(drm_dev, true);
+	if (r)
+		return r;
+	if (!adev->in_s0ix)
+		return amdgpu_asic_reset(adev);
	return 0;
}

static int amdgpu_pmops_suspend_noirq(struct device *dev)
{
	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);

	if (amdgpu_acpi_should_gpu_reset(adev))
		return amdgpu_asic_reset(adev);

	return 0;
}

I don't know if other APU want a reset, in the same context, and how to=20
differentiate all the cases, so I cannot go further, but I can test patches=
 if=20
needed.

CC

Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a =E9crit :
> On 18.05.22 07:54, Kai-Heng Feng wrote:
> > On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> >=20
> > <regressions@leemhuis.info> wrote:
> >> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
> >>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0da
> >>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"), a=
nd
> >>> the problem disappears so it's really this commit that breaks.
> >>=20
> >> In that case I'll update the regzbot status to make sure it's visible =
as
> >> regression introduced in the 5.18 cycle:
> >>=20
> >> #regzbot introduced: 887f75cfd0da
> >>=20
> >> BTW: obviously would be nice to get this fixed before 5.18 is released
> >> (which might already happen on Sunday), especially as the culprit
> >> apparently was already backported to stable, but I guess that won't be
> >> easy...
> >>=20
> >> Which made me wondering: is reverting the culprit temporarily in
> >> mainline (and reapplying it later with a fix) a option here?
> >=20
> > It's too soon to call it's the culprit.
>=20
> Well, sure, the root-cause might be somewhere else. But from the point
> of kernel regressions (and tracking them) it's the culprit, as that's
> the change that triggers the misbehavior. And that's how Linus
> approaches these things as well when it comes to reverting to fix
> regressions -- and he even might...
>=20
> > The suspend on the system
> > doesn't work properly at the first place.
>=20
> ...ignore things like this, as long as a revert is unlikely to cause
> more damage than good.
>=20
> Ciao. Thorsten
>=20
> >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' ha=
t)
> >>=20
> >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> >> reports and sometimes miss something important when writing mails like
> >> this. If that's the case here, don't hesitate to tell me in a public
> >> reply, it's in everyone's interest to set the public record straight.




