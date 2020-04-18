Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C63F1AEAAE
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 10:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgDRIJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 04:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbgDRIJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 04:09:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50A9820857;
        Sat, 18 Apr 2020 08:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587197353;
        bh=nw+VTw9UskCuMvCgX4Me999roXJP64ZnEdNNc8xXhJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V0xRHuyGIN1GggiMdr3RoQFAPmUy9SZjHIrt8NbV9p19Wfc5yAVLxnDziXEe8kzUe
         MySocPsF/pd6Ig00xdFAHVi+2rC22mUhkv6ZSTH2A8k8+GtRpYEjgiqkBr56dfhJUt
         iEgHqeL89iDRzZITbOL8o6c2b0r0mGvVdCwMeaGI=
Date:   Sat, 18 Apr 2020 10:09:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Subject: Re: regression 5.6.4->5.6.5 at drivers/acpi/ec.c
Message-ID: <20200418080911.GA2412912@kroah.com>
References: <fdd9ce1d-146a-5fbf-75c5-3a9384603312@gmx.de>
 <5478a950-4355-8084-ea7d-fe8b270bf2e3@infradead.org>
 <5392275.BHAU0OPJTB@kreacher>
 <4b21c095-fbe5-1138-b977-a505baa41a2b@gmx.de>
 <CAJZ5v0icdVL6_yGpfsorqszdi9GcLxzYdvDqTJyG4ENzkOG2pQ@mail.gmail.com>
 <d66ad8f1-d7c5-dd8a-0eb4-9e560dc9ada1@gmx.de>
 <CAJZ5v0iXJK_kFzr=cOdcTdc947MOcm2hvNV1WgvAnxOY7uvWfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJZ5v0iXJK_kFzr=cOdcTdc947MOcm2hvNV1WgvAnxOY7uvWfg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 09:54:54PM +0200, Rafael J. Wysocki wrote:
> On Fri, Apr 17, 2020 at 9:41 PM Toralf Förster <toralf.foerster@gmx.de> wrote:
> >
> > On 4/17/20 8:52 PM, Rafael J. Wysocki wrote:
> > > On Fri, Apr 17, 2020 at 6:36 PM Toralf Förster <toralf.foerster@gmx.de> wrote:
> > >>
> > >> On 4/17/20 5:53 PM, Rafael J. Wysocki wrote:
> > >>> Does the patch below (untested) make any difference?
> > >>>
> > >>> ---
> > >>>  drivers/acpi/ec.c |    5 ++++-
> > >>>  1 file changed, 4 insertions(+), 1 deletion(-)
> > >>>
> > >>> Index: linux-pm/drivers/acpi/ec.c
> > >>> ===================================================================
> > >>> --- linux-pm.orig/drivers/acpi/ec.c
> > >>> +++ linux-pm/drivers/acpi/ec.c
> > >>> @@ -2067,7 +2067,10 @@ static struct acpi_driver acpi_ec_driver
> > >>>               .add = acpi_ec_add,
> > >>>               .remove = acpi_ec_remove,
> > >>>               },
> > >>> -     .drv.pm = &acpi_ec_pm,
> > >>> +     .drv = {
> > >>> +             .probe_type = PROBE_FORCE_SYNCHRONOUS,
> > >>> +             .pm = &acpi_ec_pm,
> > >>> +     },
> > >>>  };
> > >>>
> > >>>  static void acpi_ec_destroy_workqueues(void)
> > >> I'd say no, but for completeness:
> > >
> > > OK, it looks like mainline commit
> > >
> > > 65a691f5f8f0 ("ACPI: EC: Do not clear boot_ec_is_ecdt in acpi_ec_add()")
> > >
> > > was backported into 5.6.5 by mistake.
> > >
> > > Can you please revert that patch and retest?
> > >
> > Yes, reverting that commit solved the issue.
> 
> OK, thanks!
> 
> Greg, I'm not sure why commit 65a691f5f8f0 from the mainline ended up in 5.6.5.
> 
> It has not been marked for -stable or otherwise requested to be
> included AFAICS.  Also it depends on other mainline commits that have
> not been included into 5.6.5.
> 
> Can you please drop it?

Will go do so right now, sorry about that.  Sasha, you might want to
adjust your tools a bit...
