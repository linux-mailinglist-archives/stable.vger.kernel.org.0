Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6EA04BBEA7
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 18:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiBRRtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 12:49:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235838AbiBRRtp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 12:49:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EE927CD4;
        Fri, 18 Feb 2022 09:49:26 -0800 (PST)
Date:   Fri, 18 Feb 2022 18:49:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645206564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmVi8TBeXUlm/v/kPHbfKCWVJ4hV0bUUD/V9V8Aajwc=;
        b=Pol6RFBLpkYOCYLyjLzz/sxKGhLrPXB2+06UELwZFXetgUTPPlh8mIbEP/SdhpnFWuWiA2
        Xm0Y0WyA0x/kX4jM1XluaNUu9t9Cm5atkxlOIp73quo7qegfoid9TlznnU4EMdjKL9o5Go
        vv7eEyv0XA+X/3QW7EvPVd8p6yABQGH/x1FpX/kjqohFDPWg7dyBQD2iooMqLu9Y5kvPiG
        kKTbulSpf+FX6u3j62LbQpuPHD3t3E+9uMsgZNlIEPkzN4XqFbPJhJO9iklmPhrKejcefe
        bErtdGN52gzkfJeI9pg5P+U+eXmOPsMuKngc+4pPSnBDvqACYitkk8aS97XjsA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645206564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmVi8TBeXUlm/v/kPHbfKCWVJ4hV0bUUD/V9V8Aajwc=;
        b=6xaSHPiTAR090p8kNmJv8YY6vgpJcvJKTiqI1NpA9RolkaSOl56GGOSeyhkY696fyePXLJ
        qwd6dik4PjBfEFAg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] pstore: Don't use semaphores in always-atomic-context
 code
Message-ID: <Yg/cIzXsya8dNLYp@linutronix.de>
References: <20220218172901.1425605-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220218172901.1425605-1-jannh@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-02-18 18:29:01 [+0100], Jann Horn wrote:
=E2=80=A6
> Lockdep probably never caught the problem because it's very rare that you
> actually hit the contended case, and lockdep can't check a

I appears that after =C2=B4a' a few words would follow.

> Fixes: ea84b580b955 ("pstore: Convert buf_lock to semaphore")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> Testing on 5.15.24 (latest stable), with CONFIG_PREEMPT=3Dy, when I trigg=
er
> a BUG() via LKDTM ("echo BUG > /sys/kernel/debug/provoke-crash/DIRECT"),
> I first get the expected BUG splat, followed by this RCU warning:
>=20
> Voluntary context switch within RCU read-side critical section!

Right, scheduling not allowed within a RCU read-side section. I'm not
sure if lockdep cares but if you enable CONFIG_DEBUG_ATOMIC_SLEEP then
the might_sleep() will complain if you are in a RCU section.

> This patch makes the RCU context warning go away.

Makes sense.
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -143,27 +143,26 @@ static void pstore_timer_kick(void)
>  	mod_timer(&pstore_timer, jiffies + msecs_to_jiffies(pstore_update_ms));
>  }
> =20
> -/*
> - * Should pstore_dump() wait for a concurrent pstore_dump()? If
> - * not, the current pstore_dump() will report a failure to dump
> - * and return.
> - */
> -static bool pstore_cannot_wait(enum kmsg_dump_reason reason)
> +bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
>  {
> -	/* In NMI path, pstore shouldn't block regardless of reason. */
> +	/*
> +	 * In case of NMI path, pstore shouldn't be blocked
> +	 * regardless of reason.
> +	 */
>  	if (in_nmi())
>  		return true;
> =20
>  	switch (reason) {
>  	/* In panic case, other cpus are stopped by smp_send_stop(). */
>  	case KMSG_DUMP_PANIC:
> -	/* Emergency restart shouldn't be blocked. */
> +	/* Emergency restart shouldn't be blocked by spin lock. */

 by spinning on pstore_info::buf_lock

>  	case KMSG_DUMP_EMERG:
>  		return true;
>  	default:
>  		return false;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
> =20
>  #if IS_ENABLED(CONFIG_PSTORE_DEFLATE_COMPRESS)
>  static int zbufsize_deflate(size_t size)

Sebastian
