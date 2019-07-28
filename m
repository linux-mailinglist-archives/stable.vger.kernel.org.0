Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB44A7804D
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 17:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfG1PmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 11:42:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfG1PmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jul 2019 11:42:21 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8142075E;
        Sun, 28 Jul 2019 15:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564328541;
        bh=wmj2MrQdYsB1H4j+eK3s6w5CAsAnby5ZrTdW0H0xj8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YtSu8m/K8qY6HXA61uRuyOIKSyzdUMyT0A4W+MvhdG7Um8pBfZ46SXPh/QSzgLQRd
         RruST9PrPzayGRi6mqXIKrgwfUVCaWijKnEXKwcaYBF/pG4OBqfsunZSGMGQkEkhF0
         cl/LeIBvP3sFzv41F/WtMiDIWDrXkoWo2oaa1zYI=
Date:   Sun, 28 Jul 2019 11:42:19 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vidya Sagar <vidyas@nvidia.com>,
        Thierry Reding <treding@nvidia.com>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 41/60] PCI: tegra: Enable Relaxed Ordering
 only for Tegra20 & Tegra30
Message-ID: <20190728154219.GI8637@sasha-vm>
References: <20190719041109.18262-1-sashal@kernel.org>
 <20190719041109.18262-41-sashal@kernel.org>
 <20190719135301.GA685@e121166-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190719135301.GA685@e121166-lin.cambridge.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 19, 2019 at 02:53:09PM +0100, Lorenzo Pieralisi wrote:
>On Fri, Jul 19, 2019 at 12:10:50AM -0400, Sasha Levin wrote:
>> From: Vidya Sagar <vidyas@nvidia.com>
>>
>> [ Upstream commit 7be142caabc4780b13a522c485abc806de5c4114 ]
>>
>> The PCI Tegra controller conversion to a device tree configurable
>> driver in commit d1523b52bff3 ("PCI: tegra: Move PCIe driver
>> to drivers/pci/host") implied that code for the driver can be
>> compiled in for a kernel supporting multiple platforms.
>>
>> Unfortunately, a blind move of the code did not check that some of the
>> quirks that were applied in arch/arm (eg enabling Relaxed Ordering on
>> all PCI devices - since the quirk hook erroneously matches PCI_ANY_ID
>> for both Vendor-ID and Device-ID) are now applied in all kernels that
>> compile the PCI Tegra controlled driver, DT and ACPI alike.
>>
>> This is completely wrong, in that enablement of Relaxed Ordering is only
>> required by default in Tegra20 platforms as described in the Tegra20
>> Technical Reference Manual (available at
>> https://developer.nvidia.com/embedded/downloads#?search=tegra%202 in
>> Section 34.1, where it is mentioned that Relaxed Ordering bit needs to
>> be enabled in its root ports to avoid deadlock in hardware) and in the
>> Tegra30 platforms for the same reasons (unfortunately not documented
>> in the TRM).
>>
>> There is no other strict requirement on PCI devices Relaxed Ordering
>> enablement on any other Tegra platforms or PCI host bridge driver.
>>
>> Fix this quite upsetting situation by limiting the vendor and device IDs
>> to which the Relaxed Ordering quirk applies to the root ports in
>> question, reported above.
>>
>> Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
>> [lorenzo.pieralisi@arm.com: completely rewrote the commit log/fixes tag]
>> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>> Acked-by: Thierry Reding <treding@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi Sasha,
>
>as Jon requested, please drop this patch from the autosel patch
>queue, thank you very much.

Now dropped from the queue, thanks!

--
Thanks,
Sasha
