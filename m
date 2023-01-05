Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AACC565E62F
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjAEHpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:45:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjAEHpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E14389F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 23:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FA08618DC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 07:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41935C433D2;
        Thu,  5 Jan 2023 07:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672904719;
        bh=PSFpKUUI2l7lFnd4mWauq6Ta6EsNCwJJPHEA3n+OFkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+6Wqh/om0YoJ66mdlIZU1tCA0wRDYsaZImLlPf7rN0TRu6PtOxwKwuINCCWptLdn
         vfX6fZgKRC8CFb3Q19yKkwzVduZVvT9jGrA5DiJFXUwQMAS4fLL4qm/0cB04DxaWs7
         /JdlySZroO+5JnIs+paAk6ZYz6VJn45VSED6UIgE=
Date:   Thu, 5 Jan 2023 08:45:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Backport using Microsoft GUID for s2idle on AMD
Message-ID: <Y7aADAZ07+f/97Xn@kroah.com>
References: <MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61015DB3D6EDBFD841157918E2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 07:46:58PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> At *least* 9 models of laptops across manufacturers have problems with suspend that are root caused
> to the firmware not properly implementing an AMD specific codepath, but that did implement a
> Microsoft specific one properly. To fix the suspend issues on Linux, a number of commits have been
> worked out over the last few kernel releases.  
> 
> We have eventually landed at we're going to just use the Microsoft codepath in Linux.

That is the correct solution as that is the only codepath that vendors
test.  And it's what we do for the rest of ACPI, and have done, for
decades now.  Odd that it wasn't the way this was done originally.

> All the patches to accomplish this are now landed in 6.2-rc1, and also in 6.1.3.
> 
> Now that have this all working satisfactorily I'd like to bring those fixes into 6.0.y and 5.15.y as well.
> 
> Here is the series of commits for 6.0.y:
> 
> 100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into structures
> fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt
> a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GUID
> d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
> ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
> 888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
> 631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG Flow X13
> 39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
> 54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
> 577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
> e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+

6.0 is about to go end-of-life in a few days, so this isn't needed.

> Here is the series of commits for 5.15.y:
> 
> ed470febf837 ACPI: PM: s2idle: Add support for upcoming AMD uPEP HID AMDI008
> 1a2dcab517cb ACPI: PM: s2idle: Use LPS0 idle if ACPI_FADT_LOW_POWER_S0 is unset
> 100a57379380 ACPI: x86: s2idle: Move _HID handling for AMD systems into structures
> fd894f05cf30 ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt
> a0bc002393d4 ACPI: x86: s2idle: Add module parameter to prefer Microsoft GUID
> d0f61e89f08d ACPI: x86: s2idle: Add a quirk for ASUS TUF Gaming A17 FA707RE
> ddeea2c3cb88 ACPI: x86: s2idle: Add a quirk for ASUS ROG Zephyrus G14
> 888ca9c7955e ACPI: x86: s2idle: Add a quirk for Lenovo Slim 7 Pro 14ARH7
> 631b54519e8e ACPI: x86: s2idle: Add a quirk for ASUSTeK COMPUTER INC. ROG Flow X13
> 39f81776c680 ACPI: x86: s2idle: Fix a NULL pointer dereference
> 54bd1e548701 ACPI: x86: s2idle: Add another ID to s2idle_dmi_table
> 577821f756cf ACPI: x86: s2idle: Force AMD GUID/_REV 2 on HP Elitebook 865
> e6d180a35bc0 ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
> 
> Can you please backport these for a future stable release?

That's adding new features for an old kernel, what's keeping people with
this hardware from using the 6.1 kernel instead?  What distros are
insisting that this needs to be in 5.15.y?

thanks,

greg k-h
