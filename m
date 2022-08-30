Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE175A7040
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 00:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiH3WBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 18:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbiH3WA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 18:00:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7489C217;
        Tue, 30 Aug 2022 14:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C7F5CE1E03;
        Tue, 30 Aug 2022 21:55:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD721C433D6;
        Tue, 30 Aug 2022 21:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661896536;
        bh=2F7UFQ0fKf/NQjMiKJvWGpSvFyOQISCwuLsxK+CqnRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N0cEoX7FLgRrYFHrYFlVDRiG4K3e0ACCl5cjV83BNSYHffG3+RJuwU3Wrp69QkiFb
         BMnSMG/eoyonXJ9BdxpUzj8WP4v49Tdy6Bbj5ZnV0ub8Y2suneBrdlTLGv29iGm042
         VM5WyYivgdSoEPtQ6trDYulTKodEzfpohtffVleMDVK/5MT6Gr3XPEUeRCJCmj2a7k
         GJAVlGW3c8NUjcps0dDH5Hgcve6g7YiB8Ig7AcciH8kvyLgF9PL/0Ic86qkAABJyqF
         c6jo/dEjjf64k6Cf7l9mpP58MsSMPp4mSvWtOlmS8WXrFJ4F6fB2ykI2AkMHuQYjIN
         mIAm0S647fAXA==
Received: by pali.im (Postfix)
        id 07D0D834; Tue, 30 Aug 2022 23:55:32 +0200 (CEST)
Date:   Tue, 30 Aug 2022 23:55:32 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, bjorn@helgaas.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Message-ID: <20220830215532.6nnl6d4cfg55dmcl@pali>
References: <20220823080115.331990024@linuxfoundation.org>
 <20220823080123.228828362@linuxfoundation.org>
 <CABhMZUVycsyy76j2Z=K+C6S1fwtzKE1Lx2povXKfB80o9g0MtQ@mail.gmail.com>
 <YwXH/l37HaYQD66B@kroah.com>
 <47b775c5-57fa-5edf-b59e-8a9041ffbee7@candelatech.com>
 <20220830205832.g3lyysmgkarijkvj@pali>
 <00735f18-11f9-c6c6-4abf-002d378957df@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00735f18-11f9-c6c6-4abf-002d378957df@candelatech.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday 30 August 2022 14:28:14 Ben Greear wrote:
> On 8/30/22 1:58 PM, Pali Rohár wrote:
> > On Tuesday 30 August 2022 13:47:48 Ben Greear wrote:
> > > On 8/23/22 11:41 PM, Greg Kroah-Hartman wrote:
> > > > On Tue, Aug 23, 2022 at 07:20:14AM -0500, Bjorn Helgaas wrote:
> > > > > On Tue, Aug 23, 2022, 6:35 AM Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > wrote:
> > > > > 
> > > > > > From: Stefan Roese <sr@denx.de>
> > > > > > 
> > > > > > [ Upstream commit 8795e182b02dc87e343c79e73af6b8b7f9c5e635 ]
> > > > > > 
> > > > > 
> > > > > There's an open regression related to this commit:
> > > > > 
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=216373
> > > > 
> > > > This is already in the following released stable kernels:
> > > > 	5.10.137 5.15.61 5.18.18 5.19.2
> > > > 
> > > > I'll go drop it from the 4.19 and 5.4 queues, but when this gets
> > > > resolved in Linus's tree, make sure there's a cc: stable on the fix so
> > > > that we know to backport it to the above branches as well.  Or at the
> > > > least, a "Fixes:" tag.
> > > 
> > > This is still in 5.19.5.  We saw some funny iwlwifi crashes in 5.19.3+
> > > that we did not see in 5.19.0+.  I just bisected the scary looking AER errors to this
> > > patch, though I do not know for certain if it causes the iwlwifi related crashes yet.
> > > 
> > > In general, from reading the commit msg, this patch doesn't seem to be a great candidate
> > > for stable in general.  Does it fix some important problem?
> > > 
> > > In case it helps, here is example of what I see in dmesg.  The kernel crashes in iwlwifi
> > > had to do with rx messages from the firmware, and some warnings lead me to believe that
> > > pci messages were slow coming back and/or maybe duplicated.  So maybe this AER patch changes
> > > timing or otherwise screws up the PCI adapter boards we use...
> > 
> >  From that log I have feeling that issue is in that intel wifi card and
> > it was there also before that commit. Card is crashing (or something
> > other happens on PCIe bus) and because kernel had disabled Error
> > Reporting for this card, nobody spotted any issue. And that commit just
> > opened eye to kernel to see those errors.
> > 
> > I think this issue should be reported to intel wifi card developers,
> > maybe they comment it, why card is reporting errors.
> 
> My main concern is not that AER messages started showing up, but that there
> started being kernel NPE and WARNINGS showing up sometime after 5.19.0.
> 
> Possibly this AER thing is mis-direction and the real bug is elsewhere,
> but since the bugzilla also indicated (different) driver crashes, then
> I am suspicious this changes things more significantly, at least in a subset
> of hardware out there.

Yea, of course, this is something needed to investigate.

Anyway, do you see driver crashes? Or just these AER errors? And are
your PCIe cards working, or after seeing these messages in dmesg they
stopped working? It is needed to know if you are just spammed by tons of
lines in dmesg and otherwise everything works. Or if after AER errors
your PCIe devices stop working and rebooting system is required.

> Also, any idea what this error in my logs is actually indicating?

Your PCIe controller received non-fatal, but uncorrected error. There is
also indication of Unsupported Request Completion Status. Unsupported
Request is generated by PCIe device when controller / host / kernel try
to do something which is not supported by device; pretty generic error.
PCIe base spec describe lot of scenarios when card should return this
error. Maybe some more detailed information are in TLP Header hexdump,
but I cannot decode it now.

Basically it is PCIe card driver who could know how fatal it is that
issue and how to recover from it. But as you can see intel wifi driver
does not implement that callback.

> Thanks,
> Ben
> 
> > 
> > > 
> > > [   50.905809] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
> > > [   50.905830] pcieport 0000:03:01.0: AER: device recovery failed
> > > [   50.905831] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:01.0
> > > [   50.905845] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   50.915679] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   50.922735] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
> > > [   50.928230] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
> > > [   50.935126] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
> > > [   50.935133] pcieport 0000:03:01.0: AER: device recovery failed
> > > [   50.935134] pcieport 0000:00:1c.0: AER: Multiple Uncorrected (Non-Fatal) error received: 0000:03:01.0
> > > [   50.935222] pcieport 0000:03:01.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   50.945059] pcieport 0000:03:01.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   50.952120] pcieport 0000:03:01.0:    [20] UnsupReq               (First)
> > > [   50.957614] pcieport 0000:03:01.0: AER:   TLP Header: 34000000 04001f10 00000000 88c888c8
> > > [   50.964492] pcieport 0000:03:01.0: AER:   Error of this Agent is reported first
> > > [   50.970519] pcieport 0000:03:02.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   50.980344] pcieport 0000:03:02.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   50.987399] pcieport 0000:03:02.0:    [20] UnsupReq               (First)
> > > [   50.992891] pcieport 0000:03:02.0: AER:   TLP Header: 34000000 05001f10 00000000 88c888c8
> > > [   50.999785] pcieport 0000:03:03.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.009611] pcieport 0000:03:03.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.016665] pcieport 0000:03:03.0:    [20] UnsupReq               (First)
> > > [   51.022161] pcieport 0000:03:03.0: AER:   TLP Header: 34000000 06001f10 00000000 88c888c8
> > > [   51.029052] pcieport 0000:03:05.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.038881] pcieport 0000:03:05.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.045931] pcieport 0000:03:05.0:    [20] UnsupReq               (First)
> > > [   51.051430] pcieport 0000:03:05.0: AER:   TLP Header: 34000000 07001f10 00000000 88c888c8
> > > [   51.058320] pcieport 0000:03:07.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.068147] pcieport 0000:03:07.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.075200] pcieport 0000:03:07.0:    [20] UnsupReq               (First)
> > > [   51.080696] pcieport 0000:03:07.0: AER:   TLP Header: 34000000 08001f10 00000000 88c888c8
> > > [   51.087589] iwlwifi 0000:04:00.0: AER: can't recover (no error_detected callback)
> > > [   51.087598] pcieport 0000:03:01.0: AER: device recovery failed
> > > [   51.087611] iwlwifi 0000:05:00.0: AER: can't recover (no error_detected callback)
> > > [   51.087615] pcieport 0000:03:02.0: AER: device recovery failed
> > > [   51.087628] iwlwifi 0000:06:00.0: AER: can't recover (no error_detected callback)
> > > [   51.087631] pcieport 0000:03:03.0: AER: device recovery failed
> > > [   51.087643] iwlwifi 0000:07:00.0: AER: can't recover (no error_detected callback)
> > > [   51.087646] pcieport 0000:03:05.0: AER: device recovery failed
> > > [   51.087659] iwlwifi 0000:08:00.0: AER: can't recover (no error_detected callback)
> > > [   51.087662] pcieport 0000:03:07.0: AER: device recovery failed
> > > [   51.103761] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
> > > [   51.103778] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.113608] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.120658] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
> > > [   51.126152] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
> > > [   51.133044] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
> > > [   51.133068] pcieport 0000:03:0f.0: AER: device recovery failed
> > > [   51.168925] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
> > > [   51.168940] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.178773] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.185823] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
> > > [   51.191318] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
> > > [   51.198211] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
> > > [   51.198234] pcieport 0000:03:0f.0: AER: device recovery failed
> > > [   51.260695] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
> > > [   51.260710] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.270548] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.277605] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
> > > [   51.283103] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
> > > [   51.290009] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
> > > [   51.290033] pcieport 0000:03:0f.0: AER: device recovery failed
> > > [   51.328514] pcieport 0000:00:1c.0: AER: Uncorrected (Non-Fatal) error received: 0000:03:0f.0
> > > [   51.328530] pcieport 0000:03:0f.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
> > > [   51.331638] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
> > > [   51.338363] pcieport 0000:03:0f.0:   device [10b5:8619] error status/mask=00100000/00000000
> > > [   51.338364] pcieport 0000:03:0f.0:    [20] UnsupReq               (First)
> > > [   51.345413] ACPI: \: failed to evaluate _DSM bf0212f2-788f-c64d-a5b3-1f738e285ade (0x1001)
> > > [   51.350900] pcieport 0000:03:0f.0: AER:   TLP Header: 34000000 0f001f10 00000000 88c888c8
> > > [   51.350927] iwlwifi 0000:0f:00.0: AER: can't recover (no error_detected callback)
> > > 
> > > 
> > > Thanks,
> > > Ben
> > > 
> > > -- 
> > > Ben Greear <greearb@candelatech.com>
> > > Candela Technologies Inc  http://www.candelatech.com
> > > 
> > 
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
> 
