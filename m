Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E196DDE84
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDKOxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjDKOxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:53:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311F19AB
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:53:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HttU3TU5jZNBE+O7GaJ4yZaHP2VtltpW1T6WRBHLtWNnxOvFztDWPFJS5ME0HmTKZ/xZFh7vtCmu2794iMVy2wYSZvu9qPdMefAS9J2i6CRHCW1HYskyMOL7TdCkWCyraAPwQdKr5jxX71RLpMCB8cIHJv3ZJpCRqtftaD+ejMDVOklyB9qlJDezwURbsYgg+I5gdLnu1uYq8u0bJxYI29C2P/bQ9S3E01jYeN/ro4U8N73uDHYQ6KykfaTUbAS5eyQg2FzczYBlWcaB2tDqtCY6iMxCYjljZCzvDThEewle985kO3Gi7AaURUyjJZj4eYY7Bo27MiO3vNufB6sEAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKAsGQKd0VqWNFP1yuZLWBgUSBJH6zbMC1v/C8FE1vI=;
 b=PCBgCzFnlqY3S23/5RmB5KuM69B9RCSqJ64fGHNXusPhphsVKxxg1dkjYTIcZTrnehZh8Sx5CRJ0PDIM51g8yo/tun9UjLwwBxgth4h5d9nsyY4lWLXyd/yHWqp3AqPQR3WrGq0yn6jKFuxlzJjHn1FGVoEaGyx5qaD77DCd9bhUQn1rG0c0sbIt9Nev6kVyW+DQ52jlkWoXNkQvXsa2KbFG9HD0VIZBsVKH6+6qr11zmS30uCwn7wZSsLWSCHvFIQJl9r0MtdvMBoTgi+igt1BelRGm6RxcjNItdGyTFgBb3zKNwexQBKWXUtb9h+O61kwksSdWyYBBYpAvyON5zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKAsGQKd0VqWNFP1yuZLWBgUSBJH6zbMC1v/C8FE1vI=;
 b=TPQi1T6cZowuWHdT9/PaaiM+HSAm068WqiZyRZCumUJ6wLWVxRLekH7NIWHi0ubuDYGXi/+fAY61q7dPnkmDDzlyN3GZVbMRnqUUsiXbN8LTPYq/ZSSdLUh/AyMEfaEvqfWg9532lRr7VYpT3ObWS0DfPVyrzjoslLdW4tfMtIY=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Tue, 11 Apr
 2023 14:52:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Tue, 11 Apr 2023
 14:52:59 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Veronika Schwan <veronika@pisquaredover6.de>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Topic: Regression in 6.2.10 monitors connected via MST hub stay black
Thread-Index: AQHZa+Cxi1GUd0tPvUObubuBqZQb/68k6ecAgAABzzCAACVJAP//4fAAgAE/cgCAAAAZ0A==
Date:   Tue, 11 Apr 2023 14:52:59 +0000
Message-ID: <MN0PR12MB61019E9CDFB0004FF12EE0D1E29A9@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <8e90142e-cdc3-a4a0-754a-4c7a2388940b@pisquaredover6.de>
 <MN0PR12MB61014AE52F7F84A86F909717E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <MN0PR12MB61011B4C8FF79D3035963095E2959@MN0PR12MB6101.namprd12.prod.outlook.com>
 <5d0f31da-add5-b0b4-2a91-57859529dd88@pisquaredover6.de>
 <fec3d50f-8d4e-6828-b480-e9ff2531faaa@amd.com>
 <9520740d-c014-22e3-84b2-f93121027698@pisquaredover6.de>
In-Reply-To: <9520740d-c014-22e3-84b2-f93121027698@pisquaredover6.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-11T14:52:57Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=29ff05a9-e6aa-4cba-a60c-e4c41190c9f9;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-11T14:52:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 50a2d8e0-310f-4dba-a119-e498ac9fd613
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|IA0PR12MB8088:EE_
x-ms-office365-filtering-correlation-id: 828a869a-ac35-4091-c229-08db3a9c713d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OK+8fC+gTUer+vYqusbJbsY7/TeLXFeRgIBGqxNQyPewyeAx91qBj7crfxH3QzMdCVeh56GWfM7s+DYUvtpMd2meE7368935qUGfyVLoOnphQmJnle41pO/tJyM8FyXqjhoNRjZpYODlZ3xTi2k/hCM2FkjyqrOFI7wJKTur0+uGzvf/5C9VoHT4f+HXnGncO0VPVEYw2BYQaHOWOrv8zrTcZJc/6I0LJcLxJaaARz1V/dvMZ7RZ/HCvkXi3SUOYoyMAPZyhghYmoBWK7ecS7D5xQOvSkfOEGQSQsN8hKTWCUZDzQ6ReBYZG5njI5Bpur3BCITOVhsTRywP/sRtGcM1H/zVilg5vNEp+ynP0a4TbwtX0sptfbBobrMCCxIK1JnUaiypIPwneZKwlFOGkHqhMUFIXRcNs636TdGOCrXbm1/+0fGkN020DmEUr1n4WglkQNuMbFq+2uKAs5Xg+4KpjZpTsUllJWu7qKlaDdVNahWlp2iDiwGYkodhPoB9M4f/Gq4dlAJWQEyOWgvvVZi8uns8GUnvGv1MK3IfocfRM15klxmTgtcYVLlt6mc9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(6506007)(9686003)(53546011)(8676002)(8936002)(86362001)(4326008)(52536014)(5660300002)(71200400001)(7696005)(41300700001)(316002)(2906002)(478600001)(66446008)(66946007)(76116006)(66556008)(66476007)(110136005)(6636002)(64756008)(966005)(55016003)(38100700002)(83380400001)(26005)(38070700005)(122000001)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWZON0pwT29nZ2VqZ2VmWjlnd3NtaDk2MXNyOFBoRXlDaUIzVlpzcW9OdERy?=
 =?utf-8?B?d3RlSEVQQjcwekZkeGkvSUhwTjdUUHo5MTZaUW5PdGtxS3NPL01jZnl6MlBP?=
 =?utf-8?B?bnZaTkRwYWFmR0czQkZKdDVzK0FMekhnN05xNDJkcTNzOTBnRXpoZ2RqZnZU?=
 =?utf-8?B?RlJLejBQVThrTXJ6UHNtd2pSRnpOY3pIb1h1SzliRHI0elZVYjVoaXYvejFZ?=
 =?utf-8?B?OFlyUlZQaEhvblo3cGVpdWMzZWtqd2NnL0JUM3ZEVE4ranpLUWJGZ09QOVJC?=
 =?utf-8?B?K250Rk9FbEdRVlJHZ3FQUFI4U0IrK2xWZithSWtjYWFwVmxURlpNOHp4aUxG?=
 =?utf-8?B?MU4wK2V4M0tGL1VMZ1J3NEZpOWV3WXM5eTNNVExTQ2tkTkxiQ3lXSklnVTYv?=
 =?utf-8?B?THQzcEI4MjJ4VzJHMGVHMk1JK0pldGRZenpDaDdpejgzN0c0aTdNR2s3TWxJ?=
 =?utf-8?B?b2pERS9uT1lodmNGK2RJdnFrTm1Nak9OYUQ5UEhYd0p1N0FHVFB5TERZbUVL?=
 =?utf-8?B?amMySEJpZlBQYzY3eTllZmhoSDZrNWJxWVZUUW5GWVQ3L0tYOURUMUFyYWNZ?=
 =?utf-8?B?VlN5V24wVjdNRkR3cmpUa2w3QXhpc0NudmlvMVRMWjkrTnY5azg2U2RNdmVT?=
 =?utf-8?B?U3hONzZ0RkVXdUJYZGhkUnVRZ2lnOEs3QlZWSC9jSlBJUTJhZzRyczF2aXBk?=
 =?utf-8?B?azRaeVBHcWo2WHlnR0ZTaDYrUFFsbTQydVY2bFJVU3FybXg1VkM3ZHJuNnk1?=
 =?utf-8?B?bE5LVzhJOC9nUk9pOFV0WGswbUFZOHhUUlRac3pRRnlLeFh3Y3RPSGZiMU1Y?=
 =?utf-8?B?cXFnRW9KOWpOcU8rL3NIUlYyUFlZbmQzeHlqUnMyWjlocm1CNG9Ga1owWGdF?=
 =?utf-8?B?N3FhNUpNdFRvTkhzckJFYUJsM1FnbjFoQWhhUmZkeHQ3cG9MUXVnV1pEQ3I0?=
 =?utf-8?B?Y1VBVXlGb3lmRUpWNGZORllOajliVDlrT2RRNzlrT1o5U3NSczR5b3EzZ0hX?=
 =?utf-8?B?cTZFYVdvVUdMVFovSUh3ekpwWkdjS3U5cXJUSTNGa0N6UmdUYllaWWZoY3c4?=
 =?utf-8?B?WHRtNEovaStnRHFWUHpSeFpEblpmTkRGKzFmdE9HOVdJUkcxRFYyQnJNNFRR?=
 =?utf-8?B?N3JBVkFXN1NSZE9lbjdyOXJDeFdxTWpPL2xwdlJsOTgyRWZlaGJGd0c3Rk1u?=
 =?utf-8?B?ZnBNRThUWHpzMmZ5VUZJNkpCSFVBeStOM0VXVFl2LzE1RW9SbG8vSHRwT1N3?=
 =?utf-8?B?SVh3cTd3Wjdna0hmRW8rb0dhYTkzRmQrUTV6ZUtFUXdDY3g3L05mSjROVzAw?=
 =?utf-8?B?MnBOTjR3SDg1RklIc3BRMXBqSjhLdVRlK0FIZmxFL1hPM2wrNzJ6ak5aZnc0?=
 =?utf-8?B?V2FuSUY0UFNuOVdKeGxkMVZwckYrcFF0cWJoeXBPWU4rNnVnc2VzaFFvR2Jj?=
 =?utf-8?B?dnlibU1ROWdFMGtPRUgycEZPa3hkVk91bFRCaGRzK1pFWHlkMXVRbGM5RjJy?=
 =?utf-8?B?aUN3aHNoaDRpZlovUmtwTDh1eTB4NkgwM0hDOW1veENKOEVsY2xkd3o5VFo4?=
 =?utf-8?B?M3VhM1EvZWVwS3lieldNV0xVb0dzOTFSclB3dkJDTGpWTndZd1NNUEJ2ZU1P?=
 =?utf-8?B?WnJOQ01adlJxUDJxaUdXSDlkMWJock1iSmVXOG9UOGVmSFhwVFpEZk9LcFQw?=
 =?utf-8?B?THZCRno1cklRTC9aK3NnWWJCcFNVMkNNQ21xWklyakdFNWhaQ0hmdVFRNHQx?=
 =?utf-8?B?WDBIaUoxS1dlZ3NxRFZOeVJsQjh5YVJWUlNSaWNSZFJiVW1JM0lQdW5IRUFV?=
 =?utf-8?B?RVBYNHEzb2h1V3pDMVlKRXZiU2hJKzQxbnVlWGVsN0E3VmlGWWFJcUlEMEZ6?=
 =?utf-8?B?MFhnSXNRV1ZHd0JOM0Y5SWVUa0QxZThlRXlWbnhQcXhoLzJ1QXBtMndBNXFw?=
 =?utf-8?B?dll0U2cxZ0V0bGtVT20vSC9HNzFaUEh6T2JqN0NYbVFyNWRLMmt1V3RFUEFU?=
 =?utf-8?B?bFZ0enY0VHVLbGV1UC9uMzFnNWtoZlVBcThHemJTVXVxVEZjVkoydldha2xG?=
 =?utf-8?B?L1FMN092TnI3bDU0R295elozc0k1OXNaRU5Ed2Z3Q0ZZTjg0dVN1eDVVaDFG?=
 =?utf-8?Q?4ZHQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828a869a-ac35-4091-c229-08db3a9c713d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 14:52:59.1704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GX5u5XX7fGis/2eDQu5Fh7lGydYSg6z2AtN1k1CmICZA5pwGu1xBcogEU6e5cJA2HgpoAWHzeadh8lXRIqPLGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KVGhhbmtzIQ0KDQpUaGVuIEkgdGhpbmsgd2UgbmVlZCBhIG11bHRpIHN0ZXAg
cHJvY2VzcyB0byBmaXggdGhpczoNCg0KMSkgV2UnbGwgbmVlZCB0byBkaXNjdXNzIHF1ZXVpbmcg
dGhhdCBwYXRjaCB1cCBmb3IgNi4zLXJjNw0KMikgQXNzdW1pbmcgaXQncyBxdWV1ZWQgdXAgYW5k
IGxhbmRlZCB0aGVuIGEgc2VwYXJhdGUgc2VuZCB0byBzdGFibGUgZm9yIDYuMi55IChhbmQgZXZh
bHVhdGUgaXQgZ29pbmcgdG8gNi4xLnkgdG9vKS4NCg0KVGhhbmtzLA0KDQo+IC0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFZlcm9uaWthIFNjaHdhbiA8dmVyb25pa2FAcGlzcXVh
cmVkb3ZlcjYuZGU+DQo+IFNlbnQ6IFR1ZXNkYXksIEFwcmlsIDExLCAyMDIzIDA5OjUxDQo+IFRv
OiBMaW1vbmNpZWxsbywgTWFyaW8gPE1hcmlvLkxpbW9uY2llbGxvQGFtZC5jb20+OyBadW8sIEpl
cnJ5DQo+IDxKZXJyeS5adW9AYW1kLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcN
Cj4gU3ViamVjdDogUmU6IFJlZ3Jlc3Npb24gaW4gNi4yLjEwIG1vbml0b3JzIGNvbm5lY3RlZCB2
aWEgTVNUIGh1YiBzdGF5IGJsYWNrDQo+IA0KPiBJIGFwcGxpZWQgdGhlIHBhdGNoIHRvIDYuMi4x
MCBhbmQgaXQgd29ya3MuDQo+IA0KPiBUbyBiZSBhYmxlIHRvIGFwcGx5IGl0LCBJIGhhZCB0byBh
ZGFwdCBzbGlnaHRseSAocmVuYW1lZA0KPiAnbXN0X291dHB1dF9wb3J0JyB0byAncG9ydCcpLiBJ
IGF0dGFjaGVkIHRoZSBwYXRjaCBJIGFwcGxpZWQuDQo+IA0KPiBUaGFua3MgeW91IGZvciB3b3Jr
aW5nIG9uIHRoZSBpc3N1ZSENCj4gDQo+IE9uIDExLzA0LzIwMjMgMDIuNDcsIE1hcmlvIExpbW9u
Y2llbGxvIHdyb3RlOg0KPiA+IFRoYXQncyBncmVhdCwgdGhhbmtzIcKgIFNvIHdlIGRvIGhhdmUg
YSBwYXRoIHRvIGdldHRpbmcgdGhpcyBmaXhlZA0KPiA+IHdpdGhvdXQgYSByZXZlcnQgdGhlbiwg
aXQganVzdCBtaWdodCBiZSBhIGZldyBzdGVwcy4NCj4gPg0KPiA+IENhbiB5b3UgdHJ5IHRvIGFw
cGx5IHRoYXQgZGlyZWN0bHkgdG8gNi4yLnkgYXMgd2VsbCB0byBzZWUgaWYgaXQgaGVscHMNCj4g
PiB0aGVyZSB0b28/DQo+ID4NCj4gPiBPbiA0LzEwLzIzIDE2OjM1LCBWZXJvbmlrYSBTY2h3YW4g
d3JvdGU6DQo+ID4+IEhpLA0KPiA+Pg0KPiA+PiA2LjMtcmM2IGFsb25lIGZhaWxzIHRoZSBzYW1l
IHdheS4NCj4gPj4gV2hlbiB0aGUgY29tbWl0IGlzIGFkZGVkLCBpdCB3b3Jrcy4NCj4gPj4NCj4g
Pj4gT24gMTAvMDQvMjAyMyAyMS4yMiwgTGltb25jaWVsbG8sIE1hcmlvIHdyb3RlOg0KPiA+Pj4g
W1B1YmxpY10NCj4gPj4+DQo+ID4+PiBBbmQgaWYgNi4zLXJjNiBmYWlscyB0aGUgc2FtZSB3YXks
IHBsZWFzZSBvbmUgbW9yZSBjaGVjayB3aXRoIDYuMy1yYzYNCj4gPj4+ICsgdGhpcyBjb21taXQ6
DQo+ID4+PiBodHRwczovL2dpdGxhYi5mcmVlZGVza3RvcC5vcmcvYWdkNWYvbGludXgvLS9jb21t
aXQvYzdjNGZlNWQwYjBhDQo+ID4+Pg0KPiA+Pj4+IEhpLA0KPiA+Pj4+DQo+ID4+Pj4gQ2FuIHlv
dSBieSBjaGFuY2UgY3Jvc3MgcmVmZXJlbmNlIDYuMy1yYzY/DQo+ID4+Pj4gSXQncyBxdWl0ZSBw
b3NzaWJsZSB3ZSdyZSBtaXNzaW5nIHNvbWUgb3RoZXIgY29tbWl0cyB0byBiYWNrcG9ydCBhdA0K
PiA+Pj4+IHRoZSBzYW1lDQo+ID4+Pj4gdGltZS4NCj4gPj4+Pg0KPiA+Pj4+IFRoYW5rcywNCj4g
Pj4+Pg0KPiA+Pj4+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+Pj4+PiBGcm9tOiBW
ZXJvbmlrYSBTY2h3YW4gPHZlcm9uaWthQHBpc3F1YXJlZG92ZXI2LmRlPg0KPiA+Pj4+PiBTZW50
OiBNb25kYXksIEFwcmlsIDEwLCAyMDIzIDE0OjE1DQo+ID4+Pj4+IFRvOiBadW8sIEplcnJ5IDxK
ZXJyeS5adW9AYW1kLmNvbT4NCj4gPj4+Pj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IExp
bW9uY2llbGxvLCBNYXJpbw0KPiA+Pj4+PiA8TWFyaW8uTGltb25jaWVsbG9AYW1kLmNvbT4NCj4g
Pj4+Pj4gU3ViamVjdDogUmVncmVzc2lvbiBpbiA2LjIuMTAgbW9uaXRvcnMgY29ubmVjdGVkIHZp
YSBNU1QgaHViIHN0YXkNCj4gPj4+Pj4gYmxhY2sNCj4gPj4+Pj4NCj4gPj4+Pj4gSSBmb3VuZCBh
IHJlZ3Jlc3Npb24gd2hpbGUgdXBkYXRpbmcgZnJvbSA2LjIuOSB0byA2LjIuMTAgKEFyY2ggTGlu
dXgpLg0KPiA+Pj4+PiBBZnRlciB1cGdyYWRpbmcgdG8gNi4yLjEwLCBteSBleHRlcm5hbCBtb25p
dG9ycyBzdG9wcGVkIHdvcmtpbmcgKG5vDQo+ID4+Pj4+IGlucHV0KSB3aGVuIHN0YXJ0aW5nIG15
IGRpc3BsYXkgbWFuYWdlci4NCj4gPj4+Pj4gTXkgaGFyZHdhcmU6DQo+ID4+Pj4+IExlbm92byBU
MTRzIEFNRCBnZW4gMQ0KPiA+Pj4+PiBMZW5vdm8gVVNCLUMgRG9jayBHZW4gMiA0MEFTIChmaXJt
d2FyZSB1cCB0byBkYXRlOiAxMy4yNCkNCj4gPj4+Pj4gMiBtb25pdG9ycyBjb25uZWN0ZWQgdmlh
IGRvY2sgYW5kIHRodXMgdmlhIGFuIE1TVCBodWINCj4gPj4+Pj4NCj4gPj4+Pj4gUmV2ZXJ0aW5n
IGNvbW1pdCBkN2I1NjM4YmQzMzc0YTQ3ZjBiMDM4NDQ5MTE4YjEyZDhkNmUzOTFjDQo+IGZpeGVz
IHRoZQ0KPiA+Pj4+PiBpc3N1ZS4NCj4gPj4+Pj4NCj4gPj4+Pj4gQmVzdCByZWdhcmRzLA0KPiA+
Pj4+PiBWZXJvbmlrYQ0K
