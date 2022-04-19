Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2025E506D19
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 15:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiDSNGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 09:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351374AbiDSNGf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 09:06:35 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E75737A03;
        Tue, 19 Apr 2022 06:03:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GfVUJ8XgzzlnGTEvAVktVrkHnLd4qlYc84mNe4xqU2Y4+pEc6XpMkGEqUdMZXZh3u2rNvDuzRyVhR93A9D09cCXB06M74I+frfPMEfkozxFfVg37s0UfU0X3zjftzOQlD+7fxnsyZqqod+0ClF/c1mIYGnBQuFOflm0Gv75+tQ4BRrg+vT0g7nIg45eWI7bQ2Xrh//uStqS8KX+c0gzQgJypmu81C00OIBncRVg19S8/AM8smEf/GrOTMDT9RdMvw2JcGlYMp5Q7KqBQVjGGps8AUwWMF+eYcJpiQ5BvNUtr88F1E+V19FXI0UiAXK/2kd35cfX5d8UDTHvkOHJCTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovzeeNOS6Omw9zacYr/PS6cq2VGFN0HZEqxAU/B9Fb8=;
 b=ZxLAV3+7HLjqzhvJy4EZK6aAtUv15Cm4GvjklVfWgKalSt2DHUcl9HLfGaCzRPO4Bfwhe17yFoMXYW01fVuvGIK5nV6WA3DK/MrQ+FiJ4T4h+g2phAGGPLL55E7LJqqLmpYrrfQPa8k2I4+T2YdMFEXPiDujNoJyI0r8uGmMINyKsY4ci5ReFl05Ahn11onOYOHRdrXdk05ViLJUUJj+UpTPFvxIcHu4a0kjycTSF4LEmBCnSBAL0banpXwhhvvij2Z8uFHgeDrVYGQJcrrP0Mljh8wNrRQ8yZaa59Y3kkB+uu5iwjeWd5ndTu9D3C3yeI9Fs3VUCRZdeISGTWu24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovzeeNOS6Omw9zacYr/PS6cq2VGFN0HZEqxAU/B9Fb8=;
 b=gEnz5aBUVmolbfLyTDQhKlMcuhHJN4YLBp8lPs2joYERULp3YAqW0A/mvjopxu5oz2dyCZy2EqUjQR6cbDCdemneN/gtqmfZfnf79wd2L9cU86jxMYRYolZsl3ym4lkfDuO4B+sMk6qhaE7AFKsA+cP7mda1kymvXJwvbgGwcXA=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by BY5PR12MB5543.namprd12.prod.outlook.com (2603:10b6:a03:1d1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 13:03:48 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%8]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 13:03:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     firew4lker <firew4lker@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
CC:     "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        "Gong, Richard" <Richard.Gong@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] gpio: Request interrupts after IRQ is initialized
Thread-Topic: [PATCH] gpio: Request interrupts after IRQ is initialized
Thread-Index: AQHYT6tiDiONtoBF+k2+wW5PsRbBBqz0DMIAgAEPJoCAAiA0YA==
Date:   Tue, 19 Apr 2022 13:03:48 +0000
Message-ID: <BL1PR12MB5157E0609CEBA19D2BE95C1CE2F29@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <20220414025705.598-1-mario.limonciello@amd.com>
 <20966c6b-9045-9f8b-ba35-bf44091ce380@gmail.com>
 <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
In-Reply-To: <67df4178-5943-69d8-0d61-f533671a1248@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-19T13:02:31Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=127d9d00-5152-408e-992a-13f5d961bd9c;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-19T13:03:47Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ab2f2b5c-8ae4-4fdb-86f9-96a3fce27a06
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54565942-2202-4058-4f9d-08da22050b6a
x-ms-traffictypediagnostic: BY5PR12MB5543:EE_
x-microsoft-antispam-prvs: <BY5PR12MB5543BB4C66A31C76C6130AD3E2F29@BY5PR12MB5543.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2ijAaUwt+jD0B78sJjB44VpvmOJaAwZ1iO+c+uL8sKz2sa/cpnVIYlKvXaNVRAEUXBxSjoafqoGdrKg30xqDHiNvwu+P/RKkquMY8ZgPybL0wzpE2uxl+LpIDRZmC2m6kM3zdC2WCZE/RfJaJzf9xsd0JxWfvsQ3g7jsVWc+66JdSZXDAeXb2Z90Rn/mgYaWlAJS34zDbYtZTvtUEGHkMlabKEMIrj0Lo40LCVM+eSMPH7d+64AehagYo6XWlFLmUvQnuGGXlXg5/tg/yqhEHYcqsIGS1TEy4SsI7IldLXzQa3v5PnZEBSZugCsSdvICpwOwD8zrquI9LPLc1n8VAiRgH9yqGV+Xg3iD9uBJZYiO1CVmAJUpTG2LA3Izs+Iuk/acJ4OSpSYnHeTxT8f+DtuBG545YG1OGtYMiDqb44Zi+5nKl4tqwSYzGVhiRoUw5xCrWC5mepWSfg+iXAklqIdvIr6JJONUBtQzF1fWdJArQ5hveAEVj94ZHfShueCTUXAyppTIsSBV6PMyqC64i9ZB7ppPKurd8ubUOtK0OWULsn+9MGa/Dt1VduNOolT0AZ3iykTIVkRZiiU0cVTDEm1fFrSGMc9FfQlrFpsxDadCzdJPitmNnxip1jAcyg9qImtnluQRyvOCgJ0Hw1xxuDv9GTuy8SCZif6BVNeppQaIBuBWahyIb4U1ebRiGE5CutG4NXHxcAZ0gCBqzKgVl37RRQ5AkqMxRzh4in9K3VRJ/OE7TIdgEwlKlFlI/2xgYZt+Y70CJgNZaT9FXGgubHpXw2Pn+yCMLmiQghwCJdwU3xPXAkPVSycRmMr1g+aChD5bBtMgktXHK/RbmyhTPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(122000001)(9686003)(52536014)(33656002)(8936002)(186003)(45080400002)(5660300002)(316002)(966005)(83380400001)(2906002)(66556008)(66476007)(71200400001)(76116006)(66446008)(508600001)(64756008)(8676002)(66946007)(38100700002)(55016003)(110136005)(54906003)(6506007)(7696005)(38070700005)(86362001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MW02SHZ3b1JOSmRtZnJHMlJydUEyZkxJS0lxc21TRytHbnJFT3hrQm5lWWZv?=
 =?utf-8?B?Y0svVytNSFA4WDNYYktkM3M0NEtZR3F2TVk5U2U2bTg1Sy9lN0d2S1BHNnUz?=
 =?utf-8?B?WGt4d3ZMTHpMMGVJa1FacVBpbGt0VEF6Z05qOHBvczhtOXF3c2pjeUNtMFJL?=
 =?utf-8?B?VDF1c2FRSzZycXFrV0ZPS01Tb1k4OTRlSjRianRCRkR2Vyt3cVlTd1YrQk9k?=
 =?utf-8?B?N2FFMUE3T1IrbXZWK20xN1BPZWV5b0JTN24vZ2NobXplRmNHSHVLdHZ2YTFZ?=
 =?utf-8?B?LzBvL2I2NjNFb3ZsTXkyVzRSM0ZSc2xLMC9td005bkt1cldHbFFqUHFNaFNT?=
 =?utf-8?B?aVFMTFRTclRwamtYK3BSUjdQd25ycFgzeTBJUDNGUGp6SjU5WkVEWHpBR2FJ?=
 =?utf-8?B?Ylp0VWdyTE9Yb3VhdWNRdmFQaVFrMTFSZXFjZXVISzlsNi85NDU5SGthbFdQ?=
 =?utf-8?B?YVczR3oyQUZhLzc1ZzdndlJVWng0OEg5SGcxYTVaVFp1RUxIVHpDKzVCVWNa?=
 =?utf-8?B?Z002bEIwQVU3VHNzdVR1a1QvZEdmeVIvUDhOS1V4Q0tjeXRwb3dSRVBwQlZl?=
 =?utf-8?B?Zk51bmN6SmJWT2p2KzVrRUJvczJWbmxSZE5jdzl4TkNzK3hvd21CTzZxSEZL?=
 =?utf-8?B?MkFaUEl5Tlg0Ym5GS29HaEpaZWxpMERiOU56eFVvazViRU5HbFh3UGx2ZE1s?=
 =?utf-8?B?bWFhbDdiV1dXUldPNXV5ZmFkNTRZbmtYNjY0Z2RTN3VUOUcyWWVXdTRxNk9L?=
 =?utf-8?B?VFBJZWFQeEZpOHNNR1Z1eU11N0t4Mmhyck9XYkx1QjJIcUFwUzdlWUlQbkhs?=
 =?utf-8?B?amlOeDRxYzkveVZuckNoQkFQU0pxSkVwT1lOK3JzZmRtMWVJWVlNMVRwaGUy?=
 =?utf-8?B?VXQwZENxdHNwNXlsL3VCcEFzSWk0aGFHc3djYkVTcldmUkpvTXlmcGttd3cw?=
 =?utf-8?B?dlhtbXJRSEdjV3ZJWkwrem5BdXhuU21hSnZucktsQ2oxc1FZQU4yVzJ6RFZR?=
 =?utf-8?B?UVBqc1JhbEpoU0xhM3F2ODhoZHRjWTNocEhyMHJ4cERINTVOZDFjQzdXb0hh?=
 =?utf-8?B?ejZxSlkraXg0MDA4WndMK2QwQUxRSzhMQTBPRzVqQlpTc2ZQbVJPcUxSU09B?=
 =?utf-8?B?MmI0RVNrK2F3dStUbVFXUFlmQzhLTmN3eWZoM2dwdDh6RlQvME9hRFJZVGx1?=
 =?utf-8?B?TTZxTU5uRTUrWXRrMzdzejdmQmM2UHJ2a2dURm1VbG5YR0FVdGRvMUhjcUNR?=
 =?utf-8?B?eHRCbm9xWWg1Zis0Q0VNenBLSjNRb2FmeHNheDM0bVMxL1BFZVhWWWxyQytG?=
 =?utf-8?B?cGR5Y3k1L2I4OVBQZmZBSm9Qcm1RbDJQb0RRS21jL2R2SWwzSGlWbzFFMFly?=
 =?utf-8?B?Q0R1eGZ3b3RXc3o5OStsUUR1S3hlVEFjdUlGNnRZa1ljVGlKbWxzMHJMQkpS?=
 =?utf-8?B?VGdkaDFuUlhSU242eGVlUzJ2QUZaY3dBVE1lY3Q4TEtUbWJyb1paT0hPWlN2?=
 =?utf-8?B?QVQ5bjVKWmphZ21rL2djTVdvWmFML1FLcFhkTzdHYmJJemE5Q1lIWW81V0JY?=
 =?utf-8?B?dksvczdZV1ZxQkVWbStDdEtsSXRCUUdLcVlCa0Z6U1F5TUc0emRqNlBuczVJ?=
 =?utf-8?B?bkdWZThPUkIwQ1EvZFR1TUdIbXhmQTBJbUF4R2JpK2NRb285azk2TlB4TVdv?=
 =?utf-8?B?TENjejdzNG9FSzlScUsyTGlEeEJxWFU3VHdHZkEvVlNSWUFvbTB1RFhEMUk1?=
 =?utf-8?B?Vkl5djJHSWM4WWlUTjRZMzJ3STBlUjBKWWQ2Nkw2d0JQVzlxWGRPYnQ5QTh3?=
 =?utf-8?B?V0xzbEFaajRBKzF0aXovaVp0bGVobWZDbUVkKysxeTNXVGx4NUJ3UlVsQklO?=
 =?utf-8?B?YzM0VmVRTjBKU0ZGRjJKb0dveVgxRFJYNjI4WGIwblc2aTgxZXkrT0NNZmNT?=
 =?utf-8?B?YVRLczlGMFcvUUt2UThmUzA4VXVBUk5qendRRmowdnNCUmwwN0oybnVGL3Y1?=
 =?utf-8?B?RTZBbmo3dDZCZ1Z1R1JlY2taeXBEZ1FVSU56SjJZWW9qSUtVcHl0VHhpUUc5?=
 =?utf-8?B?TVlVZ0FVOHhsaWQ3Zi9MMXN0ZWUzTVpDOVVGTWVvLzM2RXk1M2dNb3p1UkVR?=
 =?utf-8?B?VVV5OVBWRDlTZHlwWVNJMkVFaHcxTk9SS1I5bjk0SVRxaFNTWUhWdjVqUS90?=
 =?utf-8?B?a1JXSkhUanFZWktuOE5IZHp0ellKRGNQTWdEenJaQ244eGQxK2lraGhhWnhZ?=
 =?utf-8?B?L2c0RW9yUlZHcWxNTUlMV0JrdDZac29vL1ArQ3p1cVpOaGVERVhoZUVqUWNK?=
 =?utf-8?B?d2h2M1NKbWNZb2twemtEdUNGQnVWTldRbFp1MDB5cUkyTlRSZ3FUUDFvSDA3?=
 =?utf-8?Q?Vxz5preu/cXc6Pcw9R6iA/ls+YXHuTZ9aVRzf9j+FnyYk?=
x-ms-exchange-antispam-messagedata-1: AVeApgKg1JS6MA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54565942-2202-4058-4f9d-08da22050b6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 13:03:48.7887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: isDBwaUShmbdcYfYYQ4BqkNKlmctiktfwfDmx0t4XwQN8ImB5wlYfqXJSlkAd9npEIcJbnKpEF+QDvXlYAEqhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5543
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGlt
b25jaWVsbG8sIE1hcmlvDQo+IFNlbnQ6IFN1bmRheSwgQXByaWwgMTcsIDIwMjIgMjM6MzUNCj4g
VG86IGZpcmV3NGxrZXIgPGZpcmV3NGxrZXJAZ21haWwuY29tPjsgTGludXMgV2FsbGVpag0KPiA8
bGludXMud2FsbGVpakBsaW5hcm8ub3JnPjsgQmFydG9zeiBHb2xhc3pld3NraSA8YnJnbEBiZ2Rl
di5wbD47IEFuZHkNCj4gU2hldmNoZW5rbyA8YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT47IFNo
cmVleWEgUGF0ZWwNCj4gPHNocmVleWEucGF0ZWxAY29sbGFib3JhLmNvbT47IG9wZW4gbGlzdDpH
UElPIFNVQlNZU1RFTSA8bGludXgtDQo+IGdwaW9Admdlci5rZXJuZWwub3JnPjsgb3BlbiBsaXN0
IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPg0KPiBDYzogTmF0aWthciwgQmFzYXZhcmFq
IDxCYXNhdmFyYWouTmF0aWthckBhbWQuY29tPjsgR29uZywgUmljaGFyZA0KPiA8UmljaGFyZC5H
b25nQGFtZC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0hdIGdwaW86IFJlcXVlc3QgaW50ZXJydXB0cyBhZnRlciBJUlEgaXMgaW5pdGlhbGl6ZWQNCj4g
DQo+IE9uIDQvMTcvMjIgMDc6MjQsIGZpcmV3NGxrZXIgd3JvdGU6DQo+ID4gT24gNC8xNC8yMiAw
NTo1NywgTWFyaW8gTGltb25jaWVsbG8gd3JvdGU6DQo+ID4+IGNvbW1pdCA1NDY3ODAxZjFmY2Ig
KCJncGlvOiBSZXN0cmljdCB1c2FnZSBvZiBHUElPIGNoaXAgaXJxIG1lbWJlcnMNCj4gPj4gYmVm
b3JlDQo+ID4+IGluaXRpYWxpemF0aW9uIikgYXR0ZW1wdGVkIHRvIGZpeCBhIHJhY2UgY29uZGl0
aW9uIHRoYXQgbGVhZCB0byBhIE5VTEwNCj4gPj4gcG9pbnRlciwgYnV0IGluIHRoZSBwcm9jZXNz
IGNhdXNlZCBhIHJlZ3Jlc3Npb24gZm9yIF9BRUkvX0VWVCBkZWNsYXJlZA0KPiA+PiBHUElPcy4g
VGhpcyBtYW5pZmVzdHMgaW4gbWVzc2FnZXMgc2hvd2luZyBkZWZlcnJlZCBwcm9iaW5nIHdoaWxl
IHRyeWluZw0KPiA+PiB0byBhbGxvY2F0ZSBJUlFzIGxpa2Ugc286DQo+ID4+DQo+ID4+IFvCoMKg
wqAgMC42ODgzMThdIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQ
SU8gcGluDQo+ID4+IDB4MDAwMCB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODgz
MzddIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+
ID4+IDB4MDAyQyB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODgzNDhdIGFtZF9n
cGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4MDAz
RCB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODgzNTldIGFtZF9ncGlvIEFNREkw
MDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4MDAzRSB0byBJUlEs
IGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODgzNjldIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBG
YWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4MDAzQSB0byBJUlEsIGVyciAtNTE3
DQo+ID4+IFvCoMKgwqAgMC42ODgzNzldIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8g
dHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4MDAzQiB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvC
oMKgwqAgMC42ODgzODldIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRl
IEdQSU8gcGluDQo+ID4+IDB4MDAwMiB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42
ODgzOTldIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGlu
DQo+ID4+IDB4MDAxMSB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODg0MTBdIGFt
ZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4
MDAxMiB0byBJUlEsIGVyciAtNTE3DQo+ID4+IFvCoMKgwqAgMC42ODg0MjBdIGFtZF9ncGlvIEFN
REkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluDQo+ID4+IDB4MDAwNyB0byBJ
UlEsIGVyciAtNTE3DQo+ID4+DQo+ID4+IFRoZSBjb2RlIGZvciB3YWxraW5nIF9BRUkgZG9lc24n
dCBoYW5kbGUgZGVmZXJyZWQgcHJvYmluZyBhbmQgc28gdGhpcw0KPiA+PiBsZWFkcw0KPiA+PiB0
byBub24tZnVuY3Rpb25hbCBHUElPIGludGVycnVwdHMuDQo+ID4+DQo+ID4+IEZpeCB0aGlzIGlz
c3VlIGJ5IG1vdmluZyB0aGUgY2FsbCB0bw0KPiA+PiBgYWNwaV9ncGlvY2hpcF9yZXF1ZXN0X2lu
dGVycnVwdHNgIHRvDQo+ID4+IG9jY3VyIGFmdGVyIGdjLT5pcmMuaW5pdGlhbGl6ZWQgaXMgc2V0
Lg0KPiA+Pg0KPiA+PiBDYzogU2hyZWV5YSBQYXRlbCA8c2hyZWV5YS5wYXRlbEBjb2xsYWJvcmEu
Y29tPg0KPiA+PiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+PiBGaXhlczogNTQ2Nzgw
MWYxZmNiICgiZ3BpbzogUmVzdHJpY3QgdXNhZ2Ugb2YgR1BJTyBjaGlwIGlycSBtZW1iZXJzDQo+
ID4+IGJlZm9yZSBpbml0aWFsaXphdGlvbiIpDQo+ID4+IFJlcG9ydGVkLWJ5OiBNYXJpbyBMaW1v
bmNpZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AYW1kLmNvbT4NCj4gPj4gTGluazoNCj4gPj4NCj4g
aHR0cHM6Ly9uYW0xMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBz
JTNBJTJGJTJGbG9yZS4NCj4ga2VybmVsLm9yZyUyRmxpbnV4LQ0KPiBncGlvJTJGQkwxUFIxMk1C
NTE1NzdBNzdGMDAwQTAwOEFBNjk0Njc1RTJFRjklNDBCTDFQUjEyTUI1MTU3Lg0KPiBuYW1wcmQx
Mi5wcm9kLm91dGxvb2suY29tJTJGVCUyRiUyM3UmYW1wO2RhdGE9MDQlN0MwMSU3Q21hcmlvLmxp
DQo+IG1vbmNpZWxsbyU0MGFtZC5jb20lN0M5NmVjMzljNzg0ODg0OTNmZDVjYTA4ZGEyMDZkM2M3
YiU3QzNkZDg5NjENCj4gZmU0ODg0ZTYwOGUxMWE4MmQ5OTRlMTgzZCU3QzAlN0MwJTdDNjM3ODU3
OTUxMjA0NjUwNzU0JTdDVW5rbm8NCj4gd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3
TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMQ0KPiBoYVd3aUxDSlhWQ0k2TW4wJTNEJTdD
MzAwMCZhbXA7c2RhdGE9eFpiTkMlMkY1MEpxbE53Y1RZQXRHTG42DQo+IHowJTJGRVBiZkNLS09j
JTJCbFpsTWgwRVElM0QmYW1wO3Jlc2VydmVkPTANCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTog
TWFyaW8gTGltb25jaWVsbG8gPG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20+DQo+ID4+IC0tLQ0K
PiA+PiDCoCBkcml2ZXJzL2dwaW8vZ3Bpb2xpYi5jIHwgNCArKy0tDQo+ID4+IMKgIDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2dwaW8vZ3Bpb2xpYi5jIGIvZHJpdmVycy9ncGlvL2dwaW9saWIuYw0K
PiA+PiBpbmRleCAwODUzNDhlMDg5ODYuLmI3Njk0MTcxNjU1YyAxMDA2NDQNCj4gPj4gLS0tIGEv
ZHJpdmVycy9ncGlvL2dwaW9saWIuYw0KPiA+PiArKysgYi9kcml2ZXJzL2dwaW8vZ3Bpb2xpYi5j
DQo+ID4+IEBAIC0xNjAxLDggKzE2MDEsNiBAQCBzdGF0aWMgaW50IGdwaW9jaGlwX2FkZF9pcnFj
aGlwKHN0cnVjdCBncGlvX2NoaXANCj4gPj4gKmdjLA0KPiA+PiDCoMKgwqDCoMKgIGdwaW9jaGlw
X3NldF9pcnFfaG9va3MoZ2MpOw0KPiA+PiAtwqDCoMKgIGFjcGlfZ3Bpb2NoaXBfcmVxdWVzdF9p
bnRlcnJ1cHRzKGdjKTsNCj4gPj4gLQ0KPiA+PiDCoMKgwqDCoMKgIC8qDQo+ID4+IMKgwqDCoMKg
wqDCoCAqIFVzaW5nIGJhcnJpZXIoKSBoZXJlIHRvIHByZXZlbnQgY29tcGlsZXIgZnJvbSByZW9y
ZGVyaW5nDQo+ID4+IMKgwqDCoMKgwqDCoCAqIGdjLT5pcnEuaW5pdGlhbGl6ZWQgYmVmb3JlIGlu
aXRpYWxpemF0aW9uIG9mIGFib3ZlDQo+ID4+IEBAIC0xNjEyLDYgKzE2MTAsOCBAQCBzdGF0aWMg
aW50IGdwaW9jaGlwX2FkZF9pcnFjaGlwKHN0cnVjdCBncGlvX2NoaXANCj4gPj4gKmdjLA0KPiA+
PiDCoMKgwqDCoMKgIGdjLT5pcnEuaW5pdGlhbGl6ZWQgPSB0cnVlOw0KPiA+PiArwqDCoMKgIGFj
cGlfZ3Bpb2NoaXBfcmVxdWVzdF9pbnRlcnJ1cHRzKGdjKTsNCj4gPj4gKw0KPiA+PiDCoMKgwqDC
oMKgIHJldHVybiAwOw0KPiA+PiDCoCB9DQo+ID4NCj4gPiBUZXN0ZWQtQnk6ZmlyZXc0bGtlckBn
bWFpbC5jb20NCj4gPg0KPiA+IFRoaXMgcGF0Y2ggYWRkcmVzc2VzIHRoZSBpc3N1ZS4gVGVzdGVk
IG9uIGEgTGVub3ZvIFQxNCB3aXRoIEFNRCBSeXplbiA1DQo+ID4gUFJPIDQ2NTBVIHdpdGggUmFk
ZW9uIEdyYXBoaWNzIEdyYXBoaWNzLg0KPiA+DQo+ID4gV2l0aG91dCB0aGlzIHBhdGNoIHRoZSBs
YXB0b3AgaXMgaW1wb3NzaWJsZSB0byB3YWtlIGZyb20gUzMgYW5kIFMwaXguDQo+ID4NCj4gDQo+
IFRoYW5rcyBmb3IgdGVzdGluZyBpdCENCj4gDQo+IExpbnVzIFdhbGxlaWosDQo+IA0KPiBBcyB0
aGlzIGlzIGJhY2twb3J0ZWQgdG8gNS4xNS55LCA1LjE2LnksIDUuMTcueSBhbmQgdGhvc2UgYWxs
IGhhZCBwb2ludA0KPiByZWxlYXNlcyBhIGJ1bmNoIG9mIHBlb3BsZSBhcmUgaGl0dGluZyBpdCBu
b3cuICBJZiB5b3UgY2hvb3NlIHRvIGFkb3B0DQo+IHRoaXMgcGF0Y2ggaW5zdGVhZCBvZiByZXZl
cnQgdGhlIGJyb2tlbiBvbmUsIHlvdSBjYW4gYWRkIHRvIHRoZSBjb21taXQNCj4gbWVzc2FnZSB0
b286DQo+IA0KPiBMaW5rOiBodHRwczovL2dpdGxhYi5mcmVlZGVza3RvcC5vcmcvZHJtL2FtZC8t
L2lzc3Vlcy8xOTc2DQoNCkhlcmUncyBhIGZldyBtb3JlIGxpbmtzIHRvIGFkZC4NCg0KTGluazog
aHR0cHM6Ly9naXRsYWIuZnJlZWRlc2t0b3Aub3JnL2RybS9hbWQvLS9pc3N1ZXMvMTk3OQ0KDQpM
aW5rOiBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNTg1MA0K
DQpUaGFua3MsDQo=
