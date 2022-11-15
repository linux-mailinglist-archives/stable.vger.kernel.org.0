Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52B0062968C
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbiKOK7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiKOK71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:59:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3843894;
        Tue, 15 Nov 2022 02:58:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2ED1B818BA;
        Tue, 15 Nov 2022 10:58:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE09C433C1;
        Tue, 15 Nov 2022 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668509895;
        bh=z6lhldcuZ/yZWZWYTha4sLMNHyDOxr1XBhr9uVX5n8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C3LF/SOeXRSmvSzYI72M47TJMFnyabqa/F07WML9cBlIn+xpTJVpPUAw7FWNFyTTG
         penic426VNlUkeQ5wxZFYHzK/sniZWtEMgawOp0gvm1u/WAy2RFc8S0WI1bhI3OCZ8
         4llWckY1miNY1vUv9QKzaHofglUIg/cZHcWX2HmDqkHFoelTaXr22RHuZs66o5egQz
         OtuA+wqUFH6T+Bs8U9ctZWwntOdkG/WBe7oJeVc6xrT0MEgrKu9pA7j0orKugJOE7u
         vQ/rNw7qCUriD7deBsVfLTwO7HG1zP28NayMwbna3ppqx69Kypf1pV4j5MAU/ibpcq
         F417lvmoEW+Lg==
Date:   Tue, 15 Nov 2022 10:58:00 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: WARNING: CPU: 0 PID: 1111 at arch/arm64/kernel/fpsimd.c:464
 fpsimd_save+0x170/0x1b0
Message-ID: <Y3NwuOKJXudb9K30@sirena.org.uk>
References: <CA+G9fYuXG7Rh_A8W1NRVWbgWjozwzxzQY7tYw7bA4NsCuSovMg@mail.gmail.com>
 <97c413be-1a24-4447-b7ea-fa81a3170765@app.fastmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Q2Os0hM+U3KKHspW"
Content-Disposition: inline
In-Reply-To: <97c413be-1a24-4447-b7ea-fa81a3170765@app.fastmail.com>
X-Cookie: Ego sum ens omnipotens.
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q2Os0hM+U3KKHspW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 15, 2022 at 09:22:53AM +0100, Arnd Bergmann wrote:

> Have you tried what happens if you run the same thing on an x86
> machine? I would expect them to behave the same way, but it's
> possible something goes wrong with the guest CPU if this ends
> up using some (but not all) of the logic from KVM that would
> use '-cpu host' instead of '-cpu max'. Note that the Neoverse
> CPU in the Altra machine does not support SVE.

I'm finding it hard to think of a failure pattern that would
make it through VL discovery then fail at runtime but also not
obviously trigger any issues in syscall-abi...

> Other things you could easily try would use the same command
> line as above, with the possible combinations of '-cpu host'
> (replacing -cpu max) and '-enable-kvm'. Do you always get
> the same result?

The machine parameter accel={tcg,kvm} is useful for forcing a
specific backend - it's probably wise to force TCG if you might
be running on a job on a native architecture.

BTW there's some other funky stuff going on with that job, the
syscall-abi test is stopped with a timeout after 45 seconds (as
is sve-ptrace) which appears to be coming from a harness
somewhere.  The selection of FP tests run seems to miss fp-stress
too.

--Q2Os0hM+U3KKHspW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmNzcLcACgkQJNaLcl1U
h9DlGQf/d9Fj8SoOkkYluJqJi8BFS1IA4U8ObGdL1Ntw4YR2qlhSMkgKBMVVsLWp
NxdrmmzfbyfO8qPsNP85lvZlAu9z7ddDlBorMzVlFAVwZOkydzT7JiYEy44y7o/0
F6qFLXXO5l4fYsmDBvmglXiPXitFuQTgzNDIyhx1ETJErBaBzQiRpI45sCqO2Zju
lZnJgH86mqm0G+mVkTd1gsx2iX9QYxUYoilNWGozV44N1zoz/8KH+KtbvtE2U7Au
DCgOuc9WF/zqaEJ8Xi4dkHSHGidHC4rbkjyh63ANWpKZPyXT4czxC+xsBe1GJdOv
7z7/zaxbY4FNze1s8LpBHMWLWE0rtg==
=pVs/
-----END PGP SIGNATURE-----

--Q2Os0hM+U3KKHspW--
