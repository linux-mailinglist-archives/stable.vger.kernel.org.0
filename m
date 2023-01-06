Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791D466040D
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjAFQNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 11:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbjAFQNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 11:13:41 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441C176217
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 08:13:40 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id o8so1197384ilo.1
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 08:13:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eXx0iBa6ViIHYuwColwZmoSS+/fQ6cQ84A5vNmlRsTI=;
        b=nlcWyiDO7MGfoHvK4pgyUGDpHFFkPAczwmrqEeEsJRsTwZjdSWJtjVqYw9zLOC8C+u
         cSf2j/RQPoaEOuRHj5KB6lNWm6TvnNI4UGY/QVggn8PGQjUgeafEWDIY7PoZo8+P1XcC
         HDJpFarnU3SjaSCn4IA00U+BDwMax9Vnv5+a4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eXx0iBa6ViIHYuwColwZmoSS+/fQ6cQ84A5vNmlRsTI=;
        b=RXjOVtsd4fVSbHbzCQYEJKPaW+tx7gFrLlkXYnhqvusSOtoONf818tZZ2/dEmBRvl4
         9LNOJvK4x+YNCafhtcNo6RuMi+izRsdjSkdT8hzQZ7ddilSjIlDfL2Ylni/7gASmuyXi
         XTAd9BJKMSme9KCn0IPFY2W+K3vkYmVOPb459zEwZhR1ntZNmPrGtT3O9yAxFViVcjyi
         bsxJnfpcwR/nAxqGkewMsbCv/D+8IKcJw2n8f5fcs50mckYNrPgnEzD6+0JPOtoNS43T
         +zyMlOKS8fsUHcvQkDW+ZddAgBZ9xxWb+FjHhRtOYHsgOi41P4faEgjn3sATjE5XrynY
         eXEg==
X-Gm-Message-State: AFqh2krCC/75YJPExlR8WXc9ZIDMe6f7ZBlxs1T7/sIdgQFiNEuu/jrR
        UB37C/u4Ozhmtx4C47q51DrcsQ==
X-Google-Smtp-Source: AMrXdXuj7LF9VtW5dlQvsWsu4WiPuQZugekoMZXaUNeIxPHYr71Ul0XbJbv9/eG4Ll/4PMjtHOunPg==
X-Received: by 2002:a92:c151:0:b0:302:9dde:679d with SMTP id b17-20020a92c151000000b003029dde679dmr40362399ilh.17.1673021619603;
        Fri, 06 Jan 2023 08:13:39 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id t17-20020a92c911000000b002fa9a1fc421sm478364ilp.45.2023.01.06.08.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 08:13:39 -0800 (PST)
Date:   Fri, 6 Jan 2023 16:13:38 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Icenowy Zheng <uwu@icenowy.me>,
        Douglas Anderson <dianders@chromium.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH 1/2] usb: misc: onboard_hub: Invert driver registration
 order
Message-ID: <Y7hIsvAG3QWb/PmL@google.com>
References: <20230105230119.1.I75494ebee7027a50235ce4b1e930fa73a578fbe2@changeid>
 <Y7g/JA0KZukK+41g@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y7g/JA0KZukK+41g@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 04:32:52PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 05, 2023 at 11:03:28PM +0000, Matthias Kaehlcke wrote:
> > The onboard_hub 'driver' consists of two drivers, a platform
> > driver and a USB driver. Currently when the onboard hub driver
> > is initialized it first registers the platform driver, then the
> > USB driver. This results in a race condition when the 'attach'
> > work is executed, which is scheduled when the platform device
> > is probed. The purpose of fhe 'attach' work is to bind elegible
> > USB hub devices to the onboard_hub USB driver. This fails if
> > the work runs before the USB driver has been registered.
> > 
> > Register the USB driver first, then the platform driver. This
> > increases the chances that the onboard_hub USB devices are probed
> > before their corresponding platform device, which the USB driver
> > tries to locate in _probe(). The driver already handles this
> > situation and defers probing if the onboard hub platform device
> > doesn't exist yet.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > Link: https://lore.kernel.org/lkml/Y6W00vQm3jfLflUJ@hovoldconsulting.com/T/#m0d64295f017942fd988f7c53425db302d61952b4
> > Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> > 
> >  drivers/usb/misc/onboard_usb_hub.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Does this superseed this thread:
> 	Link: https://lore.kernel.org/r/20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid

This series ("usb: misc: onboard_hub: Invert driver registration order"
et al) fixes the race condition mentioned in the commit message
of the other series ("usb: misc: onboard_usb_hub: Don't create platform
devices for DT nodes without 'vdd-supply'" et al), plus another race
that was reported later (this patch).

> or is that also needed?

This series is (mostly) independent from the other one, it should
fix the issue that was reported for the RPi 3 B+. It can be landed
even if the other one is abandonded.

With this series the other one doesn't fix or mitigate any actual
issue (AFAIK), it would only be an optimization (don't instantiate
the onboard_hub drivers if they'd do nothing).

> confused

Sorry, hope this clarifies things a bit.
