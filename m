Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE46C6BEE
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 16:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCWPKU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 11:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCWPKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 11:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF2A28E87;
        Thu, 23 Mar 2023 08:09:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BB4B62789;
        Thu, 23 Mar 2023 15:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CCFC433A7;
        Thu, 23 Mar 2023 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679584141;
        bh=FcwD1XOuAwXbSMguwEYcu2IqUmhn6V+JeDS8GyUwdoQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qoy19guvDPONMFPrrRUniZA3d+B6Kx9TP8qsIGJsZzKItUjRq9pl5rIquMTFcwp+j
         +K+jzYFLycutg2DxEwkUG9dxDMFoKcxa4fQ6i6FRqXF/FTrVdyLemwBbL4tynFZVBS
         73vwjZcVyzikIl74cSATXKiknE8KQ7Q76CluxWegb6lPY94P4evy4x3RSyYJAzMMnK
         erkfra0yNCTLExyUE/uErz2QbOQEeB/TO9S369dR8wKsRGlxeYMDXKMSLiHbrInlB3
         qhtxKSKnyJ92Nh9v0V5iH4z2s3w+Hb8LrEceK0mhXt3ulhDSuNLD28jf3RqVe46r3b
         RtW+Hy+fTXASQ==
Received: by mail-vs1-f52.google.com with SMTP id d2so12965474vso.9;
        Thu, 23 Mar 2023 08:09:01 -0700 (PDT)
X-Gm-Message-State: AO0yUKXzeJjmxmZnmXB8FEalLwdpXsrAutzl8sy1cquD5oT0Anmqe9xZ
        pzj7/0D9HFbMy6WbQQ4IrnbifiD7oCO8HR2cX1Y=
X-Google-Smtp-Source: AK7set++ZFPt6vHowYbtEIYa4P3hrlJgcTOEyNvQgHDYjXeQrPmiBB2tmLE7SDiNKUUZdoCYGpwCVqJvGhhMHgGjn0U=
X-Received: by 2002:a67:d506:0:b0:425:87ab:c386 with SMTP id
 l6-20020a67d506000000b0042587abc386mr1947210vsj.3.1679584140528; Thu, 23 Mar
 2023 08:09:00 -0700 (PDT)
MIME-Version: 1.0
References: <Y5gI/3crANzRv22J@bombadil.infradead.org> <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org> <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley> <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org> <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
 <20230312062505.man5h4oo6mjbiov6@ldmartin-desk2.lan> <ZBuB3+cN4BK6woKZ@bombadil.infradead.org>
 <20230323150125.35e5nwtrez46dv4b@ldmartin-desk2.lan>
In-Reply-To: <20230323150125.35e5nwtrez46dv4b@ldmartin-desk2.lan>
From:   Luis Chamberlain <mcgrof@kernel.org>
Date:   Thu, 23 Mar 2023 08:08:49 -0700
X-Gmail-Original-Message-ID: <CAB=NE6VtAn8tew723y77KAN_w-UYE+naMaVrKsLjxpJgAkwDXw@mail.gmail.com>
Message-ID: <CAB=NE6VtAn8tew723y77KAN_w-UYE+naMaVrKsLjxpJgAkwDXw@mail.gmail.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Petr Mladek <pmladek@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ben Hutchings <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 23, 2023 at 8:02=E2=80=AFAM Lucas De Marchi
<lucas.demarchi@intel.com> wrote:
>
> On Wed, Mar 22, 2023 at 03:31:59PM -0700, Luis Chamberlain wrote:
> >On Sat, Mar 11, 2023 at 10:25:05PM -0800, Lucas De Marchi wrote:
> >> On Sat, Jan 21, 2023 at 02:40:20PM -0800, Luis Chamberlain wrote:
> >> > On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
> >> > > On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
> >> > > > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> >> > > > > Yes, the -EINVAL error is strange. It is returned also in
> >> > > > > kernel/module/main.c on few locations. But neither of them
> >> > > > > looks like a good candidate.
> >> > > >
> >> > > > OK I updated to next-20230119 and I don't see the issue now.
> >> > > > Odd. It could have been an issue with next-20221207 which I was
> >> > > > on before.
> >> > > >
> >> > > > I'll run some more test and if nothing fails I'll send the fix
> >> > > > to Linux for rc5.
> >> > >
> >> > > Jeesh it just occured to me the difference, which I'll have to
> >> > > test next, for next-20221207 I had enabled module compression
> >> > > on kdevops with zstd.
> >> > >
> >> > > You can see the issues on kdevops git log with that... and I final=
ly
> >> > > disabled it and the kmod test issue is gone. So it could be that
> >> > > but I just am ending my day so will check tomorrow if that was it.
> >> > > But if someone else beats me then great.
> >> > >
> >> > > With kdevops it should be a matter of just enabling zstd as I
> >> > > just bumped support for next-20230119 and that has module decompre=
ssion
> >> > > disabled.
> >> >
> >> > So indeed, my suspcions were correct. There is one bug with
> >> > compression on debian:
> >> >
> >> > - gzip compressed modules don't end up in the initramfs
> >> >
> >> > There is a generic upstream kmod bug:
> >> >
> >> >  - modprobe --show-depends won't grok compressed modules so initramf=
s
> >> >    tools that use this as Debian likely are not getting module depen=
dencies
> >> >    installed in their initramfs
> >>
> >> are you sure you have the relevant compression setting enabled
> >> in kmod?
> >>
> >> $ kmod --version
> >> kmod version 30
> >> +ZSTD +XZ +ZLIB +LIBCRYPTO -EXPERIMENTAL
> >
> >Debian has:
> >
> >kmod version 30
> >+ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL
>
>            ^ so... mind the minus :). It doesn't support zlib.
>
> Change your kernel config to either compress the modules as xz or zstd.

Oh so then we should complain about these things if an initramfs is
detected with modules compressed using a compression algorithm which
modprobe installed does not support. What tool would do that?

  Luis
