Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 293EBDF0A5
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 16:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfJUO62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 10:58:28 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35135 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfJUO61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Oct 2019 10:58:27 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iMZ8V-000484-8T; Mon, 21 Oct 2019 16:58:19 +0200
Date:   Mon, 21 Oct 2019 16:58:18 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Huacai Chen <chenhc@lemote.com>
cc:     Andy Lutomirski <luto@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        chenhuacai@gmail.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Paul Burton <paul.burton@mips.com>, linux-mips@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 110/110] lib/vdso: Improve do_hres() and update vdso data
 unconditionally
In-Reply-To: <alpine.DEB.2.21.1910211648200.1904@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1910211658040.1904@nanos.tec.linutronix.de>
References: <1571662320-1280-1-git-send-email-chenhc@lemote.com> <alpine.DEB.2.21.1910211648200.1904@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 21 Oct 2019, Thomas Gleixner wrote:

> On Mon, 21 Oct 2019, Huacai Chen wrote:
> > @@ -50,7 +50,7 @@ static int do_hres(const struct vdso_data *vd, clockid_t clk,
> >  		cycles = __arch_get_hw_counter(vd->clock_mode);
> >  		ns = vdso_ts->nsec;
> >  		last = vd->cycle_last;
> > -		if (unlikely((s64)cycles < 0))
> > +		if (unlikely(cycles == U64_MAX))
> >  			return -1;
> 
> That used to create worse code than the weird (s64) type cast which has the
> same effect. Did you double check that there is no change?

It still does for 32bit.
