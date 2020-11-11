Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFF92AF9CD
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 21:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgKKUcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 15:32:00 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:12148 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgKKUb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 15:31:59 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fac4a390000>; Wed, 11 Nov 2020 12:31:54 -0800
Received: from [10.26.72.124] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Nov
 2020 20:31:56 +0000
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Dmitry Osipenko <digetx@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201111103847.152721-1-jonathanh@nvidia.com>
 <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <5409bbb4-d3f9-ccc9-ac3e-6344975bd58e@nvidia.com>
Date:   Wed, 11 Nov 2020 20:31:54 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605126714; bh=9ANYYF/RxveGkqEmqPgH2v4yk5gp3dxoJ5KwqVgeNXk=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=QRdEF8pyuNFSyj2A/dP5cEdifzrb47G+YbmVyV9ebe3BPshIkrNQ8q/QMbJk/Bjs/
         7ye0VNn8nwekRC6yCNvm/Ts7VlJSfHQ/prp/CVZzgiAvDfnw/qonBCe652kVFw5xuD
         xFMXCBmtAApNt+RDL45VBoEiOk/sW0gD9sSsRou1B3I3/c4jOJQo1uyvcIgiHzTYr6
         5nOE6PjtSSKYECrL1a0GfVqwx8Rymfi/AsB2g0JaPcIVuu8fBs4F7aWvG5eAAZwFmk
         xbGXV4+YkDh9o2XlzF7tOQIxPZ1U8ogcURs4NdwOarQjLi0UenVuRnCmmNmbZaZKQs
         2ILS1OgganO5g==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 11/11/2020 13:47, Dmitry Osipenko wrote:
> 11.11.2020 13:38, Jon Hunter =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Commit 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver
>> (Tegra30 supported now)") update the Tegra20 CPUFREQ driver to use the
>> generic CPUFREQ device-tree driver. Since this change CPUFREQ support
>> on the Tegra20 Ventana platform has been broken because the necessary
>> device-tree nodes with the operating point information are not populated
>> for this platform. Fix this by updating device-tree for Venata to
>> include the operating point informration for Tegra20.
>>
>> Fixes: 9ce274630495 ("cpufreq: tegra20: Use generic cpufreq-dt driver (T=
egra30 supported now)")
>> Cc: stable@vger.kernel.org
>>
>> Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
>> ---
>>  arch/arm/boot/dts/tegra20-ventana.dts | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/t=
egra20-ventana.dts
>> index b158771ac0b7..055334ae3d28 100644
>> --- a/arch/arm/boot/dts/tegra20-ventana.dts
>> +++ b/arch/arm/boot/dts/tegra20-ventana.dts
>> @@ -3,6 +3,7 @@
>> =20
>>  #include <dt-bindings/input/input.h>
>>  #include "tegra20.dtsi"
>> +#include "tegra20-cpu-opp.dtsi"
>> =20
>>  / {
>>  	model =3D "NVIDIA Tegra20 Ventana evaluation board";
>> @@ -592,6 +593,16 @@ clk32k_in: clock@0 {
>>  		#clock-cells =3D <0>;
>>  	};
>> =20
>> +	cpus {
>> +		cpu0: cpu@0 {
>> +			operating-points-v2 =3D <&cpu0_opp_table>;
>> +		};
>> +
>> +		cpu@1 {
>> +			operating-points-v2 =3D <&cpu0_opp_table>;
>> +		};
>> +	};
>> +
>>  	gpio-keys {
>>  		compatible =3D "gpio-keys";
>> =20
>>
>=20
> This could be wrong to do because CPU voltage is fixed to 1000mV in
> Ventana's DT, are you sure that higher clock rates don't require higher
> voltages? What is the CPU process ID and SoC speedo ID on Ventana?

I see this in the bootlog ...

[    2.797684] tegra20-cpufreq tegra20-cpufreq: hardware version 0x2 0x2

> You could easily hook up CPU voltage scaling, please see acer-500 DT and
> patch [1] for examples of how to set up regulators in DT. But then it
> shouldn't be a stable patch.

According to the Ventana design guide the CPU voltage range is 0.8-1.0V
and so it appears to be set to the max. The CPUFREQ test is reporting
the following ...

cpu: cpufreq: - CPU#0:
cpu: cpufreq:   - supported governors:
cpu: cpufreq:     - ondemand *
cpu: cpufreq:     - performance
cpu: cpufreq:     - schedutil
cpu: cpufreq:   - supported rates:
cpu: cpufreq:     -  216000
cpu: cpufreq:     -  312000
cpu: cpufreq:     -  456000
cpu: cpufreq:     -  608000
cpu: cpufreq:     -  760000
cpu: cpufreq:     -  816000
cpu: cpufreq:     -  912000
cpu: cpufreq:     - 1000000 *
cpu: cpufreq: - CPU#1:
cpu: cpufreq:   - supported governors:
cpu: cpufreq:     - ondemand *
cpu: cpufreq:     - performance
cpu: cpufreq:     - schedutil
cpu: cpufreq:   - supported rates:
cpu: cpufreq:     -  216000
cpu: cpufreq:     -  312000
cpu: cpufreq:     -  456000
cpu: cpufreq:     -  608000
cpu: cpufreq:     -  760000
cpu: cpufreq:     -  816000
cpu: cpufreq:     -  912000
cpu: cpufreq:     - 1000000 *

Cheers
Jon

--=20
nvpublic
