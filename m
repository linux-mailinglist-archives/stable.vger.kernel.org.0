Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D083B0B5E
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 19:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFVR1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 13:27:18 -0400
Received: from vulcan.natalenko.name ([104.207.131.136]:59534 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhFVR1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 13:27:18 -0400
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 6DAC2AF15A7;
        Tue, 22 Jun 2021 19:24:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1624382698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6C/9aHxf9JuxozRE08JBbfiMFOix1Z/vELCSKvQaeU=;
        b=mfDz2+ubFc1YGm5Q0b/GlcuCeKNgrIqR+hF2WTnf+YraDAkSBH77f2WLs8lqFLvMmsoa+3
        1I1WZX0BcFEh0g7SU3Vi3mlz2puTPJi4fQ/7afE6srW9MRAcXxpwzYvzfI2xNBZn8tlv1r
        LKBwpsjLKUJADBPziqgLI6I4PBdG61M=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Backport d583d360a6 into 5.12 stable
Date:   Tue, 22 Jun 2021 19:24:56 +0200
Message-ID: <5661831.TEGnOE2T3c@spock>
In-Reply-To: <YNIUP70J5yWPaguo@kroah.com>
References: <11282373.oIR2C0Pl9h@spock> <YNIUP70J5yWPaguo@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On =C3=BAter=C3=BD 22. =C4=8Dervna 2021 18:47:59 CEST Greg KH wrote:
> On Tue, Jun 22, 2021 at 06:30:46PM +0200, Oleksandr Natalenko wrote:
> > I'd like to nominate d583d360a6 ("psi: Fix psi state corruption when
> > schedule() races with cgroup move") for 5.12 stable tree.
> >=20
> > Recently, I've hit this:
> >=20
> > ```
> > kernel: psi: inconsistent task state! task=3D2667:clementine cpu=3D21
> > psi_flags=3D0 clear=3D1 set=3D0
> > ```
> >=20
> > and after that PSI IO went crazy high. That seems to match the symptoms
> > described in the commit message.
>=20
> But this says it fixes 4117cebf1a9f ("psi: Optimize task switch inside
> shared cgroups") which did not show up until 5.13-rc1, so how are you
> hitting this issue?

I'm not positive 4117cebf1a9f was a root cause of the race. To me it looks=
=20
like 4117cebf1a9f just made an older issue more likely to be hit.

Peter, Johannes, am I correct saying that it is still possible to hit a=20
corruption described in d583d360a6 on 5.12?

> Did you try this patch on 5.12.y and see that it solved your problem?

Yes, I've built the kernel with this patch, and so far it runs fine. It can=
=20
take a while until the condition is hit though since it seems to be very=20
unlikely on 5.12.

=2D-=20
Oleksandr Natalenko (post-factum)


