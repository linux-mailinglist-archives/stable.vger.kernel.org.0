Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF855FEC4
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 13:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiF2Lhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 07:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbiF2Lho (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 07:37:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE09F5AB;
        Wed, 29 Jun 2022 04:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31CE0B82345;
        Wed, 29 Jun 2022 11:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DBA4C34114;
        Wed, 29 Jun 2022 11:37:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cZhq/OuP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656502658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAjoM4HFvDC4AUWHFkNt5DqEZCGtJ6lX6TQh5DuzJHU=;
        b=cZhq/OuPcYXw5B+rU4i2lkOMkeIr2dIYaWG5ve3Y++QasYq/tzRyYVrRSloT4wqhPC7sev
        MXsigzWShH+Fl7/hjlr3ANGSU6bt5auZioxAeTU5xoPaB394gLyUKlXfdQ7f5ODKkJt2KC
        szxM6/sHltM+4+DaEi/IE6q/UatohGc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9f784858 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Wed, 29 Jun 2022 11:37:37 +0000 (UTC)
Date:   Wed, 29 Jun 2022 13:37:35 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Gregory Erwin <gregerwin256@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7] ath9k: let sleep be interrupted when unregistering
 hwrng
Message-ID: <Yrw5f8GN2fh2orid@zx2c4.com>
References: <20220628151840.867592-1-Jason@zx2c4.com>
 <CAO+Okf56VAqKt5a6OoGUnMAoMsbQoBd7V_tcLf9yuqheWKH1SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO+Okf56VAqKt5a6OoGUnMAoMsbQoBd7V_tcLf9yuqheWKH1SA@mail.gmail.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Gregory,

On Tue, Jun 28, 2022 at 08:41:44PM -0700, Gregory Erwin wrote:
> Hmm, set_notify_signal() calls wake_up_state() in kernel/sched/core.c, which
> is not currently exported. Only by including EXPORT_SYMBOL(wake_up_state) and
> rebuilding vmlinux was I able to build rng-core.ko and load it successfully.
> 
> That said, this patch allows 'ip link set wlan0 down' to wake a blocked process
> reading from /dev/hwrng, eliminating the delay as described. I'll give my
> sign-off with the EXPORT_SYMBOL sorted out.

Thanks for testing, and thanks for the note about EXPORT_SYMBOL(). I'll
send a v+1 with that fixed. And then it sounds like this patch finally
addresses all the issues you were seeing. Pfiew!

Jason
