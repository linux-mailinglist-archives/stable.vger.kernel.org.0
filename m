Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D794855EF30
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 22:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiF1UVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 16:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiF1UVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 16:21:21 -0400
Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1387C3CA7E
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 13:18:45 -0700 (PDT)
Date:   Tue, 28 Jun 2022 20:18:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tmb.nu;
        s=protonmail; t=1656447523; x=1656706723;
        bh=ctnoSDpkAjzz//locm0Ami/0y0//adMs+21B++bI/PU=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:Feedback-ID:From:To:
         Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=vgZ4FCOUmUZ4yyFWreFS5pB7A6lsdsC2wFgKiwJ5MdhosNlm/tUneEQO1jwilrSzI
         QONEgCX8uVq7G7ZFFzfpXr+FRukbUDkjcW/q7SBCFFABorck2KKFwJvnrC9AJNjIeu
         GFL5FNFuhC9jOeRWZHflLl/S5BEfLKwcQfSMx+RU=
To:     Ronald Warsow <rwarsow@gmx.de>, linux-kernel@vger.kernel.org
From:   Thomas Backlund <tmb@tmb.nu>
Cc:     stable@vger.kernel.org
Reply-To: Thomas Backlund <tmb@tmb.nu>
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <f0cdac2a-79f3-af1c-eac9-698b0c8196a3@tmb.nu>
Feedback-ID: 19711308:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Den 2022-06-27 kl. 19:38, skrev Ronald Warsow:
> hallo Greg
>
> 5.18.8-rc1
>
> compiles (see [1]), boots and runs here on x86_64
> (Intel i5-11400, Fedora 36)
>
> [1]
> a regression against 5.18.7:
>
> ...
>
> LD=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vmlinux.o
>  =C2=A0 MODPOST vmlinux.symvers
> WARNING: modpost: vmlinux.o(___ksymtab_gpl+tick_nohz_full_setup+0x0):
> Section mismatch in reference from the variable
> __ksymtab_tick_nohz_full_setup to the function
> .init.text:tick_nohz_full_setup()
> The symbol tick_nohz_full_setup is exported and annotated __init
> Fix this by removing the __init annotation of tick_nohz_full_setup or
> drop the export.


Should be fixed by:


 From 2390095113e98fc52fffe35c5206d30d9efe3f78 Mon Sep 17 00:00:00 2001
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 27 Jun 2022 12:22:09 +0900
Subject: [PATCH] tick/nohz: unexport __init-annotated tick_nohz_full_setup(=
)

--
Thomas

