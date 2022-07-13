Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA314573FB7
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiGMWuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiGMWue (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:50:34 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F6322508;
        Wed, 13 Jul 2022 15:50:32 -0700 (PDT)
Received: from [46.99.201.83] (helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oBlBR-0005aw-Fr; Thu, 14 Jul 2022 00:50:17 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oBlBQ-004FN9-2T;
        Thu, 14 Jul 2022 00:50:16 +0200
Date:   Thu, 14 Jul 2022 00:50:16 +0200
From:   Ben Hutchings <ben@decadent.org.uk>
To:     kernel test robot <lkp@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        stable@vger.kernel.org
Subject: Re: [linux-stable-rc:linux-5.10.y 7082/7120]
 arch/x86/kernel/head_64.o: warning: objtool: xen_hypercall_mmu_update():
 can't find starting instruction
Message-ID: <Ys9MKAriCchlEO8S@decadent.org.uk>
References: <202207130531.SkRjrrn8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QgGe/1hBXAqx0haf"
Content-Disposition: inline
In-Reply-To: <202207130531.SkRjrrn8-lkp@intel.com>
X-SA-Exim-Connect-IP: 46.99.201.83
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--QgGe/1hBXAqx0haf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 13, 2022 at 05:38:47AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> head:   53b881e19526bcc3e51d9668cab955c80dcf584c
> commit: 7575d3f3bbd1c68d6833b45d1b98ed182832bd44 [7082/7120] x86: Use ret=
urn-thunk in asm code
> config: x86_64-rhel-8.3-syz (https://download.01.org/0day-ci/archive/2022=
0713/202207130531.SkRjrrn8-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=3D1 build):
>         # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git/commit/?id=3D7575d3f3bbd1c68d6833b45d1b98ed182832bd44
>         git remote add linux-stable-rc https://git.kernel.org/pub/scm/lin=
ux/kernel/git/stable/linux-stable-rc.git
>         git fetch --no-tags linux-stable-rc linux-5.10.y
>         git checkout 7575d3f3bbd1c68d6833b45d1b98ed182832bd44
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=3D1 O=3Dbuild_dir ARCH=3Dx86_64 SHELL=3D/bin/bash arch/x86/
>=20
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
> >> arch/x86/kernel/head_64.o: warning: objtool: xen_hypercall_mmu_update(=
): can't find starting instruction
>=20
> --=20
> 0-DAY CI Kernel Test Service
> https://01.org/lkp

Please add the following patch to fix this.  This would also be
needed for 5.15-stable.

Ben.

=46rom: Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 14 Jul 2022 00:39:33 +0200
Subject: [PATCH] x86/xen: Fix initialisation in hypercall_page after rethunk

The hypercall_page is special and the RETs there should not be changed
into rethunk calls (but can have SLS mitigation).  Change the initial
instructions to ret + int3 padding, as was done in upstream commit
5b2fc51576ef "x86/ibt,xen: Sprinkle the ENDBR".

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/xen-head.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 38b73e7e54ba..2a3ef5fcba34 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -69,9 +69,9 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
 SYM_CODE_START(hypercall_page)
 	.rept (PAGE_SIZE / 32)
 		UNWIND_HINT_FUNC
-		.skip 31, 0x90
 		ANNOTATE_UNRET_SAFE
-		RET
+		ret
+		.skip 31, 0xcc
 	.endr
=20
 #define HYPERCALL(n) \


--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--QgGe/1hBXAqx0haf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmLPTCMACgkQ57/I7JWG
EQkKPhAApwv7gCni5vZ7ITALh1yyXIUh0Vv/bc9BrCPQnbBQDHbvNS3OdFuvCxrN
yx6aRZox8x5vGdwWmStOGHwBF8TZhHHKFPp8zD6St4UrvmNju8w6uXPXLDYtaQEd
Ut6ZjptOJH4nz4O+XaFPIy635wq3lKxBMZe33iAL96WpOTF58tPPRuu2nq7EsAzl
U54x6tZQgj9tiJmxyvdUprfE0dI7ZlA81JBxd1i8mZqXNy/FnsD84yf+GjSOM3jp
JQT7rt1bj4AAL23y2+kSZv83nE2iRrD0wXZJA3Z7vzdweYRlrCXjFJxp8g9qNNj7
j1xTyiHnU7fnL72zZYoUZ4mH8nC7iXorU3GdK5YgTnmUOoOfs32XVHXESizsSd+T
fwBtK/vJtn/DuM7Wh7nuQSooQen9C1tP1IdehMRak/8voehnXGudXVmQV+33gUWO
THKXW01eswt1KR6tEZrmyj/zv1Nz9XE4wJbCoDeGn/VAts2oZpE4kzvILraA2C+w
t1wWkYtz7IfwP/YVMOSc9takgYDQRenu+MAHD+jIZR+XyG9RQtDZKY1oGXA16GD4
BqJgEsVMWTeuFM4+s0TNWfERSeLNbVpIxl4cPfQbdrFinAHF4qR9rz3pNQHx+8jB
Fr7yiOcI75Sz1Gr1/+rSewBMCVFztkEKpGqDhfYi/N30SwLH1ug=
=/IUX
-----END PGP SIGNATURE-----

--QgGe/1hBXAqx0haf--
