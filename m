Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE22681E0C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 23:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjA3W1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 17:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjA3W1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 17:27:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3EE2333A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675117626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPEODcPgRK414okg7foYA/aTV5Kft48PiJghLe7ICGI=;
        b=dXxja1yQtp0nIRGhcg9csDHMmYITiOTS3z3yy4V0/1K4XOCnkO3dVFmLBDuMT9gjn/8UL5
        9e61Nz10Q9iPuvfrk75G6LA5K7gtFr2FOHmARO+XghdcI4emJE3XAYAzjErf+gTChWoSsM
        mTzh/kepgQsILj8uB1aBZ5MfE8nWe3k=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-GUmcaY0aP3C8mKrcELlBDA-1; Mon, 30 Jan 2023 17:27:05 -0500
X-MC-Unique: GUmcaY0aP3C8mKrcELlBDA-1
Received: by mail-qk1-f199.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so7859547qkl.9
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:27:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPEODcPgRK414okg7foYA/aTV5Kft48PiJghLe7ICGI=;
        b=YHsfR0lkTvTXowOZAv9C3rSFxSyapnv0AYlaZePR3TMU0B+wDL3AFYJksRh50IOSMO
         d7VrS6DW/F3m3N6hin3obO1S5DZvuOngn+iBM5bg2Jz2+aTvbdpOQ2nrcRkJ7N19/IpI
         ZARRR8R6vNld6JRvJPF/NVy+YHOoYyvxEK2XHY2JSWqxiV3Gtd6PM05y9wyVf7d8BY5u
         6Ws9E6ApLsLJiCurOKEC5Tpejn1NYsuRrireU3ZgiCfZY70g27adb8Y2Rdpg5gs4hgc9
         tb0hC10DYU5gldUS1bQbCwmNTJhl5NX3KZSMKN9sFL3ZjNVBW2pgZKK1PSU7qCuFJngn
         xCwQ==
X-Gm-Message-State: AFqh2kpu70w49BU5GOjRbAzy5IzOTR8VbFaV+SwJPqdaPnBuwSLa8zqW
        3Rpg38QhCjkUP/bOslDftGWRX7WpJqR8GZZpVsPs8GvxzXeVWp5+U66rhMGVj/U0GxPaEwe9Mjs
        2T6FTqoGfw8StjQoD
X-Received: by 2002:a05:622a:22a6:b0:3b6:2b4b:5688 with SMTP id ay38-20020a05622a22a600b003b62b4b5688mr74319829qtb.11.1675117624925;
        Mon, 30 Jan 2023 14:27:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtPG9zQKSAcIyem1FaWDea42WwKGaM92CTOvtO89X0PGeMDEDGGt8JHya6v+5zkph0JN/g/VQ==
X-Received: by 2002:a05:622a:22a6:b0:3b6:2b4b:5688 with SMTP id ay38-20020a05622a22a600b003b62b4b5688mr74319807qtb.11.1675117624673;
        Mon, 30 Jan 2023 14:27:04 -0800 (PST)
Received: from ?IPv6:2600:4040:5c68:6800::feb? ([2600:4040:5c68:6800::feb])
        by smtp.gmail.com with ESMTPSA id i65-20020a375444000000b006e07228ed53sm8877587qkb.18.2023.01.30.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:27:04 -0800 (PST)
Message-ID: <9e4cb1d818e4ce04c3e465a397e5652349e3938a.camel@redhat.com>
Subject: Re: [Nouveau] [PATCH] nouveau: explicitly wait on the fence in
 nouveau_bo_move_m2mf
From:   Lyude Paul <lyude@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Computer Enthusiastic <computer.enthusiastic@gmail.com>
Cc:     Salvatore Bonaccorso <carnil@debian.org>, stable@vger.kernel.org,
        Karol Herbst <kherbst@redhat.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org
Date:   Mon, 30 Jan 2023 17:27:03 -0500
In-Reply-To: <Y9eWhGj/ecjUcYO/@kroah.com>
References: <20220819200928.401416-1-kherbst@redhat.com>
         <CAHSpYy0HAifr4f+z64h+xFUmMNbB4hCR1r2Z==TsB4WaHatQqg@mail.gmail.com>
         <CACO55tv0jO2TmuWcwFiAUQB-__DZVwhv7WNN9MfgMXV053gknw@mail.gmail.com>
         <CAHSpYy117N0A1QJKVNmFNii3iL9mU71_RusiUo5ZAMcJZciM-g@mail.gmail.com>
         <cdfc26b5-c045-5f93-b553-942618f0983a@gmail.com>
         <Y9VgjLneuqkl+Y87@kroah.com> <Y9V8UoUHm3rHcDkc@eldamar.lan>
         <51511ea3-431f-a45c-1328-5d1447e5169b@gmail.com>
         <Y9eWhGj/ecjUcYO/@kroah.com>
Organization: Red Hat Inc.
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks a ton for the help Greg!

On Mon, 2023-01-30 at 11:05 +0100, Greg KH wrote:
> On Sun, Jan 29, 2023 at 10:36:31PM +0100, Computer Enthusiastic wrote:
> > Hello Greg,
> > Hello Salvatore,
> >=20
> > On 28/01/2023 20:49, Salvatore Bonaccorso wrote:
> > > Hi Greg,
> > >=20
> > > I'm not the reporter, so would like to confirm him explicitly, but I
> > > believe I can give some context:
> > >=20
> > > On Sat, Jan 28, 2023 at 06:51:08PM +0100, Greg KH wrote:
> > > > On Sat, Jan 28, 2023 at 03:49:59PM +0100, Computer Enthusiastic wro=
te:
> > > > > Hello,
> > > > >=20
> > > > > The patch "[Nouveau] [PATCH] nouveau: explicitly wait on the fenc=
e in
> > > > > nouveau_bo_move_m2mf" [1] was marked for kernels v5.15+ and it wa=
s merged
> > > > > upstream.
> > > > >=20
> > > > > The same patch [1] works with kernel 5.10.y, but it is not been m=
erged
> > > > > upstream so far.
> > > > >=20
> > > > > According to Karol Herbst suggestion [2], I'm sending this messag=
e to ask
> > > > > for merging it into 5.10 kernel.
> > > >=20
> > > > We need to know the git commit id.  And have you tested it on 5.10.=
y?
> > > > And why are you stuck on 5.10.y for this type of hardware?  Why not=
 move
> > > > to 5.15.y or 6.1.y?
> > >=20
> > > This would be commit 6b04ce966a73 ("nouveau: explicitly wait on the
> > > fence in nouveau_bo_move_m2mf") in mainline, applied in 6.0-rc3 and
> > > backported to 5.19.6 and 5.15.64.
> > >=20
> > > Computer Enthusiastic, tested it on 5.10.y:
> > > https://lore.kernel.org/nouveau/CAHSpYy1mcTns0JS6eivjK82CZ9_ajSwH-H7g=
tDwCkNyfvihaAw@mail.gmail.com/
> > >=20
> > > It was reported in Debian by the user originally as
> > > https://bugs.debian.org/989705#69 after updating to the 5.10.y series=
 in Debian
> > > bullseye.
> > >=20
> > > I guess the user could move to the next stable release Debian bookwor=
m, once
> > > it's released (it's currently in the last milestones to finalize, cf.
> > > https://release.debian.org/ but we are not yet there). In the next re=
lease this
> > > will be automatically be fixed indeed.
> > >=20
> > > Computer Enthusiastic, can you confirm please to Greg in particular t=
he first
> > > questions, in particular to confirm the commit fixes the suspend issu=
e?
> > >=20
> > > Regards,
> > > Salvatore
> >=20
> > Thanks for replaying to my request: I really appreciate.
> >=20
> > I apologize if my request was not formally correct.
> >=20
> > The upstream kernel 5.10.y hangs on suspend or fails to resume if it is
> > suspended to ram or suspended to disk (if nouveau kernel module is used=
 with
> > some nvidia graphic cards).
> >=20
> > I confirm the commit ID 6b04ce966a73 (by Karol Herbst) fixes the
> > aforementioned suspend to ram and suspend to disk issues with kernel 5.=
10.y
> > . It tested it with my own computer.
> >=20
> > The last kernel version I tested is 5.10.165, that I patched and instal=
led
> > in Debian Stable (11.6) that I'm currently running and that I tested ag=
ain
> > today.
> >=20
> > It would be nice if the next point release of Debian Stable could ship =
a
> > kernel that includes patch commit ID 6b04ce966a73 for the benefit of no=
uveau
> > module users.
>=20
> Ok, I've queued it up for 5.10.y now, thanks.
>=20
> greg k-h
>=20

--=20
Cheers,
 Lyude Paul (she/her)
 Software Engineer at Red Hat

