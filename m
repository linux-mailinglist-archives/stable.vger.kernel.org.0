Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6D394DD8FE
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 12:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiCRLcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 07:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbiCRLce (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 07:32:34 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2056.outbound.protection.outlook.com [40.107.113.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA31ED055;
        Fri, 18 Mar 2022 04:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnk/Ksf8rt+Vz/HjqVFjyJQf0Ww8OO1EuzwmK3JlJxsd3is4qo4am2VnlXsvkGWhjWGJKIP2ZTcrKG/TrvUZEjnnZSWnsaE0X6YxxS73jQkTU6d29Y+izSbsipw0IgHqyebNSG4XSPkVeymjmZnlyu/K0rA0yZuJ/UHV/zC0k1U/binsfFoOeNo8Y+6k4lGz3es42F+F3CWXxSSfmFNoIpDcZp2yGZHJ9Gtohwd88QexcaRfMiXVD+BUdl5s19d7EyF0mJ/0QVJNdYYnLS2rZ6AOgOnt69pU6iDrzKB+U1dk8VmsNOHieRaxllus/+bQTWqK9z0zaiQk3bShxVt+wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkZCdX0Kq5WL09CY6E75wFrmdtoaJM8vuwOhKLHNTDg=;
 b=d3zfjOPLpke5MqwB7SSP5gfar3boPc1+KONvzoaDlxiIMzqtZXtl4VOBLX88DBTYjnlqObt0WXqbCxqID/lKUo2FM5Vcb2o/krqJtxRnbGxZQ9PX5RYUBPazn/KKvSP4I7uNtKoBHjwzLqDu/SmcTc/iFaR9DcsuNj2oY49KmAQRUKH9sWc2O9JLULR83UG9Gy6cr9dD6FwXqMOivnnDZICZFnijhgyjSArAus9QdxmdP1qNyqHZDW60PbYblU35ULFNu1BvTWBybVwy8ILT4higDDzxOAOgLZYXBoVbrKNZ5wJgfyrFirxhLYewOuKYj1d/fHpIooP6o0WPi3juJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkZCdX0Kq5WL09CY6E75wFrmdtoaJM8vuwOhKLHNTDg=;
 b=jgksEFYDDZw84J1hLdXbLb4JqODblD6xnQIKfmg8h/tfMlt5iK1hCZ4jlEKsFaqvObJ8umZNDIK43kAcN3R+LpKYFkYRvZkJvrQOGcHEqW344+Byw/4noJi2i4zYVrCrlPt+ZLnoNBoEnjKLmqYJwtiTG7KVhmc4BZHl6uDeKJk=
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com (2603:1096:400:13c::10)
 by OSAPR01MB1554.jpnprd01.prod.outlook.com (2603:1096:603:30::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.16; Fri, 18 Mar
 2022 11:31:11 +0000
Received: from TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::cdeb:f61:5132:905d]) by TYWPR01MB8591.jpnprd01.prod.outlook.com
 ([fe80::cdeb:f61:5132:905d%9]) with mapi id 15.20.5061.028; Fri, 18 Mar 2022
 11:31:11 +0000
From:   =?utf-8?B?SE9SSUdVQ0hJIE5BT1lBKOWggOWPo+OAgOebtOS5nyk=?= 
        <naoya.horiguchi@nec.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>
CC:     Miaohe Lin <linmiaohe@huawei.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] hugetlb: do not demote poisoned hugetlb pages
Thread-Topic: [PATCH] hugetlb: do not demote poisoned hugetlb pages
Thread-Index: AQHYMm5s74Zl9s9wbUiyXdr8BI2jrKy1gDYAgA0mN4CAAmwLAA==
Date:   Fri, 18 Mar 2022 11:31:11 +0000
Message-ID: <20220318113110.GA70612@hori.linux.bs1.fc.nec.co.jp>
References: <20220307215707.50916-1-mike.kravetz@oracle.com>
 <6ba788b3-901e-d740-2575-bc652461187b@huawei.com>
 <8b40c33f-1bdf-2cda-5948-cf433302514e@oracle.com>
In-Reply-To: <8b40c33f-1bdf-2cda-5948-cf433302514e@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nec.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bbe9cb4-1a84-45f9-2fc8-08da08d2cdef
x-ms-traffictypediagnostic: OSAPR01MB1554:EE_
x-microsoft-antispam-prvs: <OSAPR01MB1554D646C2757E21FF807202E7139@OSAPR01MB1554.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: txQK4D+dQSQDQCrBeA2UybMucNWr2X/ZaWXJdlIskRKSKNnzvD0KtgTQoSFhveTcsUWTRPnDAOjsN+5E5lGXa4rYOwYlvSnCQAkzvCRmIX+Q8CIyqizbHaC80Uc481YWdR55VUAaBqJS5BrfZn0H5WqDk4o2UAOBWNGSyDALLmp5TUKJa1EXgD3pDUwRSGA51bsEOZF8fMrFaI9zGunH07LtxP1aXCLnlmRcVki7wQM8mQF2+KEDHb90TQiks7mc0umD7Q61DxcFfK0En2TKcdhCjxrGc1wp3HP5OKCbkMgbskV+63H3CmumFSC7P1QSPETDRv1dmWBIO1t7fNIHdgUgq48DWB+afJHL7OvaCV6HLhaU8d2HER4KZNzDJ9TFaERUVXOcX3eT7MURU2HLj0SlVafW3dtfGVkzfsuTjr8dkmmN/ZDZ47WB2yy7quDrzwUYUjTYFryy1rdVx+LZYtrSikr/kvs73XdhVF8awOPgzsS7w1D5YDgmxLtrC7zvtENvRRO2x1wHSRD5ZJE2Iz1g2yPwmrDcun5GjfgsBz/yr9M3yYz4XMPSX7DjZ7cXvptA/RDPhbIieGAT1IrZ3Mc/nqZBlPICHISpqNHNBi0koxsyvRYbRnbprJ+EM2ncftMhDWKioNmESUPA723TdWcbItKFcZT56gezWhMqGx/Gl2P7mMZ0sSKs+mi+cac0ppcxQhcWaTcqGfdDStL/KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYWPR01MB8591.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(26005)(186003)(508600001)(1076003)(6512007)(38070700005)(9686003)(55236004)(33656002)(53546011)(6506007)(122000001)(38100700002)(82960400001)(2906002)(83380400001)(86362001)(66476007)(54906003)(316002)(66946007)(71200400001)(8676002)(66556008)(76116006)(6916009)(64756008)(66446008)(85182001)(6486002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3hxbnhGaGxXOWYzSngxWm9FMTNQVk5wRUNqb1c0QU1sZDNFazFOOTJmVzgv?=
 =?utf-8?B?dFJjRkoraEhRVEIvQ1d1bEZyNUpPelJlSm1iN1ZUb2NxYWM2OGNCVEp2VElz?=
 =?utf-8?B?VmZPT2RVdzFzMzhabGhyNnhWWHp2Y09wWlcyQ1A1djc1dEpwaHYvdDhtb1VU?=
 =?utf-8?B?Qnd2cXBIanJaYkRWbm53MHhWbVNNdjk0WlAzRWRjMktmaU1hSUdhZHp4eVZP?=
 =?utf-8?B?eGNXZmdXYVhyZ0JjWVBIZytZU1YvbHZqSW9MaEp3dTJ0VlE2NzBGUk5TeVBh?=
 =?utf-8?B?SVhHbnJlWm5mSWEwRFlZS3FPQ1BiWmczZmFUZmM4KzhFbWUxN3RwMEdZSWNK?=
 =?utf-8?B?K1ZhQ2JWWWFsUFpYb2ZqTStpV3ErQURqVTFKamh1dGRaY1BWU1RXdi85SWVt?=
 =?utf-8?B?QnZwWFd2c3NvaW9iaDFqcEh2cmdOZWJtZHF1YU4vZ0tDTEhYZUk0NE1MbkFP?=
 =?utf-8?B?bzBFVnhPTVhReStld3NsdWFWY1Q5MVZwMWZyUjZ2aWIvdFd2LzhlaStvSUhv?=
 =?utf-8?B?bEJlNlU0VDM2cEFwRkhHb05DaWFUMVE3QlZXOTZxa0hrZ0wrbHlFR0FEMzZm?=
 =?utf-8?B?UUFuangyanR2eUVvcC9uZ3V5R3M1bTF0YWtocTNXTFNqaG16T1BGN2pYRmpG?=
 =?utf-8?B?VCt4Z3BxWmh5c3RwZ0c0R1ZDNWFWaUp3dHFwaGh0NXV6MGtNbFBxVTArWWRk?=
 =?utf-8?B?bEQ1RnQwSkpBREVUWEN4NnFPWDFBNVk0d29zMTBQUDVtNVNpazkyZGtETnRN?=
 =?utf-8?B?V1FaT0RLYThJNHdQYkxzTk0yckR1bmNjWFg1aUc4UVRFWHhpNllHT2VpaHJh?=
 =?utf-8?B?cFhHd3ZER3JBWFNjdGtya0Vjd0orcEFlREZpaEdZUm1wclQzbDlXNjBwRXZM?=
 =?utf-8?B?ZlA0MlgrVHBIOXZJUDRvaU1mVnN2WkxOU21xMFBMM2V0OHE5UEJqTzVlYVQ0?=
 =?utf-8?B?enJscTdGbnN3NVhQelhIVjhLdE01U2hHUHV4dnpVei9KSGg1OXRrUW5PRXRx?=
 =?utf-8?B?Vk5oMEdMcVlaQk5iemFjbDl3ZXFVSmFENU9WcUYvT0RWdFdDS0NCZjVBV1cv?=
 =?utf-8?B?NjA2cWZ1ektiL28wNVJneVdJYmlIY1J0UDNTR09rc0xsNEdUVmFpVlpPd1Zr?=
 =?utf-8?B?ZXlDYVphUC96cGhSM1VMMHdKMUdrKzQwdnRLYktDc2tlUW5vS3ZveGtoL2Fz?=
 =?utf-8?B?K2F5Vm1GYmNnd3hqanBFNEpYUVhmNEZaRkhrZnhFcWV5VDVEWEtsaWpDaTFE?=
 =?utf-8?B?Ujh5UzRpc3lRSEhweUpKUDE5NmVTblp1ekN3TlFGL09BaDJXUkRyZ0pHS1Jv?=
 =?utf-8?B?SmtZSSs0aFlNaGVkdXJBbmc3VXg4Y3hwOUpjUTVHOWcvYVkrRTljOFVrZXhE?=
 =?utf-8?B?dGVPNHNhS3Z3aDFnNUM5NEJTelVUQkt4c2FNQUprWEU5QjllWi9wcWlZaHo4?=
 =?utf-8?B?S2hUUmZuS2xJL0lyUXN0eC9iTW53L3V6NHR5RmVScTdDK25rU0oxMUxSOHM1?=
 =?utf-8?B?NGJoMGsvdXRxMEQyRFJiZ3pSRWNmU3BITzB6SW9tdFpsQUlNSGdieXBYK1RE?=
 =?utf-8?B?cFZXTjdnTnpTbGRhTHpNUGcwa0xnenNsOHFqZmRqYWcvM2JlUTZzbk5kVVVG?=
 =?utf-8?B?MVdUWDR0NjVBNjYzYWhkYXNrZm5BRjZKdmIvYUxSUEV0c2htbXhDMEVWUWR2?=
 =?utf-8?B?bjRtOVJiM3VaRGU5TWVLbFM2bll1ZlR4R0MvdEdndjVGdGNmVHppQm1WSTBw?=
 =?utf-8?B?RHFpbk9mMVZkZldGL09YZkJadFFYeTlMbm1RN2trQktUZWpTWGVOekxLSjlP?=
 =?utf-8?B?b25iWUFlRnNDOXErTzZIbXR0b2RJUlBmcGZ0cEVFMUd0U3VweVQ3N3VvWjVk?=
 =?utf-8?B?ZzZpTlRFWkR1M2hrU0kvbzQxQ3RqQkxqWndhZ1cwTmRJYmxlWHpzNlpYYlMr?=
 =?utf-8?B?MGdqNWhFdS9kTEF1ZzZPeEZ5emFGaGg1YTcvajM5WlE0RnZrTVhYR1JZYytl?=
 =?utf-8?B?QVhTdkxXZ0lRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA2B44AD77D4484D87E250C7AECD3C9F@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYWPR01MB8591.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbe9cb4-1a84-45f9-2fc8-08da08d2cdef
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 11:31:11.6880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ptQ7MVbUYzHumvusCtyDsHl4lZUgVrkjI00+7AYzPeFb6JSLxEK51ztWzUCfzPQqjpLICH0O71JUC8IMpI+Ukw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1554
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBNYXIgMTYsIDIwMjIgYXQgMDM6MzE6NTdQTSAtMDcwMCwgTWlrZSBLcmF2ZXR6IHdy
b3RlOg0KPiBPbiAzLzgvMjIgMDU6NDMsIE1pYW9oZSBMaW4gd3JvdGU6DQo+ID4gT24gMjAyMi8z
LzggNTo1NywgTWlrZSBLcmF2ZXR6IHdyb3RlOg0KPiA+PiBJdCBpcyBwb3NzaWJsZSBmb3IgcG9p
c29uZWQgaHVnZXRsYiBwYWdlcyB0byByZXNpZGUgb24gdGhlIGZyZWUgbGlzdHMuDQo+ID4+IFRo
ZSBodWdlIHBhZ2UgYWxsb2NhdGlvbiByb3V0aW5lcyB3aGljaCBkZXF1ZXVlIGVudHJpZXMgZnJv
bSB0aGUgZnJlZQ0KPiA+PiBsaXN0cyBtYWtlIGEgcG9pbnQgb2YgYXZvaWRpbmcgcG9pc29uZWQg
cGFnZXMuICBUaGVyZSBpcyBubyBzdWNoIGNoZWNrDQo+ID4+IGFuZCBhdm9pZGFuY2UgaW4gdGhl
IGRlbW90ZSBjb2RlIHBhdGguDQo+ID4+DQo+ID4+IElmIGEgaHVnZXRsYiBwYWdlIG9uIHRoZSBp
cyBvbiBhIGZyZWUgbGlzdCwgcG9pc29uIHdpbGwgb25seSBiZSBzZXQgaW4NCj4gPj4gdGhlIGhl
YWQgcGFnZSByYXRoZXIgdGhlbiB0aGUgcGFnZSB3aXRoIHRoZSBhY3R1YWwgZXJyb3IuICBJZiBz
dWNoIGENCj4gPj4gcGFnZSBpcyBkZW1vdGVkLCB0aGVuIHRoZSBwb2lzb24gZmxhZyBtYXkgZm9s
bG93IHRoZSB3cm9uZyBwYWdlLiAgQSBwYWdlDQo+ID4+IHdpdGhvdXQgZXJyb3IgY291bGQgaGF2
ZSBwb2lzb24gc2V0LCBhbmQgYSBwYWdlIHdpdGggcG9pc29uIGNvdWxkIG5vdA0KPiA+PiBoYXZl
IHRoZSBmbGFnIHNldC4NCj4gPj4NCj4gPj4gQ2hlY2sgZm9yIHBvaXNvbiBiZWZvcmUgYXR0ZW1w
dGluZyB0byBkZW1vdGUgYSBodWdldGxiIHBhZ2UuICBBbHNvLA0KPiA+PiByZXR1cm4gLUVCVVNZ
IHRvIHRoZSBjYWxsZXIgaWYgb25seSBwb2lzb25lZCBwYWdlcyBhcmUgb24gdGhlIGZyZWUgbGlz
dC4NCj4gPj4NCj4gPj4gRml4ZXM6IDg1MzFmYzZmNTJmNSAoImh1Z2V0bGI6IGFkZCBodWdldGxi
IGRlbW90ZSBwYWdlIHN1cHBvcnQiKQ0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBNaWtlIEtyYXZldHog
PG1pa2Uua3JhdmV0ekBvcmFjbGUuY29tPg0KPiA+PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5v
cmc+DQo+ID4+IC0tLQ0KPiA+PiAgbW0vaHVnZXRsYi5jIHwgMTcgKysrKysrKysrKy0tLS0tLS0N
Cj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0K
PiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvbW0vaHVnZXRsYi5jIGIvbW0vaHVnZXRsYi5jDQo+ID4+
IGluZGV4IGIzNGY1MDE1NmY3ZS4uZjhjYTdjY2EzYzFhIDEwMDY0NA0KPiA+PiAtLS0gYS9tbS9o
dWdldGxiLmMNCj4gPj4gKysrIGIvbW0vaHVnZXRsYi5jDQo+ID4+IEBAIC0zNDc1LDcgKzM0NzUs
NiBAQCBzdGF0aWMgaW50IGRlbW90ZV9wb29sX2h1Z2VfcGFnZShzdHJ1Y3QgaHN0YXRlICpoLCBu
b2RlbWFza190ICpub2Rlc19hbGxvd2VkKQ0KPiA+PiAgew0KPiA+PiAgCWludCBucl9ub2Rlcywg
bm9kZTsNCj4gPj4gIAlzdHJ1Y3QgcGFnZSAqcGFnZTsNCj4gPj4gLQlpbnQgcmMgPSAwOw0KPiA+
PiAgDQo+ID4+ICAJbG9ja2RlcF9hc3NlcnRfaGVsZCgmaHVnZXRsYl9sb2NrKTsNCj4gPj4gIA0K
PiA+PiBAQCAtMzQ4NiwxNSArMzQ4NSwxOSBAQCBzdGF0aWMgaW50IGRlbW90ZV9wb29sX2h1Z2Vf
cGFnZShzdHJ1Y3QgaHN0YXRlICpoLCBub2RlbWFza190ICpub2Rlc19hbGxvd2VkKQ0KPiA+PiAg
CX0NCj4gPj4gIA0KPiA+PiAgCWZvcl9lYWNoX25vZGVfbWFza190b19mcmVlKGgsIG5yX25vZGVz
LCBub2RlLCBub2Rlc19hbGxvd2VkKSB7DQo+ID4+IC0JCWlmICghbGlzdF9lbXB0eSgmaC0+aHVn
ZXBhZ2VfZnJlZWxpc3RzW25vZGVdKSkgew0KPiA+PiAtCQkJcGFnZSA9IGxpc3RfZW50cnkoaC0+
aHVnZXBhZ2VfZnJlZWxpc3RzW25vZGVdLm5leHQsDQo+ID4+IC0JCQkJCXN0cnVjdCBwYWdlLCBs
cnUpOw0KPiA+PiAtCQkJcmMgPSBkZW1vdGVfZnJlZV9odWdlX3BhZ2UoaCwgcGFnZSk7DQo+ID4+
IC0JCQlicmVhazsNCj4gPj4gKwkJbGlzdF9mb3JfZWFjaF9lbnRyeShwYWdlLCAmaC0+aHVnZXBh
Z2VfZnJlZWxpc3RzW25vZGVdLCBscnUpIHsNCj4gPj4gKwkJCWlmIChQYWdlSFdQb2lzb24ocGFn
ZSkpDQo+ID4+ICsJCQkJY29udGludWU7DQo+ID4+ICsNCj4gPj4gKwkJCXJldHVybiBkZW1vdGVf
ZnJlZV9odWdlX3BhZ2UoaCwgcGFnZSk7DQo+ID4gDQo+ID4gSXQgc2VlbXMgdGhpcyBwYXRjaCBp
cyBub3QgaWRlYWwuIE1lbW9yeSBmYWlsdXJlIGNhbiBoaXQgdGhlIGh1Z2V0bGIgcGFnZSBhbnl0
aW1lIHdpdGhvdXQNCj4gPiBob2xkaW5nIHRoZSBodWdldGxiX2xvY2suIFNvIHRoZSBwYWdlIG1p
Z2h0IGJlY29tZSBIV1BvaXNvbiBqdXN0IGFmdGVyIHRoZSBjaGVjay4gQnV0IHRoaXMNCj4gPiBw
YXRjaCBzaG91bGQgaGF2ZSBoYW5kbGVkIHRoZSBjb21tb24gY2FzZS4gTWFueSB0aGFua3MgZm9y
IHlvdXIgd29yay4gOikNCj4gPiANCj4gDQo+IENvcnJlY3QsIHRoaXMgcGF0Y2ggaGFuZGxlcyB0
aGUgY29tbW9uIGNhc2Ugb2Ygbm90IGRlbW90aW5nIGEgaHVnZXRsYg0KPiBwYWdlIGlmIEhXUG9p
c29uIGlzIHNldC4gIFRoaXMgaXMgc2ltaWxhciB0byBjb2RlIGluIHRoZSBkZXF1ZXVlIHBhdGgN
Cj4gdXNlZCB3aGVuIGFsbG9jYXRpbmcgYSBodWdlIHBhZ2UgZm9yIGFsbG9jYXRpb24gdXNlLg0K
PiANCj4gQXMgeW91IHBvaW50IG91dCwgd29yayBzdGlsbCBuZWVkcyB0byBiZSBkb25lIHRvIGJl
dHRlciBjb29yZGluYXRlDQo+IG1lbW9yeSBmYWlsdXJlIHdpdGggZGVtb3RlIGFzIHdlbGwgYXMg
aHVnZSBwYWdlIGZyZWVpbmcuICBBcyB5b3Uga25vdw0KPiBOYW95YSBpcyB3b3JraW5nIG9uIHRo
aXMgbm93LiAgSXQgaXMgdW5jbGVhciBpZiB0aGF0IHdvcmsgd2lsbCBiZSBsaW1pdGVkDQo+IHRv
IG1lbW9yeSBlcnJvciBoYW5kbGluZyBjb2RlLCBvciBpZiBncmVhdGVyIGNvb3JkaW5hdGlvbiB3
aXRoIGh1Z2V0bGINCj4gY29kZSB3aWxsIGJlIHJlcXVpcmVkLg0KDQpJIHN1Ym1pdHRlZCB2NSBw
YXRjaCB0b2RheSBhbmQgaXQgY2hhbmdlcyBtZW1vcnktZmFpbHVyZS5jIG1vc3RseS4NClRoZSBj
aGFuZ2VzIG9uIGh1Z2V0bGIuYyBpcyBvbmx5IGFib3V0IGdldF9od3BvaXNvbl9odWdlX3BhZ2Uo
KSwNCndoZXJlIGNoZWNraW5nIGNvbXBvdW5kX2hlYWQoKSBpcyBkb25lIGluIGh1Z2V0bGJfbG9j
aywgc28gaXQgbmV2ZXINCnRvdWNoZXMgY29yZSBsb2dpYyBvbiBodWdldGxiIGFsbG9jYXRpb24v
ZnJlZS9kZW1vdGlvbi4NClNvIHRoZSBzdWdnZXN0ZWQgY2hhbmdlIHNob3VsZCBjb29wZXJhdGUg
d2VsbCBlbm91Z2ggd2l0aCBteSBwYXRjaC4NCg0KPiANCj4gVW5sZXNzIHlvdSBoYXZlIG9iamVj
dGlvbnMsIEkgYmVsaWV2ZSB0aGlzIHBhdGNoIHNob3VsZCBtb3ZlIGZvcndhcmQgYW5kDQo+IGJl
IGJhY2twb3J0ZWQgdG8gc3RhYmxlIHRyZWVzLiAgSWYgd2UgZGV0ZXJtaW5lIHRoYXQgbW9yZSBj
b29yZGluYXRpb24NCj4gYmV0d2VlbiBtZW1vcnkgZXJyb3IgYW5kIGh1Z2V0bGIgY29kZSBpcyBu
ZWVkZWQsIHRoYXQgY2FuIGJlIGFkZGVkIGxhdGVyLiANCg0KU2VuZGluZyB0byBzdGFibGUgbG9v
a3MgZmluZSB0byBtZS4NCg0KVGhhbmsgeW91IGZvciB0aGUgcGF0Y2ggYW5kIGhlbHBpbmduIG9u
IG15IHRocmVhZC4NCg0KUmV2aWV3ZWQtYnk6IE5hb3lhIEhvcmlndWNoaSA8bmFveWEuaG9yaWd1
Y2hpQG5lYy5jb20+
