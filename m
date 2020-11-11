Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF122AF3EE
	for <lists+stable@lfdr.de>; Wed, 11 Nov 2020 15:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgKKOmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Nov 2020 09:42:23 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19347 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKOmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 09:42:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fabf8520001>; Wed, 11 Nov 2020 06:42:27 -0800
Received: from [10.26.72.124] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Nov
 2020 14:42:20 +0000
Subject: Re: [PATCH] ARM: tegra: Populate OPP table for Tegra20 Ventana
To:     Dmitry Osipenko <digetx@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20201111103847.152721-1-jonathanh@nvidia.com>
 <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <fb615118-ecf7-3092-9e50-2a8d72c1efcd@nvidia.com>
Date:   Wed, 11 Nov 2020 14:42:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7e40cd3e-7c34-c9a9-bf00-ba7d507a2d6b@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605105747; bh=V7E5AURR711byF0lyiKVyvn5BN8y9oDHDYu6wZCh294=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=n/frox2TIcLPb8cHU9eKPH4zgLB+8QHE0MAanXYCQgnZal2f7TFNZ91xutKudCaG6
         dPlPEF6eAo8SlBS9N0M/K1XnfyxFaMKRuxhTXCxSGMu8seS9DVIlGwLyK9xE9Kr+ML
         8yFmJGZiB/BZLywopn/JeXZDfVQgcKiKjzdF+BBam8BX6vrQyimn/opbtjX3YL72GU
         t5VP9Vik4oMC/3cBKxwbNndxd+AQwivb6yBAHzhzoHXFQbHNNRTkQC0/1GeETACeMt
         2vfQ8e8paUoFOTrMw2h9D6Ies2wtbR+nW8O0HhGpmUx8IvCWWcVeoyJoIhtPH3pjFv
         FcIQ7FBWlr/MQ==
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

I looked at that and I did not see any voltage scaling being done with
the previous version of the CPUFREQ driver on Ventana. I will double
check but if it should be then I guess that was broken before.

> You could easily hook up CPU voltage scaling, please see acer-500 DT and
> patch [1] for examples of how to set up regulators in DT. But then it
> shouldn't be a stable patch.

That assumes that you are in the same country as the board you are
testing on :-)

I went back and verified that CPUFREQ scaling is working on stable
kernels 4.4, 4.9, 4.14, 4.19 and 5.4 on Ventana. It is only after your
change that it no longer works and yes it should be in stable.

Jon

--=20
nvpublic
