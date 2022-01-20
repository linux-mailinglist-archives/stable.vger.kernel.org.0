Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03843494E7F
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 14:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiATNBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 08:01:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34492 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiATNBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 08:01:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48FF0B81D73;
        Thu, 20 Jan 2022 13:01:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6506BC340E0;
        Thu, 20 Jan 2022 13:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642683704;
        bh=wwalQNmVSbEuIpDRTaRCjWnWylnsXSj3/abMBcKpGdo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q+JDZSLBxsWw3vwdtKCCmhmga9g/5UyS2wqOK4wxCFfZg6/Ovfgcplz15jUB4scQ7
         y/zUiQcL5bASZtJ5Cu3y5gqyovAB/MfjcAmi5yTMXJvUIejVx2q+LMPYWOODDlnqmN
         lw26BZ0SnMwyoEWevobRudSvLQZ4RFfZ6+3DsphupCmEBL8BSxz/AfTApbOz9BpsIS
         zGMt0Dhd9k5UxRSDkDDukHJL3jAmIIOaNJDGJynAdCSSHOYSJ1R+SpS4m8cRov6HgK
         8aTV4gkkyQV/cdV2SshFH1ac9lFt73RCFn3PYt6YmiCGi6BoSdSZ7epGjA/uABMiom
         nn28qvQUCZI4Q==
Message-ID: <e4e8fbe757860cd24e2f66b25be60d76663935d8.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Silence softlockup detection when releasing
 large enclaves
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        luto@kernel.org, mingo@redhat.com, linux-sgx@vger.kernel.org,
        x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 20 Jan 2022 15:01:29 +0200
In-Reply-To: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
References: <1aa037705e5aa209d8b7a075873c6b4190327436.1642530802.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-18 at 11:14 -0800, Reinette Chatre wrote:
> Vijay reported that the "unclobbered_vdso_oversubscribed" selftest
> triggers the softlockup detector.
>=20
> Actual SGX systems have 128GB of enclave memory or more.=C2=A0 The
> "unclobbered_vdso_oversubscribed" selftest creates one enclave which
> consumes all of the enclave memory on the system. Tearing down such a
> large enclave takes around a minute, most of it in the loop where
> the EREMOVE instruction is applied to each individual 4k enclave
> page.
>=20
> Spending one minute in a loop triggers the softlockup detector.
>=20
> Add a cond_resched() to give other tasks a chance to run and placate
> the softlockup detector.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 1728ab54b4be ("x86/sgx: Add a page reclaimer")
> Reported-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Softlockup message:
> watchdog: BUG: soft lockup - CPU#7 stuck for 22s! [test_sgx:11502]
> Kernel panic - not syncing: softlockup: hung tasks
> <snip>
> sgx_encl_release+0x86/0x1c0
> sgx_release+0x11c/0x130
> __fput+0xb0/0x280
> ____fput+0xe/0x10
> task_work_run+0x6c/0xc0
> exit_to_user_mode_prepare+0x1eb/0x1f0
> syscall_exit_to_user_mode+0x1d/0x50
> do_syscall_64+0x46/0xb0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> =C2=A0arch/x86/kernel/cpu/sgx/encl.c | 1 +
> =C2=A01 file changed, 1 insertion(+)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c
> b/arch/x86/kernel/cpu/sgx/encl.c
> index 001808e3901c..ab2b79327a8a 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -410,6 +410,7 @@ void sgx_encl_release(struct kref *ref)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0kfree(entry);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0cond_resched();
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0xa_destroy(&encl->page_ar=
ray);

I'd add a comment, e.g.

/* Invoke scheduler to prevent soft lockups. */

Other than that makes sense.

BR, Jarkko

