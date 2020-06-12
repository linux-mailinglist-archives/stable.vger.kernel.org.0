Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E781F7195
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 03:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFLBH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 21:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbgFLBH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 21:07:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A1E020842;
        Fri, 12 Jun 2020 01:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591924076;
        bh=TFInTkHIbkTJqhuVQy0vXj9Dfmfs4VSM33hgXD/T2sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sm4viin1nDwqYaWsgKMeRaagqwOUD0UK8hvTDgr3/7auKkkWA9IFaYZJrV7WFMYMl
         Zw0FbyDAxukyo1JCVHoSxWNS2s6BJn+FnLjByO1kP4hY8igAixQDG1xj95BLR+e3Sp
         JpnJynA12mavuFjzo5qxvSFYVd8JDo3L1LTX30yU=
Date:   Thu, 11 Jun 2020 21:07:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        Mark Bloch <markb@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH 4.19 25/25] Revert "net/mlx5: Annotate mutex destroy for
 root ns"
Message-ID: <20200612010755.GW1407771@sasha-vm>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.624603139@linuxfoundation.org>
 <9233056dbbce44ab5e3a3d401e4e5da119a36780.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <9233056dbbce44ab5e3a3d401e4e5da119a36780.camel@mellanox.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 10:17:33PM +0000, Saeed Mahameed wrote:
>On Tue, 2020-06-09 at 19:45 +0200, Greg Kroah-Hartman wrote:
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> This reverts commit 95fde2e46860c183f6f47a99381a3b9bff488bd5 which is
>> commit 9ca415399dae133b00273a4283ef31d003a6818d upstream.
>>
>> It was backported incorrectly, Paul writes at:
>> 	https://lore.kernel.org/r/20200607203425.GD23662@windriver.com
>>
>> 	I happened to notice this commit:
>>
>> 	9ca415399dae - "net/mlx5: Annotate mutex destroy for root ns"
>>
>> 	...was backported to 4.19 and 5.4 and v5.6 in linux-stable.
>>
>> 	It patches del_sw_root_ns() - which only exists after v5.7-rc7
>> from:
>>
>> 	6eb7a268a99b - "net/mlx5: Don't maintain a case of del_sw_func
>> being
>> 	null"
>>
>> 	which creates the one line del_sw_root_ns stub function around
>> 	kfree(node) by breaking it out of tree_put_node().
>>
>> 	In the absense of del_sw_root_ns - the backport finds an
>> identical one
>> 	line kfree stub fcn - named del_sw_prio from this earlier
>> commit:
>>
>> 	139ed6c6c46a - "net/mlx5: Fix steering memory leak"  [in v4.15-
>> rc5]
>>
>> 	and then puts the mutex_destroy() into that (wrong) function,
>> instead of
>> 	putting it into tree_put_node where the root ns case used to be
>> hand
>>
>> Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Roi Dayan <roid@mellanox.com>
>> Cc: Mark Bloch <markb@mellanox.com>
>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>Acked-by: Saeed Mahameed <saeedm@mellanox.com>
>
>
>I don't know if this was due to something wrong in my backporting
>process or AUTOSEL/wrong Fixes tag related. I will check later and will
>try my best to avoid this in the future.

I'm not sure what happened there, but FWIW - AUTOSEL wasn't involved.

-- 
Thanks,
Sasha
