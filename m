Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0BF6A5EE6
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjB1Sm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjB1Smz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:42:55 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A254136
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 10:42:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IjJvsz1YSAszmiD5gNmA/3k3Kc5pqB51AfhsDwn2LZH3BiOyymyUYupQ3tEhN22FKLB/7P1IHzN0sOc2n9HdlzMSS292Ezir1t41mHJJN9mDB+8NSJI4GYIfc/1YNMCgyqYCOLJIeLohojgrXN6IhF+sa+lrcCBway0X1pe0BZmblb1LyZuKaQnj58CzR0qcAuBUkL2ij5M/q6KCQSQb6ZnfuPYzXkBkKJrHUYrrQh98E+BBGmlp+gC/AS/a53JIOxARHjv4mVZ66sV0WAHMSc3XnwvvgqzzF6D67WwUDSE47STmszwpXWt6pCUJEqbtag8SVh2sXGEMx/VRihgf8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=obsc31vBEDBbrJ8cfZOPamAhTAefwPEIY6hm6FWEB+0=;
 b=e6HBBeLjUYQQSvfjkDGe0mcwEZmkG+I5luJI+aVLLL9ZB2P0xtEKCaWhr6MEq938pJgUNyvJDqlP5mYe0o7UZPTJYk9P0jf1hOCieDtkPEl66ut959pOJfQ7H8eyYUlv3SSzO57Iv5jiYIYu3W1SUB9zAzeeAfBndfg5Ydh5GVjv0PEpdWB5yg5OfNC5Y83nIMP2GI+/jB09nuepC+6f+Ln7euXrNuDUbHqF/CbCJa5jS/XkiNEvWKZ42p8WhEIJ79CX5SWySUp6nbrC7dl0C9ssA2zTcHIoaZSo4XY4kb2cHbnvSoU8MkmPsAsj2qRt9vPjC/LxQDEXvSbTD1ys2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=obsc31vBEDBbrJ8cfZOPamAhTAefwPEIY6hm6FWEB+0=;
 b=a2gfr4QKdiTuoQtTw1RMuK49icEbTTiLscFUsyo1Fz/0Wf0/dWVXBpnihKf81JaVXUq47RGjdwIgDd2P8uqNznCfR4ZhtS2RthNZahlu7dmIU9233Yg4/8J0RiGzoeDTC6a8MoWxJRqfnwBK6BajlOsBlTRxM2qyFbPKQQ7UsCQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH0PR12MB8007.namprd12.prod.outlook.com (2603:10b6:510:28e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 18:42:51 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 18:42:51 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>,
        "Mahapatra, Rajib" <Rajib.Mahapatra@amd.com>
Subject: RE: S2idle fix for DCN314
Thread-Topic: S2idle fix for DCN314
Thread-Index: AdlIc4X/GTKwtdN2ROKifDHf0v3sXwDMISuAAAAXjrA=
Date:   Tue, 28 Feb 2023 18:42:51 +0000
Message-ID: <MN0PR12MB6101D798550F0B730BE363C5E2AC9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <MN0PR12MB610166BFA2B07767C2BF7499E2A89@MN0PR12MB6101.namprd12.prod.outlook.com>
 <Y/5Kd+Dszzkjwa+M@kroah.com>
In-Reply-To: <Y/5Kd+Dszzkjwa+M@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-28T18:42:49Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=a4170156-8251-4a39-a038-8dd41e56e49d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-28T18:42:49Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 24abdfeb-917b-4502-8a28-ca206b7262e7
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH0PR12MB8007:EE_
x-ms-office365-filtering-correlation-id: c1a18a78-e099-4e3b-d337-08db19bb98a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RSFNzL8ztGBRmNsHZ+GTZAH2hk/9c0lnm8h6F/IGnoDfpitd+jCNvUVq7RUczAreadOV0OIRQja5HsFq6I7ouiOIjan6L6IrH/sAs1+URD6XfKWAKmcggtxEMpixFs1SdC9hGbZOYu51MIU1b0yBfNOGgdmujbBPmpzGfVYF2NFTiKMDqln+4QfyRNpxhxSQzXL3bw8s7mYO8AfCeq6t6nkfug4AYuO0OzkC9pqkCa+9psup9qyNFJHsmMu0gR20NeKv1L3W8XkG/uHVqRtv/cV0OMpwz7MsvJxft0P8UdgCNuZuiSI4U2ExZu1F5aq0yfvUL2W6NoPQturI1kXysefjtE3hMCmpXGbD0aTuB/gHyLUrSqEWPVmPm8zCxo9yPRbRZ2aVULck77GPVzyj7DfsVBc3IgdrK+gee8Z2DUTYBM6ksasguyVFh5VicEJqbaMukcgXb5xUkMoVSy0CkvyoeHeWlhpYlONQr1PG3biZZO4TVtE1zZqSdmabJYxbq71nvcCdSzO1P6zN1vyOX0LCi2IbK0f69d14BTfxjKFPPIjiGqcZPU/1v4ZbowUZZPs2uC3knUtBQ0SZRpbH4WMlehWThlXwtx2n4pEs2rlOl7ZwPaHmPhgJXXoEZLiu/D/Xni6BE8aMxtOGV9EOLNaod9WXtBgppXNs/BFwKRkYDiI1+J+jsubw80z3lCBlTAzBSTmJesmt9oL6gDThGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(38070700005)(38100700002)(122000001)(41300700001)(86362001)(33656002)(2906002)(4744005)(66556008)(8676002)(64756008)(5660300002)(66476007)(55016003)(66946007)(66446008)(4326008)(8936002)(6916009)(76116006)(186003)(6506007)(53546011)(26005)(9686003)(83380400001)(478600001)(316002)(54906003)(52536014)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cwRORzkh2uJQIAQv/AthyDsAE00N3G9yEVsKpDSChhXnl225/rNv1utQlYQ5?=
 =?us-ascii?Q?pI5Nycb9Yk+sw9AnMUp8YvPW/kQMRoDfAuLaauaoHNtM3K0rKhM0MIhwqc6l?=
 =?us-ascii?Q?DCKPE0hfW33SLXVMdtKvvt1gtsYVDG7fiAbNm4BpUg09QkMszsfrtcZj8mKW?=
 =?us-ascii?Q?c7srSko4aRZVg/9ogjOoNbffrenwTWvGiqim4KJFCCx02uZrF4+U6DShuYvn?=
 =?us-ascii?Q?gc2wgasCFgYWRn2Nteb4fdnbv9VlZ7rtA6o8zEw4gCh/As5CbXQIKNd4vHiA?=
 =?us-ascii?Q?z1fhfnDSHZCmbdH0tuDjuWHRIqPO8Rg2Pdq1Ec99TKOYKD+M2ScgqnHovCDJ?=
 =?us-ascii?Q?C/NlILepUTafSKzIumnsCmWd9LQTx74FWJAtHG4P4sdR2M7jkGyCnl89U3Xc?=
 =?us-ascii?Q?s90WBnjJVA8tqlDLHfuBSj9x2lhDw76t6hb4ONU/1vkFyLWKCRut3u8Hvj51?=
 =?us-ascii?Q?hZKcRq5oqGcB5TuWWTU7z4WFNckfyb5SHPOw5mKGGkTj165SEJ/tAolmqVBX?=
 =?us-ascii?Q?mbTJpN+A4TINMSgRehPWKcERnZvsaFwZAUZWXMa+YJJA6SfD40xZvHogMj80?=
 =?us-ascii?Q?K9CmKFvn8LOmwX9gOHbRwSHbERlOP5Nn5cSTMfBr99+ip0hmklpcaqyjw3FU?=
 =?us-ascii?Q?YZk3kn7OMgBiMR7DUIeNBuEElYauU0n9zi+zKbo6vI9KJXjJihf/TjT59q54?=
 =?us-ascii?Q?sqyO4Bs8ihpXaYRyJ0UF5M6mwJUFfOxFpXQzYtpz52DiE3zWTW6TuY/+lVOs?=
 =?us-ascii?Q?PRtpG071nh1rTnfuh6oy9+zJ7cT1RCLI2bvNcvW8q3pyWD9XIHzn0TIDbdPe?=
 =?us-ascii?Q?xIHq7/fisiA3NgSlcL0Ly7kFre7dGUuV5AVMFR72MekvLQtjXjN9Z+RFQqCJ?=
 =?us-ascii?Q?nHEcnTIM8WbyPgiFZo3hT/kuquEwSMxelyGlIgX5cZu184obXyr6SfRVU2Xz?=
 =?us-ascii?Q?JKwDBv7ny6UO64UQCd05FEve+kC3vW2J1Z5i+YgkPnAkJ65QkXXmD88OR+wo?=
 =?us-ascii?Q?R9xfot6iPGj0HP10DUZM1V/teZYlADsXfGVrMjEFjFPjWIdR3H1Be+Jh6C5n?=
 =?us-ascii?Q?m4Mt3zDdacdTfRYiyEzcPgi6jlS+2kHHhUuGc77M9UigTYwMHUvBpn4J5lcI?=
 =?us-ascii?Q?hAU4NnTBbHZbrGAfTneuFQcBZ6nohvv/F3kBy33PLhSWUvSKYt/07I9isYKm?=
 =?us-ascii?Q?GVBUoZBnW2rWDWQuOqjM+WLaWmQWwDMJ4GAQtdCKAAhomZmKsx78BoS02Xy4?=
 =?us-ascii?Q?ml/SImWkjgxgF9NxDZDyyLfW5ujHihWKea5EkfFY5SxasaPewSnAbK+2xJfk?=
 =?us-ascii?Q?FtQMnSdrB+H2jMw/CCToK1XWbvJLL8DZhdO4IGpURb5liMu4NKHWVPO+wFDu?=
 =?us-ascii?Q?PWcGkoEdw7jUAy80Er+bc+/FWFcJPwFdmKqPoxgAku3JkibaZ/Q5UOnWEcsG?=
 =?us-ascii?Q?3n9UWiOSM6ZBMuzDiybbZK9HPCo8mg8DzcJ/ur8gorBWhD2oA0HykIpiOuPg?=
 =?us-ascii?Q?weMghb8RCLEAiW10ZQxeGeI6TqrOyUOh2A6iUsU7mjieDoqEUf2JPhGJi91+?=
 =?us-ascii?Q?s2+x6oMEn+zAqouuXzY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a18a78-e099-4e3b-d337-08db19bb98a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 18:42:51.3614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C6uZzW6akDXxqNxNxDFxrirE9q9/buBca5kNNcLJpApjcFN3CZMnsTCjpDS3EpAag/9s9xu9UOZu0eVLDzbJgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8007
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, February 28, 2023 12:40
> To: Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org; Gong, Richard <Richard.Gong@amd.com>;
> Mahapatra, Rajib <Rajib.Mahapatra@amd.com>
> Subject: Re: S2idle fix for DCN314
>=20
> On Fri, Feb 24, 2023 at 05:17:52PM +0000, Limonciello, Mario wrote:
> > [Public]
> >
> > Hi,
> >
> > Newer GPU microcode binaries for products with DCN 314 cause the
> display to fail to resume from s2idle.
> > The following fix went into 6.3 that makes it work with both newer and
> older GPU microcode binaries.
> >
> > Please take this to 6.1.y.
> >
> > e383b12709e32 ("drm/amd/display: Move DCN314 DOMAIN power control
> to DMCUB")
>=20
> Also queued up for 6.2.y as you do not want to update and have a
> regression.

Much Appreciated!
