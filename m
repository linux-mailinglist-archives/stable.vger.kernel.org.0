Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8062A53FCF8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiFGLJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242612AbiFGLJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:09:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965911117B;
        Tue,  7 Jun 2022 04:05:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55F9EB81F18;
        Tue,  7 Jun 2022 11:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE31C385A5;
        Tue,  7 Jun 2022 11:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654599904;
        bh=VY0hlQVsGfljGMVlapc79czVC7ldOsRds3r0EHpM/aE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CDRPNPrxaeZpe93t5b2tWHvEnVKI17rcFD+BtIq7/B7l2iQoXPXJojlAuldY6+39F
         H5pMiSfmtXB131vjChWiFGiP22nqq9e5SxnF2nUfaPMhuVG0e2uVNfptDwODp6INut
         oeMH1CPw+jUyehx/6gXnsxuysoRx5oVwBsMsGQG5aKH/zmv+KzcZjyFdPJW+MJJxtL
         vYHVaU8vg2b8F/2raejdW0YCqD0MJTT7VXlirOpMuudZb9+zfsw9M+dpOHUdkS0kbf
         Jt1QKCHpMWiGb0A+6glZC3gITkkWcbGlrUp+NcZnXPQm9z9tELM84foIKWw8eBbXxp
         OXgvnMkqm38ew==
Date:   Tue, 7 Jun 2022 07:05:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "quic_jhugo@quicinc.com" <quic_jhugo@quicinc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector"
 has been added to the 5.18-stable tree
Message-ID: <Yp8w3tEtNVx8s37C@sashalap>
References: <20220606110755.135215-1-sashal@kernel.org>
 <BYAPR21MB1270ADDD7775284F1187E823BFA29@BYAPR21MB1270.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BYAPR21MB1270ADDD7775284F1187E823BFA29@BYAPR21MB1270.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 06, 2022 at 05:02:41PM +0000, Dexuan Cui wrote:
>> From: Sasha Levin <sashal@kernel.org>
>> Sent: Monday, June 6, 2022 4:08 AM
>> To: stable-commits@vger.kernel.org; quic_jhugo@quicinc.com
>> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
>> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
>> Wei Liu <wei.liu@kernel.org>; Dexuan Cui <decui@microsoft.com>; Lorenzo
>> Pieralisi <lorenzo.pieralisi@arm.com>; Rob Herring <robh@kernel.org>;
>> Krzysztof Wilczyński <kw@linux.com>; Bjorn Helgaas <bhelgaas@google.com>
>> Subject: Patch "PCI: hv: Fix multi-MSI to allow more than one MSI vector" has
>> been added to the 5.18-stable tree
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>     PCI: hv: Fix multi-MSI to allow more than one MSI vector
>
>(+ stable@vger.kernel.org)
>
>Hi Sasha and stable kernel maintainers,
>If we want to support multi-MSI in the pci-hyperv driver, we need all of the
>4 patches:
>
>08e61e861a0e ("PCI: hv: Fix multi-MSI to allow more than one MSI vector")
>455880dfe292 ("PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI")
>b4b77778ecc5 ("PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()")
>a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
>
>Multi-MSI can't work properly if we only pick up the first patch.
>
>We need to either pick up all the 4 patches to 5.18/5.17/etc. or pick up nothing.
>I suggest we pick up all the 4 patches.
>The patch author Jeffrey may want to chime in.

Hey Dexuan,

I wasn't trying to enable multi-MSI, I was just picking something that
looked like a fix. I'll go ahead and drop it, thanks!

-- 
Thanks,
Sasha
