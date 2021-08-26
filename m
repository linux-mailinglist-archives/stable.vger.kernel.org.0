Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D0D3F8788
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 14:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbhHZMcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 08:32:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233929AbhHZMcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 08:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC4A16108F;
        Thu, 26 Aug 2021 12:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629981090;
        bh=hZd4ssosBkmRVcvUeecQSDhLJVW2Jd22onCzpLAN62I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwGcbxTY5ghmvbms4pnO2cNP6BjbNaGIH7SrozHSaggGs+M9PcuU9T4+pqNHsRAYS
         AFqHA2B4SxNJeag3yVoDgcBafc0f1tm1LP30068JbwKxQx4xcUwbhuDCok6JCp5V2I
         L6uZ1qQsoQO0gwQo0nrZQXcT2nu0xrMhQHwpVTv9TWF+0Kg+t+tnTMOmcA0hLWHOrA
         GzNFhcl7oOhMK4KWSfdEquk4XHOfeTv30813fdBMJE+S8suNJ+zbPGHT7YFPzDTldC
         NQVvnQpVciQu95a/Wlsc74sPZxVb1wq+nv2ULnzQERfXToQ6iNkqevFrQUkyTScM4c
         8jm79VvCvvCiQ==
Date:   Thu, 26 Aug 2021 08:31:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Doug Anderson <dianders@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Alim Akhtar <alim.akhtar@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 4.4 25/31] mmc: dw_mmc: Wait for data transfer after
 response errors.
Message-ID: <YSeJoAYkHeeCVce7@sashalap>
References: <20210824170743.710957-1-sashal@kernel.org>
 <20210824170743.710957-26-sashal@kernel.org>
 <CABMQnVJrxqB8koLO9-mBCZgRyQydU7x7B8aHgRPjpxw92hBWjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABMQnVJrxqB8koLO9-mBCZgRyQydU7x7B8aHgRPjpxw92hBWjQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 26, 2021 at 08:59:53PM +0900, Nobuhiro Iwamatsu wrote:
>Hi,
>
>
>2021年8月25日(水) 2:39 Sasha Levin <sashal@kernel.org>:
>>
>> From: Doug Anderson <dianders@chromium.org>
>>
>> [ Upstream commit 46d179525a1f6d16957dcb4624517bc04142b3e7 ]
>>
>> According to the DesignWare state machine description, after we get a
>> "response error" or "response CRC error" we move into data transfer
>> mode. That means that we don't necessarily need to special case
>> trying to deal with the failure right away. We can wait until we are
>> notified that the data transfer is complete (with or without errors)
>> and then we can deal with the failure.
>>
>> It may sound strange to defer dealing with a command that we know will
>> fail anyway, but this appears to fix a bug. During tuning (CMD19) on
>> a specific card on an rk3288-based system, we found that we could get
>> a "response CRC error". Sending the stop command after the "response
>> CRC error" would then throw the system into a confused state causing
>> all future tuning phases to report failure.
>>
>> When in the confused state, the controller would show these (hex codes
>> are interrupt status register):
>>  CMD ERR: 0x00000046 (cmd=19)
>>  CMD ERR: 0x0000004e (cmd=12)
>>  DATA ERR: 0x00000208
>>  DATA ERR: 0x0000020c
>>  CMD ERR: 0x00000104 (cmd=19)
>>  CMD ERR: 0x00000104 (cmd=12)
>>  DATA ERR: 0x00000208
>>  DATA ERR: 0x0000020c
>>  ...
>>  ...
>>
>> It is inherently difficult to deal with the complexity of trying to
>> correctly send a stop command while a data transfer is taking place
>> since you need to deal with different corner cases caused by the fact
>> that the data transfer could complete (with errors or without errors)
>> during various places in sending the stop command (dw_mci_stop_dma,
>> send_stop_abort, etc)
>>
>> Instead of adding a bunch of extra complexity to deal with this, it
>> seems much simpler to just use the more straightforward (and less
>> error-prone) path of letting the data transfer finish. There
>> shouldn't be any huge benefit to sending the stop command slightly
>> earlier, anyway.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
>> Cc: Alim Akhtar <alim.akhtar@gmail.com>
>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This commit also requires the following modifications:
>  ba2d139b02ba68: mmc: dw_mmc: Fix occasional hang after tuning on eMMC
>
>Please apply this commit too.

Will do, thanks!

-- 
Thanks,
Sasha
