Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DC850E9DA
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 22:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245083AbiDYUFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 16:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245074AbiDYUFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 16:05:07 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AD6B0A52;
        Mon, 25 Apr 2022 13:02:02 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id g6so8938530ejw.1;
        Mon, 25 Apr 2022 13:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-transfer-encoding:user-agent:mime-version;
        bh=Fmjs2qdPk3eUOBZHdhQG4JdB4/lCcC7aZeX3SYv+IQM=;
        b=iSuKs2xrmd8iz5XESYCu2x1iYM3Rw3bmLCrVrR87JboXSJwZMsBDYmnrbC55MqXllw
         LzlQP/jE//VPBJ8y3DG3wd7LUWZAoyad8tnokzf4/ehHqzqr5WRalsOH003OTr5nbkdZ
         NWul1h1DZxEs+nkpe7yIKVMAXCBiFIJk5dVQLERACRWRpSmIHebRc6psouBc5QTUin6a
         g4rulWV34hhDjvnQxmIH1mAfDkaEVKbLV+xRWAjtodbtdkeaucXKkneh/edxHLdShaQD
         rx9ArWveSZ3aNJQhLePuJg5Yoy/TKqkwVkz9JjGWoH8HyWcjc/nPp1QclkSSlzk99xit
         cfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=Fmjs2qdPk3eUOBZHdhQG4JdB4/lCcC7aZeX3SYv+IQM=;
        b=E+WlqTkPXg/d8yvOeaofkSxmB2ufzRcW0IfJ/LKNYQNwEq9AfM5POVEoLv4FVMT/0U
         6Yfze/gi4jlg3IEIKMXCQOXx/Hpb+AqqO9cfLNjnbMmqqR3+xqz2GNA4Ub46kRJCp9b3
         XFIPKoOsGZQbKoynz9gn3kIFljqw7UyFJxO0Md+lj1RyDj67xbyjsdSvTkr8Oct0iNNP
         3y/i2J6RoMQuQpR7LXvDBT59k+T3qhNHkeeEWA55HiOQwxLSmDWm+yql9J2OntXHeLMa
         YUEl5BE1h7WFtrSRqpqKjp+gSDXWIlaQfX4O/LxxDgWIHDsgJLtqVnAwZ3TmwxETkHSB
         flag==
X-Gm-Message-State: AOAM530GoAgZBEnGXLkau+T2B7g75h0yPSvA7cBV6rrDxZRWit/cp3E0
        i9d10wFeOHDAA00TBafx2lcRRRIoC8tYHA==
X-Google-Smtp-Source: ABdhPJzosQC/YjZvx2sjBZa0vexS/EYotPB9tax638U/Wlv4HVYKILUzHyIDDoAi0uroTYvvAK0btQ==
X-Received: by 2002:a17:906:c1c1:b0:6ef:7bd7:a508 with SMTP id bw1-20020a170906c1c100b006ef7bd7a508mr17806427ejb.614.1650916920876;
        Mon, 25 Apr 2022 13:02:00 -0700 (PDT)
Received: from [192.168.3.2] (p5dd1ed70.dip0.t-ipconnect.de. [93.209.237.112])
        by smtp.googlemail.com with ESMTPSA id 27-20020a17090600db00b006df6b34d9b8sm3899371eji.211.2022.04.25.13.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:01:59 -0700 (PDT)
Message-ID: <89845bec6c827d7012cda916ee50b16c8eb08755.camel@gmail.com>
Subject: Re: [PATCH v1 2/2] mmc: core: Allows to override the timeout value
 for ioctl() path
From:   Bean Huo <huobean@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     ulf.hansson@linaro.org, adrian.hunter@intel.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        beanhuo@micron.com, stable <stable@vger.kernel.org>
Date:   Mon, 25 Apr 2022 22:01:59 +0200
In-Reply-To: <CACRpkdahf5QhUJ-vG6Qs7i0VYbSS02zBrQOtN8EVFu9SyHZA1Q@mail.gmail.com>
References: <20220423221623.1074556-1-huobean@gmail.com>
         <20220423221623.1074556-3-huobean@gmail.com>
         <CACRpkdahf5QhUJ-vG6Qs7i0VYbSS02zBrQOtN8EVFu9SyHZA1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2022-04-24 at 15:29 +0200, Linus Walleij wrote:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (idata->rpmb || (cm=
d.flags & MMC_RSP_R1B) =3D=3D
> > MMC_RSP_R1B) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Ensure RPMB/R1B command has completed by polling
> > CMD13
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * "Send Status".
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * Ensure RPMB/R1B command has completed by polling
> > CMD13 "Send Status". Here we
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 * allow to override the default timeout value if a
> > custom timeout is specified.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err =3D mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS,
> > false,
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 MMC_BUSY_IO);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 err =3D mmc_poll_for_busy(card, idata-
> > >ic.cmd_timeout_ms ? : MMC_BLK_TIMEOUT_MS,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 false, MMC_BUSY_IO);
>=20
> I suppose it's OK (albeit dubious) that we have a userspace interface
> setting
> a hardware-specific thing such as a timeout.
>=20
> However: is MMC_BLK_TIMEOUT_MS even reasonable here? If you guys
> know a better timeout for RPMB operations (from your experience)
> what about defining MMC_RPMB_TIMEOUT_MS to something more
> reasonable (and I suppose longer) and use that as fallback instead
> of MMC_BLK_TIMEOUT_MS?
>=20
> This knowledge (that RPMB commands can have long timeouts) is not
> something that should be hidden in userspace.
>=20

Hi Linus,


understand what you mean. I must say, it's hard to come up with a
uniform timeout value that works for all commands but also for all
vendors. Meanwhile, the MMC_BLK_TIMEOUT_MS here is not only for RPMB
commands but also for all commands (with R1B responses) issued by the
ioctl() system call. The current 10s timeout can cover almost 99% of
the scenarios. There are very few special cases that take more than
10s.

I think the current solution is the most flexible way, if the customer
wants to override the kernel default timeout, they know how to initiate
the correct timeout value in ioctl() based on their specific
hardware/software system. I don't know how to convince every maintainer
and reviewer if we don't want to give this permission or want to
maintain a unified timeout value in the kernel driver. Given that we
already have eMMC ioctl() support, and we've opened the door to allow
users to specify specific cmd_timeout_ms in struct mmc_ioc_cmd{},
please consider my change.

struct mmc_ioc_cmd {
      ...
        /*
         *Override driver-computed timeouts.  Note the difference in
units!
         */
        unsigned int data_timeout_ns;
        unsigned int cmd_timeout_ms;
...}



Kind regards,
Bean
