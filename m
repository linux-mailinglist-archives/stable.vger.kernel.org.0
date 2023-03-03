Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A766A9FEE
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjCCTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:11:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCCTLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:11:34 -0500
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5CE311D5;
        Fri,  3 Mar 2023 11:11:33 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id u9so14423311edd.2;
        Fri, 03 Mar 2023 11:11:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677870691;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkPhr2hr3X5XjuEKiyZjJHx50LL/S5v2JqxmdM1ldJY=;
        b=yw2bIPf72xBpt6Oizl1NcVzfVAauk047K6NOCM/BOoZktMgLZMhd41h2yiNbmo0jHx
         9ZbP3edizfr+gmyzP3kOUExOoU2/p36Jvexn8bMUDhW1MslylsEaCF+COOPqE1cKOnSO
         mGODQdC0ZxFH04xWhKXsdE/loEcrLCbevKAjsJvLCDssB25KOSg/iPQ4cBloIqZa/Vwr
         f7ql9S9hytBCPyrJixQc+1xU3Hr3ffz/YGrjNyXa8SncosIEOhGuGorYqr8gPBwochRJ
         dvk45LR1cyDs8LS3mZY/iKeXRgBiJp9PBCAqEKs0GprkIHfZqg2g7UEBLzQqsiXzgjK8
         agXg==
X-Gm-Message-State: AO0yUKXTzwXr/4sGI/LMebcdJs3gidXWFjRkKynAxEXmqzDe7qCZXJH1
        a7xCIkf0AGU8EoMszTl+y/ZQ1bEvgOHzVFtqDIU0SSKN
X-Google-Smtp-Source: AK7set+uuUUVWQEGFMUyLvmhxhWCNuQL1y94cQLcGgBAjUNXiBDRVjeLsgL8EjxpBSXepHZI3tiw9IPERPO/zHVPDts=
X-Received: by 2002:a50:f61b:0:b0:4bc:eec5:37f5 with SMTP id
 c27-20020a50f61b000000b004bceec537f5mr1711969edn.6.1677870691617; Fri, 03 Mar
 2023 11:11:31 -0800 (PST)
MIME-Version: 1.0
References: <20230303161910.3195805-1-srinivas.pandruvada@linux.intel.com> <ZAJB7qTK81T7Zau4@kroah.com>
In-Reply-To: <ZAJB7qTK81T7Zau4@kroah.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Fri, 3 Mar 2023 20:11:20 +0100
Message-ID: <CAJZ5v0g84guSv1MCjwJWbhO1-RFZ4bpaWFy_Mcusra3N=mjdZQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: int340x: processor_thermal: Fix deadlock
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        rafael@kernel.org, rui.zhang@intel.com, daniel.lezcano@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 3, 2023 at 7:52 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 03, 2023 at 08:19:09AM -0800, Srinivas Pandruvada wrote:
> > From: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
> >
> > When user space updates the trip point there is a deadlock, which results
> > in caller gets blocked forever.
> >
> > Commit 05eeee2b51b4 ("thermal/core: Protect sysfs accesses to thermal
> > operations with thermal zone mutex"), added a mutex for tz->lock in the
> > function trip_point_temp_store(). Hence, trip set callback() can't
> > call any thermal zone API as they are protected with the same mutex lock.
> >
> > The callback here calling thermal_zone_device_enable(), which will result
> > in deadlock.
> >
> > Move the thermal_zone_device_enable() to proc_thermal_pci_probe() to
> > avoid this deadlock.
> >
> > Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@intel.com>
> > Cc: stable@vger.kernel.org
> > ---
> > The commit which caused this issue was added during v6.2 cycle.
>
> What commit exactly?  Always list that as a Fixes: tag if you know this.

It's there in the changelog above.

I'll add a Fixes: tag to this one when applying it.

Cheers!
