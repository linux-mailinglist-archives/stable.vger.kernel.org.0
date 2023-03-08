Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820FB6B0A3A
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjCHN7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbjCHN7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:59:23 -0500
Received: from eggs.gnu.org (eggs.gnu.org [IPv6:2001:470:142:3::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F40D0086
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:57:38 -0800 (PST)
Received: from fencepost.gnu.org ([2001:470:142:3::e])
        by eggs.gnu.org with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <psmith@gnu.org>)
        id 1pZuIS-0004RY-Bb; Wed, 08 Mar 2023 08:57:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=gnu.org;
        s=fencepost-gnu-org; h=MIME-Version:References:In-Reply-To:Date:To:From:
        Subject; bh=NrRV/ZTMNJRmIh3svwc3TiQ6CtbpVKHGLANZm1P76OY=; b=G68Jp+1wsnHWqil8A
        njat5PUmXcWk0ybPvug/SxbJ6YrhIYiTUeYqqcoIRwCRk6PgfPTGZ/RxUh/2wVxP6ZyLxuBT5LXLL
        7I8XW+PkS/Cf/CZDEJ+zj8S1KFm0SW2mXu5vCfOFmlkill223CoFdqCOBOaWyxCqWcbSxoiCu1mg/
        RHRscLT8spdB8/cTNhckH+l8SZV66hWmQn4rPErGSHSTQ1l/a4ppTjfXHC2yBZvDVCPBQsYRQqkDH
        4XAsxJnRNAZj3cRs3J22BSDO8n61qtUzpl69BA6Gc3vsQJ5Ft96AlYixZDwFlxscePZH/zYY8bpk4
        uIVTqmY0Xh0RbMaVw==;
Received: from [160.231.0.90] (helo=llin-psh13-dsa.dsone.3ds.com)
        by fencepost.gnu.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <psmith@gnu.org>)
        id 1pZuIS-0006tS-3o; Wed, 08 Mar 2023 08:57:36 -0500
Message-ID: <4e731dfbe197f5c0a6c1093aee503b7f4d76cc1a.camel@gnu.org>
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
From:   Paul Smith <psmith@gnu.org>
Reply-To: psmith@gnu.org
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, bug-make@gnu.org,
        stable@vger.kernel.org
Date:   Wed, 08 Mar 2023 08:57:34 -0500
In-Reply-To: <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
References: <ZAgnmbYtGa80L731@sol.localdomain> <ZAgogdFlu69QlYwu@kroah.com>
         <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
Organization: GNU's Not UNIX!
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (by Flathub.org) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2023-03-08 at 08:12 -0500, Dmitry Goncharov wrote:
> > > Is this an intentional breakage from the 'make' side?
> No it is not an intentional breakage.
> This is a fix for https://savannah.gnu.org/bugs/?63347.

Just to note, it was possible to run into this problem with earlier
versions of GNU Make as well, it just became much simpler once the
variables were available since it's easier to have an "s" in some
variable.  But it is possible to have an "s" in a MAKEFLAGS flag which
is not introduced with a "--", and doesn't represent the short option.

I give some examples in that Savannah bug.

> > The fact that kernels 5.4 and newer imply to me that there is
> > a kernel build fix that should resolve this if someone can take the
> > time to bisect it...
>=20
> Kernel makefile was updated to work with old and new make in
> 4bf73588165ba7d32131a043775557a54b6e1db5.
> If you wanted to backport, try this commit.

Does anyone know why this commit is using a make version comparison?=20
That seems totally unnecessary to me; am I forgetting something?  As
far as I remember,

    silence :=3D $(findstring s,$(firstword -$(MAKEFLAGS)))

has always been the proper way to check for the short option "s", and
has always worked in every version of GNU Make.

https://github.com/torvalds/linux/commit/4bf73588165ba7d32131a043775557a54b=
6e1db5
