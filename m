Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206F03D181B
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 22:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhGUTo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 15:44:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:49368 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhGUTo6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 15:44:58 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1626899133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/CthbpuGZ/4QYOJnFtoyw2VJqPR9q9LtmXqXub96q+k=;
        b=cTYlhxb8dGvUls4dX0qq5oaVHOxNm7MYH/CHV24oIScKMCKsUVF/oAkignqKt1L05Z4Ms1
        yuhqj4/PZXBby3VMqDC7d49tr+RVPldtMn9btuedvliqedchBFaznNpVuMn+mxweFh5UAv
        epfElup/3o8WlZGUHw2USdI/4QbJ5aCqz08HTfEYhsD+WKa8RYE/Oezgp2Z4DU0ey0ifmF
        hDd9muJbxCy5ydu8LPdwsYPaUw5ITmIy7WgHtC2s+kB588DpHYNGcMuzO1i+qnfQHcOrm0
        23SJVGP/l6qW7IYX7oPAZu/qPpk3WWQDk9JvF1XmNNQfKNjgSrcA6HUTdFzX/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1626899133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/CthbpuGZ/4QYOJnFtoyw2VJqPR9q9LtmXqXub96q+k=;
        b=kohnLQCXgZGWJwAmpzUFf/Gws9c3kRvfJVCKy3S7dZ6xnEpGVByaElYwpltlrQeSB8QP/B
        DHq6jQkceVx3fnDw==
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Song Hui <hui.song_1@nxp.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "gpio: mpc8xxx: change the gpio interrupt flags."
In-Reply-To: <20210702133712.128611-1-linux@rasmusvillemoes.dk>
References: <20210702133712.128611-1-linux@rasmusvillemoes.dk>
Date:   Wed, 21 Jul 2021 22:25:33 +0200
Message-ID: <87v953pg76.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 02 2021 at 15:37, Rasmus Villemoes wrote:
> This reverts commit 3d5bfbd9716318b1ca5c38488aa69f64d38a9aa5.
>
> When booting with threadirqs, it causes a splat
>
>   WARNING: CPU: 0 PID: 29 at kernel/irq/handle.c:159 __handle_irq_event_percpu+0x1ec/0x27c
>   irq 66 handler irq_default_primary_handler+0x0/0x1c enabled interrupts
>
> That splat later went away with commit 81e2073c175b ("genirq: Disable
> interrupts for force threaded handlers"), which got backported to
> -stable. However, when running an -rt kernel, the splat still
> exists. Moreover, quoting Thomas Gleixner [1]
>
>   But 3d5bfbd97163 ("gpio: mpc8xxx: change the gpio interrupt flags.")
>   has nothing to do with that:
>
>       "Delete the interrupt IRQF_NO_THREAD flags in order to gpio interrupts
>        can be threaded to allow high-priority processes to preempt."
>
>   This changelog is blatantly wrong. In mainline forced irq threads
>   have always been invoked with softirqs disabled, which obviously
>   makes them non-preemptible.
>
> So the patch didn't even do what its commit log said.
>
> [1] https://lore.kernel.org/lkml/871r8zey88.ffs@nanos.tec.linutronix.de/
>
> Cc: stable@vger.kernel.org # v5.9+
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
> Thomas, please correct me if I misinterpreted your explanation.

Nothing to correct here.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
