Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112CA630C2F
	for <lists+stable@lfdr.de>; Sat, 19 Nov 2022 06:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKSFhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Nov 2022 00:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKSFhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Nov 2022 00:37:20 -0500
Received: from na01-obe.outbound.protection.outlook.com (mail-eastusazon11020024.outbound.protection.outlook.com [52.101.51.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1486052173;
        Fri, 18 Nov 2022 21:37:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVGVZ638k8B+10yzHbL8GUiyOfveyjLUabBTQqXkp70wulKJ8QJY+gJhXsf5pcZzYvxz4esJ//IsUJaZMw5Hp/gaYnFUZ2NFCp3V70fBDK+ivfAs3C37AWr6GTYzSMQq5WC+aO++i3E+Phnn+8l3zBMDR1mBHyW/KN+dvv0AbXX3qDhMAA/VvJFN6ttwE050zVN4adsQNHLDI0GMN3So7BtEyBW2l/TtnMZ1bnK4vL3wF+ks7UgZKl+r8n3irsTUaZ6uVMjbuS1YlLPXDRDewXlCTlNru9+DSzLEEh9VQj2C9glnq2+B4HHowk5bwcKv6hszyM8lIi+SUbkgq3xP3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CIyfh/9kaWNyFrCWFXqlb6jkBO8z+8sysHRHx72s+GI=;
 b=LXZDROQj8m2p/KjuVihIPyIJiX6Sd0DgTZK4jwMfFD5l6FQrV7Rw0GnvQ3xb8Rf14KPqR7BtbZ7ZC/MfyogWBl/yE0bQzmppFMeTIErOp7jLbqM3EmMpBCbX8K+n3ITLtgXffMVpj+EBNMIKC/wjLIMqEUg8/u/AVY6UboTHE0jOiNGgmEZChC4aX8obvK6WfHw64A0VWgTWhSY55mcAjBxzngX3VvG2V6lIiMotCVAeFQIKKgJTyu/748e5eaxcSucalD+dvxmk+vPBo77OsAEtoTdwVrrhwjv3bjTwygoLyZlW+QAEVh6uOTz3+EA9ZN/0JFp2mDQKd5027OOqaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CIyfh/9kaWNyFrCWFXqlb6jkBO8z+8sysHRHx72s+GI=;
 b=eM6ZPc6PnUlBWbHkmJwDmPJK5sT5pMANzgvvsWiFPaqvfMFO6zKJXhj367CsU75O4VXMrUMnt8qU8bxXDWAOoT7lcDnk144sl7vrX8fOzLppUQOrdMOU4fdXzcZ9zk+qwAik4I33saMNiaeCMOLGp2wYj6SEjeFaGkmHX/8hx/Q=
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 (2603:10b6:805:55::19) by MW4PR21MB1938.namprd21.prod.outlook.com
 (2603:10b6:303:7d::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.13; Sat, 19 Nov
 2022 05:37:16 +0000
Received: from SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e]) by SN6PR2101MB1693.namprd21.prod.outlook.com
 ([fe80::bd63:35dc:eb6e:3c9e%9]) with mapi id 15.20.5857.008; Sat, 19 Nov 2022
 05:37:16 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 6.0 13/44] clocksource/drivers/hyperv: add data
 structure for reference TSC MSR
Thread-Topic: [PATCH AUTOSEL 6.0 13/44] clocksource/drivers/hyperv: add data
 structure for reference TSC MSR
Thread-Index: AQHY+7xP5F8+J/9N0k22UysL/bMmua5FuPyA
Date:   Sat, 19 Nov 2022 05:37:16 +0000
Message-ID: <SN6PR2101MB1693A83DF44A95B439532F9DD7089@SN6PR2101MB1693.namprd21.prod.outlook.com>
References: <20221119021124.1773699-1-sashal@kernel.org>
 <20221119021124.1773699-13-sashal@kernel.org>
In-Reply-To: <20221119021124.1773699-13-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6f578323-c436-49d7-a3f3-282e777739f2;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-19T05:31:52Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR2101MB1693:EE_|MW4PR21MB1938:EE_
x-ms-office365-filtering-correlation-id: 8acec4ab-dee0-4ae1-a775-08dac9f01e55
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51HEYy/95c6rMLL3ApYGPQXijUBWz2vwMnoclSL57IB2Q8Lgs9z/a4H4XAvhoP73GCqyh1XqoW8YGn+1ct+e8bv+jJEEWUrugaagGneLC/bJVemnCLmljc05ZIbvVtPVIR3FWRRSB+Ax1YMnDHW+WbC4yOs3jMWXbTeQJGL5hlRhz0eOImer6gXQ62yf+hOJG/ieztw63inJDFoUNnu9RkvRVwpdkPYpytbf4QWz3GYrVPwfbx/L4I/YZSGLg+V3jVjunLOFq2y4K4cFJlCXq9vbbDyrKPXPnhP1OBfBhzgurcexVHOnde+IpY4IFO2yV5SRw4Z8O/+H6aMJD6WsBIEl/5LVsy2+FQWtvqh4rV8vTGUjwZLe//HnvyLX1SFCLOx1ZnxsCLjmA3prJ8eKKXmOcLDjcw7AVzme2PwzcaOC/WXkGnarLoOYNneKYwWy+L2tuFrBeLmwTFw0gBw37cjoGv5+ayjtiOfJE3/UBUd7fxC4kdqmLFCfaMoN+nw7CzRR3BqjgtUsNIL6FtIpdiaB1n6hx+9I3CL2L7j78e4+Msj5h2b7pvveS8uzJKqR7UoF8SNoqiuiySKQT7yda0ipB0TuSsPJEwS07sZLRSzIl0jmghe0Pe95k/Ip4H/CUIP1/HK2/XNyCP+rXSHHXT2HMo1GP6baULhYwFVzCFMonyQ+cdKcYbOorSvcRosmRX/atSSMDPDFM82lKYwgh/x4YpRHgFb9MmDQ29XyvkrvWneBZeq6+TXbxx4EkFGt/h6vSIAryl8UvFzoRvFZuhP9y0oWCYgINOEGd0Wnu9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR2101MB1693.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199015)(10290500003)(6506007)(7696005)(2906002)(86362001)(54906003)(110136005)(8990500004)(41300700001)(966005)(9686003)(71200400001)(5660300002)(66946007)(66556008)(66476007)(64756008)(66446008)(55016003)(478600001)(82950400001)(82960400001)(4326008)(76116006)(83380400001)(33656002)(52536014)(186003)(8936002)(26005)(122000001)(8676002)(38100700002)(38070700005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pxiWPKvqqzMapQ1fEXno3UNbdgMXtFzTzoV5Oi/SX98UQzTZOPfXgntIHTyn?=
 =?us-ascii?Q?DyScQVZwFPiRVg2k1PYFGhoCiMwz992ZIpYlTft0uiYrsPtTmD6ui6SqWBXy?=
 =?us-ascii?Q?szMiVx+3wGkczhhV/2BoR5p/NQAJaPG2qEgNOCudj015EUGfDj3RE4OA0u/A?=
 =?us-ascii?Q?Y1h5DE8KZFfzoGTUX+JxQE3mrn8eJIrWoh1WH9Ws4kjebGNGcvTXybSPwG/m?=
 =?us-ascii?Q?hX2r0GqZNCA56ynTAEXpbge8hvRDVpCXyfilQFgYQTWIymIifrzDggO4IbjJ?=
 =?us-ascii?Q?N/IAm8de20M0cDs8ihsvv7jWmE8RLMZgrxYgQRk3Xd4lSBjKbNw2DAgPnlZS?=
 =?us-ascii?Q?WwH9BVvU2JbBpvP84Gq4cp1atiBNAc6TdRAv0L/hruxfUelLoeCxqhvAAEbp?=
 =?us-ascii?Q?c79lM/NrP+/UoeOMq6f1ke8Yi7DqtKyFhAZb/F2y2U949NRNlD8pf+C46wlM?=
 =?us-ascii?Q?F7CgjrB2PZMP6zLSO/8xKuECB6A/oFIDtIB7qMvYwC5v5fUF+FVufXScPJ8r?=
 =?us-ascii?Q?mKHexTNQTQl20+bmeZPA+ucoSTYCPQYmi1yYYnpfZJ1jhGAcc4+Q2lhu0NE0?=
 =?us-ascii?Q?F2vB1IM253VFN+d6iikOovS3UesoeyPdSyOp0oj7p+0dM3DHG34OoPn2Vn03?=
 =?us-ascii?Q?u08AD0Q/V6vj/dMiGZ7aZVImcDL113yWd07hq9xQ/CrnGOXf4wPu8xZJ85OE?=
 =?us-ascii?Q?XgBT08rfB4ePZ3Ubs8YmzXfVZAgWHGVrClOp5j/CCOwdyKj1ADBuuZfI+7wc?=
 =?us-ascii?Q?h21qKG0fWqXhsI8pKCixeG4f4ajzdLYWCZXOSmlPNpv/DeGVyLybNTIUXlQy?=
 =?us-ascii?Q?P/dWsC8coeV5gCC6ri9gNcnpsleHgdMvZ13K0s4IWyeyJaI+GNHUl+rFG0rT?=
 =?us-ascii?Q?xcJeIvGIV436YR1b7O5onJo8kJoTWsUUNf0GR63hQSKPtrco5vitU16eIpbg?=
 =?us-ascii?Q?14QkhFqc89+Gry7dIUF/tt5QzjycIuE3d9NdMyv0tde1NZnWOV6uU16yDzVJ?=
 =?us-ascii?Q?4h49u7Nn2aEupxjQ5jvy6u7P9XFzj6BWw8Nl8Rx6DLGw2eovX3Z7yT7+Xgal?=
 =?us-ascii?Q?OMUMe0NeH0LI+iEYGf5BQ0IfEPCbRmOoTQVQQ4SS2bB7jfpLjwQMPcroAVJ1?=
 =?us-ascii?Q?RaXRhpfF+/UYTlTo4Hz1N7lCdAgE/CkXxH/We2pu3nm80sFj5NlDo2+iAykh?=
 =?us-ascii?Q?e3MKIEiHHMKY7yhv5CnBDKTzqGX/BamHgvNv13p3jU+mM3K0bYu+7odPZTtg?=
 =?us-ascii?Q?CUIX6Q3CGxqD2Ymt6BiqPDGf3bR13PDrC3JQJgXSZtNK6FMQEmTDDWJ0Rh/J?=
 =?us-ascii?Q?ePLOpxXcPVJ1HTdmJOg09MOavtHNxjjzsLoZgNNAO/q3koJ93Oy0StXnvbti?=
 =?us-ascii?Q?EFmLdjoumAFAGSWKZ0LuyA4VsIoM03kigjgBt0VMqXNLaniFsMTqBRoiLN/B?=
 =?us-ascii?Q?2m33TFIz7kOdgS4ZH7u8cZpoee+JKOCKZQYXdctMoT6AQwbwDAdUicbs6DdH?=
 =?us-ascii?Q?AHFod4LoAwVagCgIiu30Ba+gmiNz/ZcteJWqac4Kb5Amexd8cF8liED3dtt8?=
 =?us-ascii?Q?qP0TFF01C+6qfj79ZmYDTTAWmtv0TxpVUEWA3TH/7Noi2r2c5eJd87PDVZsd?=
 =?us-ascii?Q?Tw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR2101MB1693.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8acec4ab-dee0-4ae1-a775-08dac9f01e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2022 05:37:16.3985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IBAvAaqZuTpl5pfXWA8ueS6BgBPcrb00+3SJXWMPcm+/eXX13jJSnmJ0r5m0PVdKPhwq98IPO+CQze1UqJEjuIqqPasUesXsXv1w3RTf83Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1938
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sasha Levin <sashal@kernel.org> Sent: Friday, November 18, 2022 6:11 =
PM
>=20
> From: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
>=20
> [ Upstream commit 4ad1aa571214e8d6468a1806794d987b374b5a08 ]
>=20
> Add a data structure to represent the reference TSC MSR similar to
> other MSRs. This simplifies the code for updating the MSR.
>=20
> Signed-off-by: Anirudh Rayabharam <anrayabh@linux.microsoft.com>
> Reviewed-by: Michael Kelley <mikelley@microsoft.com>
> Link: https://lore.kernel.org/all/20221027095729.1676394-2-anrayabh@linux=
.microsoft.com/
> Signed-off-by: Wei Liu <wei.liu@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sasha -- I don't think this patch needs to be backported to any stable vers=
ions.  Anirudh
or Wei Liu, can you confirm?  The patch is more about enabling a new scenar=
io than fixing a bug.

Michael

> ---
>  drivers/clocksource/hyperv_timer.c | 29 +++++++++++++++--------------
>  include/asm-generic/hyperv-tlfs.h  |  9 +++++++++
>  2 files changed, 24 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyp=
erv_timer.c
> index bb47610bbd1c..18de1f439ffd 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/irq.h>
>  #include <linux/acpi.h>
> +#include <linux/hyperv.h>
>  #include <clocksource/hyperv_timer.h>
>  #include <asm/hyperv-tlfs.h>
>  #include <asm/mshyperv.h>
> @@ -395,25 +396,25 @@ static u64 notrace read_hv_sched_clock_tsc(void)
>=20
>  static void suspend_hv_clock_tsc(struct clocksource *arg)
>  {
> -	u64 tsc_msr;
> +	union hv_reference_tsc_msr tsc_msr;
>=20
>  	/* Disable the TSC page */
> -	tsc_msr =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> -	tsc_msr &=3D ~BIT_ULL(0);
> -	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
> +	tsc_msr.as_uint64 =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> +	tsc_msr.enable =3D 0;
> +	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
>  }
>=20
>=20
>  static void resume_hv_clock_tsc(struct clocksource *arg)
>  {
>  	phys_addr_t phys_addr =3D virt_to_phys(&tsc_pg);
> -	u64 tsc_msr;
> +	union hv_reference_tsc_msr tsc_msr;
>=20
>  	/* Re-enable the TSC page */
> -	tsc_msr =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> -	tsc_msr &=3D GENMASK_ULL(11, 0);
> -	tsc_msr |=3D BIT_ULL(0) | (u64)phys_addr;
> -	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
> +	tsc_msr.as_uint64 =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> +	tsc_msr.enable =3D 1;
> +	tsc_msr.pfn =3D HVPFN_DOWN(phys_addr);
> +	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
>  }
>=20
>  #ifdef HAVE_VDSO_CLOCKMODE_HVCLOCK
> @@ -495,7 +496,7 @@ static __always_inline void hv_setup_sched_clock(void
> *sched_clock) {}
>=20
>  static bool __init hv_init_tsc_clocksource(void)
>  {
> -	u64		tsc_msr;
> +	union hv_reference_tsc_msr tsc_msr;
>  	phys_addr_t	phys_addr;
>=20
>  	if (!(ms_hyperv.features & HV_MSR_REFERENCE_TSC_AVAILABLE))
> @@ -530,10 +531,10 @@ static bool __init hv_init_tsc_clocksource(void)
>  	 * (which already has at least the low 12 bits set to zero since
>  	 * it is page aligned). Also set the "enable" bit, which is bit 0.
>  	 */
> -	tsc_msr =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> -	tsc_msr &=3D GENMASK_ULL(11, 0);
> -	tsc_msr =3D tsc_msr | 0x1 | (u64)phys_addr;
> -	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr);
> +	tsc_msr.as_uint64 =3D hv_get_register(HV_REGISTER_REFERENCE_TSC);
> +	tsc_msr.enable =3D 1;
> +	tsc_msr.pfn =3D HVPFN_DOWN(phys_addr);
> +	hv_set_register(HV_REGISTER_REFERENCE_TSC, tsc_msr.as_uint64);
>=20
>  	clocksource_register_hz(&hyperv_cs_tsc, NSEC_PER_SEC/100);
>=20
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hype=
rv-tlfs.h
> index fdce7a4cfc6f..b17c6eeb9afa 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -102,6 +102,15 @@ struct ms_hyperv_tsc_page {
>  	volatile s64 tsc_offset;
>  } __packed;
>=20
> +union hv_reference_tsc_msr {
> +	u64 as_uint64;
> +	struct {
> +		u64 enable:1;
> +		u64 reserved:11;
> +		u64 pfn:52;
> +	} __packed;
> +};
> +
>  /*
>   * The guest OS needs to register the guest ID with the hypervisor.
>   * The guest ID is a 64 bit entity and the structure of this ID is
> --
> 2.35.1

