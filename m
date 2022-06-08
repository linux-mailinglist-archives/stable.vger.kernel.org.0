Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13E3543149
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 15:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbiFHN01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 09:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240195AbiFHN0Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 09:26:24 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6486CA85
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 06:26:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkP7iVMiewZz6BJn/+gY1IvScfduoofPihvvIOzRn4oeI3kCLVM9o8FD5UW+hd43Ayu+d+V/qbraKZApfLfgtqJxZb+gWdVHmh1INwEBtQ/Oj9fpEZqhNTQvYCHa2/QWxl1YmLoE4+LYzLE2Wi8ocWfE0xJ192mvmJQi4HV7JxxNfPKBpDZBkzLCGZub7mLImfPZVFQv9vMKpfbSDfD2Uvzm8ehmWo0xQcDhxJjagPIlYlUFz13HOtyUVBetpwrP0hBxlPn5xAJNXPaAtMcSJUQ/FzNPyJw52UQ4V6URCFu54eotDBy7xrYMLSzD4+UXkvJef5OrGIAWFLjDQtwoRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3kok6TwRkWS7bXZfismBpqbuYV1+qfsbHmGIBcn+0Y=;
 b=a+crId1WG20XYlokEyXwhWKFG6t9QH42a9A8JLsf1b6jb1MNxuOiiaGWCHsidrZT/7aTD+ozBGarkOhohAdisfOM6k804zE879rSPVQLJwQqGCrnX3q3ea/4LkJGFoBu7b6psSMdByS/5lOCVDsUhBzR6Pjv4hLfjOuNx3pUy0esJ+B1pI1iwL9iGTHvtWCeUVfGa+HWONGcuUq+l58iajQKh6594950kakinBPmxzG91XP59HtvXyK2tyqls+7VEUcXGnz1LIYs2idbHdSleEg/brja78IYfc1Mu2lAN/sxMYeo+uYEQDQCpZAvCuQsxrUFF87p8+52gCI432cokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3kok6TwRkWS7bXZfismBpqbuYV1+qfsbHmGIBcn+0Y=;
 b=eFFYj7LxR3JnfPlWYBKCcrv6r02n3FsQniULnDUj2jn5QlVBaH7PEhjYZMqRQ01nf7H6mXy6AkRodczRmmdqbTPLSHvkj630EXeoY7g4D/CQ1jfFrUpS46xnzsUaB835dzIBfE8RCeb3hbFMRsZd1COokHBRYIN3OqIWdBJ9BSgxASZu2SCnWwj7/4uA0FYGMxwhMkufHagL1qFhCpEheI46N9SCW84NHLQUJayNGZJubm32Hg6JFXoaZaEyc9cN2wwgMj9gc5xZ2IslOoH/rkQbsmfRivMDPG/nUo33/U4M7okokEVSZ/9U5rPBOk0phI52JnaovMfv5riwakWtqw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB5296.namprd12.prod.outlook.com (2603:10b6:5:39d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 13:26:19 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 13:26:19 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yongji Xie <xieyongji@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <oliver.sang@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Thread-Topic: [PATCH v2] vduse: Fix NULL pointer dereference on sysfs access
Thread-Index: AQHYWUS8lMTRd/0/2UqI8h//G1UzZa1FuoAAgAAJcAD////o4A==
Date:   Wed, 8 Jun 2022 13:26:19 +0000
Message-ID: <PH0PR12MB54811B8F17B8964A53947465DCA49@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220426073656.229-1-xieyongji@bytedance.com>
 <YmeoSuMfsdVxuGlf@kroah.com> <20220608085133-mutt-send-email-mst@kernel.org>
 <CACycT3vjNwESmoAy14+NCGxHaXJtFq6ykHTkqcpm8nvb0=sbog@mail.gmail.com>
In-Reply-To: <CACycT3vjNwESmoAy14+NCGxHaXJtFq6ykHTkqcpm8nvb0=sbog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1595ffb5-5f6c-44af-dd15-08da49527909
x-ms-traffictypediagnostic: DM4PR12MB5296:EE_
x-microsoft-antispam-prvs: <DM4PR12MB52969E74A42D0CE04289A9CADCA49@DM4PR12MB5296.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9uLIRkz8kIw9DqXFBgqMVM5DLGmPNegUHaPQ/vLUcz/z7yraIcx5U/RuUj1D59IwV9wjAYZDizUZeqP5RZzsnmMuII/gGRqG01ywNaP4vAvN5A0mYOKV60DWHlV5xM4LPL+Tw/EtmOe2mLEKIQ8A6DS2CVHsINUiq/0gBebNVBF66sIpzvIuTkt8UjyhbJjsWRidflP+wGcgqMeFmgFUQetzjXvY2CTJnWhIeOJ6k3MoSvgkfFWeJDKxvZiUKib5Ts5hsYI06wy2CPaYrTnnaFssOH+2vgQkCD5LPtHa3H3fZcWuHlnsuc/6zdNhvS+deaSRhF71oUZMJTIWV0DEOrOBr8zG9yESzFvbUHzXzY9XDnfbDas7pdj5mKAohNGnO9Z7HwbmKlWW1JzPHkh4DKVKWO4ltDzAHzAlCbCp9dPo3ykbloCh3tIOLUvlcyCoAweuu8FUk23z/XsnY1oLryW7Tju5BFiOecB/hFAzqr4EJUfU1RWE6U6a7WTZNcPzyKPU4dV2Lo8FF8UCL+rakFheCY+OKwn7n9c0Bfruv9KxekWc0CsdqsqCDElEqNpHFtnaVSau+9uys97uysN61UAq7dxJEzh2V9G1q/B/OLGwIKAEy9PC7k4AK8I9uKVnvWgYseP3xUTVdGFE3as75f2tNcExI9afgesd0lCI081xNDgGAL9swF2NsH3p8M3/p0BFZy4nG/kcua2kIaK43yX7Rtk8x4SNtxr0WObJVpcy5iqb88knbRSNkbc76EEoKFymZrtE7FNPbeLR0GC+LvIkt5aww+RppeBzLaecKSv0+bwedz1wfVnUqprtYPaBMWXaLaUfZ64zQIxb7YCZxQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52536014)(55016003)(66556008)(66946007)(66446008)(186003)(316002)(122000001)(8936002)(38070700005)(83380400001)(110136005)(9686003)(66476007)(54906003)(8676002)(38100700002)(33656002)(5660300002)(64756008)(2906002)(53546011)(6506007)(7696005)(86362001)(4326008)(76116006)(966005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzF1TzdtSUp2UWFEM1lZZGNBWnJUOUUrSzJxT3VWZlFISFhUNEErRlVMK2ZF?=
 =?utf-8?B?NSsrWjEwRGNwc2FrMHdsUGxmeTk3N3ZIV1Vtcml4bmZBelZzUzZSQVVBM3dG?=
 =?utf-8?B?a1BKUWl5RlpSSXdpamRlUXByMjhqK2h0UE85S2lOcTQ1dlViMlQzUEo4TDBs?=
 =?utf-8?B?Z0FiMVZBZTUvQTZjVlhZL0xFRnZIdnZrTnREbURqd1NndXR6ck9CYmR6QkZU?=
 =?utf-8?B?M3ZSRVpweERyS1BTdXlkRWhrWTdwc2k1cjI5RmhqNkpZSXpLRXp6bGJKTW92?=
 =?utf-8?B?UlF4Tk05RWc1a3JNeDNiQ3FyZEtQM01SSnhUWXMxeEZ3NmZqTEg3bjRORVB4?=
 =?utf-8?B?VDVYUzRSVUxMbFpVK1NnbjBqVmpYeXAramtobVppSXNxcHdtUHVSNUNsSTlC?=
 =?utf-8?B?cWNYVEhXWUpUU3VjVDVYTkRYaWlBUHZVazVGeHk5bFZMZVZEa0VOYTNZcUdG?=
 =?utf-8?B?cXR0bURQVkJwYTl4Y2tSMEhUVWRVMHFxdjVmWnVvQ0huQ1VEQ3hjY3JsSTAz?=
 =?utf-8?B?bkVoRFhaV0ZKNTJhUVZJVkFlSHhNUjNUZ3FHTkF0R3BCZzgwWWkwb1hsbjV6?=
 =?utf-8?B?SUZrYnk2SEhycUdDL1UxV3Y3MjYvdjhIcnFpRzVrOGoyNU51Q0JIOW8wZlN4?=
 =?utf-8?B?U0dRSVZZbWUvTlRtL2NhWlY2Z0c1RHpRV212OWhqYm5XUjQ3emZ3K3hKZDBQ?=
 =?utf-8?B?aVNVSi84bHY1QWFyUUxZRmJzdjFKOFZEbXAvOFBKOVpGRTFxZ1RYU0kvckds?=
 =?utf-8?B?ZTl4M09GR0tHcWlVNHpYOFNIQlJPR1FSazR0ZlhpVGsrbkZROUp2NHNpSTF4?=
 =?utf-8?B?TWIrYjRtemhsM2gyb0tFdmFZakNCcTB6ZWMrcXRac2xJWklheUkwbHBRbUdy?=
 =?utf-8?B?dFM1aHN3ZFhpQk4yMzdFNzdRR0FlLzVrVjlmb1p3ekFLUHVFQnNpeGY5OWlq?=
 =?utf-8?B?YW1qZE1zcGlwbFAvb2JCVUVzZWkxVC9XT2hwWFNsS0FySU5FT1hBWlBUSVdi?=
 =?utf-8?B?azNPV0VsajBzMnIydTI5K1hPVkRKb2JwQVU1SHlNdSt3YmR4dVFBSmEySGJW?=
 =?utf-8?B?M1k5VG5lUEkxdWJERnFNcVc2eWpwNE53WHRvaDNMQnB3YklpODZoL0hBaWZi?=
 =?utf-8?B?VitQSVFTaFZRSFowSUIxZjl1UGlMNysyNW9MbzRtUlRzR2FqYzU1b29mNUx2?=
 =?utf-8?B?dVhUNW5DbzdzcTdoT3hhelFOR3pHSEF2eHNRK3B1OTM4dWEwTE5Wbm5BRUht?=
 =?utf-8?B?WVd4ODdCckFvZVlGcmwxWUVDZWNEam1wcnluZmlsZnprRmpnY0xhZE5pVlRq?=
 =?utf-8?B?aENMeFJIdDVaQXVsbFNOWUk3Y2xxNnlzdEtxRU15dnErb2JHckozRUZ0bkZo?=
 =?utf-8?B?MzEzWkJ3UlpFSlVGbktFZ2lMeW5QMVJ0Y3VoZWcvV21KRCs0V1FxYTgyVGZI?=
 =?utf-8?B?ZkowZThLbjBINkFBQVN5bzErUld4YklDc0RZTE5yR2ZVSlBJd3FvY2ZSU1M4?=
 =?utf-8?B?NVl0dUc4cmtGT0ZVOXZGNlBINkY5UDFsSkluS1ZFUlh5bmJoM1oyVEVJNTFj?=
 =?utf-8?B?OVdTYWdzSWx4RTVONmhSc2RvQzRSZWdtS0VaWjJ1T21xNWFSS2E5cWdvaXlP?=
 =?utf-8?B?amtmTlBIZmhpc1UzSXltUzVTMEsrVVN3cW14dFJVNnFlZklWbDFicnpRbjY4?=
 =?utf-8?B?Nkhta0kveGJhN3RUVERkNmJaM295RzZWOFgzemZnNUFGVnhvZ0krM2puM3Iz?=
 =?utf-8?B?YzlmZTdDWkJrWU5JS21wa29YZzE2SWZpcW1jaXpKYWs2NklUS3VJMVFGRVho?=
 =?utf-8?B?cDlBZzdkWVdTTXRSRmg1S1dNNDRTYTlSWWxuOG5PR0tZcG9RaU8xQk14N056?=
 =?utf-8?B?MFprUVZjSVlzR1lWaVhBZURGbEdHZXkwVER6TkhtRmRKdmVCaVdEN1ZadjRF?=
 =?utf-8?B?M3dwTnpmdnYrRFpHNlVjK0hIZFlPMDBJUjJHRW5sK0pTb3Z1YktCcllVRjhY?=
 =?utf-8?B?Y3F6K3RNenNqZFFtTU9tWm45MXhVall0QnZBNTZvSmh1TkcvNTZYeTdRTllx?=
 =?utf-8?B?OUlEcHZKR0ZSUHR5bkVsNkRtcEwwbkkrT3pyNVlPSGJZdHN5aHhuNkJUZXdZ?=
 =?utf-8?B?TzRuTmd0a01EaDVqOWJDVzViQnh5MThUVkx5UW9LUUVERTA2RFVqU3k5Vng3?=
 =?utf-8?B?amlub0E4b1dKcU1IT1Q2a2tDL0ZhVVdaZlJOU2p5NmRmWkcxbVhMS1dUTUxU?=
 =?utf-8?B?L0dYQ2d3ZjV6TE02TU1TWWNpMnhoZ2h2U1crcDc3QlRyeDgrNjE4Z0NNai9D?=
 =?utf-8?B?czF3OTV0K0hvdXBJQVE5TnFFb1JWSmxnUm9QY0xDcVBKa0YxcTVxKzhDcnBG?=
 =?utf-8?Q?3rD7zvwMggy9yemmD8sQ88wzXssL0y08lyXm/PpeWfvef?=
x-ms-exchange-antispam-messagedata-1: dDB5sQX7FuXa4g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1595ffb5-5f6c-44af-dd15-08da49527909
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2022 13:26:19.3019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0N9k57MYZPN4QRQclaONxEFR/SIlExWCVS/1oGFWodOz7n8mhHF+7d/3IUCRr6tUZVEZ2+bn6qX3pyODyzyOVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5296
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gRnJvbTogWW9uZ2ppIFhpZSA8eGlleW9uZ2ppQGJ5dGVkYW5jZS5jb20+DQo+IFNlbnQ6
IFdlZG5lc2RheSwgSnVuZSA4LCAyMDIyIDk6MjYgQU0NCj4gDQo+IE9uIFdlZCwgSnVuIDgsIDIw
MjIgYXQgODo1MiBQTSBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29tPiB3cm90ZToN
Cj4gPg0KPiA+IE9uIFR1ZSwgQXByIDI2LCAyMDIyIGF0IDEwOjA3OjM4QU0gKzAyMDAsIEdyZWcg
S0ggd3JvdGU6DQo+ID4gPiBPbiBUdWUsIEFwciAyNiwgMjAyMiBhdCAwMzozNjo1NlBNICswODAw
LCBYaWUgWW9uZ2ppIHdyb3RlOg0KPiA+ID4gPiBUaGUgY29udHJvbCBkZXZpY2UgaGFzIG5vIGRy
dmRhdGEuIFNvIHdlIHdpbGwgZ2V0IGEgTlVMTCBwb2ludGVyDQo+ID4gPiA+IGRlcmVmZXJlbmNl
IHdoZW4gYWNjZXNzaW5nIGNvbnRyb2wgZGV2aWNlJ3MgbXNnX3RpbWVvdXQgYXR0cmlidXRlDQo+
ID4gPiA+IHZpYSBzeXNmczoNCj4gPiA+ID4NCj4gPiA+ID4gWyAxMzIuODQxODgxXVsgVDM2NDRd
IEJVRzoga2VybmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSwNCj4gPiA+ID4gYWRkcmVzczog
MDAwMDAwMDAwMDAwMDBmOCBbIDEzMi44NTA2MTldWyBUMzY0NF0gUklQOg0KPiA+ID4gPiAwMDEw
Om1zZ190aW1lb3V0X3Nob3cgKGRyaXZlcnMvdmRwYS92ZHBhX3VzZXIvdmR1c2VfZGV2LmM6MTI3
MSkNCj4gPiA+ID4gWyAxMzIuODY5NDQ3XVsgVDM2NDRdIGRldl9hdHRyX3Nob3cgKGRyaXZlcnMv
YmFzZS9jb3JlLmM6MjA5NCkgWw0KPiA+ID4gPiAxMzIuODcwMjE1XVsgVDM2NDRdIHN5c2ZzX2tm
X3NlcV9zaG93IChmcy9zeXNmcy9maWxlLmM6NTkpIFsNCj4gPiA+ID4gMTMyLjg3MTE2NF1bIFQz
NjQ0XSA/IGRldmljZV9yZW1vdmVfYmluX2ZpbGUNCj4gPiA+ID4gKGRyaXZlcnMvYmFzZS9jb3Jl
LmM6MjA4OCkgWyAxMzIuODcyMDgyXVsgVDM2NDRdIGtlcm5mc19zZXFfc2hvdw0KPiA+ID4gPiAo
ZnMva2VybmZzL2ZpbGUuYzoxNjQpIFsgMTMyLjg3MjgzOF1bIFQzNjQ0XSBzZXFfcmVhZF9pdGVy
DQo+ID4gPiA+IChmcy9zZXFfZmlsZS5jOjIzMCkgWyAxMzIuODczNTc4XVsgVDM2NDRdID8gX192
bWFsbG9jX2FyZWFfbm9kZQ0KPiA+ID4gPiAobW0vdm1hbGxvYy5jOjMwNDEpIFsgMTMyLjg3NDUz
Ml1bIFQzNjQ0XSBrZXJuZnNfZm9wX3JlYWRfaXRlcg0KPiA+ID4gPiAoZnMva2VybmZzL2ZpbGUu
YzoyMzgpIFsgMTMyLjg3NTUxM11bIFQzNjQ0XSBfX2tlcm5lbF9yZWFkDQo+ID4gPiA+IChmcy9y
ZWFkX3dyaXRlLmM6NDQwIChkaXNjcmltaW5hdG9yIDEpKSBbIDEzMi44NzYzMTldWyBUMzY0NF0N
Cj4gPiA+ID4ga2VybmVsX3JlYWQgKGZzL3JlYWRfd3JpdGUuYzo0NTkpIFsgMTMyLjg3NzEyOV1b
IFQzNjQ0XQ0KPiA+ID4gPiBrZXJuZWxfcmVhZF9maWxlIChmcy9rZXJuZWxfcmVhZF9maWxlLmM6
OTQpIFsgMTMyLjg3Nzk3OF1bIFQzNjQ0XQ0KPiA+ID4gPiBrZXJuZWxfcmVhZF9maWxlX2Zyb21f
ZmQgKGluY2x1ZGUvbGludXgvZmlsZS5oOjQ1DQo+ID4gPiA+IGZzL2tlcm5lbF9yZWFkX2ZpbGUu
YzoxODYpIFsgMTMyLjg3OTAxOV1bIFQzNjQ0XQ0KPiA+ID4gPiBfX2RvX3N5c19maW5pdF9tb2R1
bGUgKGtlcm5lbC9tb2R1bGUuYzo0MjA3KSBbIDEzMi44Nzk5MzBdWyBUMzY0NF0NCj4gPiA+ID4g
X19pYTMyX3N5c19maW5pdF9tb2R1bGUgKGtlcm5lbC9tb2R1bGUuYzo0MTg5KSBbIDEzMi44ODA5
MzBdWw0KPiA+ID4gPiBUMzY0NF0gZG9faW50ODBfc3lzY2FsbF8zMiAoYXJjaC94ODYvZW50cnkv
Y29tbW9uLmM6MTEyDQo+ID4gPiA+IGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jOjEzMikgWyAxMzIu
ODgxODQ3XVsgVDM2NDRdDQo+ID4gPiA+IGVudHJ5X0lOVDgwX2NvbXBhdCAoYXJjaC94ODYvZW50
cnkvZW50cnlfNjRfY29tcGF0LlM6NDE5KQ0KPiA+ID4gPg0KPiA+ID4gPiBUbyBmaXggaXQsIGRv
bid0IGNyZWF0ZSB0aGUgdW5uZWVkZWQgYXR0cmlidXRlIGZvciBjb250cm9sIGRldmljZQ0KPiA+
ID4gPiBhbnltb3JlLg0KPiA+ID4gPg0KPiA+ID4gPiBGaXhlczogYzhhNjE1M2I2YzU5ICgidmR1
c2U6IEludHJvZHVjZSBWRFVTRSAtIHZEUEEgRGV2aWNlIGluDQo+ID4gPiA+IFVzZXJzcGFjZSIp
DQo+ID4gPiA+IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8b2xpdmVyLnNhbmdAaW50
ZWwuY29tPg0KPiA+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBYaWUgWW9uZ2ppIDx4aWV5b25namlAYnl0ZWRhbmNlLmNvbT4NCj4gPiA+ID4g
LS0tDQo+ID4gPiA+ICBkcml2ZXJzL3ZkcGEvdmRwYV91c2VyL3ZkdXNlX2Rldi5jIHwgNyArKyst
LS0tDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9u
cygtKQ0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92ZHBhL3ZkcGFfdXNl
ci92ZHVzZV9kZXYuYw0KPiA+ID4gPiBiL2RyaXZlcnMvdmRwYS92ZHBhX3VzZXIvdmR1c2VfZGV2
LmMNCj4gPiA+ID4gaW5kZXggZjg1ZDFhMDhlZDg3Li4xNjBlNDBkMDMwODQgMTAwNjQ0DQo+ID4g
PiA+IC0tLSBhL2RyaXZlcnMvdmRwYS92ZHBhX3VzZXIvdmR1c2VfZGV2LmMNCj4gPiA+ID4gKysr
IGIvZHJpdmVycy92ZHBhL3ZkcGFfdXNlci92ZHVzZV9kZXYuYw0KPiA+ID4gPiBAQCAtMTM0NCw5
ICsxMzQ0LDkgQEAgc3RhdGljIGludCB2ZHVzZV9jcmVhdGVfZGV2KHN0cnVjdA0KPiA+ID4gPiB2
ZHVzZV9kZXZfY29uZmlnICpjb25maWcsDQo+ID4gPiA+DQo+ID4gPiA+ICAgICBkZXYtPm1pbm9y
ID0gcmV0Ow0KPiA+ID4gPiAgICAgZGV2LT5tc2dfdGltZW91dCA9IFZEVVNFX01TR19ERUZBVUxU
X1RJTUVPVVQ7DQo+ID4gPiA+IC0gICBkZXYtPmRldiA9IGRldmljZV9jcmVhdGUodmR1c2VfY2xh
c3MsIE5VTEwsDQo+ID4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgTUtERVYoTUFK
T1IodmR1c2VfbWFqb3IpLCBkZXYtPm1pbm9yKSwNCj4gPiA+ID4gLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBkZXYsICIlcyIsIGNvbmZpZy0+bmFtZSk7DQo+ID4gPiA+ICsgICBkZXYtPmRl
diA9IGRldmljZV9jcmVhdGVfd2l0aF9ncm91cHModmR1c2VfY2xhc3MsIE5VTEwsDQo+ID4gPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICBNS0RFVihNQUpPUih2ZHVzZV9tYWpvciksIGRl
di0+bWlub3IpLA0KPiA+ID4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgZGV2LCB2ZHVz
ZV9kZXZfZ3JvdXBzLCAiJXMiLA0KPiA+ID4gPiArIGNvbmZpZy0+bmFtZSk7DQo+ID4gPiA+ICAg
ICBpZiAoSVNfRVJSKGRldi0+ZGV2KSkgew0KPiA+ID4gPiAgICAgICAgICAgICByZXQgPSBQVFJf
RVJSKGRldi0+ZGV2KTsNCj4gPiA+ID4gICAgICAgICAgICAgZ290byBlcnJfZGV2Ow0KPiA+ID4g
PiBAQCAtMTU5NSw3ICsxNTk1LDYgQEAgc3RhdGljIGludCB2ZHVzZV9pbml0KHZvaWQpDQo+ID4g
PiA+ICAgICAgICAgICAgIHJldHVybiBQVFJfRVJSKHZkdXNlX2NsYXNzKTsNCj4gPiA+ID4NCj4g
PiA+ID4gICAgIHZkdXNlX2NsYXNzLT5kZXZub2RlID0gdmR1c2VfZGV2bm9kZTsNCj4gPiA+ID4g
LSAgIHZkdXNlX2NsYXNzLT5kZXZfZ3JvdXBzID0gdmR1c2VfZGV2X2dyb3VwczsNCj4gPiA+DQo+
ID4gPiBPaywgdGhpcyBsb29rcyBtdWNoIGJldHRlci4NCj4gPiA+DQo+ID4gPiBCdXQgd293LCB0
aGVyZSBhcmUgc29tZSBwcm9ibGVtcyBpbiB0aGlzIGNvZGUgb3ZlcmFsbC4gIEkgc2VlIGENCj4g
PiA+IG51bWJlciBvZiBmbGF0LW91dC13cm9uZyB0aGluZ3MgaW4gdGhlcmUgdGhhdCBzaG91bGQg
aGF2ZSBiZWVuDQo+ID4gPiBjYXVnaHQgYnkgY29kZSByZXZpZXdzLiAgU29tZSBleGFtcGxlczoN
Cj4gPiA+ICAgICAgIC0gZW1wdHkgcmVsZWFzZSgpIGNhbGxiYWNrcy4gIFRoYXQgaXMgYSBodWdl
IHNpZ24gdGhlIGNvZGUNCj4gPiA+ICAgICAgICAgZGVzaWduIGlzIHdyb25nIGFuZCBicm9rZW4g
YW5kIHlvdSBhcmUganVzdCB0cnlpbmcgdG8gbWFrZSB0aGUNCj4gPiA+ICAgICAgICAgZHJpdmVy
IGNvcmUgcXVpZXQgZm9yIHNvbWUgcmVhc29uLiAgVGhlIGRvY3VtZW50YXRpb24gaW4gdGhlDQo+
ID4gPiAgICAgICAgIGtlcm5lbCBleHBsYWlucyB3aHkgdGhpcyBpcyBub3Qgb2suDQo+ID4gPiAg
ICAgICAtIF9fbW9kdWxlX2dldChUSElTX01PRFVMRSk7ICBUaGF0J3MgcmFjeSwgYnVnZ3ksIGFu
ZCBkb2Vzbid0IGRvDQo+ID4gPiAgICAgICAgIHdoYXQgeW91IHRoaW5rIGl0IGRvZXMuICBQbGVh
c2UgbmV2ZXIgZXZlciBldmVyIGRvIHRoYXQuICBJdA0KPiA+ID4gICAgICAgICB0b28gaXMgYSBz
aWduIG9mIGEgYnJva2VuIGRlc2lnbi4NCj4gPiA+ICAgICAgIC0gbm8gRG9jdW1lbnRhdGlvbi9B
QkkvIGVudHJpZXMgZm9yIHRoZSBzeXNmcyBmaWxlcyBoZXJlLiAgSQ0KPiA+ID4gICAgICAgICB0
aGluayBpdCdzIGJ1cnJpZWQgaW4gc29tZSBvdGhlciBkb2N1bWVudGF0aW9uIGZpbGUgYnV0IHRo
YXQncw0KPiA+ID4gICAgICAgICBub3QgdGhlIGNvcnJlY3QgcGxhY2UgZm9yIGl0IGFuZCBpZiB5
b3UgcnVuIHNjcmlwdHMvZ2V0X2FiaS5wbA0KPiA+ID4gICAgICAgICB3aXRoIHRoZSBjb2RlIGxv
YWRlZCBpdCB3aWxsIHJpZ2h0bHkgY29tcGxhaW4gYWJvdXQgdGhpcy4NCj4gPiA+DQo+ID4gPiBE
byB5b3Ugd2FudCB0byBhZGRyZXNzIHRoZXNlLCBvciBkbyB5b3Ugd2FudCBwYXRjaGVzIGZvciB0
aGVtPw0KPiA+ID4NCj4gPiA+IHRoYW5rcywNCj4gPiA+DQo+ID4gPiBncmVnIGstaA0KPiA+DQo+
ID4gU28sIGFueSBwYXRjaGVzPw0KPiA+DQo+IA0KPiBGb3IgZW1wdHkgcmVsZWFzZSgpIGNhbGxi
YWNrcywgSSB0aGluayBQYXJhdiBpcyB3b3JraW5nIG9uIGl0IGJhc2VkIG9uIHRoZQ0KPiBkaXNj
dXNzaW9uIFsxXS4gSSBjYW4gaGVscCB0ZXN0IGFuZCBzZW5kIHRoZSBwYXRjaCBpZiBQYXJhdiB3
YW50cy4NCj4gDQpBcyB0aGVyZSBhcmUgbm8gbW9yZSBjb21tZW50cywgSSB3aWxsIHNlbmQgdGhl
IHBhdGNoIGZvciB2ZHVzZSB0aGlzIHdlZWsgYmFzZWQgb24gWzFdIHdoaWNoIHdhcyBwcmV2aW91
c2x5IGluIGVtYWlsIGZvcm0uDQoNCj4gRm9yIERvY3VtZW50YXRpb24sIEkgaGF2ZSBzZW50IGEg
cGF0Y2ggWzJdLg0KPiANCj4gWzFdIGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xpc3RzL2xpbnV4
LXZpcnR1YWxpemF0aW9uL21zZzU2NTE4Lmh0bWwNCj4gWzJdDQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC9DQUNHa01FdUplVTZjMXo4K19GcUd0b3ZiRitTcTh3X2VRVWNHOA0KPiBTSG1f
R1hWNXE3eU5BQG1haWwuZ21haWwuY29tLw0KPiANCj4gVGhhbmtzLA0KPiBZb25namkNCg==
