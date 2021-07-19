Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468923CD3B3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhGSKgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 06:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235999AbhGSKge (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 06:36:34 -0400
X-Greylist: delayed 48219 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Jul 2021 03:27:36 PDT
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FFEC061574;
        Mon, 19 Jul 2021 03:27:36 -0700 (PDT)
Received: from spock.localnet (unknown [151.237.229.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 695A1B3F3D1;
        Mon, 19 Jul 2021 13:17:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1626693429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wrtAMp8n8lOfYMpdjEfS7NS2+/lTSHmoD6u2/ln0m0M=;
        b=TUtaLbEqSNYuzc0eN7Y8ZZEE82uB4YSU4usOV9A63uQh9EV1ZVvdPzRFFHrIW9iVWiJbi8
        Q4UzzAQomutjXIc6CBkHdg8QNK+TWjSFTMONW7yFd6grqHJvuemKiH7uuvtLDlvjAsns/+
        ejiX7ahR4cTe1KXWi/drpvktUGSQemc=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Boqun Feng <boqun.feng@gmail.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Cc:     Zhouyi Zhou <zhouzhouyi@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Date:   Mon, 19 Jul 2021 13:17:07 +0200
Message-ID: <11144384.Jnp629F0a1@natalenko.name>
In-Reply-To: <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com> <YPVQfaamqwu1PRrK@boqun-archlinux> <08803f78-3e99-6b3f-e809-5828fe47cf06@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello.

On pond=C4=9Bl=C3=AD 19. =C4=8Dervence 2021 13:12:58 CEST Miaohe Lin wrote:
> On 2021/7/19 18:14, Boqun Feng wrote:
> > On Mon, Jul 19, 2021 at 03:43:00AM +0100, Matthew Wilcox wrote:
> >> On Mon, Jul 19, 2021 at 10:24:18AM +0800, Zhouyi Zhou wrote:
> >>> Meanwhile, I examined the 5.12.17 by naked eye, and found a suspicious
> >>> place that could possibly trigger that problem:
> >>>=20
> >>> struct swap_info_struct *get_swap_device(swp_entry_t entry)
> >>> {
> >>>=20
> >>>      struct swap_info_struct *si;
> >>>      unsigned long offset;
> >>>     =20
> >>>      if (!entry.val)
> >>>     =20
> >>>              goto out;
> >>>    =20
> >>>     si =3D swp_swap_info(entry);
> >>>     if (!si)
> >>>    =20
> >>>        goto bad_nofile;
> >>>   =20
> >>>    rcu_read_lock();
> >>>  =20
> >>>   if (data_race(!(si->flags & SWP_VALID)))
> >>>  =20
> >>>      goto unlock_out;
> >>>  =20
> >>>   offset =3D swp_offset(entry);
> >>>   if (offset >=3D si->max)
> >>>  =20
> >>>    goto unlock_out;
> >>>  =20
> >>>   return si;
> >>>=20
> >>> bad_nofile:
> >>>   pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
> >>>=20
> >>> out:
> >>>   return NULL;
> >>>=20
> >>> unlock_out:
> >>>   rcu_read_unlock();
> >>>   return NULL;
> >>>=20
> >>> }
> >>> I guess the function "return si" without a rcu_read_unlock.
> >>=20
> >> Yes, but the caller is supposed to call put_swap_device() which
> >> calls rcu_read_unlock().  See commit eb085574a752.
> >=20
> > Right, but we need to make sure there is no sleepable function called
> > before put_swap_device() called, and the call trace showed the following
> >=20
> > happened:
> > 	do_swap_page():
> > 	  si =3D get_swap_device():
> > 	    rcu_read_lock();
> > 	 =20
> > 	  lock_page_or_retry():
> > 	    might_sleep(); // call a sleepable function inside RCU read-side=20
c.s.
> > 	   =20
> > 	    __lock_page_or_retry():
> > 	      wait_on_page_bit_common():
> > 	        schedule():
> > 		  rcu_note_context_switch();
> > 		  // Warn here
> > 	 =20
> > 	  put_swap_device();
> > 	 =20
> > 	    rcu_read_unlock();
> >=20
> > , which introduced by commit 2799e77529c2a
>=20
> When in the commit 2799e77529c2a, we're using the percpu_ref to serialize
> against concurrent swapoff, i.e. there's percpu_ref inside
> get_swap_device() instead of rcu_read_lock(). Please see commit
> 63d8620ecf93 ("mm/swapfile: use percpu_ref to serialize against concurrent
> swapoff") for detail.

The problem here is that 2799e77529c2a got pulled into stable, but=20
63d8620ecf93 was not pulled. Are you suggesting that 63d8620ecf93 should be=
=20
pulled into the stable kernel as well?

Thanks.

=2D-=20
Oleksandr Natalenko (post-factum)


