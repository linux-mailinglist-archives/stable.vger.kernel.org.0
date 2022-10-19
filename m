Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2829760371A
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 02:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJSA1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 20:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiJSA1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 20:27:51 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2046.outbound.protection.outlook.com [40.107.117.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39385D57CB;
        Tue, 18 Oct 2022 17:27:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYX66cAwZnNe0XFsXjGKZ7nQyY4TXdbQqllEH9eo85CXVr/tYi+iw0sNCS88UHvOxE5WrrlxEWpzHkJfsgjwV45yZEgFlzhbgDyxUHhpb/h5d2vEbkBpiTijv8SvXMeW3goVOPG41LjvWeXJK66B1DeNqBy0K9Q2pfJCHhWSjw2HsNV6htMEtBjzFHA+Y7RbIg1ZJ5W7Qby7kwDjomYJcScZ0946P10UpLs+ncJ2xZYYvIWLFhk3UXJyll08h79eMLzL50W4NAABaYMFP4bhmbpeE8wNXi502UihXTMgpogheHCDUacCipehTkMO40egOHf0am6BumTz9oYyVpOocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVNr/pAdKK/YXjNIBsANU5RSloujZCSXVoKCinPNobM=;
 b=SJoxx8ZKUxGUpw6ymzgfqbmcNF5aTNw1AW+9BdSSHMsSkTpy0zcIfKD1Bh3fk0yf49blQ+IZVUtLq1PUK2MGV+wSIULzQ1cIz2dr6orVmim99QD8z/OIQhhZVDHq3HQPTcJnEZO2W+ysve/GLImgNNzu5M4pf6CM4gbtn8kVRmmVeMRp/am3QplN5z9EnfVSsZgGNaSUuVzu4EF7ppeF9PB9kINTsf6hPOWEX5LjuubgprQmVJDhdytx7SwdOPIEQDjIEQm9GsRaiUNO+hYClS7oEU0dQ7xwbqeRBAh9bC8ZR2hBAowlfrnkiVHJnst+vPieAbpMQCtSSNTlASSBmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVNr/pAdKK/YXjNIBsANU5RSloujZCSXVoKCinPNobM=;
 b=QfkhJG36feogyQ7VQWKMMkRQnfqpvY0NqFfDuDKS90PtEJOz0Zq+qO8OT1Gcmljh7v7ym3vwJw1Z54/Qx0Rsv5wYPClZYgnD78whjvzKBqA6erqVg8U8NvG7VTvSMQxiyU5b5Uekyn2dpyJzMWGWsM4Q5Sz+hu9h7L7C+sJsmSEYtpJtjF1e20D3qUFzsDeMI+K73F3p4QbpB8gGxNvKHdz2uTMl/xAUbnuj6JktH1eyjwmdTV6mYg9ijKaePdrtkOlqJ9kw/pYub1ni3quITuqs3yVuFqbTZXY5klL0GmsxnINHzqCn9DXR9dEI1U77L2ku3yDN8TZwvZTLwKLpeQ==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 00:27:47 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::aa83:33dc:435c:cb5d%6]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 00:27:47 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 4.9 8/8] virtio_pci: don't try to use intxif pin
 is zero
Thread-Topic: [PATCH AUTOSEL 4.9 8/8] virtio_pci: don't try to use intxif pin
 is zero
Thread-Index: AQHY4oZM5o9tSp9Hu0yEUvWfyWvrF64U2yWw
Date:   Wed, 19 Oct 2022 00:27:46 +0000
Message-ID: <TY2PR06MB3424671C418DAEF5E1B7E57C852B9@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20221018001202.2732458-1-sashal@kernel.org>
 <20221018001202.2732458-8-sashal@kernel.org>
In-Reply-To: <20221018001202.2732458-8-sashal@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|SI2PR06MB5140:EE_
x-ms-office365-filtering-correlation-id: 4f77ef3c-0761-478b-636c-08dab168bf21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eImV6Vw0tzoUSoUBxVfkOsKQbEDALyKrmHeMTb0Dh+CpWflwDdvDuz+ns4aDTM0k6Xxt8UM8DwkfgZuQ3FV5H8TwtFICFOQg9H20tuAOs5C86DduPUwxvS16qxLIg0kCUueofGR0YXe8auZbcFmfriiqYa+nnn5XdBDLVbtsMZP/TzhVFqvi3lRbgSsYNlXvb9nwtsu4kJDtD8nV3Zmm63gbvMvJubsx+h6wHJCkzW/C+e0f12cvVrzyPCwn/zwj+z8Zx+2UOvfvtFkJlN6ndxxeJsuE6rq2BwMPV6hO1GHnhhJVwBQE1dvxpnPj6+oqul4LKKnRym188xN7njzufrSSnL+2BPa9GRtKa5vi3cHhLLORN+Ww8Qd0ndv3cXTjE5GjpVZRE2d10LHyzdNwsLPkexM8G21Ccrt/9wTqbuDYc/PpqhwnGDenDy81ohCI0HlophFJ1r/h5H9fI2CnG7au1Kc0OXH3at9fbjEJ65bfaG1KmWKinKOuG7t8JP/SLhsvj2HChE+rBeruAtSAGqW3qsmSoPdOa+ASgA1oGVnerRa+gmEuRIp5yNlcB0fl4Hy68bhxl5JgE5kbUnFYMw93Kvt+fDAsy7C9jBCCVj76q6K5GGn2e7loFUkOmmgFLLRllBaCvrlzVXvryEjMCcJoQQACxM6zzSTxxqyeP42mERfT0W/gelyR0Fp1ytbYrQHkOnrdjFnNgmBdyOBqxu08arBfJR2LJkGOvv1kqBl5oSUeeN7Ib14AXKgqYA+njcRhPebKFbpHRNz0bVoC3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(346002)(39840400004)(366004)(451199015)(53546011)(7696005)(6506007)(478600001)(9686003)(44832011)(26005)(33656002)(71200400001)(2906002)(83380400001)(186003)(55016003)(86362001)(8936002)(6916009)(316002)(8676002)(54906003)(52536014)(122000001)(66446008)(5660300002)(38100700002)(76116006)(66946007)(66476007)(4326008)(66556008)(64756008)(41300700001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXBudGVLSWkvcnhvK2ZNRzhqUFhUS0ZyQUhJZmhpa3QvRC9Bb1N6NmwyNEhp?=
 =?utf-8?B?QUpZUEpIZ1oyRVlsRHJDWVhzMzkrb0xGeWczbnI0NVo3aTRBZHhMYnhhcWIw?=
 =?utf-8?B?RW44OXA3cWxWRHJSUzJDNCtwSjF2d3FDM015YVBQVVY1Q3ZOSEtRZ1E0TG1Z?=
 =?utf-8?B?ODNlTTdZZ2JjZzlHTms1NGIzVHZoRFpHdDR5UVpjWm56S2ZtbXRWdTBkNEg3?=
 =?utf-8?B?NHBQVEw4bU1sVUdzZEowbWhHajg0Qm1GR2dYOHA3M1FFK2VuT2piZVA5bmNx?=
 =?utf-8?B?ZGUwQVpIYWxNSHd5MlBGclhNUWZ4T3h6NC9aaGpTVnlMemtveHhnQ3pUbmx3?=
 =?utf-8?B?eDNEQzJOeUV2OVpxRzY2YWxxVE1vVVFZaFRaUjJraE4xaHpHWFl3emp2aWRS?=
 =?utf-8?B?Z29rNnIybThQQXVKZ2czdGxTaFNudFNvNktsZUJHWFZUb1VIT2t3a3dvRmdJ?=
 =?utf-8?B?UUN4VGI1NFo1T0Q0anFzcHNRanNoSE5MTXZTREN6aDRmMDV1NWI3L0sxNWZM?=
 =?utf-8?B?ZkdZWjFJMXJ0OWpTVzBWNmRkbTE4cUp6UENrRzhjRWd5WWgzdTF2OEx1cjY5?=
 =?utf-8?B?UDBFQTBqNlV5NkMvNnRYMExWcy94dGxHYXdkVVJIQWJUdWZtNS9nMXNxNk41?=
 =?utf-8?B?ZVpaT3N3MEtmYXpTaUpaeTBrdFBRbml6YnY2UzRYVXhBaUxDaGpZa1lacGtJ?=
 =?utf-8?B?clg0dnR4djd0VjRMNEhYa1BFcVl2dVZ0UStmbDR0eGhzY0xIc2ZFcU5mZk1F?=
 =?utf-8?B?WDY2cUxzczl6eW92S2E2SU8xb3dCalRKcUFHcE1DOTE1Z01VMmRiaTkrbmVr?=
 =?utf-8?B?UXVRYjdvbXEvMjc4emFIQzQyZ2YvUXlzSVdENEtGNVZnaUFNSjQ3T3BLcGJN?=
 =?utf-8?B?QndyalAxSzZkUkJ1dkZydVY5OU5oNitaVmE4MGhvS1JhRGY0ZFpiYVg4MTRx?=
 =?utf-8?B?RWpWOVVpMUh3YlBxVWN1Zm11MlZBbnVrSFJXY01pZ1Q3cXhMV1k0RytDeWhY?=
 =?utf-8?B?NHB4RW0xNXpnMjFrSmVUcGhaOEhJTmhGdFFRR2w3ZU5GdFRpdWQvelEwM29V?=
 =?utf-8?B?aHFjMjRCdkkvOE96L0dsS29nZEp6Y04yU2o5KzkyMkN0akFhUkYvNlVIS1B4?=
 =?utf-8?B?RVZ3NDduMEhGNTFHRk8wL2czY2RqMmdScEdFdmhGVFRLUWN2TUVlSWtwaFRn?=
 =?utf-8?B?UVRQdWxvUHpNY3RYejMxZWViWGYxNDZST0g3MklZSHNxQTV1TnpMbmExV0tO?=
 =?utf-8?B?R2pJYk9VZndVTWtTaGxFQ0l4Tm9TSVVJdVRyYmRzWFl6SDdEbzhzR2FWbUVL?=
 =?utf-8?B?dGRqVlVlU3VxL2hOZHBlVi9tbWYwY0dMSlBMRVExVVc0MHFiaHFYNzlONzdD?=
 =?utf-8?B?T21FWWpqbnhQSGdSOVREQnY3MUFQUFVlSlQ5dzVGcHZyaTM0NDNVSVIzMHpB?=
 =?utf-8?B?RnN2ZWZxa2J1Zk94SUk2UUJNR0xTUVptSVJwakRoTDJOK3l1d1UwbDB5NVBu?=
 =?utf-8?B?UDRJT2h2eEFVbzlNTnRsWmZScC8yeUtwSUV5MmJiTzVxY1hlQnNjZUU3Z3po?=
 =?utf-8?B?TWJrLy9QUWRpMWpHMlU1UUdjUmhyZG1lYW1mL1F2MW9ta1NoeHFZdFJhWGZk?=
 =?utf-8?B?S1lEa21ocVBmSGhEcVRjbHZ6UHNKNldkSkwvNXNxM0d4eEF0QTNtdlN1T3Vr?=
 =?utf-8?B?RDB6enkzS2R4Q2VjNEcwazFibDRzbVlIYUVDUlJiUTk2eml5b3F6Sm80b0k5?=
 =?utf-8?B?bnRxajZuRjh1TUVqMEJkOU9GcVhlandiOFFWTG9wWnVvak5MVHVHTEs0Qjlj?=
 =?utf-8?B?c2psNVlqUEZmRk16R1dtQmNKK1BFcnpEcDJjSGR5aXpNVnNSYzJyeWZrZytW?=
 =?utf-8?B?d2Q5eGNSbUlUU1Fld2s4WlloTDdmQ3Q5YzcxTDBwd0IxZkJDUzNSVWNRMVhK?=
 =?utf-8?B?N3k3d0l0cmtob3Bpd3RmdVpkWkt3aU1Zekd4cHRHSTFkVmtrZXBtUGFLRklJ?=
 =?utf-8?B?cU9vb3B6NlgwN3pwNjFieTh1bDduRC8ydXllalpvREgweFNiRnpUejBGai9H?=
 =?utf-8?B?QTJWaUwyMDBHNTc0eWJyMjV6QXRLa3VldDRoaE0xa0txayttUkhXbERKM3lD?=
 =?utf-8?B?YUhpdjRQdXMrdGdvR0IwUE9ibElIb2M2R1hLQllnbkQ0QlVsS3JDb0lFQXVa?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f77ef3c-0761-478b-636c-08dab168bf21
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 00:27:46.7073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zgaCRmhVacKZBJG1XfZJch3HnnnYaUiR9jWgyFSV5NqGkHhVvZTBAitGFkgH0C4faSKQgZRO/uxk642xB3qIe02YV2hHbGQ87QtmVsNXpq8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgc2FzaGENCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYXNoYSBM
ZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgMTgsIDIw
MjIgODoxMiBBTQ0KPiBUbzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZn
ZXIua2VybmVsLm9yZw0KPiBDYzogQW5ndXMgQ2hlbiA8YW5ndXMuY2hlbkBqYWd1YXJtaWNyby5j
b20+OyBNaWNoYWVsIFMgLiBUc2lya2luDQo+IDxtc3RAcmVkaGF0LmNvbT47IFNhc2hhIExldmlu
IDxzYXNoYWxAa2VybmVsLm9yZz47IGphc293YW5nQHJlZGhhdC5jb207DQo+IHZpcnR1YWxpemF0
aW9uQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnDQo+IFN1YmplY3Q6IFtQQVRDSCBBVVRPU0VM
IDQuOSA4LzhdIHZpcnRpb19wY2k6IGRvbid0IHRyeSB0byB1c2UgaW50eGlmIHBpbiBpcyB6ZXJv
DQo+IA0KPiBGcm9tOiBBbmd1cyBDaGVuIDxhbmd1cy5jaGVuQGphZ3Vhcm1pY3JvLmNvbT4NCj4g
DQo+IFsgVXBzdHJlYW0gY29tbWl0IDcxNDkxYzU0ZWFmYTMxOGZkZDI0YTFmMjZhMWM4MmIyOGUx
YWMyMWQgXQ0KPiANCj4gVGhlIGJhY2tncm91bmQgaXMgdGhhdCB3ZSB1c2UgZHB1IGluIGNsb3Vk
IGNvbXB1dGluZyx0aGUgYXJjaCBpcyB4ODYsODANCj4gY29yZXMuIFdlIHdpbGwgaGF2ZSBhIGxv
dHMgb2YgdmlydGlvIGRldmljZXMsbGlrZSA1MTIgb3IgbW9yZS4NCj4gV2hlbiB3ZSBwcm9iZSBh
Ym91dCAyMDAgdmlydGlvX2JsayBkZXZpY2VzLGl0IHdpbGwgZmFpbCBhbmQNCj4gdGhlIHN0YWNr
IGlzIHByaW50ZWQgYXMgZm9sbG93czoNCj4gDQo+IFsyNTMzOC40ODUxMjhdIHZpcnRpby1wY2kg
MDAwMDpiMzowMC4wOiB2aXJ0aW9fcGNpOiBsZWF2aW5nIGZvciBsZWdhY3kgZHJpdmVyDQo+IFsy
NTMzOC40OTYxNzRdIGdlbmlycTogRmxhZ3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwICh2aXJ0
aW80MTgpIHZzLiAwMDAxNWEwMA0KPiAodGltZXIpDQo+IFsyNTMzOC41MDM4MjJdIENQVTogMjAg
UElEOiA1NDMxIENvbW06IGt3b3JrZXIvMjA6MCBLZHVtcDogbG9hZGVkIFRhaW50ZWQ6DQo+IEcg
ICAgICAgICAgIE9FICAgIC0tLS0tLS0tLSAtICAtIDQuMTguMC0zMDUuMzAuMS5lbDgueDg2XzY0
DQo+IFsyNTMzOC41MTY0MDNdIEhhcmR3YXJlIG5hbWU6IEluc3B1ciBORjUyODBNNS9ZWk1CLTAw
ODgyLTEwRSwgQklPUw0KPiA0LjEuMjEgMDgvMjUvMjAyMQ0KPiBbMjUzMzguNTIzODgxXSBXb3Jr
cXVldWU6IGV2ZW50cyB3b3JrX2Zvcl9jcHVfZm4NCj4gWzI1MzM4LjUyODIzNV0gQ2FsbCBUcmFj
ZToNCj4gWzI1MzM4LjUzMDY4N10gIGR1bXBfc3RhY2srMHg1Yy8weDgwDQo+IFsyNTMzOC41MzQw
MDBdICBfX3NldHVwX2lycS5jb2xkLjUzKzB4N2MvMHhkMw0KPiBbMjUzMzguNTM4MDk4XSAgcmVx
dWVzdF90aHJlYWRlZF9pcnErMHhmNS8weDE2MA0KPiBbMjUzMzguNTQyMzcxXSAgdnBfZmluZF92
cXMrMHhjNy8weDE5MA0KPiBbMjUzMzguNTQ1ODY2XSAgaW5pdF92cSsweDE3Yy8weDJlMCBbdmly
dGlvX2Jsa10NCj4gWzI1MzM4LjU1MDIyM10gID8gbmNwdXNfY21wX2Z1bmMrMHgxMC8weDEwDQo+
IFsyNTMzOC41NTQwNjFdICB2aXJ0YmxrX3Byb2JlKzB4ZTYvMHg4YTAgW3ZpcnRpb19ibGtdDQo+
IFsyNTMzOC41NTg4NDZdICB2aXJ0aW9fZGV2X3Byb2JlKzB4MTU4LzB4MWYwDQo+IFsyNTMzOC41
NjI4NjFdICByZWFsbHlfcHJvYmUrMHgyNTUvMHg0YTANCj4gWzI1MzM4LjU2NjUyNF0gID8gX19k
cml2ZXJfYXR0YWNoX2FzeW5jX2hlbHBlcisweDkwLzB4OTANCj4gWzI1MzM4LjU3MTU2N10gIGRy
aXZlcl9wcm9iZV9kZXZpY2UrMHg0OS8weGMwDQo+IFsyNTMzOC41NzU2NjBdICBidXNfZm9yX2Vh
Y2hfZHJ2KzB4NzkvMHhjMA0KPiBbMjUzMzguNTc5NDk5XSAgX19kZXZpY2VfYXR0YWNoKzB4ZGMv
MHgxNjANCj4gWzI1MzM4LjU4MzMzN10gIGJ1c19wcm9iZV9kZXZpY2UrMHg5ZC8weGIwDQo+IFsy
NTMzOC41ODcxNjddICBkZXZpY2VfYWRkKzB4NDE4LzB4NzgwDQo+IFsyNTMzOC41OTA2NTRdICBy
ZWdpc3Rlcl92aXJ0aW9fZGV2aWNlKzB4OWUvMHhlMA0KPiBbMjUzMzguNTk1MDExXSAgdmlydGlv
X3BjaV9wcm9iZSsweGIzLzB4MTQwDQo+IFsyNTMzOC41OTg5NDFdICBsb2NhbF9wY2lfcHJvYmUr
MHg0MS8weDkwDQo+IFsyNTMzOC42MDI2ODldICB3b3JrX2Zvcl9jcHVfZm4rMHgxNi8weDIwDQo+
IFsyNTMzOC42MDY0NDNdICBwcm9jZXNzX29uZV93b3JrKzB4MWE3LzB4MzYwDQo+IFsyNTMzOC42
MTA0NTZdICA/IGNyZWF0ZV93b3JrZXIrMHgxYTAvMHgxYTANCj4gWzI1MzM4LjYxNDM4MV0gIHdv
cmtlcl90aHJlYWQrMHgxY2YvMHgzOTANCj4gWzI1MzM4LjYxODEzMl0gID8gY3JlYXRlX3dvcmtl
cisweDFhMC8weDFhMA0KPiBbMjUzMzguNjIyMDUxXSAga3RocmVhZCsweDExNi8weDEzMA0KPiBb
MjUzMzguNjI1MjgzXSAgPyBrdGhyZWFkX2ZsdXNoX3dvcmtfZm4rMHgxMC8weDEwDQo+IFsyNTMz
OC42Mjk3MzFdICByZXRfZnJvbV9mb3JrKzB4MWYvMHg0MA0KPiBbMjUzMzguNjMzMzk1XSB2aXJ0
aW9fYmxrOiBwcm9iZSBvZiB2aXJ0aW80MTggZmFpbGVkIHdpdGggZXJyb3IgLTE2DQo+IA0KPiBU
aGUgbG9nIDoNCj4gImdlbmlycTogRmxhZ3MgbWlzbWF0Y2ggaXJxIDAuIDAwMDAwMDgwICh2aXJ0
aW80MTgpIHZzLiAwMDAxNWEwMCAodGltZXIpIg0KPiB3YXMgcHJpbnRlZCBiZWNhdXNlIG9mIHRo
ZSBpcnEgMCBpcyB1c2VkIGJ5IHRpbWVyIGV4Y2x1c2l2ZSxhbmQgd2hlbg0KPiB2cF9maW5kX3Zx
cyBjYWxsIHZwX2ZpbmRfdnFzX21zaXggYW5kIHJldHVybnMgZmFsc2UgdHdpY2UgKGZvcg0KPiB3
aGF0ZXZlciByZWFzb24pLCB0aGVuIGl0IHdpbGwgY2FsbCB2cF9maW5kX3Zxc19pbnR4IGFzIGEg
ZmFsbGJhY2suDQo+IEJlY2F1c2UgdnBfZGV2LT5wY2lfZGV2LT5pcnEgaXMgemVybywgd2UgcmVx
dWVzdCBpcnEgMCB3aXRoDQo+IGZsYWcgSVJRRl9TSEFSRUQsIGFuZCBnZXQgYSBiYWNrdHJhY2Ug
bGlrZSBhYm92ZS4NCj4gDQo+IEFjY29yZGluZyB0byBQQ0kgc3BlYyBhYm91dCAiSW50ZXJydXB0
IFBpbiIgUmVnaXN0ZXIgKE9mZnNldCAzRGgpOg0KPiAiVGhlIEludGVycnVwdCBQaW4gcmVnaXN0
ZXIgaXMgYSByZWFkLW9ubHkgcmVnaXN0ZXIgdGhhdCBpZGVudGlmaWVzIHRoZQ0KPiAgbGVnYWN5
IGludGVycnVwdCBNZXNzYWdlKHMpIHRoZSBGdW5jdGlvbiB1c2VzLiBWYWxpZCB2YWx1ZXMgYXJl
IDAxaCwgMDJoLA0KPiAgMDNoLCBhbmQgMDRoIHRoYXQgbWFwIHRvIGxlZ2FjeSBpbnRlcnJ1cHQg
TWVzc2FnZXMgZm9yIElOVEEsDQo+ICBJTlRCLCBJTlRDLCBhbmQgSU5URCByZXNwZWN0aXZlbHku
IEEgdmFsdWUgb2YgMDBoIGluZGljYXRlcyB0aGF0IHRoZQ0KPiAgRnVuY3Rpb24gdXNlcyBubyBs
ZWdhY3kgaW50ZXJydXB0IE1lc3NhZ2UocykuIg0KPiANCj4gU28gaWYgdnBfZGV2LT5wY2lfZGV2
LT5waW4gaXMgemVybywgd2Ugc2hvdWxkIG5vdCByZXF1ZXN0IGxlZ2FjeQ0KPiBpbnRlcnJ1cHQu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmd1cyBDaGVuIDxhbmd1cy5jaGVuQGphZ3Vhcm1pY3Jv
LmNvbT4NCj4gU3VnZ2VzdGVkLWJ5OiBNaWNoYWVsIFMuIFRzaXJraW4gPG1zdEByZWRoYXQuY29t
Pg0KPiBNZXNzYWdlLUlkOiA8MjAyMjA5MzAwMDA5MTUuNTQ4LTEtYW5ndXMuY2hlbkBqYWd1YXJt
aWNyby5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhh
dC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4N
Cj4gLS0tDQo+ICBkcml2ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1vbi5jIHwgMyArKysNCj4g
IDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1vbi5jDQo+IGIvZHJpdmVycy92aXJ0aW8vdmlydGlv
X3BjaV9jb21tb24uYw0KPiBpbmRleCAzN2UzYmE1ZGFkZjYuLmQ2MzRlYjkyNmEyZiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy92aXJ0aW8vdmlydGlvX3BjaV9jb21tb24uYw0KPiArKysgYi9kcml2
ZXJzL3ZpcnRpby92aXJ0aW9fcGNpX2NvbW1vbi5jDQo+IEBAIC0zODksNiArMzg5LDkgQEAgaW50
IHZwX2ZpbmRfdnFzKHN0cnVjdCB2aXJ0aW9fZGV2aWNlICp2ZGV2LCB1bnNpZ25lZA0KPiBudnFz
LA0KPiAgCQkJCSB0cnVlLCBmYWxzZSk7DQo+ICAJaWYgKCFlcnIpDQo+ICAJCXJldHVybiAwOw0K
PiArCS8qIElzIHRoZXJlIGFuIGludGVycnVwdCBwaW4/IElmIG5vdCBnaXZlIHVwLiAqLw0KPiAr
CWlmICghKHRvX3ZwX2RldmljZSh2ZGV2KS0+cGNpX2Rldi0+cGluKSkNCj4gKwkJcmV0dXJuIGVy
cjsNCj4gIAkvKiBGaW5hbGx5IGZhbGwgYmFjayB0byByZWd1bGFyIGludGVycnVwdHMuICovDQo+
ICAJcmV0dXJuIHZwX3RyeV90b19maW5kX3Zxcyh2ZGV2LCBudnFzLCB2cXMsIGNhbGxiYWNrcywg
bmFtZXMsDQo+ICAJCQkJICBmYWxzZSwgZmFsc2UpOw0KPiAtLQ0KPiAyLjM1LjENCg0KdGhlIHBh
dGNoIDcxNDkxYzU0ZWFmYTMxIGhhcyBiZWVuIGZpeGVkIGJ5IDIxNDVhYjUxM2UzYjMsDQpJdCBp
cyByZXBvcnQgYnkgTWljaGFlbCBFbGxlcm1hbiA8bXBlQGVsbGVybWFuLmlkLmF1PiBhbmQgc3Vn
Z2VzdGVkIGJ5IGxpbnVzLg0KSWYgaXQgaXMgbWVyZ2VkIGluIHRoZSBzdGFibGUgZ2l0IHJlcG8s
IEkgd29ycnkgYWJvdXQgcG93ZXJwYyBhcmNoLg0KVGhhbnMuDQoNCg==
