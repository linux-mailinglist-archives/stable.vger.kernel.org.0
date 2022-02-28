Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57D04C77F5
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbiB1ShF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240732AbiB1Sg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:36:57 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63BF4BFF2;
        Mon, 28 Feb 2022 10:23:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khr6vT7jG6CazJrFDKiq9u8Fwm8XKLZ2YCRJ4afh1QeK23GgBzlf7SnlvERcaNVkXtmkv11ym3hw+eP7ZSyKorjogh7xgBnNRF5gsOU4aG2tODMZoSl8UpIFyqPmGubJwIqvUo10VcZp9G/x+3lAlKowkTX9VXgtofZ4b9U9yE9K46F33sxI8HZ6nEsl+zQiYQFo0NFvL5db1Hjcqxm7FJh3geg8UGXJy3Qe43k2D+j86CequZ+CJso8NNoKuQehk0EXTIcmriaWLlDjCkFD/9AZX+aMMYdPNfOn/2Yyss7e7DiipR4MEba7z5p2Y+54raUjS75pA1R2ihXguJTt7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sHzOXZPgAnOf7U4l9/6Y1DsXAsur53QQU+0YRmj4r9E=;
 b=WORDsl6+xARvDxeUHPcL3MF8y2qOXxkdshFgrP3/ukzDwEUzB6Q5MK5yxrmJa+iWSEsM3XfF0muIentNO30sF1/Ca3pmkpVQgQ8nGH2nKE0Gla5B9UgKK8UXXRymzVvNkBcEfFQUZE5g/vOXhMl54pX0Y8tExZfU4bJdoNkgrRU/CKfVayoLB2EEzO38/uzJx4rI3k7hjACbSRaY7RVSFZwtlkGGBCr7XXZNhsFSkcVsrDL7HVPtD2gAEfjsZ0iDogEf43WFc2iZAvcNP+DSxtITGm97NnH2KVGy3QzpsLGGbutiMFJ5VLH1MaZAub7HG4jJRclwo1nnPLOomup7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sHzOXZPgAnOf7U4l9/6Y1DsXAsur53QQU+0YRmj4r9E=;
 b=epG6kdlteKJpvIjDkcHpqorcGY6bibobm7AkM/Fim2irhbOzoOOX8lWMSYEQVITywBvoqiqCFLJ3Rnd69Qg0v/tkycCg9EooYp8ohvAv/D9AFr0ZFkml4dDs6i2FsdZc65PvsCnz+aKbeL0bmlg6Pck1tbLgqAV8BKMgPPUVcGk=
Received: from BN9PR12MB5146.namprd12.prod.outlook.com (2603:10b6:408:137::16)
 by CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Mon, 28 Feb
 2022 18:23:29 +0000
Received: from BN9PR12MB5146.namprd12.prod.outlook.com
 ([fe80::8147:cc0e:8aa7:89ba]) by BN9PR12MB5146.namprd12.prod.outlook.com
 ([fe80::8147:cc0e:8aa7:89ba%3]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:23:29 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Koenig, Christian" <Christian.Koenig@amd.com>,
        "Yu, Qiang" <Qiang.Yu@amd.com>
Subject: RE: [PATCH 5.15 020/139] drm/amdgpu: check vm ready by
 amdgpu_vm->evicting flag
Thread-Topic: [PATCH 5.15 020/139] drm/amdgpu: check vm ready by
 amdgpu_vm->evicting flag
Thread-Index: AQHYLMnIIs9/drZ410yWRuLdU6BTdqypRroQ
Date:   Mon, 28 Feb 2022 18:23:29 +0000
Message-ID: <BN9PR12MB5146BF7F56C28642EF3BABABF7019@BN9PR12MB5146.namprd12.prod.outlook.com>
References: <20220228172347.614588246@linuxfoundation.org>
 <20220228172350.001376260@linuxfoundation.org>
In-Reply-To: <20220228172350.001376260@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-02-28T18:22:43Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=6c141a46-a9a0-4b6c-a865-996fc6e79037;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-02-28T18:23:26Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d2dff6c9-ed66-4144-b7fe-eb270dbdd60a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b74ba9e9-1c6c-4fbc-486b-08d9fae76b54
x-ms-traffictypediagnostic: CH2PR12MB4198:EE_
x-microsoft-antispam-prvs: <CH2PR12MB41987256868E6C3F5ECE368EF7019@CH2PR12MB4198.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 32iYFxTY7xmXTUS9kYilzG8M+NL1or8s/It2nYTeYDCAlVu8hdQZOqguvWQiaabdZdppStY8DexqRBNxImNgZeZwiJiGILjhMNn80tSU4NUQr/v5Fgl0kvrEH/kPDDT5Voyc32Ocw3g9fk9DcQgPXG4xLjOnuIAprU9XOqxKckn4VO/MzOgQDcIpsOfZ6DBasC1MB+U/aoKNTbXtHsT+mPBDV82ClrS7Wjmlmx4WIbbcI+sggiaha5qLZ4tK5i5fq4uY5AubeZG3gu4wzzhf7twxcD6KiSYE6QW0KVGGdGuOE6tuh2ki8dSvEC8HMmIhAVgY7ezz3asWalrWFQim3DGTwzInnQnYHk9DaLD387m2Ck5Rejee71l0rKs/WM4Zhn9eYht+t3YbTq9brF6PKXmAe+gerLQX0cvV9PueOyLJSLdaA7NS0d5zzDzYhBgrn9scVCBNHD3UhFn6YfbjVoAP8q1cGwQbFLGaU3bysJIZQzK91E3PQ+aa1lcnhD7H/zcvai0N788C/WGQdS1bD/khIViRd7+BNGqHW9Rq1VXhpf4Wes5gM3evz0M8XBBl5V23256EKLWIpLsWseFO50DbN4rtCaKw7b6YwjCrIlpXRSmWmlUuNJr1nbitkIze8dz5Fihc/6OHBL7YtciA7sEmuyyHTSmWQurwu3rrdvDU8CFCspvqmKxrt+0jWkjTj2/IgjzW0HFdy6o5OEAz3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5146.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(71200400001)(4326008)(6506007)(38100700002)(53546011)(66574015)(9686003)(122000001)(508600001)(55016003)(83380400001)(110136005)(54906003)(7696005)(316002)(8936002)(52536014)(86362001)(38070700005)(5660300002)(2906002)(33656002)(186003)(26005)(66946007)(66556008)(66446008)(64756008)(76116006)(66476007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUdZWE9GRDMyV09qVTBwOEJjY3hmNDA5UnNNWEtVVjFvbjFIQkhZUHNucTA5?=
 =?utf-8?B?bHF5M3RKNXZWdkJHUjc4QjNVQjdhcUNHZk5pWVQvd0d3RDFIaVgwVUxXcnd2?=
 =?utf-8?B?Mlg4d0dRU1RBTk5aZmEvSWJtZkdyMkZKWURpWEdxUXM5NnZPbmk1STRFVVhD?=
 =?utf-8?B?cGgzMVNydlRXR2pJaG5oWHE1SXVKdWw3TWVNZ3pMRDFTbWtaTWNJZmpjU0Jw?=
 =?utf-8?B?c1A4Q1N6eXVybGpVNklJdTJhNUNDeG1raE5ZaDVUZnJNZlRyaHFONEZUQUNU?=
 =?utf-8?B?K2dla1RZM0l4WWhTbWl0MXdSZTEyTVZWMUtKOStnMCt6cDZoNUV3aFUwWkN1?=
 =?utf-8?B?Y2ZhNDJTZmJyQWY2cjdTVUYrZDdoeHNaY2NtQW9xN3U4a3oxQUoyQ0ZYb1VV?=
 =?utf-8?B?Kys2OEkwTVBid3VJbGZSMVNaM3RIRFNpSlM3aDROQTRmNlAraXBSdGdsVWxR?=
 =?utf-8?B?N3lqMzI4QUR3WkNwSDk0Z01IU2s3TS92QTZ4VktHZlBIekJUQXZnNlhkdmxo?=
 =?utf-8?B?Y1hGZjdoSXVzT2Jpd2JjQXc1dGxlaSsxWi90bWlQSTg4R1FOWUNQSXlhUTJE?=
 =?utf-8?B?ZFBVY2taZ29TTGxjOHFqRUZ0LzVST1V6NmdrOG1iQkx2ZVN5Wk1yOUlsazg3?=
 =?utf-8?B?Q3dza3c0Nkx5VU5OMk1CSFhvcDZSTlhtdVVtVC8yUFRuMkhzL1RWMDRra3Y5?=
 =?utf-8?B?RUplTmJ6RkJUOVRRbEk1WnRMS0ZNN0p1ZFZOYWhNeVRiY2lkMjdBK1BnRENx?=
 =?utf-8?B?eS9DcjQvR1RWR1JlektPcVVMYnJFaVZhendadE9QUlNkdjJEQTYrUi9VMmU0?=
 =?utf-8?B?c29JTDNYaS8rdGM5MmV1T3FJV012ZzdrWGFvQUd6dWt3cHRnYWxkbEtPNVNE?=
 =?utf-8?B?SGVENHZrVXBqRlZ0ZnAxeVlYL24rY2JITmZMQis2MlYvQzJDVm03M1FlRWtR?=
 =?utf-8?B?Qmp4NEtOc0luaVJRNS9nYjdEdXg3R1FnMitZL2pQK2p6Qm42NG00N25QYzRF?=
 =?utf-8?B?MDVONnNSbUhNUUpBTWxlK0lNMllYdnV1NWVvT1lqajBUWVUzWG9TcFlwaTVt?=
 =?utf-8?B?NXlKcEZteDM1cFNCRDNGd2l1azBkb2cyQmUzYXg5VDB3d3ZsYUVnNEdVRDhk?=
 =?utf-8?B?SGtOWk1SUEtKQUd0RENBTGRyWTgwZkp5RE42L25IdVVhd2JlQzZIYlZBOGhH?=
 =?utf-8?B?bFVKNW1CUmxXQ2MrZVN2MHN1Y3p2dWF2cmRHalhkajNTa3N0SGxyMHA0VHRG?=
 =?utf-8?B?ZTFOTHZqQ2xKbXEvQ1pUMStZV3pzTkRWZTRySy8yWWg5MXhRUzRmUzgxNWJz?=
 =?utf-8?B?ZlhVNGVZNStPeDZHczJPTm56Q0M4NC9FRTVFc2xFejBNZk8wMERRTTlielBo?=
 =?utf-8?B?OVkrL013dngvZnhNK0o1S3FuNFF2Q1hkWVZsdHpZVjdkdjhXeWpTUGNTMUV4?=
 =?utf-8?B?WFhXRlZMQit1b1QxcVRXRFVPdmFvSlJVOERHeFNSTjRKNHVWZzZXVUFBV05j?=
 =?utf-8?B?MFM4T21xWU1UUUUyV3BPbjl6dHJiTjYxanRNUmE1UWdqYzFGNkFkeXM1TTRP?=
 =?utf-8?B?QlNjY1BaWEJueFEzQVRxbVNZT0oxMlZvTmRzdG5vTTRrM2Y5bDByUzZ2c0xV?=
 =?utf-8?B?TG1vdUtSY3hFSUpiaTQ0NDYwcUQ5a2YvdHRUNVdycnNwUWt5aWZjNkRaMmdF?=
 =?utf-8?B?amVIUVlqbytZUGlQRTFVZnVNQ09ScDVYM3l0bjV5alpWeFEwNnRSVVVCRHdV?=
 =?utf-8?B?Lzh3QnVQeVlLT1FFL1RuNDc2Qk0rVXdabmtCSGk0MkFQdjhIZmxzdWdNYi9L?=
 =?utf-8?B?b3hvaFFVUkhvc0F2U1pXZUlPaEl6N1lsbUdZb3J3MFBmVXZhOWJCRy8rRWsw?=
 =?utf-8?B?WTJ5ek0wa0xDTFZpVDk1elEwaXU3NnhNdWJYWGgrNGkzZGVZc2FZUFdPeDFP?=
 =?utf-8?B?ZzFXRldibENERVI0dmN6SUx4SUErTXJsdjF3a3RwdWtPMThFVk9pTHB2UENm?=
 =?utf-8?B?UVdjVHFUSHJ6VDhEVUt3b0k2cVlwOHBJR3ZDUWVjaGh3U3hVK00zUEJhb0hF?=
 =?utf-8?B?ODRQdlIxV0xkNjBpY1NyQ0dCdzR4WEoweE8xRU01QmJqbC9kM21BWmxadHJ0?=
 =?utf-8?B?cXZqdmMrRCtUbU9HK3pRWWtOSlZyVDN5RUphQk04MjNYY09yZVlWQ1pDZmRV?=
 =?utf-8?Q?gYADTAQMdX2eRQIdRQjBQuQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5146.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74ba9e9-1c6c-4fbc-486b-08d9fae76b54
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 18:23:29.4242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aljs5XyPyspkkHeuUi8Pb0PLBWB3RVG+uKSjJyQrwqDR9TC+PP+0CSrTb7YjSLmegxXUS8gSyY6yCyp0vY7MGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4198
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBHcmVnIEty
b2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPiBTZW50OiBNb25kYXks
IEZlYnJ1YXJ5IDI4LCAyMDIyIDEyOjIzIFBNDQo+IFRvOiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IENjOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24u
b3JnPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9s
Z2VuLm1wZy5kZT47IEtvZW5pZywNCj4gQ2hyaXN0aWFuIDxDaHJpc3RpYW4uS29lbmlnQGFtZC5j
b20+OyBZdSwgUWlhbmcgPFFpYW5nLll1QGFtZC5jb20+Ow0KPiBEZXVjaGVyLCBBbGV4YW5kZXIg
PEFsZXhhbmRlci5EZXVjaGVyQGFtZC5jb20+DQo+IFN1YmplY3Q6IFtQQVRDSCA1LjE1IDAyMC8x
MzldIGRybS9hbWRncHU6IGNoZWNrIHZtIHJlYWR5IGJ5DQo+IGFtZGdwdV92bS0+ZXZpY3Rpbmcg
ZmxhZw0KPiANCj4gRnJvbTogUWlhbmcgWXUgPHFpYW5nLnl1QGFtZC5jb20+DQo+IA0KPiBjb21t
aXQgYzFhNjZjM2JjNDI1ZmY5Mzc3NGZiMmY2ZWVmYTY3YjgzMTcwZGQ3ZSB1cHN0cmVhbS4NCj4g
DQo+IFdvcmtzdGF0aW9uIGFwcGxpY2F0aW9uIEFOU0EvTUVUQSB2MjEuMS40IGdldCB0aGlzIGVy
cm9yIGRtZXNnIHdoZW4NCj4gcnVubmluZyBDSSB0ZXN0IHN1aXRlIHByb3ZpZGVkIGJ5IEFOU0Ev
TUVUQToNCj4gW2RybTphbWRncHVfZ2VtX3ZhX2lvY3RsIFthbWRncHVdXSAqRVJST1IqIENvdWxk
bid0IHVwZGF0ZSBCT19WQSAoLQ0KPiAxNikNCj4gDQo+IFRoaXMgaXMgY2F1c2VkIGJ5Og0KPiAx
LiBjcmVhdGUgYSAyNTZNQiBidWZmZXIgaW4gaW52aXNpYmxlIFZSQU0gMi4gQ1BVIG1hcCB0aGUg
YnVmZmVyIGFuZCBhY2Nlc3MNCj4gaXQgY2F1c2VzIHZtX2ZhdWx0IGFuZCB0cnkgdG8gbW92ZQ0K
PiAgICBpdCB0byB2aXNpYmxlIFZSQU0NCj4gMy4gZm9yY2UgdmlzaWJsZSBWUkFNIHNwYWNlIGFu
ZCB0cmF2ZXJzZSBhbGwgVlJBTSBib3MgdG8gY2hlY2sgaWYNCj4gICAgZXZpY3RpbmcgdGhpcyBi
byBpcyB2YWx1YWJsZQ0KPiA0LiB3aGVuIGNoZWNraW5nIGEgVk0gYm8gKGluIGludmlzaWJsZSBW
UkFNKSwgYW1kZ3B1X3ZtX2V2aWN0YWJsZSgpDQo+ICAgIHdpbGwgc2V0IGFtZGdwdV92bS0+ZXZp
Y3RpbmcsIGJ1dCBsYXR0ZXIgZHVlIHRvIG5vdCBpbiB2aXNpYmxlDQo+ICAgIFZSQU0sIHdvbid0
IHJlYWxseSBldmljdCBpdCBzbyBub3QgYWRkIGl0IHRvIGFtZGdwdV92bS0+ZXZpY3RlZCA1LiBi
ZWZvcmUNCj4gbmV4dCBDUyB0byBjbGVhciB0aGUgYW1kZ3B1X3ZtLT5ldmljdGluZywgdXNlciBW
TSBvcHMNCj4gICAgaW9jdGwgd2lsbCBwYXNzIGFtZGdwdV92bV9yZWFkeSgpIChjaGVjayBhbWRn
cHVfdm0tPmV2aWN0ZWQpDQo+ICAgIGJ1dCBmYWlsIGluIGFtZGdwdV92bV9ib191cGRhdGVfbWFw
cGluZygpIChjaGVjaw0KPiAgICBhbWRncHVfdm0tPmV2aWN0aW5nKSBhbmQgZ2V0IHRoaXMgZXJy
b3IgbG9nDQo+IA0KPiBUaGlzIGVycm9yIHdvbid0IGFmZmVjdCBmdW5jdGlvbmFsaXR5IGFzIG5l
eHQgQ1Mgd2lsbCBmaW5pc2ggdGhlIHdhaXRpbmcgVk0gb3BzLg0KPiBCdXQgd2UnZCBiZXR0ZXIg
Y2xlYXIgdGhlIGVycm9yIGxvZyBieSBjaGVja2luZyB0aGUgYW1kZ3B1X3ZtLT5ldmljdGluZyBm
bGFnDQo+IGluIGFtZGdwdV92bV9yZWFkeSgpIHRvIHN0b3AgY2FsbGluZw0KPiBhbWRncHVfdm1f
Ym9fdXBkYXRlX21hcHBpbmcoKSBsYXRlci4NCj4gDQo+IEFub3RoZXIgcmVhc29uIGlzIGFtZGdw
dV92bS0+ZXZpY3RlZCBsaXN0IGhvbGRzIGFsbCBCT3MgKGJvdGggdXNlciBidWZmZXINCj4gYW5k
IHBhZ2UgdGFibGUpLCBidXQgb25seSBwYWdlIHRhYmxlIEJPcycgZXZpY3Rpb24gcHJldmVudCBW
TSBvcHMuDQo+IGFtZGdwdV92bS0+ZXZpY3RpbmcgZmxhZyBpcyBzZXQgb25seSBmb3IgcGFnZSB0
YWJsZSBCT3MsIHNvIHdlIHNob3VsZCB1c2UNCj4gZXZpY3RpbmcgZmxhZyBpbnN0ZWFkIG9mIGV2
aWN0ZWQgbGlzdCBpbiBhbWRncHVfdm1fcmVhZHkoKS4NCj4gDQo+IFRoZSBzaWRlIGVmZmVjdCBv
ZiB0aGlzIGNoYW5nZSBpczogcHJldmlvdXNseSBibG9ja2VkIFZNIG9wICh1c2VyIGJ1ZmZlciBp
bg0KPiAiZXZpY3RlZCIgbGlzdCBidXQgbm8gcGFnZSB0YWJsZSBpbiBpdCkgZ2V0cyBkb25lIGlt
bWVkaWF0ZWx5Lg0KPiANCj4gdjI6IHVwZGF0ZSBjb21taXQgY29tbWVudHMuDQo+IA0KPiBBY2tl
ZC1ieTogUGF1bCBNZW56ZWwgPHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT4NCj4gUmV2aWV3ZWQtYnk6
IENocmlzdGlhbiBLw7ZuaWcgPGNocmlzdGlhbi5rb2VuaWdAYW1kLmNvbT4NCj4gU2lnbmVkLW9m
Zi1ieTogUWlhbmcgWXUgPHFpYW5nLnl1QGFtZC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXgg
RGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gQ2M6IHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz4NCg0KQSByZWdyZXNzaW9uIHdhcyByZXBvcnRlZCBhZ2FpbnN0IHRo
aXMgcGF0Y2ggaW4gNS4xNy4gIFBsZWFzZSBkcm9wIGZvciBub3cuDQoNCkFsZXgNCg0KPiAtLS0N
Cj4gIGRyaXZlcnMvZ3B1L2RybS9hbWQvYW1kZ3B1L2FtZGdwdV92bS5jIHwgICAgOSArKysrKysr
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
IA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdm0uYw0KPiArKysg
Yi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfdm0uYw0KPiBAQCAtNzY4LDExICs3
NjgsMTYgQEAgaW50IGFtZGdwdV92bV92YWxpZGF0ZV9wdF9ib3Moc3RydWN0IGFtZA0KPiAgICog
Q2hlY2sgaWYgYWxsIFZNIFBEcy9QVHMgYXJlIHJlYWR5IGZvciB1cGRhdGVzDQo+ICAgKg0KPiAg
ICogUmV0dXJuczoNCj4gLSAqIFRydWUgaWYgZXZpY3Rpb24gbGlzdCBpcyBlbXB0eS4NCj4gKyAq
IFRydWUgaWYgVk0gaXMgbm90IGV2aWN0aW5nLg0KPiAgICovDQo+ICBib29sIGFtZGdwdV92bV9y
ZWFkeShzdHJ1Y3QgYW1kZ3B1X3ZtICp2bSkgIHsNCj4gLQlyZXR1cm4gbGlzdF9lbXB0eSgmdm0t
PmV2aWN0ZWQpOw0KPiArCWJvb2wgcmV0Ow0KPiArDQo+ICsJYW1kZ3B1X3ZtX2V2aWN0aW9uX2xv
Y2sodm0pOw0KPiArCXJldCA9ICF2bS0+ZXZpY3Rpbmc7DQo+ICsJYW1kZ3B1X3ZtX2V2aWN0aW9u
X3VubG9jayh2bSk7DQo+ICsJcmV0dXJuIHJldDsNCj4gIH0NCj4gDQo+ICAvKioNCj4gDQo=
