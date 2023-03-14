Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAFF6B9C7B
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 18:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjCNRIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 13:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNRIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 13:08:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47D715C95;
        Tue, 14 Mar 2023 10:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59B73B8136E;
        Tue, 14 Mar 2023 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88004C433D2;
        Tue, 14 Mar 2023 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678813694;
        bh=ucM21cLRUuIM1P+fjJ7tyXVrvw8aDslNNA8co2hjLB0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CQwA8hQi6papIwLzlFCwnT8ZgfxGYB2LsuTVCVtFvYeeMxK4u4qRxhb/NYejRj78g
         N+xHIw0JZfELVtT+p65MmB7c5tmgUhvmAEVq2ZRlzn8d2Ep76OavoWeOf10Monumx9
         KVSgQrxRkAPML1uZicpPU0RrnQjrGmVV4zE475+3hq3kpTScUqY2iviptRobfIg0f9
         wjdPGTCMNO5WeKwjE0rfZn2lFuAE6XDbzul3kV1qwjmAfrj0rvnlPO9IhRDalJzLso
         6MIzkKrpqlQdEkUuOJcyKSyHwsyzTjQNye0xdVmUGQTdDWD2O4rlsxv/CuP3eUnByC
         IdykfYulsxTgA==
Date:   Tue, 14 Mar 2023 17:08:09 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, conor.dooley@microchip.com,
        ndesaulniers@google.com, trix@redhat.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH] riscv: Handle zicsr/zifencei issues between clang and
 binutils
Message-ID: <75037eb4-7be4-4182-a377-18343491c7da@spud>
References: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1CEuDSeV8bwTFyS+"
Content-Disposition: inline
In-Reply-To: <20230313-riscv-zicsr-zifencei-fiasco-v1-1-dd1b7840a551@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1CEuDSeV8bwTFyS+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Nathan,

On Mon, Mar 13, 2023 at 04:00:23PM -0700, Nathan Chancellor wrote:
> There are two related issues that appear in certain combinations with
> clang and GNU binutils.
>=20
> The first occurs when a version of clang that supports zicsr or zifencei
> via '-march=3D' [1] (i.e, >=3D 17.x) is used in combination with a version
> of GNU binutils that do not recognize zicsr and zifencei in the
> '-march=3D' value (i.e., < 2.36):
>=20
>   riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifence=
i2p0: Invalid or unknown z ISA extension: 'zifencei'
>   riscv64-linux-gnu-ld: failed to merge target specific data of file fs/e=
fivarfs/file.o
>   riscv64-linux-gnu-ld: -march=3Drv64i2p0_m2p0_a2p0_c2p0_zicsr2p0_zifence=
i2p0: Invalid or unknown z ISA extension: 'zifencei'
>   riscv64-linux-gnu-ld: failed to merge target specific data of file fs/e=
fivarfs/super.o
>=20
> The second occurs when a version of clang that does not support zicsr or
> zifencei via '-march=3D' (i.e., <=3D 16.x) is used in combination with a
> version of GNU as that defaults to a newer ISA base spec, which requires
> specifying zicsr and zifencei in the '-march=3D' value explicitly (i.e, >=
=3D
> 2.38):
>=20
>   ../arch/riscv/kernel/kexec_relocate.S: Assembler messages:
>   ../arch/riscv/kernel/kexec_relocate.S:147: Error: unrecognized opcode `=
fence.i', extension `zifencei' required
>   clang-12: error: assembler command failed with exit code 1 (use -v to s=
ee invocation)
>=20
> This is the same issue addressed by commit 6df2a016c0c8 ("riscv: fix
> build with binutils 2.38") (see [2] for additional information) but
> older versions of clang miss out on it because the cc-option check
> fails:
>=20
>   clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupport=
ed standard user-level extension 'zicsr'
>   clang-12: error: invalid arch name 'rv64imac_zicsr_zifencei', unsupport=
ed standard user-level extension 'zicsr'
>=20
> To resolve the first issue, only attempt to add zicsr and zifencei to
> the march string when using the GNU assembler 2.38 or newer, which is
> when the default ISA spec was updated, requiring these extensions to be
> specified explicitly. LLVM implements an older version of the base
> specification for all currently released versions, so these instructions
> are available as part of the 'i' extension. If LLVM's implementation is
> updated in the future, a CONFIG_AS_IS_LLVM condition can be added to
> CONFIG_TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI.
>=20
> To resolve the second issue, use version 2.2 of the base ISA spec when
> using an older version of clang that does not support zicsr or zifencei
> via '-march=3D', as that is the spec version most compatible with the one
> clang/LLVM implements and avoids the need to specify zicsr and zifencei
> explicitly due to still being a part of 'i'.
>=20
> [1]: https://github.com/llvm/llvm-project/commit/22e199e6afb1263c943c0c0d=
4498694e15bf8a16
> [2]: https://lore.kernel.org/ZAxT7T9Xy1Fo3d5W@aurel32.net/
>=20
> Cc: stable@vger.kernel.org
> Link: https://github.com/ClangBuiltLinux/linux/issues/1808
> Co-developed-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

TBH, barely identifiable as having much to do with my V1 anymore, so
could easily have dropped those.
Either way, thanks for sorting this out while I've been sick :)

Acked-by: Conor Dooley <conor.dooley@microchip.com>

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> This is essentially a v3 of Conor's v1 and v2 but since I am sending the
> patch after finding a separate but related issue, I left it at v1:
>=20
> - v1: https://lore.kernel.org/20230223220546.52879-1-conor@kernel.org/
> - v2: https://lore.kernel.org/20230308220842.1231003-1-conor@kernel.org/
>=20
> I have built allmodconfig with the following toolchain combinations to
> confirm this problem is resolved:
>=20
> - clang 12/17 + GNU as and ld 2.35/2.39
> - clang 12/17 with the integrated assembler + GNU ld 2.35/2.39
> - clang 12/17 with the integrated assembler + ld.lld
>=20
> There are a couple of other incompatibilities between clang-17 and GNU
> binutils that I had to patch to get allmodconfig to build successfully
> but those are less likely to be hit in practice because the full LLVM
> stack can be used with LLVM versions 13.x and newer.

> I will follow up
> with separate issues and patches.

Cool, I'll "look forward" to those...

Thanks,
Conor.

--1CEuDSeV8bwTFyS+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZBCp+AAKCRB4tDGHoIJi
0roxAQCXsosSBtzf9Ovi8xT5U07z0OBYx29ltaw6MCTxk1St1AD/R4eRfRoNh6BC
vrfhzHF5bwseLnWtO2Yc8FoBMRGegQc=
=UId/
-----END PGP SIGNATURE-----

--1CEuDSeV8bwTFyS+--
