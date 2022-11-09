Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89AA622789
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 10:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiKIJvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 04:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiKIJvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 04:51:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBA21409F;
        Wed,  9 Nov 2022 01:51:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFRLx/F2aSiM2Wz3VkJVpROMRzB73XMVkoYmXzVsMWgH9uaVlR5M/bfFhyLGa6UAEXz1vA693JkEDflMHHGoIDP60nNTMDwDmOjrrrfKLDwIBXN2CkB3HQ5rv/KV6PiQP0LXERluV3Av5F1V4/Z3QBOV+p4DSmB1xRSIwn+hdYlVkfVE57qzWw3H3g2JtVpxzQHs6M/WMI1b6Vz/qc/1a5LUGTQmSs+/+xq8Bq3sCGOSEfCp3SZb+/766v1/7NSFKWPNamADh+y+0Jx5wRTKtRPNejpUFSzq4hzE0JKWeOHra+5ljAOUN9U69Kw/pbnXaRJOvHG3zZ5MuqXgHd0PSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4viiPlclFCm0lRfBYtgbzhmQQ/nn8TwX6ZlzrlVHIw=;
 b=aORZOskM6jpJ3y93qnNjmRnF0FaHCFR66xJ6Ne7cX27fqDl4nObMkOEE7FavuFQmC5MvlSvAkhxWUJDEcJ0Qz0KUB+q2zqnHOboUQRSoknak3gWZU6B4d+ZE8L4gMY7HEUzzBQFcT1278cehiSoXucauaCYTVW4nuTmAX2lq+nckxXJbG1tW0a+eF+i69Cz2fEHZLi9I0gsdZDYbvJ39DSnl0ewt2ftl8cARwR4hc3CpW+fYgG49vRFZcMoMaS6F1Wd2nnJIEii51sjeaREqZJn0LEnmTCLrrOrg1Yo7pi+8RelMvbLpmv4Sq4quZ8fIvm0HEtQ4yWkzRuKHzW52vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4viiPlclFCm0lRfBYtgbzhmQQ/nn8TwX6ZlzrlVHIw=;
 b=Pax2usQ8n74pcfoODYrk1wvdrbzcKgu2fIZwd9EKfje7MStbqPa6VFckHAO01hgCmUPmqAE3HFaEKQgMPxQ5R+rV7UPuQESEQXpCVhHs6cYRuYu7zZRtWbzeN2enl4Bqgf8gFRPd1peeRkns/vri6mhhR5YrjGkwgfVcIMQj8CE=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by MN2PR12MB4406.namprd12.prod.outlook.com (2603:10b6:208:268::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 09:51:08 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d%3]) with mapi id 15.20.5813.012; Wed, 9 Nov 2022
 09:51:08 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Imre Deak <imre.deak@intel.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] drm/display/dp_mst: Fix
 drm_dp_mst_add_affected_dsc_crtcs() return code
Thread-Topic: [PATCH 2/2] drm/display/dp_mst: Fix
 drm_dp_mst_add_affected_dsc_crtcs() return code
Thread-Index: AQHY8KmDgDOpykFiaUquLWRxaffyka42X5Gw
Date:   Wed, 9 Nov 2022 09:51:08 +0000
Message-ID: <CO6PR12MB5489C81E7CA10EFD47771E07FC3E9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20221104235926.302883-1-lyude@redhat.com>
 <20221104235926.302883-3-lyude@redhat.com>
In-Reply-To: <20221104235926.302883-3-lyude@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-11-09T09:50:57Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=3fc3d74a-8c90-4768-a12f-ca62fef7349b;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|MN2PR12MB4406:EE_
x-ms-office365-filtering-correlation-id: a9f900da-ef97-4bb8-24ce-08dac237ed31
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j1fXbLb8w5rQkEmKRXR6o+NGDlXP40TPHkeYLti+w7RIyDIUznAlA8TgptXV45QjHskXE1x4ZzktRlvT5dEwXjT3jMOTXWEEBA7da13qmD6kzPvVRvrBfMxp0hIRMKEr2BMJRh7a+Q3kK5iNXe8FS6X+S5Rc/QwRi09oluWUedeKy6X9Lx0z2LdvgOKivwgVp/1IH1iz+PP0cEv+BbiE6QoL0jBS6xX37T99AFIyjrup7Sl8nDOda7RsKDIRBCHRAXNZgBMwNlSzMtk8v84SkMglWnwVieY3mPbo+BgyL5Qh4RYa6htZkL8NpnIAk2Jt5DGnGEfgBVVS+DCtdFS3jWWQURImwbWIJPNEuSxyo/bl7g3E7xKh3eDWVPbozMNvuCNBf25HRl4eYCMOBlSqPT5hGdBFDwMqbtrsanY5sYxKM8LcYoTA52yCCD41RLvEBIeYCAC+TSUX85sDaAWMKn4zkGNGMVgXn8ZJW3FzTg6thnXiU8L6q0Z+KFmthJERkWxlBn16hHFePZ7S4KlmUXtd5DfpO5oKib2WpHrKcaGw2QQRYiXu0MDAkb+Ww2sRWE5tPoUrh4utHndzwA/Uw46ZNH7yhcMpceFNVeTW6ooJaNp4e83FjCzxpLa7u7C1zDvXOkczQaqAllLKEmrhGYaetU50PIDDa/5rWXvLADda6M1Qw6/PL+NEafDZZfbeHMqlCTJSnJXls5cIO0+KiJvr5mYxOVRc5abFJ+ALg6D7M761jbT5VgHqSlwFvZGRjtvRXQHDoopbvIt7IGK13/W/Mwr5ZnYHa+jHJ4dVeEQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199015)(26005)(9686003)(7416002)(64756008)(38100700002)(71200400001)(83380400001)(41300700001)(110136005)(54906003)(53546011)(66446008)(86362001)(33656002)(8676002)(4326008)(76116006)(66946007)(66556008)(66476007)(7696005)(6506007)(316002)(186003)(52536014)(55016003)(5660300002)(8936002)(38070700005)(122000001)(2906002)(478600001)(11716005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dyHcPsynM15MqJv9di+XR6krqAiKjv9Fee3JSkEeIFgxR+SVAJdB9jBTS3rV?=
 =?us-ascii?Q?f7X3oCq0m4LyND0QR0Ex5FdkavBbKrF6AgeHh1WPCTJkur2bKRk9KokqTUr9?=
 =?us-ascii?Q?+tAjqldYSQDOdwd4MGOSBbDO0NeYqZtJj/J3HJd402WkFaRoDNIXcafk3clD?=
 =?us-ascii?Q?2/pOUmE1GsuM5RmRGs6jHhMYJ15UQvRkyKXmlgSN6Vl3w/C+jZLEuDoWPi/s?=
 =?us-ascii?Q?yJNDu+l0pmxjpsAIiqLVpphPzgm4Uz7eRwUGNQwyvhz4UozPnBv1ho6VYbjj?=
 =?us-ascii?Q?C0HHKTq/lYTBqetSHnt8UXXra08amx2us25h+4hBZ52gQZSh2Mzt7ZN8AEli?=
 =?us-ascii?Q?wJHBaHp20PRcV3yVcKcfHe8W6Z0hBwNmapl0bj9bnuS6Vvw9QAa4wiSDTkAB?=
 =?us-ascii?Q?l/xEaWUR7AIm+kwua7GtpC5GZXoOzZLVK3pSXiuFgnF411MLlGDC2Y4GV4uz?=
 =?us-ascii?Q?1plsonXtfwuA29v6tOgoId/CL/Q/TSyaVV2UQLR7MBAKsuE5vLEu9TutB0JX?=
 =?us-ascii?Q?ZQQnjpMIaC/D0pFgJdNcGAGd4frydAoPYOLQbLFkPCIMYwI+nyePoA6YmdLQ?=
 =?us-ascii?Q?K+52SSuonY8oxnFnwAK5R06HdT8P8WxnXIymMikxD5sItIZlbSZvZPaxNRKp?=
 =?us-ascii?Q?Dfa8f+qFww2V/dBnXuMfqHNa56YSxL0bCbE5wKkXVw+Qh6uJSWeI1HJ/gkJY?=
 =?us-ascii?Q?cgCeMfUC/0GDCP7qAcColQHaHG49IObgyZtNtjyRLL2okGIrvaUYem/AORoe?=
 =?us-ascii?Q?CkGumOvjGhGi2GmiEDIYcHsiky4lwImzfxawrGZkX+wdIWEll2f0JKGbCaAr?=
 =?us-ascii?Q?nFf+HQQIRkOnnWipRRpoGf/hApmRhyJbvgfTLCnoVonD5+bOniDFioNG/KS8?=
 =?us-ascii?Q?dZiJF3mjSCfZDstxZSp3ZVDjHilGt9ecLABS+yZQZuL0uweWTk5C1M90t+66?=
 =?us-ascii?Q?Z9cH+WSNdTaP7xkZnfc1DkYgFCWkmNGmZ6AqSp9ZvdGqQHIjHGACWNFxf14l?=
 =?us-ascii?Q?lpm43jj5Yq/HJhNpf6rFQUT9n7kapabH4b4socZwrSodormklPHrGD8Gt6bo?=
 =?us-ascii?Q?Y1PoonhbqOatfRImnt662ij7PoVACEsZhm2eIiHzO3p4z+54V5JhtMtF4xmD?=
 =?us-ascii?Q?/GwkzkpvY2UKyDSiiPZGVppNc+2U7hLhfQ0CYeT+UY3RTodIpqVK/OTlVihE?=
 =?us-ascii?Q?beLfe0+2lvmcB4N3+cnb6lcOPzx6TBklGZyhyWMzkqd+SVhfse0mnOE59TXJ?=
 =?us-ascii?Q?dmHr7Gd9b7k0AyJq3S9d/QMJ7JGSd/Y5R8vrQVV7oUy5nxxQjURXN8bdCtdo?=
 =?us-ascii?Q?Luey9ICp9SlzU/AxBjeakc9F6/hOq7bZZd3el+FjVVEjVkEGXKpeG+WheCGs?=
 =?us-ascii?Q?ZnK6vAYxWvHqOqm2wgeYIDiKcw70rCEWej6rUt2cRzHITawscOC7FPkdE11h?=
 =?us-ascii?Q?8HWDxct07e4v+vfeHwZ6dSmDaBu1nmhAmwUyJ9jU21yop8980dDdQZ3ka/rG?=
 =?us-ascii?Q?B0WMKkZ0QLi5wg6zburGsGIHUW1UiAgq3P5ojAUSw6gR5cAs6LEXAC9n8eZq?=
 =?us-ascii?Q?FXzhcOgerYV+WcYyQYs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f900da-ef97-4bb8-24ce-08dac237ed31
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 09:51:08.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ElGfTNd1JKvlKK+bWvF33XdFE2S+du2tvtbz8RcELx2HSuP/2ZIq5x1B4pjAf6xlPesJT4djEBJ2b+yGN0YNFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4406
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - General]

Hi Lyude,

It LGTM. Feel free to add=20
Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>

> -----Original Message-----
> From: Lyude Paul <lyude@redhat.com>
> Sent: Saturday, November 5, 2022 7:59 AM
> To: amd-gfx@lists.freedesktop.org
> Cc: stable@vger.kernel.org; David Airlie <airlied@gmail.com>; Daniel Vett=
er
> <daniel@ffwll.ch>; Jani Nikula <jani.nikula@intel.com>; Thomas
> Zimmermann <tzimmermann@suse.de>; Lin, Wayne
> <Wayne.Lin@amd.com>; Imre Deak <imre.deak@intel.com>; Mikita Lipski
> <mikita.lipski@amd.com>; Deucher, Alexander
> <Alexander.Deucher@amd.com>; open list:DRM DRIVERS <dri-
> devel@lists.freedesktop.org>; open list <linux-kernel@vger.kernel.org>
> Subject: [PATCH 2/2] drm/display/dp_mst: Fix
> drm_dp_mst_add_affected_dsc_crtcs() return code
>=20
> Looks like that we're accidentally dropping a pretty important return cod=
e
> here. For some reason, we just return -EINVAL if we fail to get the MST
> topology state. This is wrong: error codes are important and should never=
 be
> squashed without being handled, which here seems to have the potential to
> cause a deadlock.
>=20
> Signed-off-by: Lyude Paul <lyude@redhat.com>
> Fixes: 8ec046716ca8 ("drm/dp_mst: Add helper to trigger modeset on
> affected DSC MST CRTCs")
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/display/drm_dp_mst_topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> index ecd22c038c8c0..51a46689cda70 100644
> --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> @@ -5186,7 +5186,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct
> drm_atomic_state *state, struct drm
>  	mst_state =3D drm_atomic_get_mst_topology_state(state, mgr);
>=20
>  	if (IS_ERR(mst_state))
> -		return -EINVAL;
> +		return PTR_ERR(mst_state);
>=20
>  	list_for_each_entry(pos, &mst_state->payloads, next) {
>=20
> --
> 2.37.3
