Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F0A602854
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 11:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJRJ1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 05:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiJRJ1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 05:27:03 -0400
Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF84AD999
        for <stable@vger.kernel.org>; Tue, 18 Oct 2022 02:26:51 -0700 (PDT)
Date:   Tue, 18 Oct 2022 09:26:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=emersion.fr;
        s=protonmail3; t=1666085205; x=1666344405;
        bh=lkgJpWb4BaP1gv7AzAPzQPSfRTAjw60rN7V6Xsc2zOY=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID;
        b=JxJ0JbIU/XDTDzCBQ1z/bshkld/8VLeDOh03KydWqzJHV77rAWfPMKsgYkSXw7h0n
         41k8RYXmK7iFlX4mkjYC2KZokoZN/WGDAxs4zNZvSNarjWKoutmnEqkeMmRyaPkvz6
         d6kOFAW54+LCvwRLeoOhcaeZRbpk9BwSIJX9jW8n09fMtqJ42N3NEhvUBRsfVfByr1
         aaWN9H/pH5zje7/aA2ToaCIuY89p+LTcW74AU6DxO5bUyEtKp4kcFgdpZolTqu+np4
         9f165iQf8Dhen4f+4Qa/wt9hs5RngjMCJ5waT6IY4pIXDYj/qJunlyTNe4j+NtC3R3
         uWzkEbrq2IkCg==
To:     =?utf-8?Q?Ville_Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
From:   Simon Ser <contact@emersion.fr>
Cc:     dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?utf-8?Q?Jonas_=C3=85dahl?= <jadahl@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/connector: send hotplug uevent on connector cleanup
Message-ID: <ItXxb260gmsCB1yhoUXl8D1d8T7-EXkKsK9w_Qcyb2VsBCH7zAPzPfbYVWGqCJxne3pH3lpKdRLoIuOZzhfCtE9I8UByM0Y17_qVopplReg=@emersion.fr>
In-Reply-To: <Y05w5U0CAbrdA10S@intel.com>
References: <20221017153150.60675-1-contact@emersion.fr> <20221017153150.60675-2-contact@emersion.fr> <Y05w5U0CAbrdA10S@intel.com>
Feedback-ID: 1358184:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, October 18th, 2022 at 11:24, Ville Syrj=C3=A4l=C3=A4 <ville.syr=
jala@linux.intel.com> wrote:

> On Mon, Oct 17, 2022 at 03:32:01PM +0000, Simon Ser wrote:
>=20
> > A typical DP-MST unplug removes a KMS connector. However care must
> > be taken to properly synchronize with user-space. The expected
> > sequence of events is the following:
> >=20
> > 1. The kernel notices that the DP-MST port is gone.
> > 2. The kernel marks the connector as disconnected, then sends a
> > uevent to make user-space re-scan the connector list.
> > 3. User-space notices the connector goes from connected to disconnected=
,
> > disables it.
> > 4. Kernel handles the the IOCTL disabling the connector. On success,
> > the very last reference to the struct drm_connector is dropped and
> > drm_connector_cleanup() is called.
> > 5. The connector is removed from the list, and a uevent is sent to tell
> > user-space that the connector disappeared.
> >=20
> > The very last step was missing. As a result, user-space thought the
> > connector still existed and could try to disable it again. Since the
> > kernel no longer knows about the connector, that would end up with
> > EINVAL and confused user-space.
>=20
> So is the uevent sent by the mst delayed destroy work
> useless now, or what is going on there?

No, that one is still useful, step (2) above.
