Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC185B58A8
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 12:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiILKpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 06:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiILKpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 06:45:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E6131343;
        Mon, 12 Sep 2022 03:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFB3BB80C6E;
        Mon, 12 Sep 2022 10:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B74C433D6;
        Mon, 12 Sep 2022 10:45:45 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="WhI4t8//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662979544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+3jz39/jak5Ui0pcc0KV1+Nyj2qNdWQKuMuXzkcF0AY=;
        b=WhI4t8//mpoQSwZTIptLboJ0/fFAX+euuiRy9UcaIdwzIRXI+j83JP2o64iZeu8b3u2xQS
        lpjrbgwZI4dy0cByQvNfKEXG/gqjV6UpV6e4e0SiGAO56Hg7H92iqzGU/NT9IxkLDV/G4h
        yh4NwDSPbUxHZEoH4jrqufpJAUELUpM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7413db67 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 12 Sep 2022 10:45:43 +0000 (UTC)
Date:   Mon, 12 Sep 2022 11:45:38 +0100
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
Cc:     linux-pm@vger.kernel.org, stable@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH RESEND] power: supply: avoid nullptr deref in
 __power_supply_is_system_supplied
Message-ID: <Yx8N0hGNcbVPnJxW@zx2c4.com>
References: <CAJZ5v0js78b3qZXoxgXEwG7g0a7n_ALnEYjjzBGaQW7q4_ceCA@mail.gmail.com>
 <20220905172428.105564-1-Jason@zx2c4.com>
 <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220911123346.a7xbzdlbb7r5p6ih@mercury.elektranox.org>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sebastian,

On Sun, Sep 11, 2022 at 02:33:46PM +0200, Sebastian Reichel wrote:
> > -	if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY)
> > +	if (psy->desc->type != POWER_SUPPLY_TYPE_BATTERY && psy->desc->get_property)
> >  		if (!psy->desc->get_property(psy, POWER_SUPPLY_PROP_ONLINE,
> >  					&ret))
> >  			return ret.intval;
> 
> Thanks, queued into power-supply's fixes branch. But I'm curioous
> how you triggered this. Which power-supply driver does not add
> a get_property function?

AFAIK, I'm just using the normal ACPI one. Really nothing fancy.
Thinkpad X1 Extreme Gen 4.

Maybe get_property was being set and unset during some kind of
initialization/deinitialization that was happening in response to some
other event? Not sure, except that I managed to trigger it twice before
patching my kernel so my laptop would keep working.

My machine went through three changes I know about between the threshold
of "not crashing" and "crashing":
- Upgraded to 5.19 and then 6.0-rc1.
- I used my laptop on batteries for a prolonged period of time for the
  first time in a while.
- I updated KDE, whose power management UI elements may or may not make
  frequent calls to this subsystem to update some visual representation.

I don't have any data to back up this claim at all, but something that
at least _sounds_ plausible is that an updated KDE thing was hammering
on this read() method, while a decreasing battery state caused some
aspect of the subsystem to reinitialize the power management object,
making ->get_property() temporarily NULL. But just a guess!

Jason
