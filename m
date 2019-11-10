Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13421F6921
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 14:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfKJN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 08:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726301AbfKJN12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 08:27:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 677D520842;
        Sun, 10 Nov 2019 13:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573392447;
        bh=/aAS81CjOifeeNA7ZvXi+dQlY4r367Vx/Fui8g6nnew=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q/r7veqmNQjQpaVc+WLTgjr2c63Q8DL1hSvU/TMHMleHzyEaVQhKfmxI3t56bhNNs
         4eZOl0MFODsSVIn5sDEbYOYgwqPd7gVVrMa6BmWsCOFB/kw3E22HNhz6ppfvVgg/jR
         xVBiu2JTKm3uari2Ta08NEXKeelqZVnVGZHCnINY=
Date:   Sun, 10 Nov 2019 08:27:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 4.19 133/191] efi: honour memory reservations
 passed via a linux specific config table
Message-ID: <20191110132726.GN4787@sasha-vm>
References: <20191110024013.29782-1-sashal@kernel.org>
 <20191110024013.29782-133-sashal@kernel.org>
 <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-PawCS_Wq3Hm+gm_f=6-ihXarkQqP9prkj4CLt=pAnvg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 10, 2019 at 08:33:47AM +0100, Ard Biesheuvel wrote:
>On Sun, 10 Nov 2019 at 03:44, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> [ Upstream commit 71e0940d52e107748b270213a01d3b1546657d74 ]
>>
>> In order to allow the OS to reserve memory persistently across a
>> kexec, introduce a Linux-specific UEFI configuration table that
>> points to the head of a linked list in memory, allowing each kernel
>> to add list items describing memory regions that the next kernel
>> should treat as reserved.
>>
>> This is useful, e.g., for GICv3 based ARM systems that cannot disable
>> DMA access to the LPI tables, forcing them to reuse the same memory
>> region again after a kexec reboot.
>>
>> Tested-by: Jeremy Linton <jeremy.linton@arm.com>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>NAK
>
>This doesn't belong in -stable, and I'd be interested in understanding
>how this got autoselected, and how I can prevent this from happening
>again in the future.

It was selected because it's part of a fix for a real issue reported by
users:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1806766

Besides ubuntu, it is also carried by:

SUSE: https://www.suse.com/support/update/announcement/2019/suse-su-20191530-1/
CentOS: https://koji.mbox.centos.org/koji/buildinfo?buildID=4558

As a way to resolve the reported bug.

Any reason this *shouldn't* be in stable? I'm aware that there might be
dependencies that are not obvious to me, but the solution here is to
take those dependencies as well rather than ignore the process
completely.

-- 
Thanks,
Sasha
