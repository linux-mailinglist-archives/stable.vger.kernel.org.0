Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B55E54FA48
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 17:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383014AbiFQP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 11:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383072AbiFQP2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 11:28:41 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07943CA41;
        Fri, 17 Jun 2022 08:28:40 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:28:37 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1655479719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FK6l8SzoSPqIrigMbDIQktqM7w5SV1VjeU/8pdVzSgU=;
        b=UJpcFyQx82C700K08rXXBJ5s/mIOa+CjW7uqx99XMZNs7wfim5gKItYumTZzm+rweKBfpW
        f/FpKjOlp5O6bap1K4nr54i0UIUHpAtcZXMsqSdLeXKAYEzByXu82vIbyQOSlR52wjjbR6
        7J9iAoosa5X2OOpboTJBwaxa7AtOF7q/J0Zw1giyCVYSdMaXeuiKQeArvB3aSOGtLocYbQ
        b6e47HdpaT/tICMwy1milxU3tGE5hnAMspRUL/qQ7kZAZqvQc5Ahk6Euz5v1WlXRHN0wQ8
        U3EQ7DteFgV0o9HV3fwQCL2So8lzUwRXbVRzZubJMU6r1egYKTn8teToa0juOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1655479719;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FK6l8SzoSPqIrigMbDIQktqM7w5SV1VjeU/8pdVzSgU=;
        b=D23yCIxMoTeth25msg17J5a7PTr4x4B/pozVmLAIfAlqAtHCqeqcihyx2F5hPlu3ImN5NK
        GtzU9T3YBkaQtHAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH] random: schedule mix_interrupt_randomness() less often
Message-ID: <YqydpeU8sGgRafnK@linutronix.de>
References: <20220616105052.322610-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220616105052.322610-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-06-16 12:50:52 [+0200], Jason A. Donenfeld wrote:
> This commit changes that 64 in rule (c) to be 1024, which means we
> schedule mix() 16 times less often. And it does *not* need to change the
> 64 in rule (a).

So the worker gets invoked less often and credits more bits in one go.
Looks like a win-win situation.

Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
