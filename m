Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6908E62B261
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 05:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiKPEfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 23:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiKPEfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 23:35:52 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2087.outbound.protection.outlook.com [40.107.95.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0602E690;
        Tue, 15 Nov 2022 20:35:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IohUXn9R0uMmMCLSHF9tv6mzAO06jU/+5FbsQCwtEi9w5U2W0J1mXegB5/wQXkiF3i8ILQFnU5m9IK1EbXTeOiHRB63G4oBPiKP/CN7gIvIdNm/EeIUlWOnTe8BpBz/5OyfRLJasb6n/iP2Iu9puf/idPj9/5pb97gy7pQcugLA3SZ2cP10b5/3vzDZUqO6dydVNNOHv56noP5iYmYJjB80P3WvvI83axv5UV7JcVdlQXMs97rJVi7es6SbsjH/0UZsZQdoKBKZ71KVBX51xmvzBIJQFq7uNxE5rgP0iDxx576kC3mzNrlHORnJb6jH7zqHvPI2U0UUkhWVPIPZboA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlQsQLT6x+Ob43VRpiQSx5bdIl4n/wMmVC8DBOjONQI=;
 b=K6/OgfUqyZp9p5WxQ34/ie3U9//rXwS1H3KirfBraRRpjzHcotb6J32MceYGx8yQTZ+OHam/IgLBfZFMUD+yQCCORtY/hjQR8lrE70cOmwAXWzJ0Ew0CD7u/ANbxLUSwmM2+V7Ztdea0SgKAWGE4lsStMwg+AQjoMAq3JsjFnWZfBt8ErxXdOjwnL8sHInJ1BkxGUcaP6WWembMHZIc1PySSEHJtvt86V1KDsXH4EbzAjdB54sNx+0zjcmh2YegIVQXrTgKzZ03jlIu7zBHn7S7y3OU7QRy81lQ6g/u139eCMpfNokml5yfQ99RLCircG/+oNLySiI740/wbPjEgGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VlQsQLT6x+Ob43VRpiQSx5bdIl4n/wMmVC8DBOjONQI=;
 b=UOOJs67ejoNRWfRLZQ7ReO4uOdIZcYmn6sZfrdyDnfGJSXar0RO17VVMIIF3HDx772eQ3l9CSee6EElmP0zWVq3QuXFSrss9tX+5AGmSECa6HA2GN7qIGKEl3fL/eB3xhAghFevMbIOptgoTn2LxZGQwQy3ENJv131AVS5jRNkk=
Received: from CO6PR12MB5489.namprd12.prod.outlook.com (2603:10b6:303:139::18)
 by IA1PR12MB6113.namprd12.prod.outlook.com (2603:10b6:208:3eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 04:35:48 +0000
Received: from CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d]) by CO6PR12MB5489.namprd12.prod.outlook.com
 ([fe80::2509:5f0c:f0f4:882d%3]) with mapi id 15.20.5813.018; Wed, 16 Nov 2022
 04:35:48 +0000
From:   "Lin, Wayne" <Wayne.Lin@amd.com>
To:     Lyude Paul <lyude@redhat.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
CC:     "Wentland, Harry" <Harry.Wentland@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Li, Sun peng (Leo)" <Sunpeng.Li@amd.com>,
        "Siqueira, Rodrigo" <Rodrigo.Siqueira@amd.com>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        "Pillai, Aurabindo" <Aurabindo.Pillai@amd.com>,
        "Li, Roman" <Roman.Li@amd.com>, "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Wu, Hersen" <hersenxs.wu@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        "Mahfooz, Hamza" <Hamza.Mahfooz@amd.com>,
        "Hung, Alex" <Alex.Hung@amd.com>,
        "Francis, David" <David.Francis@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        "Liu, Wenjing" <Wenjing.Liu@amd.com>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Topic: [PATCH 1/2] drm/amdgpu/mst: Stop ignoring error codes and
 deadlocking
Thread-Index: AQHY8KmDMbF79LTxvE27gfK2SyT5Bq42XHDQgAips4CAAgGkwA==
Date:   Wed, 16 Nov 2022 04:35:48 +0000
Message-ID: <CO6PR12MB548985C79946AE359536DCE6FC079@CO6PR12MB5489.namprd12.prod.outlook.com>
References: <20221104235926.302883-1-lyude@redhat.com>
         <20221104235926.302883-2-lyude@redhat.com>
         <CO6PR12MB5489E3850FE3C9FBDA7BAC29FC3E9@CO6PR12MB5489.namprd12.prod.outlook.com>
 <4482e7de979cc6673162b7aac0fcbfddb5d2d906.camel@redhat.com>
In-Reply-To: <4482e7de979cc6673162b7aac0fcbfddb5d2d906.camel@redhat.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-11-16T04:35:24Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f8793975-3d28-493f-a8f6-a912854631e6;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR12MB5489:EE_|IA1PR12MB6113:EE_
x-ms-office365-filtering-correlation-id: ef453703-e263-4a8d-f128-08dac78c08e3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dah8hDEesJJv9R7prWFHQdNmX+cGsHarK9Q2dhV4kotYcrHCyEBiY6PnVKN+b+5jWZcoW8LcNRMqZ6a1bQdgRZRRdmsMOOtj6TZclq/QZW5Ovf2NMj2D/hQw+1R+aXXgh2ezVgEzxINDHMRaZ3K1daRkrjdWNxkU2tNWOEKa/s6U2RmXSa5m6QDRsq6DerzFfTTWPAdO+Lgb5e0SR/OaEyH7ko6atPCU8bBlslS5wfQu8xW2FTzMn0oR6iNIoCprn/W7tnxKe9g9sX/HmKNPBP57hdO/6Wjgve+x3NobkX9vWHK0iBufKebH0xpnnOmAMEhvz4ZeNFVF/N31E1yAhaforEouYiOwAt5DIVUO1N8XFVbw2MqErq6PONjeIJhtsFQ2PdgiBmrWitFjSBytQ3yb5Vec7rRCWijawD9KHFMNSC1CoRmRS5MQ82NsQFu6e+MtNNBzkEO/butApI10DikjeVUMCUbfKOg/qpV35v7An5XBBz7D3IyyT3Ms5RqpYMVBows6KxD0OccvXyyFErNrGdRPeVGot4Xc9Cyq/tPjhWw5RHIWBQRVR0/4vYsTsbuOkN4T/ksM/PKAXb8uxEvRveystMofQFH47l8+fNgwaYjcDpVV5xxiqcYLAbIls7HvMSQvWKKzo+yPLMNWAr5rPGXT3T5iJncEfsYSnOyhuKu35t6OxJqhwSUUGCcASnqNFjdMV10lwNvKUUqe83iCg4zWEWpAC62lY+CYNR1JNtYH6aSkKmo4V3j97wTQOFaOHsHZMg9UQKSAnVbTzO7Uz6n5t71XZVnrJyUsNYQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5489.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(451199015)(110136005)(54906003)(26005)(83380400001)(38100700002)(41300700001)(55016003)(71200400001)(38070700005)(2906002)(122000001)(478600001)(86362001)(7696005)(8936002)(33656002)(52536014)(316002)(53546011)(4326008)(66476007)(76116006)(64756008)(66556008)(9686003)(66946007)(66446008)(5660300002)(6506007)(186003)(8676002)(11716005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFZvQ0lHMktQTlJ4N1k0QUo1dnAyQ29DUkNQRUdxc2k4bXFhK05XU1doRTk4?=
 =?utf-8?B?TDlmWGhPSXBRZFNGVmxDM01QNUVtd0doSmo4K1VYcVIyME92V2o1ZVJlaml5?=
 =?utf-8?B?eE1rNS96UDlmTGZMTHhoVzJXbkdGNVpxei9NaWxOVVYwd1pNdXlFeXhHWGFy?=
 =?utf-8?B?UllpVFhPOW9rbnExN2VWNWhkWThZekFSdjZncDBqYnVBajFxQ1hMZTl3MCtN?=
 =?utf-8?B?TXZ4YkYyK0xUWUZwaGpYT2pSQWpGc2JLWTVST04xNnYyMjdFQlJSQjNWU1E2?=
 =?utf-8?B?UFlkYlcxSnlyUE1lYStwS0hGSDJUNkl4OXBNRUNsWUV1RHRQNlpyNVlQS3ZB?=
 =?utf-8?B?RWZpd3ptc1lnOGpjSy9obXhIMVRWUDRoWDFGMkFCYUZXNC82anB0NWJ1TmFF?=
 =?utf-8?B?Y2hsb3lGb2EzQ0JtYzdMRGlpNXJPQ1N4WTJlRU9BR0RjMGViQXZoTFltZ3J0?=
 =?utf-8?B?NUZRZGRBc2s1NmFiSStqZDJreFBEZlYxL2d0TlBnSzlMd0xZQnd0SjV0MDhV?=
 =?utf-8?B?K0NocE1xeWs0cUtxWHFXbFRnT0F4RnY1U1pmYmxpREpadWhHeXQxbHdJcGV4?=
 =?utf-8?B?WFM1Sk9oNit0cGJ4d1Erd0d5Y2U2MWcrdi9vcHRYY0I3enZhMVVsTXVBSkNt?=
 =?utf-8?B?Uk9wZCtacXR2TGNjT3pvQkNJWUhnOGlNMFQyNnRpTC9mdlB6ckxGY08yT0k4?=
 =?utf-8?B?OHRPTHRHSEY5bWowWGFRdjEzZDBMQjhHWVdFZVFwekN1b25OVGFlbXpMVzlt?=
 =?utf-8?B?KzhhM2Uvb1cwQk1mbzRwdm9iRkpJMVJoZlZJOFRKWkFMK2J1T2FaNGlDaUQr?=
 =?utf-8?B?LzI1dHFXZHRZOFVBZ2tHYk1kTVBTZVY4eWtvTjRwMld3N0pNWGREUTdjcnZ3?=
 =?utf-8?B?N213bUZsK2ZmbHFWV0ZLN3FBRm1hdmJ6YjZhcFRqVkYrTUltcnV2bjBxbW8w?=
 =?utf-8?B?YW0vNVZPbE1qazdzb0ZNQ1pkMnBWSXdqcXFpT2s2K3RjTFk0elR4eWNtaTB0?=
 =?utf-8?B?emZZaVVST05PdUE0NjU3SnI5SVFxcmIzM05TWGt3bFEydFNMZktHejlDdWdV?=
 =?utf-8?B?ejBneWUwd3BGbjZJSENOVkRXWVZCamVzelVvK1gvTFVyS2l4dmdxb1RDZmVI?=
 =?utf-8?B?RVRJekJQQ0Zsc1RubENnUXpxdi9tVnNLRnZjU1JSYnJ4Z2tVVVgrME5EaUxa?=
 =?utf-8?B?QjJEOWZhMndSaCtLOWFtVk9hN2FJK3hJM08xYnE5OWZSMXlyZm1rZmVtQmMy?=
 =?utf-8?B?SXVUbnhhVHFuWmQ0OFhiTExwcFpQcUhLRTlvYmxZcmlCN2phNHJJT2toQnZy?=
 =?utf-8?B?aC9kdEhQT0xwOE1DTnlpMG5rcHlieXRzZFN4MmJWTFA4R1BFdmtVdHZPUDA0?=
 =?utf-8?B?SHJvd2o2SjBRNkM1UzhjN0luYnArL3duZGdIdDZORUU3QndwT0plcm55R21T?=
 =?utf-8?B?UWwvajNoeDFIQUFydGRaejRlM0Q3VlN4cWtETDBKQzFZcnNXUGsxZVZ0K3VG?=
 =?utf-8?B?TnFxOC9yTW9zRzZjV0RGZEQwYmFFWE1aQlJneUhSOXYzWjBwQTVPYkNNeDM5?=
 =?utf-8?B?WlVOazU3eW9nS1NKRGdvWTBFa0RySmhXeTJmTEpXV1pXd1RmZzA0amQ2cVNB?=
 =?utf-8?B?bkkxbnhJUDNsRFkxWEZIV015VkNRdWRrcFpiWElrY0Nlb0ZlL2ZGNzdaUmNW?=
 =?utf-8?B?a0ZXZWVTVGRpOUR5ZmRIUzlVMHFhVFlTeTFKMEIvUzdja2tHUStxRWhSSFgx?=
 =?utf-8?B?VzB2QjRRVXZjNFJwL1htOFk0ZklmdjRzNWF2Y1RnTm1ORHFoTDJYZlRjeTdq?=
 =?utf-8?B?eHdTL001bWV5akRVTTFpMWNtekFsZEpWeTdqbVY1VmEwaU5RWlVSWUFaWjdi?=
 =?utf-8?B?VGFZSUwvd3JMU3BuNFM4TURiTCtlendpMXRqYVgvTmkxRzZLdTZaUlFpbVhQ?=
 =?utf-8?B?eTJoa2NnSnNPZGNpR2ptZXlnSXVuK2kxZFNyT3ovY0dNNTIwWFRSVWloRjRa?=
 =?utf-8?B?eTBvZUVQMXFSTHM0VjQrRDRDdmYvYmpZRzd1Szd0YnM2azlmQnFHeGpsdHEy?=
 =?utf-8?B?Nm5kUDNNM0FOcG9ETU04QitqRjl6UkJYTWZNSVlMNXlPV085cXVCOWpyeDE0?=
 =?utf-8?Q?y9vU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5489.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef453703-e263-4a8d-f128-08dac78c08e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2022 04:35:48.4226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GMtYaEesaXEpHX0sjNBMdf4mvas2v6KP8qFW38LDDsJOlv3AGlWPNGofrVlAS/udVj9PEUFK+Fv6eUVr3exeog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTHl1
ZGUgUGF1bCA8bHl1ZGVAcmVkaGF0LmNvbT4NCj4gU2VudDogVHVlc2RheSwgTm92ZW1iZXIgMTUs
IDIwMjIgNTo1NSBBTQ0KPiBUbzogTGluLCBXYXluZSA8V2F5bmUuTGluQGFtZC5jb20+OyBhbWQt
Z2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBDYzogV2VudGxhbmQsIEhhcnJ5IDxIYXJyeS5X
ZW50bGFuZEBhbWQuY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsNCj4gTGksIFN1biBwZW5n
IChMZW8pIDxTdW5wZW5nLkxpQGFtZC5jb20+OyBTaXF1ZWlyYSwgUm9kcmlnbw0KPiA8Um9kcmln
by5TaXF1ZWlyYUBhbWQuY29tPjsgRGV1Y2hlciwgQWxleGFuZGVyDQo+IDxBbGV4YW5kZXIuRGV1
Y2hlckBhbWQuY29tPjsgS29lbmlnLCBDaHJpc3RpYW4NCj4gPENocmlzdGlhbi5Lb2VuaWdAYW1k
LmNvbT47IFBhbiwgWGluaHVpIDxYaW5odWkuUGFuQGFtZC5jb20+OyBEYXZpZA0KPiBBaXJsaWUg
PGFpcmxpZWRAZ21haWwuY29tPjsgRGFuaWVsIFZldHRlciA8ZGFuaWVsQGZmd2xsLmNoPjsgS2F6
bGF1c2thcywNCj4gTmljaG9sYXMgPE5pY2hvbGFzLkthemxhdXNrYXNAYW1kLmNvbT47IFBpbGxh
aSwgQXVyYWJpbmRvDQo+IDxBdXJhYmluZG8uUGlsbGFpQGFtZC5jb20+OyBMaSwgUm9tYW4gPFJv
bWFuLkxpQGFtZC5jb20+OyBadW8sIEplcnJ5DQo+IDxKZXJyeS5adW9AYW1kLmNvbT47IFd1LCBI
ZXJzZW4gPGhlcnNlbnhzLnd1QGFtZC5jb20+OyBUaG9tYXMNCj4gWmltbWVybWFubiA8dHppbW1l
cm1hbm5Ac3VzZS5kZT47IE1haGZvb3osIEhhbXphDQo+IDxIYW16YS5NYWhmb296QGFtZC5jb20+
OyBIdW5nLCBBbGV4IDxBbGV4Lkh1bmdAYW1kLmNvbT47IEZyYW5jaXMsDQo+IERhdmlkIDxEYXZp
ZC5GcmFuY2lzQGFtZC5jb20+OyBNaWtpdGEgTGlwc2tpIDxtaWtpdGEubGlwc2tpQGFtZC5jb20+
OyBMaXUsDQo+IFdlbmppbmcgPFdlbmppbmcuTGl1QGFtZC5jb20+OyBvcGVuIGxpc3Q6RFJNIERS
SVZFUlMgPGRyaS0NCj4gZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnPjsgb3BlbiBsaXN0IDxs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvMl0g
ZHJtL2FtZGdwdS9tc3Q6IFN0b3AgaWdub3JpbmcgZXJyb3IgY29kZXMgYW5kDQo+IGRlYWRsb2Nr
aW5nDQo+IA0KPiBPbiBXZWQsIDIwMjItMTEtMDkgYXQgMDk6NDggKzAwMDAsIExpbiwgV2F5bmUg
d3JvdGU6DQo+ID4gPiDCoMKgCX0NCj4gPiA+IC0JaWYgKCFkcm1fZHBfbXN0X2F0b21pY19jaGVj
ayhzdGF0ZSkgJiYgIWRlYnVnZnNfb3ZlcndyaXRlKSB7DQo+ID4gPiArCXJldCA9IGRybV9kcF9t
c3RfYXRvbWljX2NoZWNrKHN0YXRlKTsNCj4gPiA+ICsJaWYgKHJldCA9PSAwICYmICFkZWJ1Z2Zz
X292ZXJ3cml0ZSkgew0KPiA+ID4gwqDCoAkJc2V0X2RzY19jb25maWdzX2Zyb21fZmFpcm5lc3Nf
dmFycyhwYXJhbXMsIHZhcnMsIGNvdW50LCBrKTsNCj4gPiA+IC0JCXJldHVybiB0cnVlOw0KPiA+
ID4gKwkJcmV0dXJuIDA7DQo+ID4gPiArCX0gZWxzZSBpZiAocmV0ID09IC1FREVBRExLKSB7DQo+
ID4gPiArCQlyZXR1cm4gcmV0Ow0KPiA+DQo+ID4gSSB0aGluayB3ZSBzaG91bGQgcmV0dXJuIGhl
cmUgd2hlbmV2ZXIgdGhlcmUgaXMgYW4gZXJyb3IuIE5vdCBqdXN0IGZvcg0KPiA+IEVERUFETEsg
Y2FzZS4NCj4gDQo+IEFyZSB3ZSBzdXJlIGFib3V0IHRoaXMgb25lPyBJIHRoaW5rIHdlIG1heSBh
Y3R1YWxseSB3YW50IHRvIG1ha2UgdGhpcyBzbyBpdA0KPiByZXR1cm5zIG9uIHJldCAhPSAtRU5P
U1BDLCBzaW5jZSB3ZSB3YW50IHRoZSBmdW5jdGlvbiB0byBjb250aW51ZSBpZiB0aGVyZSdzDQo+
IG5vIHNwYWNlIGluIHRoZSBhdG9taWMgc3RhdGUgYXZhaWxhYmxlIHNvIGl0IGNhbiB0cnkgcmVj
b21wdXRpbmcgdGhpbmdzIHdpdGgNCj4gY29tcHJlc3Npb24gZW5hYmxlZC4gT24gcmV0ID09IDAg
aXQgc2hvdWxkIHJldHVybiBlYXJseSB3aXRob3V0IGRvaW5nDQo+IGNvbXByZXNzaW9uLCBhbmQg
b24gcmV0ID09IC1FTk9TUEMgaXQgc2hvdWxkIGp1c3QgY29udGludWUgdGhlIGZ1bmN0aW9uDQo+
IGZyb20gdGhlcmUNCj4gDQpPaCwgcmlnaHQuLiBUaGFua3MgZm9yIHNhdmluZyBtZSBmcm9tIGNh
dXNpbmcgZGlzYXN0ZXIgOiApDQoNCj4gLS0NCj4gQ2hlZXJzLA0KPiAgTHl1ZGUgUGF1bCAoc2hl
L2hlcikNCj4gIFNvZnR3YXJlIEVuZ2luZWVyIGF0IFJlZCBIYXQNCi0tDQpSZWdhcmRzLA0KV2F5
bmU=
