Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EA268D3DE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 11:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjBGKO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 05:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231608AbjBGKOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 05:14:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B391C559C;
        Tue,  7 Feb 2023 02:14:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKHHm2d1Go1ItNMtrM7THOJwwPdBar0VR/flVpMQylF6tBLNy75b+dlvE5x1K44zAvmN3jhTadec7h8lDItR7adNaLcXGpplts0g0uiJeAgcR9EcROhrN25ftOLaizgJxPVBBFRaIUbuSdIbWSPCa65tvJBpgWLwUji+kyDPe0tkQ2afqy3LFTbCk2VALJQdRI201FZXi34yqt7LiID2g0Y+rjOUMo8zcXxT68ClEdw3Jmj6n/WfzdAENDig0/4q/k4NboOr4SFvnYhoyIjIjD091ZlIdBUQl8cnBnc4iOcnYdIz7WRTL/zHgAVnVtJ2CQePUhcLNyhlyhAYZCkUww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/JReHxc5T7WwFGkb0n4UMu4+EZoK4YwETmVhTB72Tk=;
 b=WxI8v9imINUrWSTlPStm+a1DNWSiF7nsjblESwL2xZghQRdfnl8Mp4O4Gj25Up4ToparoC/AzOfkAnoYMKLKPxfeofQbuvMuh1Yid9sM7h6Oyn75S3lRZXQIlgclIEi0EeOxp1czIIUbhAr2y9Jd1aU4WcXtcI+N2x8IrTr/LpVFVBPXHBr3BbzFBKDGQhYVmGpGjCDKqoVU6+zafOuRFazz4Fdmx5v1Zewm7rCI76sZwcVLiXV5sOYrwfIncsIED/PzGgQg7PPtRLiMY/q6m2JsmQKvN+nghLLf2IC4QM2HfchOyURkqaIGIoxipFKlZPBNcWLwo2PUCk8PRRXRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/JReHxc5T7WwFGkb0n4UMu4+EZoK4YwETmVhTB72Tk=;
 b=P3sIiGThSpAssc/guR7pWsrJ8Z/68vOrAxk6eiVAR19XbY5nve8bn+gvbatfBiKxcK1l5dQyBDYiadDElG9Wvg3cMx0LUXk/klxjAt2fdCfQOYhtX2q7OMzHE5J0+uY0jj4NdXbJH4OxvXRaMnvQhaef9ADcMvsJKXma2xQlUAa8RlZiYsuIZmHUTlYBHJpfztrzTkz7wqjZ21ak8z8FGYI91l8xAArbSikFXnPWnUY6VN+4bM9TbF2qG9fmwphNdgaAxnGsZ03qujmmUi7X7bzu8MTvVjFMuJX4EmT719PJWKH+ss7uxXa+HTmDCFrjbfnOf4JYrvKLAtsnGi9OjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5413.namprd12.prod.outlook.com (2603:10b6:8:3b::8) by
 LV2PR12MB5894.namprd12.prod.outlook.com (2603:10b6:408:174::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Tue, 7 Feb
 2023 10:14:47 +0000
Received: from DM8PR12MB5413.namprd12.prod.outlook.com
 ([fe80::6988:39d7:86a0:fa7b]) by DM8PR12MB5413.namprd12.prod.outlook.com
 ([fe80::6988:39d7:86a0:fa7b%4]) with mapi id 15.20.6064.035; Tue, 7 Feb 2023
 10:14:47 +0000
Date:   Tue, 7 Feb 2023 11:14:38 +0100
From:   Thierry Reding <treding@nvidia.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>, stable@vger.kernel.org,
        Anup Patel <anup@brainfault.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Michael Walle <michael@walle.cc>,
        Bjorn Andersson <andersson@kernel.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] cpuidle: add ARCH_SUSPEND_POSSIBLE dependencies
Message-ID: <Y+IkjuCr9UuY5ZDg@orome>
References: <20230206193319.4107220-1-arnd@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1uapiBDzeWxBRlL/"
Content-Disposition: inline
In-Reply-To: <20230206193319.4107220-1-arnd@kernel.org>
X-NVConfidentiality: public
User-Agent: Mutt/2.2.9 (2022-11-12)
X-ClientProxiedBy: FR2P281CA0148.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::6) To DM8PR12MB5413.namprd12.prod.outlook.com
 (2603:10b6:8:3b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5413:EE_|LV2PR12MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: a222f44f-a5d4-48a5-237d-08db08f423ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgbZHxRyAq7UC0tFP6SK9tkFJrSxmAHyjdCYKxowTRcq9zGUAx1OxNbFehb5D4tPCK09NAtBZ0k/Cg+9cpjCdhua/WZZNr2cptjuW/whgF4Zuac/J/rpP28wO6OmZv/oD08ucYVoHOb/3ENkxQCwoFjEhA4uDh4bRphTWYrzrkCg5WGdvY7uxtbkWHzybcb/RwG7IX2T+AswEAghzcepEwQ1fxHru/FKx8u+3H7/TVsRE+yvHR9gpGck6zOa3tDiuOBZrk+uASOLKdCQoBS/CtiLT1HXULOlL9RzRxaCZnfjRKwxm6A9iLfbavbY/jCb8Tcrab5Ci3qJFXF6223o4j08GsWMiYX1cwQLl2ODtDLY3GjnCImR/q1z+1SqnNgs9483F1Ns2vU90CmV2Kl0i5XzeMnH02OggoKsyzIAveyo5D8gIYRHyuYX9NQyGk+nceFX66tejQLRq2/qoxOUty76d2ihPJrOyWLvlNyMGuVqE0LsS+4SkLYoAbKSy4ch8Pagl5sANXaPb0OzUHNnAF598s9p/FYXhRmyLkVK2EEQNci0IxYj2QLEDpvPgPCiH/eOrFcDwCIhes4233nfksrzuPTp4eEPQWfHCb0cpQVFUnfENrZdJALR1ARw+Cv1WUDTAqTcCZ5CgUcY6A9y484Gj2zlIfrJ+ralrxPlr7TYvWR+l1RS5bwLK8w/TMlzEeMBREmaEipKo/rAGr8K0NsmGHyQ3V1O5kM/+jua+CUQd3rhOZW7PcLTOjgAtjvgfXA2nDSJqw3pXtaYNA+j4/GXncXwJrAba/CxKzHJVXkedpdMhNBXUwINFGZGXMlE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5413.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199018)(86362001)(478600001)(38100700002)(33716001)(316002)(6486002)(54906003)(966005)(8936002)(41300700001)(6506007)(21480400003)(6666004)(6512007)(83380400001)(66556008)(66946007)(6916009)(66476007)(4326008)(186003)(8676002)(7416002)(9686003)(44144004)(2906002)(5660300002)(2700100001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gz70zWTqWmWzn0SezLEPQUU/cgYvvHGEQK8kx6uyNVjd8PpFIS1d/L5zQv7p?=
 =?us-ascii?Q?5VqJlAVdHuBztyFgIjO841xYEm9xI/ThO9z2T6uZ7UG0SrnSFp26+KbG0ycJ?=
 =?us-ascii?Q?VrXjZpL8+V5+tCnDFmcUYUgzYk/i7xiPUc06QepZv5i5H1jsaP75LDkOI6Gv?=
 =?us-ascii?Q?T8CKhPGC7pqZha6k0muVcj4QNNAOiXjNyXWSrZ5kiRxg6malGZYKuvizeUN5?=
 =?us-ascii?Q?WC5VJy8o9Ks/QFAXYsuqrrNWRRMuOraF0scLZfF7AtjX+s9hg/LpN8k4z2z4?=
 =?us-ascii?Q?dXaZTn3Qma1F846KXXHhXYDa8mIyX9gIqU/J6gKmxPyIL/kb2CvxFpzxtB/A?=
 =?us-ascii?Q?0NfiHvCCTR+hRAzKc9O1+p/zmBEljAvQINdeps7EBPn5R0SpsyDN+45VtZL0?=
 =?us-ascii?Q?QQ/Xv7+it9aoJfCIzNjtjCa5nh5FUQGiQ32HHCuLQc9dBa/BQhWDCD8k0R4R?=
 =?us-ascii?Q?aKLtAEngnsgYG2TtAhP7Zg1GX9udpYFdhSaTHh/VaREJUAn/Giews15hH+p5?=
 =?us-ascii?Q?xY4Mri4FS5Upf5XyCM3LF4Oyf/Gv3iccRotRa6gfdpCgBw6qXc5T3p/HwX2V?=
 =?us-ascii?Q?I5T1ueD0zLfDQGPztZtAeldu/QDrDrEvbAJ6is9zUuU+69aIS2spKTKCK7zi?=
 =?us-ascii?Q?jWcirhOsKAre041LNewykJYQORbNpPmwcXSIIDsGiWnH2xj2tUA+D5nwXks4?=
 =?us-ascii?Q?7h0Qy7S+Lh2fc37B8+cUn7ZAz5i3DLMsDUZuUi23onlJrSCn+/MPhl7ts4aV?=
 =?us-ascii?Q?HT0W9l49Gs6+wMjLbjCuv0OWxvXELIdICIu3tERuQgoU5MKMvuIM+AkFOdMC?=
 =?us-ascii?Q?g11CE4sD8c3fnRwP9EpuxiY+zFP/c1gyrvgP7saIvBHt1FFeFQixk2TXxG+g?=
 =?us-ascii?Q?WgAy/kN+bpSO8Jzx9jpQghoFFyc4TV3HOCGXUPUk5sRqrth9PvTV0ty2djxV?=
 =?us-ascii?Q?kwf9QY5UzieOhDxDX7oN3AeuGLc7Ol0FsMOGGY8VMzQXGRUw5eyeKZe1nrdB?=
 =?us-ascii?Q?W5na748kLyZI8i/5W3BlDB3z7N+mznNePIqjtw2WC1fxBw9p3xqHduHQQx08?=
 =?us-ascii?Q?XWfXzFA4aOoJQRxlJ9Sgq5QNpaN78k7NLMMQL5gLvumSl4Dh89mN1nFwmr3P?=
 =?us-ascii?Q?6AlQBHNkiH8FIqDE9RKlKXH+ErBJdXHv7xr02fvgMKAxRXsUj9XCEBDmBHbj?=
 =?us-ascii?Q?6PtMvLMRgl0D8vUN5PgyU+6Ol68XT4V13bUbNz56+jFcjh60LrcVuK2vX5nY?=
 =?us-ascii?Q?bQprdExCuJYDkvVPkoBDYATYJ5Wj3C/XtaLc5h1DEjwfm9DTDRmyTKfq2KIT?=
 =?us-ascii?Q?izlAiaJ2RRAk6a0ZZJZj3R/p8uMdiDICN12diJen2fioDsqsTH6CycLa9O/5?=
 =?us-ascii?Q?XxUPDWfTd8RCllatk/C33Y6Vo3SdQ+XXxpzZT4Bx0Ol/vLG8xh5gdCnZzK0X?=
 =?us-ascii?Q?lDHW+3lkUuapdmE7NmTvbWxJ0o/Zf3rvx4cJzYyoDBjiHXOEXdB5ZVkZ4kGA?=
 =?us-ascii?Q?CDj+9vslLxusWpxZDievNINX2hc75u90S2t4m+XKYdrY7qfejPlsk/2cJ1Pq?=
 =?us-ascii?Q?uLWDyss2biqvlCQftvsrtpxeSfp5iBjg+HQYMtAlhsRJi0HwoGTe2qhtz+px?=
 =?us-ascii?Q?6jFRpfR191o6LZHNxi22oHQW3jdRrxEF8LjccLXA90sf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a222f44f-a5d4-48a5-237d-08db08f423ea
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5413.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:14:47.2521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ryoJZ877J+wnI5ySgSJS/hDgerBFGT70JwwNRYm4PgPJSjSi/8h1yd6hWfUwS9r3YWHn0WVODrRTQt3v1MXkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5894
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--1uapiBDzeWxBRlL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 06, 2023 at 08:33:06PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Some ARMv4 processors don't support suspend, which leads
> to a build failure with the tegra and qualcomm cpuidle driver:
>=20
> WARNING: unmet direct dependencies detected for ARM_CPU_SUSPEND
>   Depends on [n]: ARCH_SUSPEND_POSSIBLE [=3Dn]
>   Selected by [y]:
>   - ARM_TEGRA_CPUIDLE [=3Dy] && CPU_IDLE [=3Dy] && (ARM [=3Dy] || ARM64) =
&& (ARCH_TEGRA [=3Dn] || COMPILE_TEST [=3Dy]) && !ARM64 && MMU [=3Dy]
>=20
> arch/arm/kernel/sleep.o: in function `__cpu_suspend':
> (.text+0x68): undefined reference to `cpu_sa110_suspend_size'
> (.text+0x68): undefined reference to `cpu_fa526_suspend_size'
>=20
> Add an explicit dependency to make randconfig builds avoid
> this combination.
>=20
> Fixes: faae6c9f2e68 ("cpuidle: tegra: Enable compile testing")
> Fixes: a871be6b8eee ("cpuidle: Convert Qualcomm SPM driver to a generic C=
PUidle driver")
> Link: https://lore.kernel.org/all/20211013160125.772873-1-arnd@kernel.org/
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: stable@vger.kernel.org
> Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I found this in my backlog of patches that never made it upstream,
> testing shows this is still needed. Please apply.
> ---
>  drivers/cpuidle/Kconfig.arm | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Thierry Reding <treding@nvidia.com>

--1uapiBDzeWxBRlL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmPiJI4ACgkQ3SOs138+
s6Fo5g//Z2+ph11g6x0ChBT6i1GOSzVzU/JLkGSlDHsvue6sR/RQIhGsyuAjLvAh
eJ/mD+IRFMIWw42GCPgRlShDvRHzsTX06MjuXA4349M9KUg8PbCmo55QKhIRl9TY
ZmviivWZs7Nbpwtu83EIYK0ZIV0+S3edCXzfMEDFuVqUbOAcHqkdfBqWnqkmksV5
U2pX5y40QjPHR9C4KfKWvLMG66msja175NK7m1EOjSnWGWJiuGu7hYJyGazX8taq
DiGLQgvDQOktJuU1nXIHAmiOGlbOsXgtzfzIJpn2FhkminwF0Qj57Kd982mwKtLk
hLVnjAFvEoqQPeswN4AKyNzVklYTwxQWHPhsi/TTQFO71prVlNimx2rhaXbrPJtz
KVJJZOiivwBlYNR9JAIF7hKTzzC2p4MdHUk1J9oQydKPnHZhmW+Aah6BILaoVg7z
95ip04kkXKiAGTe17MMWAuBRjK+8ThaDsFZQTpQf40jxAjrIG45d9YHUdck+f42N
dMwYaPqC8aVX0/H6QetkPfYLb+Tu7PaVBx2L3mOz9ZvfLhbYN1WI6SuZzSURmF2s
IgN3mtsey+0ScAgqCbWm7ImasaungwFpmshDFvAd5mV8cIn8QO0WN73xacI8ipJn
Zt6zA40x+B5k5hiv+EFruRjA73TMDi6lxBJB/1Pv+BD74AR3l/E=
=Qxrn
-----END PGP SIGNATURE-----

--1uapiBDzeWxBRlL/--
