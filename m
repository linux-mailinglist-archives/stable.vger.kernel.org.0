Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939146728F6
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 21:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjARUDy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 15:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbjARUD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 15:03:29 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593A75F381;
        Wed, 18 Jan 2023 12:03:16 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 650A31EC0646;
        Wed, 18 Jan 2023 21:02:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1674072176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=MpYmGfdGJwdpjiTRbkmmwRqJaAFYLwbh/MMe94wnB9Q=;
        b=sFHLQDIFvRjMCqLkNTLwW0JZ6trLoxL2UAOjri4x1KRwbzs0TlHZMKcLaBFDO0jrI7JxId
        uDgjrlVaoVuQvTfpHOWjcASbllBTW3vnWLXWBh6A/pxpN38JvKMFXnPQZvQsT2sNblUaMK
        F4jknNchU6NaIBVzrQsSU/5stQDtlnY=
Date:   Wed, 18 Jan 2023 21:02:52 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        NeilBrown <neilb@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Petr Pavlu <petr.pavlu@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8hQbC3wvu1S+uZ5@zn.tnic>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 04:04:22PM -0800, Luis Chamberlain wrote:
> and now I'm seeing this while trying to build v5.1:
> 
> ld: arch/x86/boot/compressed/pgtable_64.o:(.bss+0x0): multiple definition of `__force_order';
> arch/x86/boot/compressed/kaslr_64.o:(.bss+0x0): first defined here

You need to backport 

aa5cacdc29d7 ("x86/asm: Replace __force_order with a memory clobber")

for that.

Happens when building older kernels with newer toolchain.


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
