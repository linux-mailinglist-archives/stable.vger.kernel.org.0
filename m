Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792DD2FB90C
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 15:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395367AbhASORx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 09:17:53 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:40692 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390021AbhASKTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 05:19:18 -0500
Date:   Tue, 19 Jan 2021 10:18:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1611051513;
        bh=q+dny+d9bvN1Z30lIJh9zYFbNAX8RL+E2yHDrPen8dc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=EEJJJiPIPVks4KgMcNX6viXtSMfYjtON2y4W70FpTyTi14JE/rViukoIbCoh/NwXN
         hS2y3D1bjc6lPimCVxpsJGSayd2xTHqIPYkw+u2PNQdJZGb4Ts6i0V0kinGewOOUKB
         oBAMay6gJFo6aUuzcfDMK+QfOwnHlqdJ+tcouH/UU4s7dbOdAFtGrHpPbrCtmEiLVr
         Uh2CHjzBIq/6E7dwbs5d92IPTrVY1/ye8B23nwyLheIdxzxKsSNI/011eJlJ3J6yIg
         gEdyJ1b35Ic670vTqrTU2L79iCZcVqEYXS/RsIj7UFODx29LjbOHcEuOjkhOp7NBYg
         OdkXmaVJ2dDfA==
To:     Lyude Paul <lyude@redhat.com>
From:   Simon Ser <contact@emersion.fr>
Cc:     nouveau@lists.freedesktop.org, James Jones <jajones@nvidia.com>,
        Martin Peres <martin.peres@free.fr>,
        Jeremy Cline <jcline@redhat.com>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        =?utf-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Nirmoy Das <nirmoy.aiemd@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Reply-To: Simon Ser <contact@emersion.fr>
Subject: Re: [PATCH 1/3] drivers/nouveau/kms/nv50-: Reject format modifiers for cursor planes
Message-ID: <HfzDFy00Jir8FH_WqWz7EmLYojZvbfaoSAhmjdxfTSVxhBBpUYgpdApQFXXM2Uv3yzq0ySUYLCq2izrT5d9_gxna2IN9U8zHme2dvo7LlKs=@emersion.fr>
In-Reply-To: <20210119015415.2511028-1-lyude@redhat.com>
References: <20210119015415.2511028-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, January 19th, 2021 at 2:54 AM, Lyude Paul <lyude@redhat.com> wr=
ote:

> Nvidia hardware doesn't actually support using tiling formats with the
> cursor plane, only linear is allowed. In the future, we should write a
> testcase for this.
>
> Fixes: c586f30bf74c ("drm/nouveau/kms: Add format mod prop to base/ovly/n=
vdisp")
> Cc: James Jones <jajones@nvidia.com>
> Cc: Martin Peres <martin.peres@free.fr>
> Cc: Jeremy Cline <jcline@redhat.com>
> Cc: Simon Ser <contact@emersion.fr>
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: Lyude Paul <lyude@redhat.com>

Together with [1], this patch allows me to run unpatched modifier-aware
user-space successfully, without a cursor visual glitch. drm_info
correctly reports the new modifier list, and wlroots logs confirm that
a flavor of NVIDIA_BLOCK_LINEAR_2D is used for the primary buffers and
LINEAR is used for cursor buffers.

Code looks good to me as well.

Reviewed-by: Simon Ser <contact@emersion.fr>

[1]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/3724
