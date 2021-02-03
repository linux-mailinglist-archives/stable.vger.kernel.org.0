Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6553730D9E6
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhBCMi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 07:38:57 -0500
Received: from foss.arm.com ([217.140.110.172]:39158 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhBCMi4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 07:38:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97E76D6E
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 04:38:10 -0800 (PST)
Received: from [10.57.49.26] (unknown [10.57.49.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 468B23F73B
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 04:38:10 -0800 (PST)
Subject: Re: [PATCH v2 0/3] drm: panfrost: Coherency support
From:   Robin Murphy <robin.murphy@arm.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <cover.1600780574.git.robin.murphy@arm.com>
Message-ID: <61cc1b7b-9622-f346-7ae4-a2c2b2d75a2a@arm.com>
Date:   Wed, 3 Feb 2021 12:38:09 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <cover.1600780574.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 2020-09-22 15:16, Robin Murphy wrote:
> Hi all,
> 
> Here's a quick v2 with the tags so far picked up and some inline
> commentary about the shareability domains for the pagetable code.
> 
> Robin.
> 
> 
> Robin Murphy (3):
>    iommu/io-pgtable-arm: Support coherency for Mali LPAE
>    drm/panfrost: Support cache-coherent integrations
>    arm64: dts: meson: Describe G12b GPU as coherent

Please would you consider applying these patches to 5.10 stable? The 
mainline commit IDs are now:

728da60da7c1 iommu/io-pgtable-arm: Support coherency for Mali LPAE
268af50f38b1 drm/panfrost: Support cache-coherent integrations
03544505cb10 arm64: dts: meson: Describe G12b GPU as coherent

and I've checked that they cherry-pick to the current 5.10.y branch 
(5.10.12) cleanly.

Amlogic-based boards that require this support are quite popular, and 
end-users are now starting to run into the weird behaviour that ensues 
without it, which is all to easy to misattribute to the userspace driver 
in Mesa, e.g. [1],[2]. Fortunately 5.10 also happens to be the first 
kernel version to start probing the particular GPU models on these SoCs 
anyway, and I'm not aware of any other significant systems that are 
affected, so I don't believe we will need to worry about any other 
stable versions.

Thanks,
Robin.

[1] https://gitlab.freedesktop.org/mesa/mesa/-/issues/4157
[2] https://gitlab.freedesktop.org/mesa/mesa/-/issues/4160

> 
>   arch/arm64/boot/dts/amlogic/meson-g12b.dtsi |  4 ++++
>   drivers/gpu/drm/panfrost/panfrost_device.h  |  1 +
>   drivers/gpu/drm/panfrost/panfrost_drv.c     |  2 ++
>   drivers/gpu/drm/panfrost/panfrost_gem.c     |  2 ++
>   drivers/gpu/drm/panfrost/panfrost_mmu.c     |  1 +
>   drivers/iommu/io-pgtable-arm.c              | 11 ++++++++++-
>   6 files changed, 20 insertions(+), 1 deletion(-)
> 
