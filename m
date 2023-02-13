Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5002D694304
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjBMKlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBMKli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:41:38 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F364126C3
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 02:41:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dAarxkfZKs8RmEVPGmOliIIwdl+7Tzav7+ipZ53DCjAq9zf+KhThgU9LuN3vQL2avBQhkwtinJTPPJFCzrd9sDxSHvdhlLjaht7XdwEFt4j5B8t5BFeCCjjlQrRq1xT+LtyZ+n5d7taFgbkADxke7qQ0HLyvG4YnMXIyOnTjLFhY5M4qGaLaSBwsQI04fTLOxiMlZkxnFY456X1CLnMlF75jgFWNI0vsJOz7pfqDPmxCRD5IWY6b2h+F7aF25W91lY7arO+uSxW/gmD6k6pyme45NimBuBaptydj4EpWu0PpCYq6nE33QaWWdDCojtnhKlciy+M9QSbBhcAcZOFL2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHmfp3qUb325UHgbIrL53tcpJx1zZOCquP90cwbxyWY=;
 b=b56ILeAEvlkzDBQd/+iOeChRmAaLl4/GVt73+ZrdFzZM2sfLhVgT9gwQmaiIYpZM9mWXqUXVsMcH5fNPi/MiIXyW27NoGhIk8UjLAs8j5IwCO366AXy8ixI1Z94kKVYUT8xeMR8rD6aCpPi45TCCxNpmLiTGSNX9+cY2YoEFfX/jZCBlb5M7IFbtkHG/hI0QkJX4ZKeq9Bmr0foODOyXO+QliQTU3JaPG/Hl0eUi6knx0uMZu7wi0tiaZ3KYpHtQPX/TxfUqyrk2HFFNHs1799R0meNbmTGHrV12oYojzhGlh7KkA6fyNPIZcD1KNO+ZDyRWGULQldZyhNlu1m2ECw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHmfp3qUb325UHgbIrL53tcpJx1zZOCquP90cwbxyWY=;
 b=zJasCdwx6nsVtT03krHFw2xcAZYumGpLXeXkmh7wthDJeK8Mr42OqwDuNmBGwXgmzCTsKrQvEYKDCYacSU1yZaHuTPVz1lK/AAFkriMUcqtWBm9CMdsgxBhMlhU4TSW6hMXPX+Nyd3+BQU/S5xUog8kGixinpiIA5s0p/3qDfbQ=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by PH7PR12MB8179.namprd12.prod.outlook.com (2603:10b6:510:2b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 10:41:33 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::4152:ed89:1dfe:4792]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::4152:ed89:1dfe:4792%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 10:41:33 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Jani Nikula <jani.nikula@intel.com>, Lyude Paul <lyude@redhat.com>,
        "imre.deak@intel.com" <imre.deak@intel.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        =?utf-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: RE: [Cc: drm-misc folks] Re: [Intel-gfx] [CI 1/4] drm/i915/dp_mst:
 Add the MST topology state for modesetted CRTCs
Thread-Topic: [Cc: drm-misc folks] Re: [Intel-gfx] [CI 1/4] drm/i915/dp_mst:
 Add the MST topology state for modesetted CRTCs
Thread-Index: AQHZOvQTHCq2EmbAQUqcHECy8YUa767HLX4AgADW2ICABLRjUA==
Date:   Mon, 13 Feb 2023 10:41:32 +0000
Message-ID: <CO6PR12MB548949E961F9FE5627BA5064FCDD9@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20230206114856.2665066-1-imre.deak@intel.com>
 <Y+JLQfuSAS6xLPIS@ideak-desk.fi.intel.com>
 <0b5a4e81dc98f9c28d77f0f53741712d1c7c3c09.camel@redhat.com>
 <87bkm1x0dk.fsf@intel.com>
In-Reply-To: <87bkm1x0dk.fsf@intel.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-13T10:41:04Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=0a607094-cf15-444f-8eac-8c78b66d22ee;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|PH7PR12MB8179:EE_
x-ms-office365-filtering-correlation-id: bba3bf74-0d3b-4f8f-9872-08db0daedf9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LWVL/7jpwORSkHR+Bg0aBMw5YBwbGqfH6zq7WMBFjmhV2Q2AXfB5zd4FNo0oEsOKuKQbIQMP7HuKrqhV0HBLUPhvDXGQEc3Wdm3TNdDYpcfQ6TIjLKVog/tF9GKly2zCFEajwwzQeoIrAKbTAPijpefVVqw03fp1yD7tpYp+DajFFNS3zrCVckWzH5qa/FuZtjTmRfw3n+JLlgqpxYxmkkBDjXA9Z4t2aseqsAjFl6zooi3UDZsMkz0/ubekdTBE9nM62KiXNHi/b/ol4A52S2NG5+hehdVbbABP/bn9JKQ2sdHZclazRi5PoXcv7gooLznbJTGkWw5VFl0IcqQL4hQAegFDzcJ42od2WoX0CdSrqOUkKnXT4wLgYgkyHcNTOn+A7D0LN6tNn94lSJDzWrbPkmVRC1IQw1ldt4OYeqg95Q6Y8jQz4iAQNjCvBN1jkpTic+6+zb5SXS6794WilXTVIVViLzBImp8S97KZK3hQP66xpa2QTnYuB9+aco5f30/KhaPky5ydjnxnofzai0ZGwAEVYYr2nb3fMCCfPDfzcQwqPJw0QyLHKybj4i2EoYHptTNQTrDqwwy+cPgpInpu++LTEW4/JvuSrTzm5xcA7QfRSBnBzOF1JJ3Z7tGwMMZEGa/NSeO02TpfP9+CPaQwy9vplQzQmEj2ggFjaak=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199018)(4326008)(41300700001)(33656002)(66574015)(83380400001)(55016003)(122000001)(86362001)(38070700005)(38100700002)(110136005)(54906003)(316002)(7696005)(71200400001)(66446008)(66556008)(8676002)(66476007)(64756008)(9686003)(26005)(186003)(76116006)(66946007)(55236004)(6506007)(53546011)(966005)(478600001)(2906002)(7416002)(5660300002)(52536014)(8936002)(17423001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWZmQURaM0p1YVlGY3BOK25pU2ttM3ZZUmlPQm81VFM3T3pvalBrbXUxZk1p?=
 =?utf-8?B?L3VBdkxNaFQxQlo2eEM0VUl6WGtMazBWNDVWd0V0WmxrL0Y4RGpMQ2RyMWV1?=
 =?utf-8?B?VFVvS1pzSTJTSkxJSjI2dlMvQ3NFLytKalhMMG5QVDlnVDM1eU9ZS0RyUXYr?=
 =?utf-8?B?UUpoT3dQcCtkMllWbFJEWEY3RmwwdzRNZEdTNTJ4QVVpZys4b2dsU0Yxc1pZ?=
 =?utf-8?B?YXY5VCtmUkdlbFlzMlBKc2tVc2o3UVd2MkJLek5lcWlSeWVGZHBZZWpVeHNU?=
 =?utf-8?B?VnNEMkZyMHF3NmhPOEd2MGtmeEhmQVR1ZktsVk15M0JxaFZZMVlNZEVraDh2?=
 =?utf-8?B?SExQWXpxR1hLOUpVay9CWkw3U3VEeUVZUEg5WWVzWEoyb0p4RksvV3ljei9B?=
 =?utf-8?B?b3hHQTVwNTRWa3pvV3d3Y1Z5L0oyNno2a1I3ZkJBWnVZckhpN1E2dENUZnI4?=
 =?utf-8?B?Zk9ma013TXdGcElDYlNzbkZqNnlBbldFZTRrazIwajJicHp5Z0JBRVdHSDNP?=
 =?utf-8?B?VEZLKy8yTjhvN2NUZVR5R09aM01HVTNrdmczaWhNVDBJRXFnK1duNkx5aFZS?=
 =?utf-8?B?MnFCMGdLTitwdHozcytNZ3hpSEFFSXBNQ0V3VE1kVVlzQWwydFl1V1ArZVE2?=
 =?utf-8?B?R2RuUmVXcmtRaGh5WGMrZWdGMDlwc1RIcEdIQVpGRy8xS3czbVNMK25NUmZR?=
 =?utf-8?B?NnhjeWNtZ2craWdWYTFZU1ZrbkVkV2RQaW9UVFJLaHJ1eER0V2hZVGZ5TzIz?=
 =?utf-8?B?RjZ0NGFDU2ltUXdQQ3ZxNUkxVloxeFp3eER6MmdJVytJd2JsR3RuL0xzYnJR?=
 =?utf-8?B?Zm5ueTluRlpjRml0ZldkWnZBQXBoVUhFaWZ5azlzdVRYWm82NldaVDZ2UGx2?=
 =?utf-8?B?QVozSzkxZGs3d3c5Mi9maWJFb1lzQ2k4bUhKb2oxVkgyeGFLUEpKQi9GMGhm?=
 =?utf-8?B?bWRLUXgvc04yVFgyTHVCdmwvN3lKNTZWOWRvNjVLMHdHRmdSQ2Q2TzVQTGFv?=
 =?utf-8?B?bW1udHVXZXAwOE00YW5YYTlCUjB0cXlvY3ZvSTRLWVhrRlJOTGpOT2taRXIw?=
 =?utf-8?B?REJld2RlM05vaXZBYkcrWmRGNGI5QkxxOWJIQmg0ZUVQb1FNeS92Q1Nka2Vl?=
 =?utf-8?B?L1VraEZXMlJuUkJkVytYOWRSc0RSZzF4UUpYdFZwZkNRdmd5WE93Q2p0cVl1?=
 =?utf-8?B?QXF2YzFFSnBONXNYQURPOTQ4eGFtaTVtTlVYK09KaXkraWpmUll1SHg3d1N4?=
 =?utf-8?B?U2hyVHNLbVZaL2k5dDh2T0ZPU2VaUFFISitsM1JYckNTN3VPYkRIRUUxL2RK?=
 =?utf-8?B?b0UrN2ZWNTdEMnlCK3J4ajRsMEZuZXYyU2ZST2V0Z1ZxV1FoWlh6OGMzdUtC?=
 =?utf-8?B?M2xBM3dodDBqOUoyMzM2dkZnMEN6bUpjZXJkQXhZK3p0U2hJSDloemVPY01m?=
 =?utf-8?B?Qmk3cWYvTGZOUEVkQXZxOFo3VmJ3Y3k1M0Ftdnp4bWhiTnZ3dTBQb2ovY2Z2?=
 =?utf-8?B?ZHZJalE2SmUxR0NLR0NKN3RTRlpuMXJaelN2R3ZJa1FNSUd0ZWQ2L1ZLYkJi?=
 =?utf-8?B?RzkxSm9hTVY1NlRKbnI0ZTlFbU5JTlFyUTFkeXhXYUt3blNCMkNyZ3QzL1Nq?=
 =?utf-8?B?YnpOQ3JOdkFpRGw0L2o2aTRML0dSUVR0UjVqVzNVZkVCbG9vd3NzcEEvam9X?=
 =?utf-8?B?Kys2Yk1xL1I0ZDYyckFMRXhGa1lQSm13M1J1N0lTK0FoSmJJOCtGMTMzVW40?=
 =?utf-8?B?RVNwcTZhSzd4eDhhSllrWjZkdmFSSTZoYWpna1RkN0ZKMWx2RUgxWWwvWUxu?=
 =?utf-8?B?ZEc4ZmFyNkMvQnQvMTcyN0tXN0RFMy83d0hkRlBZVXdxU2VtZkpYWUp0d1hD?=
 =?utf-8?B?alBpS1EvTUJjdEFPZ0I1b2o1ZllldUwxTzJZdnhod3JCMkV0aFFqK0VxWEdG?=
 =?utf-8?B?dUZITXluS3dTVDM0dkQyQ1QyV3ZacnhWazBSNVB5bG42eDg0S3FyMlp0VWxi?=
 =?utf-8?B?Mjc2a3luTXFWUUFOc0NrcHUxbzRjZWlpRFI5eWN3dEgramtJcTJRVkUrbzV0?=
 =?utf-8?B?eTd3NXVpKzZIZko4TWJKckRrS085U3FvUDV1ZnFQS2VnSVMyYzJqZXRYTGR6?=
 =?utf-8?Q?DuV4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bba3bf74-0d3b-4f8f-9872-08db0daedf9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 10:41:32.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GtuU55lhvNX525oXGogSkVH1Qp1Iln/eJ4SoVjwhLPSCNabklVKHVPbvme31ESYF/u9QxRH8Ui1l7HxPoPDfsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8179
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KQWRkIE1hcmlvIGZvciBhd2FyZW5lc3MuDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFuaSBOaWt1bGEgPGphbmkubmlrdWxhQGludGVsLmNvbT4N
Cj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAxMCwgMjAyMyA2OjQ4IFBNDQo+IFRvOiBMeXVkZSBQ
YXVsIDxseXVkZUByZWRoYXQuY29tPjsgaW1yZS5kZWFrQGludGVsLmNvbTsgV2VudGxhbmQsDQo+
IEhhcnJ5IDxIYXJyeS5XZW50bGFuZEBhbWQuY29tPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxB
bGV4YW5kZXIuRGV1Y2hlckBhbWQuY29tPjsgRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRlckBm
ZndsbC5jaD4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc7IGludGVsLWdmeEBsaXN0cy5m
cmVlZGVza3RvcC5vcmc7IGRyaS0NCj4gZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnOyBWaWxs
ZSBTeXJqw6Rsw6QgPHZpbGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPjsgQmVuDQo+IFNrZWdn
cyA8YnNrZWdnc0ByZWRoYXQuY29tPjsgTGluLCBXYXluZSA8V2F5bmUuTGluQGFtZC5jb20+OyBL
YXJvbA0KPiBIZXJic3QgPGtoZXJic3RAcmVkaGF0LmNvbT47IFRob21hcyBaaW1tZXJtYW5uDQo+
IDx0emltbWVybWFubkBzdXNlLmRlPg0KPiBTdWJqZWN0OiBSZTogW0NjOiBkcm0tbWlzYyBmb2xr
c10gUmU6IFtJbnRlbC1nZnhdIFtDSSAxLzRdIGRybS9pOTE1L2RwX21zdDoNCj4gQWRkIHRoZSBN
U1QgdG9wb2xvZ3kgc3RhdGUgZm9yIG1vZGVzZXR0ZWQgQ1JUQ3MNCj4gDQo+IE9uIFRodSwgMDkg
RmViIDIwMjMsIEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhhdC5jb20+IHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyMy0wMi0wNyBhdCAxNDo1OSArMDIwMCwgSW1yZSBEZWFrIHdyb3RlOg0KPiA+PiBIaSBh
bGwsDQo+ID4+DQo+ID4+IE9uIE1vbiwgRmViIDA2LCAyMDIzIGF0IDAxOjQ4OjUzUE0gKzAyMDAs
IEltcmUgRGVhayB3cm90ZToNCj4gPj4gPiBBZGQgdGhlIE1TVCB0b3BvbG9neSBmb3IgYSBDUlRD
IHRvIHRoZSBhdG9taWMgc3RhdGUgaWYgdGhlIGRyaXZlcg0KPiA+PiA+IG5lZWRzIHRvIGZvcmNl
IGEgbW9kZXNldCBvbiB0aGUgQ1JUQyBhZnRlciB0aGUgZW5jb2RlciBjb21wdXRlDQo+ID4+ID4g
Y29uZmlnIGZ1bmN0aW9ucyBhcmUgY2FsbGVkLg0KPiA+PiA+DQo+ID4+ID4gTGF0ZXIgdGhlIE1T
VCBlbmNvZGVyJ3MgZGlzYWJsZSBob29rIGFsc28gYWRkcyB0aGUgc3RhdGUsIGJ1dCB0aGF0DQo+
ID4+ID4gaXNuJ3QgZ3VhcmFudGVlZCB0byB3b3JrIChzaW5jZSBpbiB0aGF0IGhvb2sgZ2V0dGlu
ZyB0aGUgc3RhdGUgbWF5DQo+ID4+ID4gZmFpbCwgd2hpY2ggY2FuJ3QgYmUgaGFuZGxlZCB0aGVy
ZSkuIFRoaXMgc2hvdWxkIGZpeCB0aGF0LCB3aGlsZSBhDQo+ID4+ID4gbGF0ZXIgcGF0Y2ggZml4
ZXMgdGhlIHVzZSBvZiB0aGUgTVNUIHN0YXRlIGluIHRoZSBkaXNhYmxlIGhvb2suDQo+ID4+ID4N
Cj4gPj4gPiB2MjogQWRkIG1pc3NpbmcgZm9yd2FyZCBzdHJ1Y3QgZGVjbGFydGlvbnMsIGNhdWdo
dCBieSBoZHJ0ZXN0Lg0KPiA+PiA+IHYzOiBGYWN0b3Igb3V0IGludGVsX2RwX21zdF9hZGRfdG9w
b2xvZ3lfc3RhdGVfZm9yX2Nvbm5lY3RvcigpIHVzZWQNCj4gPj4gPiAgICAgbGF0ZXIgaW4gdGhl
IHBhdGNoc2V0Lg0KPiA+PiA+DQo+ID4+ID4gQ2M6IEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhhdC5j
b20+DQo+ID4+ID4gQ2M6IFZpbGxlIFN5cmrDpGzDpCA8dmlsbGUuc3lyamFsYUBsaW51eC5pbnRl
bC5jb20+DQo+ID4+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyA2LjENCj4gPj4gPiBS
ZXZpZXdlZC1ieTogVmlsbGUgU3lyasOkbMOkIDx2aWxsZS5zeXJqYWxhQGxpbnV4LmludGVsLmNv
bT4gIyB2Mg0KPiA+PiA+IFJldmlld2VkLWJ5OiBMeXVkZSBQYXVsIDxseXVkZUByZWRoYXQuY29t
Pg0KPiA+PiA+IFNpZ25lZC1vZmYtYnk6IEltcmUgRGVhayA8aW1yZS5kZWFrQGludGVsLmNvbT4N
Cj4gPj4NCj4gPj4gSXMgaXQgb2sgdG8gbWVyZ2UgdGhlc2UgNCBwYXRjaGVzIChhbHNvIGF0IFsx
XSksIHZpYSB0aGUgaTkxNSB0cmVlPw0KPiA+Pg0KPiA+PiBJZiBzbyBjb3VsZCBpdCBiZSBhbHNv
IGFja2VkIGZyb20gdGhlIEFNRCBhbmQgTm91dmVhdSBzaWRlPw0KPiA+DQo+ID4gV2hpY2hldmVy
IGJyYW5jaCB3b3JrcyBiZXN0IGZvciB5J2FsbCBpcyBmaW5lIGJ5IG1lLCBpZiBpdCdzIHZpYQ0K
PiA+IGk5MTUncyB0cmVlIEkgZ3Vlc3Mgd2UgbWlnaHQgbmVlZCB0byBiYWNrLW1lcmdlIGRybS1t
aXNjIGF0IHNvbWUgcG9pbnQNCj4gPiBzbyBJIGNhbiB3cml0ZSB1cCBlcXVpdmFsZW50IGZpeGVz
IGZvciBub3V2ZWF1IGFzIHdlbGwuDQo+ID4NCj4gPiAoQWRkZWQgVGhvbWFzIFppbW1lcm1hbm4g
dG8gQ2MpDQo+IA0KPiBJIHN1Z2dlc3QgbWVyZ2luZyB0aGUgc2VyaWVzIHZpYSBkcm0tbWlzYy1u
ZXh0LWZpeGVzIGJyYW5jaCwgdG8gZ2V0IHRoZW0gdG8NCj4gTGludXMnIHRyZWUgaW4gdGhlIHVw
Y29taW5nIG1lcmdlIHdpbmRvdy4gVGhleSBhbGwgYXBwbHkgY2xlYW5seSB0aGVyZS4gVGhlDQo+
IGRyaXZlcnMgY2FuIGJhY2ttZXJnZSB0aGVtIGZyb20gZHJtLW5leHQgaW4gdGhlIG1lYW4gdGlt
ZSwgb3Igd2FpdCBmb3INCj4gdjYuMy1yYzEuDQo+IA0KPiBEYW5pZWwgYWNrZWQgdGhpcyAod2Vs
bCwgYW55IC1uZXh0LWZpeGVzIGJyYW5jaCkgb24gSVJDIHllc3RlcmRheSwgb2J2aW91c2x5DQo+
IGFjayBmcm9tIG1lIHRvby4NCj4gDQo+IEkgdGFrZSB0aGUgYWJvdmUgYXMgTHl1ZGUncyBhY2sg
Zm9yIG5vdXZlYXUuDQo+IA0KPiBIYXJyeSwgV2F5bmUsIGRvIHlvdSBhZ3JlZSB3aXRoIHRoaXMs
IGFjayBmb3IgbWVyZ2luZyB0aGUgQU1EIHBhcnQgdmlhIGRybS0NCj4gbWlzYy1uZXh0LWZpeGVz
PyAoQWxleCBzdWdnZXN0ZWQgdG8gZ2V0IHlvdXIgaW5wdXQuKQ0KPiANCg0KVGhhbmsgeW91IElt
cmUsIEx5dWRlIGFuZCBKYW5pLg0KVGhhdCBsb29rcyBnb29kIHRvIG1lIGFuZCBJIGFncmVlIHdp
dGggdGhhdC4NCg0KVGhhbmtzIQ0KDQpSZWdhcmRzLA0KV2F5bmUNCj4gDQo+IEJSLA0KPiBKYW5p
Lg0KPiANCj4gDQo+ID4NCj4gPj4NCj4gPj4gWzFdIGh0dHBzOi8vcGF0Y2h3b3JrLmZyZWVkZXNr
dG9wLm9yZy9zZXJpZXMvMTEzNzAzLw0KPiA+Pg0KPiA+PiA+IC0tLQ0KPiA+PiA+ICBkcml2ZXJz
L2dwdS9kcm0vaTkxNS9kaXNwbGF5L2ludGVsX2Rpc3BsYXkuYyB8ICA0ICsrDQo+ID4+ID4gZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9tc3QuYyAgfCA2MQ0KPiA+PiA+ICsr
KysrKysrKysrKysrKysrKysrDQo+IGRyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxf
ZHBfbXN0LmgNCj4gPj4gPiB8ICA0ICsrDQo+ID4+ID4gIDMgZmlsZXMgY2hhbmdlZCwgNjkgaW5z
ZXJ0aW9ucygrKQ0KPiA+PiA+DQo+ID4+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9p
OTE1L2Rpc3BsYXkvaW50ZWxfZGlzcGxheS5jDQo+ID4+ID4gYi9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9kaXNwbGF5L2ludGVsX2Rpc3BsYXkuYw0KPiA+PiA+IGluZGV4IDE2NjY2MmFkZTU5M2MuLjM4
MTA2Y2Y2M2IzYjkgMTAwNjQ0DQo+ID4+ID4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlz
cGxheS9pbnRlbF9kaXNwbGF5LmMNCj4gPj4gPiArKysgYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9k
aXNwbGF5L2ludGVsX2Rpc3BsYXkuYw0KPiA+PiA+IEBAIC01OTM2LDYgKzU5MzYsMTAgQEAgaW50
IGludGVsX21vZGVzZXRfYWxsX3BpcGVzKHN0cnVjdA0KPiBpbnRlbF9hdG9taWNfc3RhdGUgKnN0
YXRlLA0KPiA+PiA+ICAJCWlmIChyZXQpDQo+ID4+ID4gIAkJCXJldHVybiByZXQ7DQo+ID4+ID4N
Cj4gPj4gPiArCQlyZXQgPSBpbnRlbF9kcF9tc3RfYWRkX3RvcG9sb2d5X3N0YXRlX2Zvcl9jcnRj
KHN0YXRlLCBjcnRjKTsNCj4gPj4gPiArCQlpZiAocmV0KQ0KPiA+PiA+ICsJCQlyZXR1cm4gcmV0
Ow0KPiA+PiA+ICsNCj4gPj4gPiAgCQlyZXQgPSBpbnRlbF9hdG9taWNfYWRkX2FmZmVjdGVkX3Bs
YW5lcyhzdGF0ZSwgY3J0Yyk7DQo+ID4+ID4gIAkJaWYgKHJldCkNCj4gPj4gPiAgCQkJcmV0dXJu
IHJldDsNCj4gPj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9p
bnRlbF9kcF9tc3QuYw0KPiA+PiA+IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRl
bF9kcF9tc3QuYw0KPiA+PiA+IGluZGV4IDhiMGU0ZGVmYTNmMTAuLmYzY2IxMmRjZmUwYTcgMTAw
NjQ0DQo+ID4+ID4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9kcF9t
c3QuYw0KPiA+PiA+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBf
bXN0LmMNCj4gPj4gPiBAQCAtMTIyMywzICsxMjIzLDY0IEBAIGJvb2wgaW50ZWxfZHBfbXN0X2lz
X3NsYXZlX3RyYW5zKGNvbnN0DQo+IHN0cnVjdCBpbnRlbF9jcnRjX3N0YXRlICpjcnRjX3N0YXRl
KQ0KPiA+PiA+ICAJcmV0dXJuIGNydGNfc3RhdGUtPm1zdF9tYXN0ZXJfdHJhbnNjb2RlciAhPQ0K
PiBJTlZBTElEX1RSQU5TQ09ERVIgJiYNCj4gPj4gPiAgCSAgICAgICBjcnRjX3N0YXRlLT5tc3Rf
bWFzdGVyX3RyYW5zY29kZXIgIT0NCj4gPj4gPiBjcnRjX3N0YXRlLT5jcHVfdHJhbnNjb2Rlcjsg
IH0NCj4gPj4gPiArDQo+ID4+ID4gKy8qKg0KPiA+PiA+ICsgKiBpbnRlbF9kcF9tc3RfYWRkX3Rv
cG9sb2d5X3N0YXRlX2Zvcl9jb25uZWN0b3IgLSBhZGQgTVNUDQo+ID4+ID4gK3RvcG9sb2d5IHN0
YXRlIGZvciBhIGNvbm5lY3Rvcg0KPiA+PiA+ICsgKiBAc3RhdGU6IGF0b21pYyBzdGF0ZQ0KPiA+
PiA+ICsgKiBAY29ubmVjdG9yOiBjb25uZWN0b3IgdG8gYWRkIHRoZSBzdGF0ZSBmb3INCj4gPj4g
PiArICogQGNydGM6IHRoZSBDUlRDIEBjb25uZWN0b3IgaXMgYXR0YWNoZWQgdG8NCj4gPj4gPiAr
ICoNCj4gPj4gPiArICogQWRkIHRoZSBNU1QgdG9wb2xvZ3kgc3RhdGUgZm9yIEBjb25uZWN0b3Ig
dG8gQHN0YXRlLg0KPiA+PiA+ICsgKg0KPiA+PiA+ICsgKiBSZXR1cm5zIDAgb24gc3VjY2Vzcywg
bmVnYXRpdmUgZXJyb3IgY29kZSBvbiBmYWlsdXJlLg0KPiA+PiA+ICsgKi8NCj4gPj4gPiArc3Rh
dGljIGludA0KPiA+PiA+ICtpbnRlbF9kcF9tc3RfYWRkX3RvcG9sb2d5X3N0YXRlX2Zvcl9jb25u
ZWN0b3Ioc3RydWN0DQo+IGludGVsX2F0b21pY19zdGF0ZSAqc3RhdGUsDQo+ID4+ID4gKwkJCQkJ
ICAgICAgc3RydWN0IGludGVsX2Nvbm5lY3RvciAqY29ubmVjdG9yLA0KPiA+PiA+ICsJCQkJCSAg
ICAgIHN0cnVjdCBpbnRlbF9jcnRjICpjcnRjKSB7DQo+ID4+ID4gKwlzdHJ1Y3QgZHJtX2RwX21z
dF90b3BvbG9neV9zdGF0ZSAqbXN0X3N0YXRlOw0KPiA+PiA+ICsNCj4gPj4gPiArCWlmICghY29u
bmVjdG9yLT5tc3RfcG9ydCkNCj4gPj4gPiArCQlyZXR1cm4gMDsNCj4gPj4gPiArDQo+ID4+ID4g
Kwltc3Rfc3RhdGUgPSBkcm1fYXRvbWljX2dldF9tc3RfdG9wb2xvZ3lfc3RhdGUoJnN0YXRlLT5i
YXNlLA0KPiA+PiA+ICsJCQkJCQkgICAgICAmY29ubmVjdG9yLT5tc3RfcG9ydC0NCj4gPm1zdF9t
Z3IpOw0KPiA+PiA+ICsJaWYgKElTX0VSUihtc3Rfc3RhdGUpKQ0KPiA+PiA+ICsJCXJldHVybiBQ
VFJfRVJSKG1zdF9zdGF0ZSk7DQo+ID4+ID4gKw0KPiA+PiA+ICsJbXN0X3N0YXRlLT5wZW5kaW5n
X2NydGNfbWFzayB8PSBkcm1fY3J0Y19tYXNrKCZjcnRjLT5iYXNlKTsNCj4gPj4gPiArDQo+ID4+
ID4gKwlyZXR1cm4gMDsNCj4gPj4gPiArfQ0KPiA+PiA+ICsNCj4gPj4gPiArLyoqDQo+ID4+ID4g
KyAqIGludGVsX2RwX21zdF9hZGRfdG9wb2xvZ3lfc3RhdGVfZm9yX2NydGMgLSBhZGQgTVNUIHRv
cG9sb2d5DQo+ID4+ID4gK3N0YXRlIGZvciBhIENSVEMNCj4gPj4gPiArICogQHN0YXRlOiBhdG9t
aWMgc3RhdGUNCj4gPj4gPiArICogQGNydGM6IENSVEMgdG8gYWRkIHRoZSBzdGF0ZSBmb3INCj4g
Pj4gPiArICoNCj4gPj4gPiArICogQWRkIHRoZSBNU1QgdG9wb2xvZ3kgc3RhdGUgZm9yIEBjcnRj
IHRvIEBzdGF0ZS4NCj4gPj4gPiArICoNCj4gPj4gPiArICogUmV0dXJucyAwIG9uIHN1Y2Nlc3Ms
IG5lZ2F0aXZlIGVycm9yIGNvZGUgb24gZmFpbHVyZS4NCj4gPj4gPiArICovDQo+ID4+ID4gK2lu
dCBpbnRlbF9kcF9tc3RfYWRkX3RvcG9sb2d5X3N0YXRlX2Zvcl9jcnRjKHN0cnVjdA0KPiBpbnRl
bF9hdG9taWNfc3RhdGUgKnN0YXRlLA0KPiA+PiA+ICsJCQkJCSAgICAgc3RydWN0IGludGVsX2Ny
dGMgKmNydGMpIHsNCj4gPj4gPiArCXN0cnVjdCBkcm1fY29ubmVjdG9yICpfY29ubmVjdG9yOw0K
PiA+PiA+ICsJc3RydWN0IGRybV9jb25uZWN0b3Jfc3RhdGUgKmNvbm5fc3RhdGU7DQo+ID4+ID4g
KwlpbnQgaTsNCj4gPj4gPiArDQo+ID4+ID4gKwlmb3JfZWFjaF9uZXdfY29ubmVjdG9yX2luX3N0
YXRlKCZzdGF0ZS0+YmFzZSwgX2Nvbm5lY3RvciwNCj4gY29ubl9zdGF0ZSwgaSkgew0KPiA+PiA+
ICsJCXN0cnVjdCBpbnRlbF9jb25uZWN0b3IgKmNvbm5lY3RvciA9DQo+IHRvX2ludGVsX2Nvbm5l
Y3RvcihfY29ubmVjdG9yKTsNCj4gPj4gPiArCQlpbnQgcmV0Ow0KPiA+PiA+ICsNCj4gPj4gPiAr
CQlpZiAoY29ubl9zdGF0ZS0+Y3J0YyAhPSAmY3J0Yy0+YmFzZSkNCj4gPj4gPiArCQkJY29udGlu
dWU7DQo+ID4+ID4gKw0KPiA+PiA+ICsJCXJldCA9DQo+IGludGVsX2RwX21zdF9hZGRfdG9wb2xv
Z3lfc3RhdGVfZm9yX2Nvbm5lY3RvcihzdGF0ZSwgY29ubmVjdG9yLCBjcnRjKTsNCj4gPj4gPiAr
CQlpZiAocmV0KQ0KPiA+PiA+ICsJCQlyZXR1cm4gcmV0Ow0KPiA+PiA+ICsJfQ0KPiA+PiA+ICsN
Cj4gPj4gPiArCXJldHVybiAwOw0KPiA+PiA+ICt9DQo+ID4+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfbXN0LmgNCj4gPj4gPiBiL2RyaXZlcnMv
Z3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfbXN0LmgNCj4gPj4gPiBpbmRleCBmNzMwMWRl
NmNkZmIzLi5mMTgxNWJiNzIyNjcyIDEwMDY0NA0KPiA+PiA+IC0tLSBhL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2Rpc3BsYXkvaW50ZWxfZHBfbXN0LmgNCj4gPj4gPiArKysgYi9kcml2ZXJzL2dwdS9k
cm0vaTkxNS9kaXNwbGF5L2ludGVsX2RwX21zdC5oDQo+ID4+ID4gQEAgLTgsNiArOCw4IEBADQo+
ID4+ID4NCj4gPj4gPiAgI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+DQo+ID4+ID4NCj4gPj4gPiAr
c3RydWN0IGludGVsX2F0b21pY19zdGF0ZTsNCj4gPj4gPiArc3RydWN0IGludGVsX2NydGM7DQo+
ID4+ID4gIHN0cnVjdCBpbnRlbF9jcnRjX3N0YXRlOw0KPiA+PiA+ICBzdHJ1Y3QgaW50ZWxfZGln
aXRhbF9wb3J0Ow0KPiA+PiA+ICBzdHJ1Y3QgaW50ZWxfZHA7DQo+ID4+ID4gQEAgLTE4LDUgKzIw
LDcgQEAgaW50IGludGVsX2RwX21zdF9lbmNvZGVyX2FjdGl2ZV9saW5rcyhzdHJ1Y3QNCj4gPj4g
PiBpbnRlbF9kaWdpdGFsX3BvcnQgKmRpZ19wb3J0KTsgIGJvb2wNCj4gPj4gPiBpbnRlbF9kcF9t
c3RfaXNfbWFzdGVyX3RyYW5zKGNvbnN0IHN0cnVjdCBpbnRlbF9jcnRjX3N0YXRlDQo+ID4+ID4g
KmNydGNfc3RhdGUpOyAgYm9vbCBpbnRlbF9kcF9tc3RfaXNfc2xhdmVfdHJhbnMoY29uc3Qgc3Ry
dWN0DQo+ID4+ID4gaW50ZWxfY3J0Y19zdGF0ZSAqY3J0Y19zdGF0ZSk7ICBib29sDQo+ID4+ID4g
aW50ZWxfZHBfbXN0X3NvdXJjZV9zdXBwb3J0KHN0cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHApOw0K
PiA+PiA+ICtpbnQgaW50ZWxfZHBfbXN0X2FkZF90b3BvbG9neV9zdGF0ZV9mb3JfY3J0YyhzdHJ1
Y3QNCj4gaW50ZWxfYXRvbWljX3N0YXRlICpzdGF0ZSwNCj4gPj4gPiArCQkJCQkgICAgIHN0cnVj
dCBpbnRlbF9jcnRjICpjcnRjKTsNCj4gPj4gPg0KPiA+PiA+ICAjZW5kaWYgLyogX19JTlRFTF9E
UF9NU1RfSF9fICovDQo+ID4+ID4gLS0NCj4gPj4gPiAyLjM3LjENCj4gPj4gPg0KPiA+Pg0KPiAN
Cj4gLS0NCj4gSmFuaSBOaWt1bGEsIEludGVsIE9wZW4gU291cmNlIEdyYXBoaWNzIENlbnRlcg0K
