Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8914E8FB8
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239114AbiC1IHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbiC1IHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:07:06 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BC752E58;
        Mon, 28 Mar 2022 01:05:26 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A840D1EC03AD;
        Mon, 28 Mar 2022 10:05:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1648454720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=TgYlt5nc7wuciyx7G8H9YwvEKtCL+n4QE5+p7msxcds=;
        b=V9IqrlxxviCrGiqelyL2A4fuZ02xoQlvZmW05/np63cGMoImBaU6+12OzilUmj4ggY+GFn
        JqZ46zIiR4h3DyaxRKVol9wqXLnKyG4q07tz+4NovtOaz7R5QZtUzn4OF/M2iBtGsq3rlU
        6Ypa1ZH/furZtBZNMAb0GDqQb2+xj48=
Date:   Mon, 28 Mar 2022 10:05:22 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org
Subject: Re: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when
 `threshold_create_bank()` fails
Message-ID: <YkFsQhpGGXIFTMyp@zn.tnic>
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-3-ammarfaizi2@gnuweeb.org>
 <YkDqo2eEbABbtSGY@zn.tnic>
 <82609267-8fc6-5b3d-c931-c0d93ab14788@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82609267-8fc6-5b3d-c931-c0d93ab14788@gnuweeb.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 28, 2022 at 11:12:53AM +0700, Ammar Faizi wrote:
> Although, I am not sure if that 100% guarantees mce_threshold_remove_device()
> will not mess up with the interrupt (e.g. freeing the data while the interrupt
> reading it), unless we're using RCU stuff.
> 
> What do you think?

I would've said it doesn't matter but that thresholding device creation
is part of hotplug and it can happen multiple times even *after* the
interrupt vector has been set during setup so a potential teardown and
concurrent thresholding interrupt firing might really hit in a not fully
initialized/cleaned up state so yeah, let's do Yazen's thing.

The alternative would be the temporarily re-assign mce_threshold_vector
to default_threshold_interrupt while setup is being done but that's not
really necessary atm.

But call that helper function __threshold_remove_device().

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
