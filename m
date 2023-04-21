Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104016EAB52
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbjDUNN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbjDUNN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 09:13:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on20612.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eab::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3132D52
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 06:13:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcU6c77J6KpRlyoyzu+9uwFE8N40YdnJOJ23LD9ULj45+ZCbC4+WLp/G5zrOzAs7hO9QIoH1n5YJ+QVT9TQacUAyWNPu7JAU5Tdh2RA/LYRvbjerr1fKBMPGym7kypOVoJX9/Bx0QK3Yt8eT2vTdLpgucr3aa+s298bPyjsjWdGmHSD+GltNh0AlDzorpF7dwFj+ei4Fl84JP2XHtPOh+qZPauP0vETQWZ80+p/HCnh39gUC+LgDPw8WRrrRoteCiok8/mj+oeK/42Jysak/9ERVEs26qQF6dBkYdWYqEp212CQh/CH0AgpDLGFUba3gHmNCOg4QoLgBNprBvY3L/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssuDPhmsX+dV466wBK+9NCr2IIo7ssZeaXVJgeCgIdU=;
 b=JoGZCVAHnxrcfxT3OTuHBwI6Sv3votwyspR4ZZUBI8L6VImWtIu/2Sc68cp8y8NH9sucbS7IXJSrqhNvm6xqH0IOpqFl3fNFPvpNb2qfTt5ZbNtiNKd4j1WSUtmoFEi4AnzPOVR8J4pC4lyYvvuvCzIvk39IzLQ/w+rOPjklUBnNgN4Iisy/JiqcbChmGIVBLqGmk16uF0CTqW/Krdj52YfCFj45OFB3FASthUYZ387Fqi7HMJCTUM2M0y1V5wjcnksZIpS5joSwB+QwZ/6AY/xK5HmtsQHcxmcipzAJ0XSBmnkps29F54SvY+FH4StY2g308N5Nzc56a1y6+6dCDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssuDPhmsX+dV466wBK+9NCr2IIo7ssZeaXVJgeCgIdU=;
 b=uJC4uVdpHJT45Xd0chzdO5LVOZxxvwON1mtQ70npq9bnan3j6C65UlEts0FbDTUg89woIssxRTOQCz4owZhqBJFhcDMVk4qxug7yO0Xt2ktt99DTOgv4KVGO3rP2a1Nk0RLJu30yGPf8Ntu1OzGY3VcjaUjCw1QWgs+3cPF/4nc=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by CH3PR12MB7690.namprd12.prod.outlook.com (2603:10b6:610:14e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:13:52 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::eb2a:87af:d22d:ccb]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::eb2a:87af:d22d:ccb%5]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 13:13:52 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     =?iso-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "lyude@redhat.com" <lyude@redhat.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "jani.nikula@intel.com" <jani.nikula@intel.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new message
Thread-Topic: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new
 message
Thread-Index: AQHZcbxV7BqBioN1p0GeDL3gde3pDK8xGQoAgASm9EA=
Date:   Fri, 21 Apr 2023 13:13:52 +0000
Message-ID: <CO6PR12MB54893CD6D3B839F5F78AC203FC609@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20230418060905.4078976-1-Wayne.Lin@amd.com>
 <ZD6isq36T+RQ7uNK@intel.com>
In-Reply-To: <ZD6isq36T+RQ7uNK@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-21T13:13:04Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=99b1f007-9036-4c33-8be6-3a728cb24061;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|CH3PR12MB7690:EE_
x-ms-office365-filtering-correlation-id: b2328da4-fbfc-40bd-9f47-08db426a40b7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: arhwg4IXJVdvlZL7Xr5QjD0rEdyGHnng3Kzzf0u6bpL5HBqYgkvXGrl5P4QpA3R/t5CY3bYt7R+HWsi0z+q0SufMZgWxJTOqtEz+G1putrMMdCDojbuHYGljP8y+NPbt4LVYFJTAJbS+SHfJ23KeTD4n85i0TK0Ohm5St1Myn3Y/Q2RN/K/nf0azMDX0y/2BNHUei9hUjWjbiGJsN9+HTdkx7h1A+HIb1CkaGZK3l1ehYWv8nT5F7uNiIy/mSns1qvj5B+NJYj1aHu0PtUqWS4Dh806VzezVuLd1g95fYHcS9GjDZ9CUF1S2W7e6qu89v8ZwAxXnkmY28ktQniKepfKS2QUBhIKMX8w2T57LTtXC75WVbUACV408z55kt0+zk1tN+7m7s/r749S/K0FptYchqSVApqrXjx/ZcrpKPO8L0HpK6UNBy7o1NLzRDfqDRHz+6Un9Q6QADpg21D57EI/YfnSpRLab7hBqQyesDAYGks/dWC4GWwo3yn/QIQisnUVppP7NBuPQ1LAS0AOCcnIqIYdAa88t48Nlucf37hT9mFO/gW73KVfvIWSfSM9xbYplnHGC8GfbXiHtvB2JIjVGFg4AX67MPH+ArQJbiVGbmcxANg42DWHu5EfSR9K0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(451199021)(53546011)(9686003)(6506007)(26005)(55016003)(186003)(33656002)(54906003)(478600001)(71200400001)(5660300002)(7696005)(38100700002)(52536014)(4326008)(8676002)(2906002)(316002)(38070700005)(15650500001)(64756008)(6916009)(86362001)(66476007)(66556008)(66946007)(66446008)(76116006)(8936002)(41300700001)(122000001)(83380400001)(66574015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bcBsLp+MWQpI+qfu8M0x0xhjBUUxWrFT0oc5IfM9wam9ThiHoJdt8yJtV8?=
 =?iso-8859-1?Q?gPsWs5UB2Q4WgXwhIE+gNLwAi29DG1pgJl6fnrA4ONgLiUx6Z35qnp1/eO?=
 =?iso-8859-1?Q?gpapA5AbeiimQmy0rkwarmZze0N2r4ipETy4b+YSz1XMVIPFM2IRSp6w/U?=
 =?iso-8859-1?Q?69FrmXZHt1bQwSUxutP7fFbzjXd2b9+8vI0z1uRYO+Uk6IfgjZnBKvbgeJ?=
 =?iso-8859-1?Q?Nyu/7jz49s/58KSEvyOxy38U+BJFgpwKFbuSGK6ODPc1IsdJuUhtEPkQV0?=
 =?iso-8859-1?Q?c3kvhu09tZYtwHnfWxvMXwV3ulVLGRgG3Gg1GCszUcTjLyZAKICgMczgIf?=
 =?iso-8859-1?Q?BGdG5G8P8keOASISrHqau7g/wP7RPNeEX9vsYdmWpgPFFErH16uBMdJDTb?=
 =?iso-8859-1?Q?p+dVsZaOdeDzBshgE2NUPKZyOUoM8UF3uVrmRWG0pmpFT2S2fQgfEgsglU?=
 =?iso-8859-1?Q?rIBSG5farja5vxHCgmXvs7V57uCe72fYM2dqZQWJ1WrMMw3NvW5UzBnj5M?=
 =?iso-8859-1?Q?QMQFKAlvyk+UkHx6VpC0TemQK38NROfYNSt3LbUcSKFo3xY1hBDgvPuDQc?=
 =?iso-8859-1?Q?jaS6Xs7bkjew0n518rQTWcr5Uo+ltRspt6yvJwaZiXCgZSNADL420Skk+S?=
 =?iso-8859-1?Q?wMAcS2URrhfIFbHSanSUVgHY7GO9y/hrtk1Uyv9oUoF00i7A1BAC2QgUGo?=
 =?iso-8859-1?Q?OvkVWbIfvWVMvUzmf4spkQ3BAPeVHTM+xMvCQbbPFuMBl1GcLhgLkedX4Y?=
 =?iso-8859-1?Q?ZkOuYAr9IYPXUR8K0t4uNhXZWx8qcKfbT3fPWjy2o5eksYqCKUzaAOPBv8?=
 =?iso-8859-1?Q?QTZS0qvvPqke8n9169lGronVuzQ4TwrggtS8t8dFVJM7dK6BNBJBedGJ4M?=
 =?iso-8859-1?Q?EZ20UNEnihqTD0SYSv9ltx/ARv7Uy6kvmBsrX7aapLHfjxZQ1yzKOIJcXj?=
 =?iso-8859-1?Q?2LXDS5yYfmyl4RnI6W+7zanr3oTQnwtiVgbwQqqa7qwwFEFBgyJVu0lr2e?=
 =?iso-8859-1?Q?ChuMVb8JpP/zMOSjEdSrIJo46KERBZ1tlkjW2CxJYE0ommjKZ0kpXKlsZx?=
 =?iso-8859-1?Q?7S7OTdCURX2wYQK7bh+B4WCMEEBJK1f7ME/Wb6sZHryqksGI49/3dtP1Qm?=
 =?iso-8859-1?Q?7cGqOP+O4Bbd7jj9Zj7zrWhpWT7nf4wBq5pTyxI9uFYi9VulJLV39x3Ljd?=
 =?iso-8859-1?Q?GbTAKu//ifGE6PFHc/JorrNdAdcjnZlKzN5Ht/Z1PL3cjaGJG82d5xyBND?=
 =?iso-8859-1?Q?7o47pKdHLMeB1SkML1mxds3IQrAfUWSjKxayh3NqNg723yWoLwPdRfg6F6?=
 =?iso-8859-1?Q?JsV5fPfSEpR6cvlLOfzHGPXOt/i8vmAcpFUsIt/Ra0y29WpcFpLcCrJyL/?=
 =?iso-8859-1?Q?N0FQ2Qg2+M8kS/ibOBe78m5bOjv3ANri4S1NQqha8F8V6HQCDGlCbnrgPW?=
 =?iso-8859-1?Q?jmdFjY91mU5sXnvtjukCrHXTvN0ctB+DJAASzxrpCL/2O98bUzX6uUE7Ug?=
 =?iso-8859-1?Q?fXXGHufdjI5MQBRUakvktxrV6vjw6dZL4UR9NWIsFbpu2RdbXZRDausUNL?=
 =?iso-8859-1?Q?MXSibTphIonO2DCAcY0T4kywQKqySnrD5PmtwQ2bRog9TojZOy6bOBjx2r?=
 =?iso-8859-1?Q?qmOVwjoqDCKjU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2328da4-fbfc-40bd-9f47-08db426a40b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 13:13:52.2323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VxGGEwIhA8umIV6pHnu+Lpxjx1rgj2kjUnkK2z8vZ4wN0qxdOIH38FZoZ6sERlwzS37C9s7F59jYATzIJojNRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7690
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Much appreciated, Ville and Jani!

To tackle this MST message ack event now, probably I could just pull out th=
e=20
drm_dp_mst_kick_tx() out of drm_dp_mst_hpd_irq() and make it the second=20
step function to handle mst hpd irq? Would like to know your thoughts : )

Again, thanks for your time!

Regards,
Wayne Lin

> -----Original Message-----
> From: Ville Syrj=E4l=E4 <ville.syrjala@linux.intel.com>
> Sent: Tuesday, April 18, 2023 10:01 PM
> To: Lin, Wayne <Wayne.Lin@amd.com>
> Cc: dri-devel@lists.freedesktop.org; amd-gfx@lists.freedesktop.org;
> lyude@redhat.com; imre.deak@intel.com; jani.nikula@intel.com; Wentland,
> Harry <Harry.Wentland@amd.com>; Zuo, Jerry <Jerry.Zuo@amd.com>;
> stable@vger.kernel.org
> Subject: Re: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new
> message
>=20
> On Tue, Apr 18, 2023 at 02:09:05PM +0800, Wayne Lin wrote:
> > [Why & How]
> > The sequence for collecting down_reply/up_request from source
> > perspective should be:
> >
> > Request_n->repeat (get partial reply of Request_n->clear message ready
> > flag to ack DPRX that the message is received) till all partial
> > replies for Request_n are received->new Request_n+1.
> >
> > While assembling partial reply packets, reading out DPCD DOWN_REP
> > Sideband MSG buffer + clearing DOWN_REP_MSG_RDY flag should be
> wrapped
> > up as a complete operation for reading out a reply packet.
> > Kicking off a new request before clearing DOWN_REP_MSG_RDY flag might
> > be risky. e.g. If the reply of the new request has overwritten the
> > DPRX DOWN_REP Sideband MSG buffer before source writing ack to clear
> > DOWN_REP_MSG_RDY flag, source then unintentionally flushes the reply
> > for the new request. Should handle the up request in the same way.
> >
> > In drm_dp_mst_hpd_irq(), we don't clear MSG_RDY flag before caliing
> > drm_dp_mst_kick_tx(). Fix that.
> >
> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |  2 ++
> > drivers/gpu/drm/display/drm_dp_mst_topology.c | 22
> +++++++++++++++++++
> >  drivers/gpu/drm/i915/display/intel_dp.c       |  3 +++
> >  drivers/gpu/drm/nouveau/dispnv50/disp.c       |  2 ++
> >  4 files changed, 29 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > index 77277d90b6e2..5313a5656598 100644
> > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> > @@ -3166,6 +3166,8 @@ static void dm_handle_mst_sideband_msg(struct
> amdgpu_dm_connector *aconnector)
> >  			for (retry =3D 0; retry < 3; retry++) {
> >  				uint8_t wret;
> >
> > +				/* MSG_RDY ack is done in drm*/
> > +				esi[1] &=3D ~(DP_DOWN_REP_MSG_RDY |
> DP_UP_REQ_MSG_RDY);
> >  				wret =3D drm_dp_dpcd_write(
> >  					&aconnector->dm_dp_aux.aux,
> >  					dpcd_addr + 1,
> > diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > index 51a46689cda7..02aad713c67c 100644
> > --- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
> > @@ -4054,6 +4054,9 @@ int drm_dp_mst_hpd_irq(struct
> > drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl  {
> >  	int ret =3D 0;
> >  	int sc;
> > +	const int tosend =3D 1;
> > +	int retries =3D 0;
> > +	u8 buf =3D 0;
> >  	*handled =3D false;
> >  	sc =3D DP_GET_SINK_COUNT(esi[0]);
> >
> > @@ -4072,6 +4075,25 @@ int drm_dp_mst_hpd_irq(struct
> drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
> >  		*handled =3D true;
> >  	}
> >
> > +	if (*handled) {
> > +		buf =3D esi[1] & (DP_DOWN_REP_MSG_RDY |
> DP_UP_REQ_MSG_RDY);
> > +		do {
> > +			ret =3D drm_dp_dpcd_write(mgr->aux,
> > +
> 	DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0,
> > +						&buf,
> > +						tosend);
> > +
> > +			if (ret =3D=3D tosend)
> > +				break;
> > +
> > +			retries++;
> > +		} while (retries < 5);
>=20
> What's with this magic retry loop?
>=20
> Not sure I like the whole thing though. Splitting the irq ack semi-random=
ly
> between driver vs. multiple helpers doesn't feel great to me.
>=20
> As a whole the HPD_IRQ handling is a total mess atm. At some point I was
> trying to sketch something a bit better for it. The approach I was thinki=
ng was
> something along the lines of:
>=20
>  u8 vector[...];
>  drm_dp_read_irq_vector(vector);
>  ... handle all irqs/etc., calling suitable helpers as needed
> drm_dp_clear_irq_vector(vector);
>=20
> And I was also thinking that this drm_dp_*_irq_vector() stuff would alway=
s
> use the ESI layout, converting as needed from/to the old layout for pre-1=
.2
> (or whatever the cutoff was) devices.
> That way drivers would just need the one codepath.
>=20
> > +
> > +		if (ret !=3D tosend)
> > +			drm_dbg_kms(mgr->dev, "failed to write dpcd
> 0x%x\n",
> > +				    DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0);
> > +	}
> > +
> >  	drm_dp_mst_kick_tx(mgr);
> >  	return ret;
> >  }
> > diff --git a/drivers/gpu/drm/i915/display/intel_dp.c
> > b/drivers/gpu/drm/i915/display/intel_dp.c
> > index bf80f296a8fd..abec3de38b66 100644
> > --- a/drivers/gpu/drm/i915/display/intel_dp.c
> > +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> > @@ -3939,6 +3939,9 @@ intel_dp_check_mst_status(struct intel_dp
> *intel_dp)
> >  		if (!memchr_inv(ack, 0, sizeof(ack)))
> >  			break;
> >
> > +		/* MSG_RDY ack is done in drm*/
> > +		ack[1] &=3D ~(DP_DOWN_REP_MSG_RDY |
> DP_UP_REQ_MSG_RDY);
> > +
> >  		if (!intel_dp_ack_sink_irq_esi(intel_dp, ack))
> >  			drm_dbg_kms(&i915->drm, "Failed to ack ESI\n");
> >  	}
> > diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > index edcb2529b402..e905987104ed 100644
> > --- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > +++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
> > @@ -1336,6 +1336,8 @@ nv50_mstm_service(struct nouveau_drm *drm,
> >  		if (!handled)
> >  			break;
> >
> > +		/* MSG_RDY ack is done in drm*/
> > +		esi[1] &=3D ~(DP_DOWN_REP_MSG_RDY |
> DP_UP_REQ_MSG_RDY);
> >  		rc =3D drm_dp_dpcd_write(aux, DP_SINK_COUNT_ESI + 1,
> &esi[1],
> >  				       3);
> >  		if (rc !=3D 3) {
> > --
> > 2.37.3
>=20
> --
> Ville Syrj=E4l=E4
> Intel
