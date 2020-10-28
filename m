Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A27B29DFD4
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 02:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgJ2BFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 21:05:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbgJ1WFx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:05:53 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116422470E;
        Wed, 28 Oct 2020 22:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922753;
        bh=F1c6QXnKInsunrs54b2TDGrRkEY1sKVhgft/QBBBS/4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BE++ewv+P4nwQUTepsCZG6cKx0Y8e9s2HVp4cvHYT2JFtD+o0NMeixwS7XHof/FTU
         zIYkgzglXdN6urahcV9wNuV240zH6n21REZ42myOcV7+FL2Zmgs7och7o/cwobFX8l
         FjyCgExzfSM8KShC6S3hkap2uZ/BYpI3fKh+TePU=
Date:   Wed, 28 Oct 2020 18:05:51 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: Re: [PATCH 4.19 111/264] nvmem: core: fix possibly memleak when use
 nvmem_cell_info_to_nvmem_cell()
Message-ID: <20201028220551.GA87646@sasha-vm>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135435.887735842@linuxfoundation.org>
 <20201028201234.GA11038@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201028201234.GA11038@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 09:12:34PM +0100, Pavel Machek wrote:
>Hi!
>
>> From: Vadym Kochan <vadym.kochan@plvision.eu>
>>
>> [ Upstream commit fc9eec4d643597cf4cb2fef17d48110e677610da ]
>>
>> Fix missing 'kfree_const(cell->name)' when call to
>> nvmem_cell_info_to_nvmem_cell() in several places:
>>
>>      * after nvmem_cell_info_to_nvmem_cell() failed during
>>        nvmem_add_cells()
>>
>>      * during nvmem_device_cell_{read,write} when cell->name is
>>        kstrdup'ed() without calling kfree_const() at the end, but
>>        really there is no reason to do that 'dup, because the cell
>>        instance is allocated on the stack for some short period to be
>>        read/write without exposing it to the caller.
>>
>> So the new nvmem_cell_info_to_nvmem_cell_nodup() helper is introduced
>> which is used to convert cell_info -> cell without name duplication as
>> a lighweight version of nvmem_cell_info_to_nvmem_cell().
>>
>> Fixes: e2a5402ec7c6 ("nvmem: Add nvmem_device based consumer apis.")
>
>There's something very wrong here.

Right, looks like it actually fixes 16bb7abc4a6b ("nvmem: core: fix
memory abort in cleanup path"). I'll just drop this commit.

-- 
Thanks,
Sasha
