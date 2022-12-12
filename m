Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD4F64A72A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 19:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiLLSfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 13:35:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiLLSex (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 13:34:53 -0500
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC2E12746;
        Mon, 12 Dec 2022 10:34:49 -0800 (PST)
Received: by mail-qv1-f54.google.com with SMTP id d2so8777579qvp.12;
        Mon, 12 Dec 2022 10:34:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs2Cn6MInWO2Vp6jIz3bcJBYYCuM+2I3Q8E3W6mSSyg=;
        b=Psz7tDWuxUW004804H2lGxtgTn+fYPKbU0UjpIHSVS3Ek8EgICKe/Vb+2auFVQVeG2
         z56nuE0WJhljpJwe8TkjaYXmEQVsRYqioqP4XD7oJBembBQfzEgCYeCUoP2dgp5wL6o2
         BHXQffl8XjX7XKxyw2rIgvFpBxVFLYOLGRi79zhFoQm21UXk/FaPMyVMEQJ7H+3vka3k
         Zv0lYcr3uXSX5gthSnCAYjiqS97Qx4O6dpUaxFtrkYqLcGAX+T8O5sMS8+gFNtcUqALn
         j7fZrZ/V0Z0xfEBdOTg/WSqfHJM+eN0LHXEMZlgZWYhamTNOLkWy7XA3koaERWT9/49c
         AG3Q==
X-Gm-Message-State: ANoB5pmuJYZ1GfjP7QZH/yM+jsxZ9/qYtiimWwVHzGwHbuHK//8DzvMy
        MfIXA59qugprw6mkrbbm6cJPoSHHBTQszI5z5NDY/ASv
X-Google-Smtp-Source: AA0mqf68esnfpSOaYXkl8w5uWtikQbvdjF80wVqyN0PehN87AzTDTMO6p1Li2IYRnU/SCaZyXRGBFCBiM5aFD2lCAJ8=
X-Received: by 2002:a0c:facd:0:b0:4de:83db:b846 with SMTP id
 p13-20020a0cfacd000000b004de83dbb846mr254614qvo.119.1670870088624; Mon, 12
 Dec 2022 10:34:48 -0800 (PST)
MIME-Version: 1.0
References: <20221010141630.zfzi7mk7zvnmclzy@techsingularity.net>
 <CAJZ5v0j9JyDZupNnQUsTUVv0WapGjK7b5S-4ewZ8-b=HOret2Q@mail.gmail.com>
 <20221010174526.3yi7nziokwwpr63s@techsingularity.net> <CAJZ5v0je1dS4xSG46r64s8G5sJHjiziX92GBaKXaxueTim3wJA@mail.gmail.com>
 <20221011092050.gnh3dr5iqdvvrgs5@techsingularity.net> <Y5dx8pskqpaQU8kk@paranoid-android>
In-Reply-To: <Y5dx8pskqpaQU8kk@paranoid-android>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 12 Dec 2022 19:34:37 +0100
Message-ID: <CAJZ5v0iJGJ3AU+CLEgA3XTvdb-7xiyKOzzGEEsSO-xc0br_dQw@mail.gmail.com>
Subject: Re: Intermittent boot failure after 6492fed7d8c9 (v6.0-rc1)
To:     Mathieu Chouquet-Stringer <me@mathieu.digital>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-rtc@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 7:25 PM Mathieu Chouquet-Stringer
<me@mathieu.digital> wrote:
>
>         Hello Rafael,
>
> On Tue, Oct 11, 2022 at 10:20:50AM +0100, Mel Gorman wrote:
> > On Mon, Oct 10, 2022 at 08:29:05PM +0200, Rafael J. Wysocki wrote:
> > > > That's less than the previous 5/10 failures but I
> > > > cannot be certain it helped without running a lot more boot tests. The
> > > > failure happens in the same function as before.
> > >
> > > I've overlooked the fact that acpi_install_fixed_event_handler()
> > > enables the event on success, so it is a bug to call it when the
> > > handler is not ready.
> > >
> > > It should help to only enable the event after running cmos_do_probe()
> > > where the driver data pointer is set, so please try the attached
> > > patch.
>
> I'm hitting this issue on the 6.0 stable releases (aka 6.0.y) and
> looking at the stable tree I see this hasn't been merged... I just got
> bitten by this on 6.0.12.
>
> Greg, if Rafael agrees, I think you should apply 4919d3eb2ec0 and
> 0782b66ed2fb to the 6.0.y tree.

This is fine with me, please send an inclusion request to Greg and the
"stable" list.
