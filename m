Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6736E5DBB
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjDRJnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 05:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjDRJmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 05:42:38 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632036E93
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 02:42:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KehmVivfMGOu2inMEZJj4mc+XEY3DHkVnPd/iDTloDh4AY9MTHM5y1HTLDDtn+V4rcHmpqU2icmz6pT9XLzyeptPEoDljwgdIzKHgzW5hfjTXvk2aa4tMb+FcxrNGw3W359k/PgTI4LFf8N5GJfH6dqjMDmIF8IPs2uxwQ1Es87h0AWBY71qYaiBSY4QLk1DDqKYPYpZLBXRfQc1dUfT2SHrcX3A19sK/+LrUCqeOewpQKqFM1rUObnswvEPvtJPOFOMDZs9xrPC5N4xMOAUYsJtdOsSMe98+rEN5i6P4uGv04V4d5kQhl6ooygVabDNcoM1adUSM9mlt4Qg2bjJfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tT1LNcfSAqPrYDRGEcD+lPOLdvNwwd0k54g2L2jtOFg=;
 b=HRM5HL6/JDnsSnys+k3URoRYfPUe3kRS6I34NyMp6j2dEnI7CpSK2sH//2yu39UxGumCgKEFyneUQhQizTNYLnwTbsqfkmkJrPr41KJED2KK/CXRTFN52UqwA2h+P0geMZX5t78lUOOirbAgi5hioMwJlbD4Is3v2p7HF514+/0CNy6W0mTFKzhOiwE8LDHaVuIr4KOrk/XbJX3mWyzkzbkUi4ROOc/bZc3C7hIYG8bbRmrxiY8D6f5NAQVT+rxYnATBz4bEDRLq3wRhyIC74TCUyYvs0OAZuPBZV09q3p69MKS+bTH5zIab7Jo4dEG138zAUGERbrTv9manFvMUhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tT1LNcfSAqPrYDRGEcD+lPOLdvNwwd0k54g2L2jtOFg=;
 b=t7on2GUEM8e0+O97hA60pbSDP3n5FzPsoiIlcIx/jrPVNL/7Z43aj6hv+B5I5OJdbwGrRvq3iirtS+ciJisx/s6jnx2v/UEDta3dufQp4iw84/md/HbOTX30Y1puVegriORiu8dkzmLb0iB64NlW05X6KlYz0QnGf8zAWz++YFg=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by SA1PR12MB8697.namprd12.prod.outlook.com (2603:10b6:806:385::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Tue, 18 Apr
 2023 09:42:19 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::7f60:1f4d:7409:7f4f]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::7f60:1f4d:7409:7f4f%6]) with mapi id 15.20.6319.020; Tue, 18 Apr 2023
 09:42:18 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Jani Nikula <jani.nikula@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "lyude@redhat.com" <lyude@redhat.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "ville.syrjala@linux.intel.com" <ville.syrjala@linux.intel.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new message
Thread-Topic: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new
 message
Thread-Index: AQHZcbxV7BqBioN1p0GeDL3gde3pDK8wwtQAgAAIZQA=
Date:   Tue, 18 Apr 2023 09:42:18 +0000
Message-ID: <CO6PR12MB5489C9667D84E0207BD6C14DFC9D9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20230418060905.4078976-1-Wayne.Lin@amd.com>
 <87mt351sin.fsf@intel.com>
In-Reply-To: <87mt351sin.fsf@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-18T09:41:32Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=d02a7bc4-2d08-416e-8e71-c2fb2a5a3927;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|SA1PR12MB8697:EE_
x-ms-office365-filtering-correlation-id: b12a44db-a332-4782-b924-08db3ff1335a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M41FFw2RIq+S21lBmNR+gT2ks4s8pj343wLBboShVH0T0w7PNQJDnC+cdWccDnzB29RAzbcVIrnGdl3pvIsRS0Y3vE8zofZxBUWtfZbney3y8W+kr27jxz+69k5Nhtt+piK4kBhE1g6eIusi+Up/qzFJtYTYuPTFEKO8QppSw4/yHjb/AtfJiFtcq9nvIUdKNqhBS6kKCJf4SejTUrbptyLihDpI8b4/SqDwv8z3OpExtaDjGOK9enwQXC/WSrnyjsF+nd+ZeWUsySSMGrjnA3wB0WbPlKN7cRcF9dP13qlkKyn79FNVBdCVlxbESafPLIcjsLHVgS/rxAVjwGh7ezwU7YyJtU3erMWoxvf/6eJuO7hS5kaNADvNnXGSWLeIXy2kW1kHSgudLDHdMEgLLAd8G3qG52iEJhIxEH1VBRsb+sA+4pKZQHQAU/IvEYwinxKLfavOHteb+QgJ7RU4DLLjb7gvjVT17VPqMs8LZwmh33aj/CpQmnxY7g+NhJxD9YbIoKSrqJgeWtP9sdl0ppWaHEi9vKAABI2krBMKt3BD3h59/SLydjHPAAmRibEfF4TqiTQIvzlgn6gwNzNGSfGOFexvu+vtLAItPFwMjLERWB5GqPhiaZ0W2ARw9KhR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(451199021)(26005)(66446008)(5660300002)(38100700002)(122000001)(15650500001)(52536014)(55016003)(2906002)(8936002)(86362001)(8676002)(64756008)(4326008)(66476007)(41300700001)(66946007)(33656002)(38070700005)(316002)(66556008)(54906003)(71200400001)(76116006)(83380400001)(110136005)(53546011)(55236004)(186003)(9686003)(7696005)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o2GlT6tAv1zD98Vb4iOk0x8dOXdb3klv8mZlFvKXfmI8HC4IWZKWvAc/LoZV?=
 =?us-ascii?Q?wc794UDFOgFACYQpxmRQJ3APUV8ObFwiNPG+ifxcdi0F4MckjteRa/94Ls/H?=
 =?us-ascii?Q?FUDTuodwe6ccjsM4N/pIxNnMRs5q2LaYsLg/8KbiDWiuY3wKRXe+c5stD0a7?=
 =?us-ascii?Q?4FCPPBYRPHroy+cgKO56yRiIalCswEuEo/xn+FfmpdppDgEI3HVtJB91JFYv?=
 =?us-ascii?Q?mAboopqCxjhJ/qSKxzaxs/KRoXJm5ZRdFrGR1JlHCPkYdY9uEVh1UASzoIY3?=
 =?us-ascii?Q?s+lA38iGz1QnMKCvibpB2CFRVXUq15mHcZk2XV9DMm881GB2g6lIAX0YB5rM?=
 =?us-ascii?Q?yeFpZJORyMdQiYq5LPhsrww/zxqfuyd+XK7dIBXE+Crfi3qKE/jc32hlRXWN?=
 =?us-ascii?Q?4Vn1xoJWJRI3c8k3fmpqJI2szNhzWgH9sB+q/f9xYJdRnfQdONFPmg3wZAb1?=
 =?us-ascii?Q?nfW4oP6hTvfhi0GwccEdumdvSDKVNg7GSDVnImx3iKEzN+cw1RCHHP8nWqnT?=
 =?us-ascii?Q?bFOSMcUP8t3rYWDC1mKrkMrtHVQJTzSGNwtnQriC6pDl14I9nbJRf0TKPQ/c?=
 =?us-ascii?Q?tz/oIlBwgw34qZnO8HvfTUwmo5POg51QWUrPSOYi896YyBtukOJOxtP46ESR?=
 =?us-ascii?Q?7b1qg9D34umX1iGAZuQm8FfTTqs+ksl27YoBiY05BjwvCXG9ECNYZu7GI3uv?=
 =?us-ascii?Q?LacicyGe4CwKaHP5FREq1QQG6fjzidVEmX+w6TmwBBPuoHGpoEtYEkLl/qZ+?=
 =?us-ascii?Q?IzI4VB4dZNexlLcX4pFI6xy6wC/dCPZAGUk9DoA+MZ2/fLTksnkPtjPkdO0z?=
 =?us-ascii?Q?hc1pC6uKDU8QX8zPvnnvGzmbbe0FlCQffouemWazxXDHPDuoemILWzTHiDE/?=
 =?us-ascii?Q?9SebGZOHd4HnY4zz5V+fcfZX0+sevyBNjJ3BfMu1afGwXG8/V2MCojewGfez?=
 =?us-ascii?Q?7noiwXPyBeJws6q+fn+p3WwPe3v5vUBHEX9Iq82AHCytzVd8U16obrw5SobK?=
 =?us-ascii?Q?MrPjpDqsZPXme/cNqLTzVrVC28nIGos1LoQEP1g/F93LcA9TNfeZd6E3SZYz?=
 =?us-ascii?Q?0VkPh4nL7aSG1C7+UEaQLPcsYjjJIqnH4xgdJn1x0brqeQcvKiwSA28ITtf0?=
 =?us-ascii?Q?7/aA8L86RvdEtODlPdAv9w2EoSzoeBmznLge83aW6wZXaCok6cZXwtI11UFn?=
 =?us-ascii?Q?kdAtce+UF6WgZ2julIRx1y5XquOcUZeHqgAZjba3xUcT5O1dsoVVkAT/tK91?=
 =?us-ascii?Q?z4yYgXsjaUMyE3gVsKptebblXsIV6UK1ISjC0q6Lc97p+MbjCeO18TL2wMYu?=
 =?us-ascii?Q?aPrv1Ka1esZG2SCFaYS/UnCEmdFTH6DDNsr4YS0SJOZqGe9xZFaICIDsUKQT?=
 =?us-ascii?Q?UZmAWzJIBPxmXhiBBQZiMSh7QezLjMZdVwW8aQtr71fy0826sdxjC4/Dr96P?=
 =?us-ascii?Q?J+Ppux/ReWgLEVLMOIv1RdlVUZvwaR562JwA3D0dobrM9OTPf3KCU8JcfruZ?=
 =?us-ascii?Q?vY0PTT2tZCyITtP2ncnYMpBTp6dzbrJ5t7vhObPfBeVljxpBcaNiqor9VIzE?=
 =?us-ascii?Q?cWz/goTz0VV3rD8t2/Q=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b12a44db-a332-4782-b924-08db3ff1335a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2023 09:42:18.3783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 507E/WbTIMyx4Lkjoade5UyLMmbF36fQXJF8MUBvfaVnD5WkY7iaJkVgcZSSn7Pixofm+0p5IsO7oh46zuYCzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8697
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi Jani Nikula,

Appreciate your time and feedback! Will adjust the patch.
Some comments inline.

> -----Original Message-----
> From: Jani Nikula <jani.nikula@intel.com>
> Sent: Tuesday, April 18, 2023 4:53 PM
> To: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
> amd-gfx@lists.freedesktop.org
> Cc: lyude@redhat.com; imre.deak@intel.com; ville.syrjala@linux.intel.com;
> Wentland, Harry <Harry.Wentland@amd.com>; Zuo, Jerry
> <Jerry.Zuo@amd.com>; Lin, Wayne <Wayne.Lin@amd.com>;
> stable@vger.kernel.org
> Subject: Re: [PATCH] drm/dp_mst: Clear MSG_RDY flag before sending new
> message
>=20
> On Tue, 18 Apr 2023, Wayne Lin <Wayne.Lin@amd.com> wrote:
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
>=20
> Why do the masking within the retry loop?
>=20
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
>=20
> All of these should be in tighter scope.
>=20
> >  	*handled =3D false;
> >  	sc =3D DP_GET_SINK_COUNT(esi[0]);
> >
> > @@ -4072,6 +4075,25 @@ int drm_dp_mst_hpd_irq(struct
> drm_dp_mst_topology_mgr *mgr, u8 *esi, bool *handl
> >  		*handled =3D true;
> >  	}
> >
> > +	if (*handled) {
>=20
> That should check for DP_DOWN_REP_MSG_RDY and
> DP_UP_REQ_MSG_RDY only, right? If those are not set, we didn't do
> anything with them, and should not ack.

Right. I was thinking the sink count change will accompany the CSN
up request message. I'll change it to be more clear. Thanks.
>=20
> > +		buf =3D esi[1] & (DP_DOWN_REP_MSG_RDY |
> DP_UP_REQ_MSG_RDY);
> > +		do {
> > +			ret =3D drm_dp_dpcd_write(mgr->aux,
> > +
> 	DP_DEVICE_SERVICE_IRQ_VECTOR_ESI0,
> > +						&buf,
> > +						tosend);
>=20
> We should probably have a helper function to do the acking, similar to
> intel_dp_ack_sink_irq_esi(), which could be used both by this function an=
d
> the drivers.
>=20
> > +
> > +			if (ret =3D=3D tosend)
> > +				break;
> > +
> > +			retries++;
> > +		} while (retries < 5);
>=20
> Please don't use a do-while when a for loop is sufficient.
>=20
> 	for (tries =3D 0; tries < 5; tries++)
>=20
> and it's obvious at a glance how many times at most this runs. Not so wit=
h a
> do-while where you count *re-tries*. Again, would be nice to abstract thi=
s
> away in a helper function.
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
>=20
> Above we check if there's anything to ack and bail out, and now this clea=
rs
> the bits but writes them anyway.
>=20
> I think the handled parameter was problematic before, but now it's even
> more convoluted. What does it indicate? It used to mean you need to ack i=
f
> it's set, but now it's something different. This function is getting very=
 difficult
> to use correctly.

My plan was to ack message events within drm_dp_mst_hpd_irq() since the
events are handled there. There are still CP_IRQ and LINK_STATUS_CHANGED
events above get handled in intel_dp_check_mst_status(), so I intended to
mask DP_DOWN_REP_MSG_RDY/DP_UP_REQ_MSG_RDY, and ack
CP_IRQ/LINK_STATUS_CHANGED here.
>=20
> BR,
> Jani.
>=20
>=20
>=20
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
>=20
> Same here, this acks even if it's already been acked.
>=20
> >  		if (rc !=3D 3) {
>=20
> --
> Jani Nikula, Intel Open Source Graphics Center

--
Regards,
Wayne Lin
