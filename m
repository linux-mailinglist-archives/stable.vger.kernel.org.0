Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13958FFE98
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 07:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfKRGfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 01:35:45 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9070 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfKRGfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Nov 2019 01:35:45 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd23bc10000>; Sun, 17 Nov 2019 22:35:45 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Sun, 17 Nov 2019 22:35:44 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Sun, 17 Nov 2019 22:35:44 -0800
Received: from [10.25.74.243] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Nov
 2019 06:35:41 +0000
Subject: Re: stable request: PCI: tegra: Enable Relaxed Ordering only for
 Tegra20 & Tegra30
From:   Vidya Sagar <vidyas@nvidia.com>
To:     <ben@decadent.org.uk>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, Jon Hunter <jonathanh@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Krishna Thota <kthota@nvidia.com>
References: <11251eb0-5675-9d3d-d15f-c346781e2bff@nvidia.com>
 <20191111130908.GA448544@kroah.com>
 <9d7871e7-f8aa-1ed5-dc2e-37ba6f218a2f@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <cd787fce-3675-a2d1-90a7-5fa0c4b3f946@nvidia.com>
Date:   Mon, 18 Nov 2019 12:05:38 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <9d7871e7-f8aa-1ed5-dc2e-37ba6f218a2f@nvidia.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574058945; bh=yC9YmO9iY4x6XOFtTJ1ck/A/zBa81wN0ty/ofzhcMCM=;
        h=X-PGP-Universal:Subject:From:To:CC:References:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=axtTL5tsvJLPbOAKbEFM+B0x9aKxiX3a2ex4f6BuWA9YNl8oCYsQPkP8SSb/YEQWK
         K9RpKpETTjz7V26J6Gxj4vgvPnx+YmjzUxZyY/goJMZgeqHzbFladMyUaPXnKmdnUt
         cFoP2WeelsXE2Cw/S+AIOEyA/j4xH34TFpSn6qWHJByNT5xXxV8Nsr8euwW/7se97e
         eAm7TMhKK9phU3z5RVUz/n4Cp2C//akydgZ7dr1JLWxhTcHX/1hApYjm4aYNmg4Kg9
         hfSTEk6cVMG9j0ebOXvRV3Zd0OhoEJruC4EThgaSIeN2hyetKhEx6/wEQhCFkaiyv9
         YxJcyM5xcR1KQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/11/2019 8:52 PM, Vidya Sagar wrote:
> On 11/11/2019 6:39 PM, Greg Kroah-Hartman wrote:
>> On Mon, Nov 11, 2019 at 06:24:53PM +0530, Vidya Sagar wrote:
>>> Hi Greg,
>>> We noticed that the Tegra PCIe host controller driver enabled
>>> "Relaxed Ordering" bit in the PCIe configuration space for "all"
>>> devices erroneously. We pushed a fix for this through the
>>> commit: 7be142caabc4780b13a522c485abc806de5c4114 and it has been
>>> soaking in main line for the last four months.
>>> Based on the discussion we had @ http://patchwork.ozlabs.org/patch/1127=
604/
>>> we would now like to push it to the following stable kernels
>>> 4.19=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : Applies cleanly
>>> 3.16, 4.4, 4.9 & 4.14 : Following equivalent patch needs to be used as =
the
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 file was at drivers/pci/host/pci-tegra.c earlier
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 (and moved to drivers/pci/controller/pci-tegra.c starting 4.19)
>>
>> All now queued up (except for 3.16, that's Ben's tree, he will get to it
>> soon.)
>>
Hi Ben,
Could you please queue this up for 3.16 as well?

- Vidya Sagar

>> thanks,
>>
>> greg k-h
>>
>=20
> Thanks a lot Greg.
>=20
> - Vidya Sagar

