Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C110C5C4
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 10:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfK1JPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 04:15:50 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:16231 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfK1JPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 04:15:50 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddf903f0000>; Thu, 28 Nov 2019 01:15:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 28 Nov 2019 01:15:49 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 28 Nov 2019 01:15:49 -0800
Received: from [10.21.133.51] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 28 Nov
 2019 09:15:47 +0000
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
        <ben.hutchings@codethink.co.uk>, <lkft-triage@lists.linaro.org>,
        <stable@vger.kernel.org>, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191127202845.651587549@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0c65f759-f22c-1b15-1f71-929def8ac43e@nvidia.com>
Date:   Thu, 28 Nov 2019 09:15:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191127202845.651587549@linuxfoundation.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574932543; bh=V74iSjsTEwiiPrnOfi0LtxlFEQG8OKs27AT3qLvjsjc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=JPxrg/kzFyWejtuin+B7lEjpILoBP8FbjcVwUgvfWi5xZ8KpE4KsL8q6fRaiaMW7f
         5MAARFZ/tyj9byIb367//45vEhD//K0O3BKr2XIhPlYEfohxBObmlyCl67Rb3y356s
         whZ2nUrueugKuX5P0brgcP08mI5nLg2LYtrd6pwp6PZz47pBvLqXygHfX5Fh23eYB7
         eM/GforiEKy5Ej473jN0IkVWHHql4pfLnKEHV8Qz8p8AUw7CZe4rGXqZJB2syLhgJW
         botpMgAc0p+txnVjSAHXBoq7o8gIKIbM5M4Of8I6hQsEb5aHZvG1lWfqp5Hgk5IV5B
         N0qfM57UqAtDQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 27/11/2019 20:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.14 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

...

> Jouni Hogander <jouni.hogander@unikie.com>
>     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject

The above commit is causing a boot regression (NULL pointer deference
crash) on Tegra210 for v5.3. Reverting this on top of 5.3.14-rc1 fixes
the problem. Complete results for Tegra are here ...

Test results for stable-v5.3:
    13 builds:	13 pass, 0 fail
    24 boots:	18 pass, 6 fail
    34 tests:	34 pass, 0 fail

Linux version:	5.3.14-rc1-g7173a2d18fa6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Cheers
Jon

-- 
nvpublic
