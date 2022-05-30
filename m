Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D31538505
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 17:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiE3Pf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 11:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbiE3PfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 11:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4941F14916C;
        Mon, 30 May 2022 07:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D77A860EA6;
        Mon, 30 May 2022 14:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CCEC385B8;
        Mon, 30 May 2022 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653921717;
        bh=8abrn0+fyaPOA35f7xmWZpHOHqa414fCZZbKmkVupjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqwLJQyttHeCPer1sfDH0foSp8e/arMMnFrMmAru9XrZ6jm7g/ajrEcIvpf4/sGG8
         j+mEfsV8h2gk7WZptLWACzxOAyIyN2p8t5LHZluCv/mpLj+mKbccprao57jsNMQgcn
         FKnAHaVnVyGHF05wiz5jDb2dm4jpMxLWhZX4mwr8OjIXrsErRQIZobH/VG6z6E33sl
         eSFuyCLMbqKiHRCj5NUnbmS7KTlV9tKcZqIlEKX2ldQ9IEAo8XtAivLXb7Uzn19oUF
         7gL9/wR8KRd9D24wVXGUQLmuu7LICcpmWXyk7qDp+lD3dUMcZkhyXK1y3YoUuHEYi5
         gurOAs1LGl21w==
Date:   Mon, 30 May 2022 16:41:54 +0200
From:   Mark Brown <broonie@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/18] KVM: arm64: Always start with clearing SVE flag on
 load
Message-ID: <YpTXsgd1MPpJEjUJ@sirena.org.uk>
References: <20220528113829.1043361-1-maz@kernel.org>
 <20220528113829.1043361-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ttQtBwibfUEMVFH9"
Content-Disposition: inline
In-Reply-To: <20220528113829.1043361-2-maz@kernel.org>
X-Cookie: May your camel be as swift as the wind.
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ttQtBwibfUEMVFH9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 28, 2022 at 12:38:11PM +0100, Marc Zyngier wrote:
> On each vcpu load, we set the KVM_ARM64_HOST_SVE_ENABLED
> flag if SVE is enabled for EL0 on the host. This is used to restore
> the correct state on vpcu put.
>=20
> However, it appears that nothing ever clears this flag. Once
> set, it will stick until the vcpu is destroyed, which has the
> potential to spuriously enable SVE for userspace.

Oh dear.

Reviewed-by: Mark Brown <broonie@kernel.org>

> We probably never saw the issue because no VMM uses SVE, but
> that's still pretty bad. Unconditionally clearing the flag
> on vcpu load addresses the issue.

Unless I'm missing something since we currently always disable
SVE on syscall even if the VMM were using SVE for some reason
(SVE memcpy()?) we should already have disabled SVE for EL0 in
sve_user_discard() during kernel entry so EL0 access to SVE
should be disabled in the system register by the time we get
here.

--ttQtBwibfUEMVFH9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmKU17EACgkQJNaLcl1U
h9Bxzgf/W2VmJBtB0a4vcrBCgfX7ollA3ex5VNB6egRZO8MINJrGPpI+Jv5J21sA
1ouYS/mgLxtq0X8ACQX1wcCv4SHFzZ+fOj0D7PM85BvUxWWF4AYlyjZ9dfpx0t4X
BQykcxau0Ep3Gj27LAkCQxvAe/X5QEuymskYptEMrIigKy2Af+LwdwJNy03Pw/M7
BJBGRk6DKpX9GBCnNx/zVjAp3wkpW50q67c2S+A35z2VzD5Fpk7zQWtwQGCp+X/D
/UZr74rJl6izdLI+ycIFUr41Lq95C7cl4/mHC1h4S9i9ceklOthnl1BgxOY0c/FT
zsZnSWRL7SBHTEnNr46EjfpsiId3Cg==
=aTTw
-----END PGP SIGNATURE-----

--ttQtBwibfUEMVFH9--
