Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5BAD5087BB
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 14:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378417AbiDTMJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 08:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378395AbiDTMJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 08:09:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3375727FCE
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 05:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B50D961984
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 12:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4356EC385A8;
        Wed, 20 Apr 2022 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650456429;
        bh=6Qi1kXogNlz84HRLz/3FHBceeVA1WINqwVQD5nQMb/A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oF2C3wS7oRmLLmMQ9Ycyemii+y6LP1ngMMLsd/Wd2uHJtVCLdUuFuZw4Q/XsDLW9l
         rxti/mtfDgJGxMmfsQAJuDi/haha7Hefmt0L2ajdfOfH8RWoVwjSJy2nWH0zhAjm/R
         KlR81Hld9ahIZPm5xPMbooMoJ9ZRvLtnCg3Qlp/jgQ/93zf4g/UWyb76ODn9Dm3PL2
         2yWa4j98GrmVuPQR/Nmdcs5kBmdiVErYff9HSDGeRjatxsvaRBSorPk9EZ9tWx0m35
         lgu+Xsa4Z3MkvJESTrm7mmZjvonFPqHIfGKWCAfLzIoi9VfkhwNw/6jn1zJE4gq431
         zZWNtA6OS3+/w==
Date:   Wed, 20 Apr 2022 13:07:03 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernelci-results@groups.io, bot@kernelci.org,
        gtucker@collabora.com, stable@vger.kernel.org
Subject: Re: stable-rc/linux-5.4.y bisection: baseline.login on
 qemu_arm-virt-gicv2-uefi
Message-ID: <Yl/3Z+QMCPbDafbC@sirena.org.uk>
References: <625c8753.1c69fb81.b232.69bb@mx.google.com>
 <Yl65zxGgFzF1Okac@sirena.org.uk>
 <Yl/PzFKR6U0bH43T@linux.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ae2ZQSt8iu/6zsd6"
Content-Disposition: inline
In-Reply-To: <Yl/PzFKR6U0bH43T@linux.ibm.com>
X-Cookie: Will it improve my CASH FLOW?
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ae2ZQSt8iu/6zsd6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 20, 2022 at 12:18:04PM +0300, Mike Rapoport wrote:

> I don't know how exactly kernel-ci runs qemu with UEFI, I've tried this:

> $QEMU -serial stdio -M virt-2.11,gic-version=3D2 -cpu cortex-a15 -m 1G \
> -drive file=3D$QEMU_EFI,if=3Dpflash,format=3Draw,unit=3D0,readonly=3Don \
> -drive file=3Dflash1.img,if=3Dpflash,format=3Draw,unit=3D1,readonly=3Doff=
 \
> -kernel $kernel \
> -append "console=3DttyAMA0"=20

> with stable-rc/linux-5.4.y and I've got as far as to failure to mount
> rootfs and the crash in dmu_setup() didn't reproduce for me.

The command should be something to the effect of:

qemu-system-aarch64 -cpu max -machine virt,gic-version=3D3,mte=3Don,accel=
=3Dtcg -nographic -net nic,model=3Dvirtio,macaddr=3D52:54:00:12:34:58 -net =
user -m 512 -monitor none -bios /var/lib/lava/dispatcher/tmp/75061/deployim=
ages-ptln1wlp/bios/QEMU_EFI.fd -kernel /var/lib/lava/dispatcher/tmp/75061/d=
eployimages-ptln1wlp/kernel/Image -append "console=3DttyAMA0,115200 root=3D=
/dev/ram0 debug verbose console_msg_format=3Dsyslog earlycon" -initrd /var/=
lib/lava/dispatcher/tmp/75061/deployimages-ptln1wlp/ramdisk/rootfs.cpio.gz =
-drive format=3Dqcow2,file=3D/var/lib/lava/dispatcher/tmp/75061/apply-overl=
ay-guest-6hyfr8ki/lava-guest.qcow2,media=3Ddisk,if=3Dvirtio,id=3Dlavatest

(with different paths) where QEMU_EFI.fd is:

   http://storage.kernelci.org/images/uefi/edk2-stable202005/arm64/QEMU_EFI=
=2Efd

I didn't pull an exact job, sorry.  A full job showing the expected flow
(for GICv3 which shows the same thing) is at:

   https://lava.sirena.org.uk/scheduler/job/75061

--ae2ZQSt8iu/6zsd6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmJf92cACgkQJNaLcl1U
h9BEeAf9GzEYhWH+CCVSm0EK52qHjVGhal50LrxrXVmm5V+S0D8mMAi6mLe6RWFA
a/9/QU0i4f0zR3n79BUyzK4futuJ/mE9kEsVJwFXsz0kmp1DeMcxqvvWbZSYhmEa
BCLFyeFMxylSlQPPn5/yvCEFLo0JejbzD4uP6LfXZVF5TP95tjj7CK+ByLnzMLVn
zIrqNy4fzvaEvo+kTIPa21VTHexUUPBIfJCz1MG/haaqWzYUq2zhNm0ut6sosXmJ
B3DWT6E2a8AHX2XXEnDpx6BvSCGL3/j+RtzEBeehXZ8zclmftK8SQhBSRRSgtLUP
YRn5nfynAqV5ma6Yfp6WbUWFEGI3Gg==
=aw4O
-----END PGP SIGNATURE-----

--ae2ZQSt8iu/6zsd6--
