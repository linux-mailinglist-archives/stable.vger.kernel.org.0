Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCF24FDDA
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 21:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFWT07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 15:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbfFWT06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Jun 2019 15:26:58 -0400
Received: from localhost (unknown [107.242.116.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77FBA20645;
        Sun, 23 Jun 2019 19:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561318017;
        bh=Qk84AQXyLsM0Q715iByu0Urs776YIzdFYFvfNBzaHSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nvyWq0tGWxoBQWi1U8yw0GrSEkKGf9Ep8x5Mzd/lvnjUaj/tNarFybHick6q4z6r3
         CSp9qsNHB+WS2E64s8Df+Zepy2dC1lYlLwV7iqvfMZooIdAwElf2I9lw7JjCE1l//A
         c+QaMlPr6TDTUPIbb1suKEJ196kigSoZ4+ARTdiI=
Date:   Sun, 23 Jun 2019 15:26:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chengguang Xu <cgxu519@gmx.com>, Wu Hao <hao.wu@intel.com>,
        Alan Tull <atull@kernel.org>, linux-fpga@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 17/59] fpga: dfl: expand minor range when
 registering chrdev region
Message-ID: <20190623192652.GM2226@sasha-vm>
References: <20190614202843.26941-1-sashal@kernel.org>
 <20190614202843.26941-17-sashal@kernel.org>
 <20190615054806.GB23883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190615054806.GB23883@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 15, 2019 at 07:48:06AM +0200, Greg Kroah-Hartman wrote:
>On Fri, Jun 14, 2019 at 04:28:01PM -0400, Sasha Levin wrote:
>> From: Chengguang Xu <cgxu519@gmx.com>
>>
>> [ Upstream commit de9a7f6f5f1967d275311cca9163b4a3ffe9b0ae ]
>>
>> Actually, total amount of available minor number
>> for a single major is MINORMASK + 1. So expand
>> minor range when registering chrdev region.
>>
>> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
>> Acked-by: Wu Hao <hao.wu@intel.com>
>> Acked-by: Alan Tull <atull@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/fpga/dfl.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
>> index c25217cde5ca..4b66aaa32b5a 100644
>> --- a/drivers/fpga/dfl.c
>> +++ b/drivers/fpga/dfl.c
>> @@ -322,7 +322,7 @@ static void dfl_chardev_uinit(void)
>>  	for (i = 0; i < DFL_FPGA_DEVT_MAX; i++)
>>  		if (MAJOR(dfl_chrdevs[i].devt)) {
>>  			unregister_chrdev_region(dfl_chrdevs[i].devt,
>> -						 MINORMASK);
>> +						 MINORMASK + 1);
>>  			dfl_chrdevs[i].devt = MKDEV(0, 0);
>>  		}
>>  }
>> @@ -332,8 +332,8 @@ static int dfl_chardev_init(void)
>>  	int i, ret;
>>
>>  	for (i = 0; i < DFL_FPGA_DEVT_MAX; i++) {
>> -		ret = alloc_chrdev_region(&dfl_chrdevs[i].devt, 0, MINORMASK,
>> -					  dfl_chrdevs[i].name);
>> +		ret = alloc_chrdev_region(&dfl_chrdevs[i].devt, 0,
>> +					  MINORMASK + 1, dfl_chrdevs[i].name);
>>  		if (ret)
>>  			goto exit;
>>  	}
>
>Not a bugfix, so not needed for stable kernels, thanks.

Dropped, thanks!

--
Thanks,
Sasha
