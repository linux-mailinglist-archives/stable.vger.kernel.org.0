Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20B96675CDE
	for <lists+stable@lfdr.de>; Fri, 20 Jan 2023 19:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjATSkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Jan 2023 13:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjATSj7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Jan 2023 13:39:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90609CC25
        for <stable@vger.kernel.org>; Fri, 20 Jan 2023 10:39:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC66s65wN/gDQ5ooex+f1MhUX/5uHNW9duen0q+/46FPoQf2aGEbzMh9+96HRlJIXPAHBhUoZhLet0LmNL+IkX7FAaj1Orn4kAaFgWQMioBgk53/9ULFO5wO3Dfo5+PWy+mEUHD5agDxmN2Yv7EcECAp7zynlTHl+pMttuAKQkgVhww4CC2GXDG2IfM83VFQHLWsiJbevWLvd6AG86WR5ZSrzyZwj7qE7kfSoy3FO4pIH+YJoDGIWNCVP2lLLv4UxcFoglhnuqFprlxN0SJFMOtBm+QUvQb0OEifduM4IfeTVQTh8rT+mY8oUNGv6HJ7yFBFFQPdQb4z6tJOKoCW8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91D7i2aHW7tJSvvxN6uYJn/z6LSYNH6edJZ1rpweEBI=;
 b=F0+q4dzEgRw6M3VShoGNBvTSpjD76aZKfDOzoSxCmZ1MrciLSSy2BHzDRsxjDTXDTDvjCAVePiuXr2vdj5eOYrn7i3wyhl/xPlnA7EZu/MeqVC04TxRdhhKku8gpus/jngXGkA2BHAKMW+pCA6gojrq9FDIWuhjvSkUQ6W+vWP3Sg5n0uMIvBQ3K/CsS0nwRt4ZPMNvdsxfdV7x3FEALl+jL58HaUEGLNuT3lF/2zaMY7XTd8D8YH/smjmRZMu3OhYAT0x+3WcW9QJRsHwXzU3R7pCK0+Zjn6AZEXgypHWxexd4bs3fa7F1mkRJA14Raw71hfbcM6pcWSz7sTOTNwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91D7i2aHW7tJSvvxN6uYJn/z6LSYNH6edJZ1rpweEBI=;
 b=nURKCFTIIl0+1BmybPfcpqAR6be4quGAwKanXw89e9hKiEXbCT3EqEaTrYOQ2NORAw65rH5Ml5TcZ+1ZadrS/66+JsVveG/KB+HMs3ruYy7uaWCvK0fk9iBXn3zpMjeggH6Dbg9IFyWhWj3pDZI1B155PxZn3uX30cxcdS/eRWQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH0PR12MB8173.namprd12.prod.outlook.com (2603:10b6:510:296::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Fri, 20 Jan
 2023 18:39:56 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6002.025; Fri, 20 Jan 2023
 18:39:56 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     "Lin, Wayne" <Wayne.Lin@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stanislav.lisovskiy@intel.com" <stanislav.lisovskiy@intel.com>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "bskeggs@redhat.com" <bskeggs@redhat.com>
Subject: RE: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Thread-Topic: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
Thread-Index: AQHZJmMAtR5rbDYwjEqZfEqNL1EmRa6noYAAgAABQQCAAAeOAIAABaDw
Date:   Fri, 20 Jan 2023 18:39:56 +0000
Message-ID: <MN0PR12MB6101FE67D355FF2A47470C37E2C59@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
 <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com>
 <20230120181806.GA890663@roeck-us.net>
In-Reply-To: <20230120181806.GA890663@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-20T18:39:54Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=42df329d-4905-4158-8c9f-3e26add6daa7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-20T18:39:54Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: fdc82a4a-afcf-4a38-a1a6-e17b12245f41
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH0PR12MB8173:EE_
x-ms-office365-filtering-correlation-id: 5802f195-2381-4aa8-acae-08dafb15ba28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9taRzMq0oQ8AUqOeKwtGDnn5gtqmaSHwxFMPwkJcuIiAjVOrJCsBUwf5w/sngfMwy9Ijn2KgQ7jhgxNw3H/nQ7bCrHu5YGAXotaSPrLkTfo8HS1YrC6ppozKlqAklYmxjlX0xvN8fJboJOIQh9dyAKxxxj6l3aUdeHqijohKHJMwC3WTKaBfoOh/BaIUzbfcA9bd21p7j46Bx3CMyXorzmGZCxxXgh8sJnzxZbARo5WAoEuCKcDV9GVPDM1QZpGk4lMZ9PWUV1yHzEHpu19NoOYCG7aOGGWfeQ9o2kVTpnJTuaUVwv6LibmCBlFgI7guJL9fwbx7L/wNXMiaNdHlPwv1o6g3ViULSOPLMkwee/ebsM5btO5J+gHt7IFr/8jbUNwBUoESmwF5MYASmFna9v03VKffIvQKI3/HdrmHQvLdxF3u8ZoNUCKU3SIhvoNLK1S/77GP56hjMt8k3Chh7wJM/x0oQNSmSPsw7boj2khRwdB3mxJcHLble4YdQIY3A26N3GATGlj8W4rasyG2qlQar/zD3fOnSPowb+RQ12KO8VZenHkV/APitZdpsWNRawl19d0Y1cnnaLqiYpbV/JLWo7oAysL2GbFCN5c9KVW0DasHnFS9A0t4O3OGv9IJNUh4nZpRfJy14z+YEGS7Qw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199015)(41300700001)(966005)(26005)(66556008)(478600001)(66446008)(33656002)(38070700005)(186003)(86362001)(54906003)(316002)(66476007)(38100700002)(71200400001)(66946007)(7696005)(55016003)(53546011)(5660300002)(2906002)(6506007)(9686003)(76116006)(6916009)(4326008)(64756008)(8936002)(52536014)(83380400001)(8676002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sq3jTa2/Qatn7NWdIqyi6a04ZNqn+b0oucJY28OA+z7a1KenuCj2cm885egx?=
 =?us-ascii?Q?T9WUra649r/TRbzZS3L7Dui2BtJ7V4vDxyIAQmF8xjVCzt1LLbiHFVWLSpdl?=
 =?us-ascii?Q?zCdPq5Nn5MxTmgM65i04Lati32Zu70M3ImTgTYuKjcMmPsBIclJE7h4d62Cj?=
 =?us-ascii?Q?oACSo6iuQSxmxIWv+dBFWduxrbDoqaXfdmCwV0Vz/IbPEo3Gne7Q9QSp7ZZC?=
 =?us-ascii?Q?usUxfM6wZG7VZeO3EaquFt1MWQ9iyqk4AaerSaa9IhYCuM9lIV/xLCKzrMNv?=
 =?us-ascii?Q?oFbF9EnYBAwWSGRiEascFk0pcUDmxQerC7In93hjoSXaHSstukmirn4bJ+Rv?=
 =?us-ascii?Q?xICYYCR3rbau3g63gACEqufO6lOnq3MT7B14fHKF8vRPVpsFcBWj7R9TEGZ/?=
 =?us-ascii?Q?vTsozxA2rJN4Vr3beZGpvEpZXME7lRCHm2KZk+McE7magbD71LED1Vt1tNlA?=
 =?us-ascii?Q?WmC5dSdaKaRv8hVS3a0eslXh4G2TxgP5txjSZ4HlvoTW3JCmgCGEn48BXkbi?=
 =?us-ascii?Q?LVJFpyQAueXaKLOlU8REglvatT8bzcdTILSQGYWh9PVXFkfTq9ZP37pFbjz8?=
 =?us-ascii?Q?wmh2/sGiEjDAT+bBKVwJUDZ91YYSN2zDQSwE9rVR7Ji/3P/1bpqRJn3vZRKu?=
 =?us-ascii?Q?gpgicJFevPdbsrxHWWiJ/YISB4I9uDCOncV1w5RtcebyfSU1USRFrjGvgIdu?=
 =?us-ascii?Q?GR6fe4PkE0LPjHQPzYsHsLey58JbFIexvMKVoI4XkjSTXTFiysZAb4F1OqPU?=
 =?us-ascii?Q?mgVk/evd+1iVVTQjqd9XPicX5Hj61hvUv4qBAemoCwLA0OPNcipNWBB5ZDZQ?=
 =?us-ascii?Q?fKiEZ7072nenbzAiQRHCh83xvWxCcHOSsTJsnZUJwV9hGjEbSX1v36JYoyXN?=
 =?us-ascii?Q?k7N+POA0JoyHHUKqwIhPuWuy1QvALZpk2lTK5YGcLYkCp5jAIr77VC2/p2hd?=
 =?us-ascii?Q?AtxL5a4BNWq6UGB8/Hk4phj45KpdElL2m2LGwICrTqDr03GPi9Z9qE+IBF9I?=
 =?us-ascii?Q?9j+Qjqde3l49SKcYbm5qyfjiAPUu0efTW9U6BWUiBKWtJNL7hgOZFfcvZ6f4?=
 =?us-ascii?Q?oK/hHjJa9CIOzgRMB2RugMHknTep7R9Yd2ZtapthfIF4CXmIkbKywp4M+90J?=
 =?us-ascii?Q?4lsq5q5umYp92vzBri91/yOMymEM0yJknIntZeHW20wDG071igGH9Lf9rKZt?=
 =?us-ascii?Q?n1VcYxHlX9jmPFmRRRP6x5pWWrZjWd5qR0rAuutH+71F7Zqzne63mwzzNWgG?=
 =?us-ascii?Q?XUpO/An5IEgqfSTHfTgg+ILlOFG5oX0/ESn6j7cSlEp7tfe47oE0Jk/1MMeZ?=
 =?us-ascii?Q?t7HyLNMVVj7GVop57O6l63o3Rw0Saj/OaDRjUAnpB/4zK61Tlm+P78GIb6HB?=
 =?us-ascii?Q?jYqGYL9HrC3SsJfo6eSS/p/xfmXJ/26EADw2MjiweR8W0+WRmT5KkObk82nG?=
 =?us-ascii?Q?9OsfL3JJ496/APhIeTmUnBv0Yv4jfjHHrCLcK32DU7/a6isXjhRHC4kijfI6?=
 =?us-ascii?Q?pIWtqPWbiQfeLSJwIumQ5Rmsniv02/uu7KK++U9QET/A83truMi1jY/KSteB?=
 =?us-ascii?Q?96OTESuf0ywgLtpwKJc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5802f195-2381-4aa8-acae-08dafb15ba28
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 18:39:56.1990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XKUKkiWopCXvqMA3nK6VucXCD216xsicwfT/Z2EHT//53+6CA7+MoScKZiJA+AEQZnwlX+bnZ/TN6BNrmTM/Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8173
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Guenter Roeck <groeck7@gmail.com> On Behalf Of Guenter Roeck
> Sent: Friday, January 20, 2023 12:18
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: Lin, Wayne <Wayne.Lin@amd.com>; dri-devel@lists.freedesktop.org;
> amd-gfx@lists.freedesktop.org; stable@vger.kernel.org;
> stanislav.lisovskiy@intel.com; Zuo, Jerry <Jerry.Zuo@amd.com>;
> bskeggs@redhat.com
> Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info in=
to
> the atomic state"
>=20
> Hi Mario,
>=20
> On Fri, Jan 20, 2023 at 11:51:04AM -0600, Limonciello, Mario wrote:
> > On 1/20/2023 11:46, Guenter Roeck wrote:
> > > On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
> > > > This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
> > > >
> > > > [Why]
> > > > Changes cause regression on amdgpu mst.
> > > > E.g.
> > > > In fill_dc_mst_payload_table_from_drm(), amdgpu expects to
> add/remove payload
> > > > one by one and call fill_dc_mst_payload_table_from_drm() to update
> the HW
> > > > maintained payload table. But previous change tries to go through a=
ll
> the
> > > > payloads in mst_state and update amdpug hw maintained table in once
> everytime
> > > > driver only tries to add/remove a specific payload stream only. The
> newly
> > > > design idea conflicts with the implementation in amdgpu nowadays.
> > > >
> > > > [How]
> > > > Revert this patch first. After addressing all regression problems c=
aused
> by
> > > > this previous patch, will add it back and adjust it.
> > >
> > > Has there been any progress on this revert, or on fixing the underlyi=
ng
> > > problem ?
> > >
> > > Thanks,
> > > Guenter
> >
> > Hi Guenter,
> >
> > Wayne is OOO for CNY, but let me update you.
> >
> > Harry has sent out this series which is a collection of proper fixes.
> > https://patchwork.freedesktop.org/series/113125/
> >
> > Once that's reviewed and accepted, 4 of them are applicable for 6.1.
>=20
> Thanks a lot for the update. There is talk about abandoning v6.1.y as
> LTS candidate, in large part due to this problem, so it would be great
> to get the problem fixed before that happens.

Any idea how soon that decision is happening?  It seems that we have line
of sight to a solution including back to 6.1.y pending that review.  So per=
haps
we can put off the decision until those are landed.
