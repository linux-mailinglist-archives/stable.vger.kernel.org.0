Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B6A55D75C
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiF0Uny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 16:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiF0Unx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 16:43:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396A7186DA;
        Mon, 27 Jun 2022 13:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVpqTmFszfP3E9HVAu0O9TRjFsk12D2rByKfno6qUlgpPAr+LphS42buOELCeL9sE40wQPeoRigCSTlbwcmKH9mGx63pBYFeL+VHdxOQQilrUJG7oEDsQDE5DOtJHyeEnlRQWJlYvXcyEO0FFWSWCunmk3syg5v/31z6vnMs5p0W0Ez8IESUde3xo1a9ndwR38Em0IcEgeJoj/5jo1NLB45olFEn1XE/k+9DhfEL+fsLbTXlYsiKd3D1PdrK52+3Z6ZtwMpXVmIyPzawT+E/w7egGX1cScsiAtlhY50xUc0/fCfQg0tY6Ui9LmNH834g5ejk3n54wTrMCYT0m1Iu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGC2vrI+ytYSjDEiPTLh9BSh2pS2M19LxOjUwgl6f5o=;
 b=ENzyvDMtgho652AToIeZpTWF6/OI+QuvdwLd46tcln/uRdb6mf1i771vBPcoPxP1Z4VoRD9+gb/7f9m6xLf9U6je9jXJaXEJQQhsPIg9WiSU6Kot7UMTr0jQns0WHDUz404fcGrk5w+1QNa/0BAEy+o5wYr1cyZ5lJxwkhj9I+0Pyxe7D9YPgJoqNuLCHV0FENGiqqW/KCNSPjWO4GB8pLMfQD2gC3q9XlCJ0/u2cesFBVlc95VwTmlQnRHq5KIZiBokXWsdyLS4n+xZ6smsJG/fRwjjNrYFlTIM6i5MbeHwOF41zunhow3rogKRejltP9ywaTlSpt4cmqgmUyRCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGC2vrI+ytYSjDEiPTLh9BSh2pS2M19LxOjUwgl6f5o=;
 b=FjJbJmuT37KZ3+Z85MYyBS13SsonH20CqVlPqW+cmNzN8Afl+jNMMARVYVN1++iDNeaoPIHYHl2bHdQt8iP/yVs6rfdqizXAYukPePWhUDre6SFxT8N5PfYMMGAHi9uf0Uf7PfC+yKz76TtNfYa5bN17mxON4+jew7kvKZAtYR25IITsp8WVmArgFNKXsWDQEaEQ47xo7emg8rPf5I8xaP6cnxc0MakEyrGgEZuF+RVd0aqOd6C7j+VVgLuiWIv5YrJJ0Gf3K2Wqj0bjwpkwnqnU6uBxY/blDQuvO/xAxw4VJMci3ObxbPuowFJvU8PxFL2u0hfFxhMauawXeqp1OA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH2PR12MB4891.namprd12.prod.outlook.com (2603:10b6:610:36::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Mon, 27 Jun
 2022 20:43:50 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::240b:5f1b:9900:d214%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 20:43:50 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Pablo Greco <pgreco@centosproject.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG
 SX6000LNP (AKA SPECTRIX S40G)
Thread-Topic: [PATCH v2] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG
 SX6000LNP (AKA SPECTRIX S40G)
Thread-Index: AQHYiI1ZTnvonTb8MECRWsBXT0juhK1jvBsA
Date:   Mon, 27 Jun 2022 20:43:50 +0000
Message-ID: <00568db1-359d-338f-247e-f9e16d0cf9f3@nvidia.com>
References: <20220625121502.9092-1-pgreco@centosproject.org>
In-Reply-To: <20220625121502.9092-1-pgreco@centosproject.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5535762d-6d9e-4a58-afa9-08da587dbde2
x-ms-traffictypediagnostic: CH2PR12MB4891:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9xwdeJczXIeV+YGGvEYk3IdjrT6EFaQYUEnRH3q+gti1Xx4hhx+bzg5PWWGVkwjXKTPp6nkR5nYJ3U4Y/L1y1rwRkzKPZjB0CNXC0w6883LgHjJ2Z9CcReAzxYx8pEgU0lQRlPhLjQr3FRDCDHuQIar7c9r86sp9QACTrrLFMCLbO2g8dvhA9e1hYmKUTBNproq99J3DTF2WpgihNjtH7EkMWI3l+oBqJxlHpEGrVyxiyZRjd1dsGOAxBPgUke1m50F2Zr1Ln69HcI6gJpbHS6F+pWbwRIXZlbr5pC7QoIfnGfWPSIg43/KKMaNMmsN4mmGxufsT79gCZ4BE+/x/CbE0B/ALKvvlTvuFV1aSz3CmmrI0zGU9P+nmlM7ECEXYWF/VzVh+rBHzF9GKZu9Zsdo05znInppgdtWDSRW/RytUkTIOwaRbwmVwUXG0rjE/xSMfOwyQ5n3XFFY31pobeuiwaw1xbN620NwJCbCpfzq0c5RIGd8B1P1Pak5G3/K5urlE2rQ6kyd4DmtEiR4mD7os+2GgjfmkIrhi+vlVj76HE1EvLGhC69/YzhAE9OiVpUtAbsDWwhwFtJn0oyd1e9KrpFR7dwG/tvBOblcls8SOgUX7kCdH7MDryCoV4AvqXj3NtJP/nIGR++v+T2+D+tb8Hn5aWBARcKv7A8JbJCoXywSxvQ74q6VgwcqECTPdy89446qAEKR6MaeMd5pCNwV9wf8vsruMHv1jON0AvXY7eNjHMNTJ3S0v7fNImwdS/ykzqMWjiHz/P4DRgImYLDhAW32uHLkSJSc03UVoRfF86+FOc8VBYMU9KcxNh3UjkmXXx23+99FNUnskWOwhNn/9S7q5p0QclPo5youd8XE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(366004)(376002)(346002)(136003)(64756008)(2616005)(38070700005)(31696002)(186003)(66476007)(36756003)(122000001)(91956017)(31686004)(2906002)(76116006)(71200400001)(54906003)(38100700002)(316002)(4326008)(5660300002)(6506007)(66556008)(6486002)(6916009)(53546011)(66446008)(66946007)(8676002)(478600001)(86362001)(6512007)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3FnVXl3b2hIcm1iVnAzWUtVZW9WaldhQXpha1FPMTdzOWxPMGZtQXBvUC9S?=
 =?utf-8?B?T1FrdzkyZElxanNjYjNKQXFDeEp1UXZpdm5ZVGR6ZUNXVXR5blNnTnN3NEhi?=
 =?utf-8?B?eTI5Y3VRWGhFcERSOEtBNWdTTUZFNWV1WjBoSWJOQnAyRjFOMEx2aVFxMi84?=
 =?utf-8?B?NDI1UUQwLzZyK2dDTDZSMWlSaDBBbU9Xa3lXUXZ1dWhTYTB2VnF1TzUrdmJE?=
 =?utf-8?B?Yi9HclVVNHZmN2IxT1RQdzhFblJJUTJFT2kvYk5CWkVYQlF6MlBMOWZQa0xR?=
 =?utf-8?B?b2FTdXUrdGxnMUhLRnM4RGQxbkI4S0RjSEErWk1OZUkwblZ2aFFLckpoZmJY?=
 =?utf-8?B?UGhiRWlFUVFMVXM4Zmh0VUNFMStUaktaZExzeDBqK25hL3BrY2dQQzFkVDhD?=
 =?utf-8?B?R3lwS28yWW1lTWsyK2NvM2x4ckRwTjBrQ3ovV215MWlPR3l1VE1Ba05lNkEw?=
 =?utf-8?B?cDMrTTNDbXJPTkdJQXNXbDRxYlEzODBPTU1tTTZoelVkclRDMWF4R1BhNUVV?=
 =?utf-8?B?K2RTWGtEc3NjTEY4YmxYZGgyT3M0bkRyb3dpTU90cFFuMWRPb1QvZDBCQmJZ?=
 =?utf-8?B?Mkd1aEpVVWNCcnlvQzJIazljTU9IbEhNbjM3WGNFc2RDWUMveUF0L0pYZVEx?=
 =?utf-8?B?VEQ4cUk4K3Iwd3NrNlc1Yyt3L1NDUEowSWdqS1FVVXNSNE14MU8yYllaZGN5?=
 =?utf-8?B?KzJtMEFpNkdQQkMwTXc1MzRuZTVOcHFvS0hmR2VCTHIxN1M4ZWdXa2JIaE54?=
 =?utf-8?B?KzgyZlVtdnY4VVlJMGFxZGNWbE15azBKcEtaR3RMcGtzWklZZFpIN2dnbkNy?=
 =?utf-8?B?WHFFdHJOZmE2Nnp5N3VRNUROTy9GVVdJbThpSXU0NmZ4Q3hlVlNiYzdoaDNY?=
 =?utf-8?B?amlmV21GZmR2VDFwZU0wdUw2UzVESzBNdmJVWEZYRWZMdTNuemtoVE9aMG1h?=
 =?utf-8?B?YVp6ZjZHKzV0Y2hyN2F6azBvODV3Ny9ua1FVRllKZEZaeEpXQ3FRZ2duOGEw?=
 =?utf-8?B?ZzYzSU9iaTJWaitzVXJPY2NENExkcGpVR3VycVdaanpqQzF1bDBpNzlFYmVR?=
 =?utf-8?B?Yk9JUklLVTk5a2lBU2tlVUtPQ3NTdHhscXY5YytMdWZ2S0QrSVA1SlpzRXJL?=
 =?utf-8?B?aGFJME45ZWIwMFRSVWxWZzhZVTU5ZGZZOHNpK250ejdIQmhxMEJ6Tmw3NENM?=
 =?utf-8?B?N2UrSjBWQXh6dTAvZ3ExaTJvSzR4YkNyR2tDZXJETmx0bVE5WDJLS2dXbG9n?=
 =?utf-8?B?UHMya0ljbmR5TFVMd25XaXVkUmRTWGNnRURUZUMzMjBuaEtZdU5TQ1JaNWtX?=
 =?utf-8?B?K0tRZjV6ak9ZVVFlRmw2KzRsMlJxa3gxMThVZUVITFFldE5IZkpJSERPQ3dm?=
 =?utf-8?B?UXFpRG5WTXA3VGVtTGg0cFVrZ25qZU1DdGdBOFFkNE5jNnlDY3lkSDFnMS9T?=
 =?utf-8?B?SDNQNnJoanY0akdJV0IyQllIcDRlU3RIVmd4eHZpTWxJcWd1L3ByYThmdzVM?=
 =?utf-8?B?dVp1QkdNaXF4OWlVeDNDVGppRUlEc2ZzK2s1b0tYQXlEYTBadDRJMDlVR0Qx?=
 =?utf-8?B?OC94aDcvYlpHSEZSeFkzUE8xM1pIRUdRMzljZ0dOM0NDMTQrSEVMVUtNVEZt?=
 =?utf-8?B?T2J6bWhOaWtZY29iTk9tcHNuQVpqc1d2elIrdkhNQWE0SlplMkRjM0xNT0pj?=
 =?utf-8?B?SmlBdXhVUnc1SnQ3N2JrUVd5M2JaMDEzK0g4aUxzMFErZGViaXJVbHFUT0xx?=
 =?utf-8?B?S1VML3E4emI1UHRReUtLM2UyU3JhYnJ3VFBMQ05wZ2Z0YXJpNTIwcGxCa08v?=
 =?utf-8?B?TnlMWUdaa2RYQlV3MmpCbWtZWFNIZlRXSlJpeTRyRDhOc1ByZFZTTmNOZEQ3?=
 =?utf-8?B?MXZKdlgzTkppb2dNQ1hNeHpKaExqVGJ2RzVweXBuckM2cGI1ZVdieFNMVEhS?=
 =?utf-8?B?TzZYeGFPa3I1OS9mZzU0aFNOUkkzaTVBWi9oK0pTL0p0T1pYNVJLWC9KVnFL?=
 =?utf-8?B?V3k0dHNxMXFZTEVINHRYQTZkK0lsM0lvVTNQVFA1SXUzQmorRDJLSHU2b3Nx?=
 =?utf-8?B?YjBiZmo2dmwrZ2djRi9WMXBsSkJzV2d6S0Z1OHJiSWIvU1RObkxFWlcxWWdM?=
 =?utf-8?B?WCtkaTdHdkhvU1FCUWt6djJnTkZnbWdZcGNvYzVEODNES3NqaXZQTWZZd0lI?=
 =?utf-8?Q?A1YkLUq4cWoy2noX+ubwsMehf6ypq/GTp0kb6Ms3Bp0F?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAAEE3046D43AB489CC288BFF6D28DBB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5535762d-6d9e-4a58-afa9-08da587dbde2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 20:43:50.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kItBS6dmBtsJJW46Htxq/cDb6puvIsTI0UnSeuTwzoA/zfAjlmB/TFupWSvt0MPPXOE18djeMRzpnZDkhJ8miA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4891
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gNi8yNS8yMiAwNToxNSwgUGFibG8gR3JlY28gd3JvdGU6DQo+IEFEQVRBIFhQRyBTUEVDVFJJ
WCBTNDBHIGRyaXZlcyByZXBvcnQgYm9ndXMgZXVpNjQgdmFsdWVzIHRoYXQgYXBwZWFyIHRvDQo+
IGJlIHRoZSBzYW1lIGFjcm9zcyBkcml2ZXMgaW4gb25lIHN5c3RlbS4gUXVpcmsgdGhlbSBvdXQg
c28gdGhleSBhcmUNCj4gbm90IG1hcmtlZCBhcyAibm9uIGdsb2JhbGx5IHVuaXF1ZSIgZHVwbGlj
YXRlcy4NCj4gDQoNCkNhbiBiZSB3cml0dGVuIHdpdGggbW92aW5nICJub3QiIHRvIHRoZSAybmQg
bGluZSwgaWYgYW55b25lIGNhcmVzIDotDQoNCkFEQVRBIFhQRyBTUEVDVFJJWCBTNDBHIGRyaXZl
cyByZXBvcnQgYm9ndXMgZXVpNjQgdmFsdWVzIHRoYXQgYXBwZWFyIHRvDQpiZSB0aGUgc2FtZSBh
Y3Jvc3MgZHJpdmVzIGluIG9uZSBzeXN0ZW0uIFF1aXJrIHRoZW0gb3V0IHNvIHRoZXkgYXJlIG5v
dA0KbWFya2VkIGFzICJub24gZ2xvYmFsbHkgdW5pcXVlIiBkdXBsaWNhdGVzLg0KDQo+IEJlZm9y
ZToNCj4gWyAgICAyLjI1ODkxOV0gbnZtZSBudm1lMTogcGNpIGZ1bmN0aW9uIDAwMDA6MDY6MDAu
MA0KPiBbICAgIDIuMjY0ODk4XSBudm1lIG52bWUyOiBwY2kgZnVuY3Rpb24gMDAwMDowNTowMC4w
DQo+IFsgICAgMi4zMjMyMzVdIG52bWUgbnZtZTE6IGZhaWxlZCB0byBzZXQgQVBTVCBmZWF0dXJl
ICgyKQ0KPiBbICAgIDIuMzI2MTUzXSBudm1lIG52bWUyOiBmYWlsZWQgdG8gc2V0IEFQU1QgZmVh
dHVyZSAoMikNCj4gWyAgICAyLjMzMzkzNV0gbnZtZSBudm1lMTogYWxsb2NhdGVkIDY0IE1pQiBo
b3N0IG1lbW9yeSBidWZmZXIuDQo+IFsgICAgMi4zMzY0OTJdIG52bWUgbnZtZTI6IGFsbG9jYXRl
ZCA2NCBNaUIgaG9zdCBtZW1vcnkgYnVmZmVyLg0KPiBbICAgIDIuMzM5NjExXSBudm1lIG52bWUx
OiA3LzAvMCBkZWZhdWx0L3JlYWQvcG9sbCBxdWV1ZXMNCj4gWyAgICAyLjM0MTgwNV0gbnZtZSBu
dm1lMjogNy8wLzAgZGVmYXVsdC9yZWFkL3BvbGwgcXVldWVzDQo+IFsgICAgMi4zNDYxMTRdICBu
dm1lMW4xOiBwMQ0KPiBbICAgIDIuMzQ3MTk3XSBudm1lIG52bWUyOiBnbG9iYWxseSBkdXBsaWNh
dGUgSURzIGZvciBuc2lkIDENCj4gQWZ0ZXI6DQo+IFsgICAgMi40Mjc3MTVdIG52bWUgbnZtZTE6
IHBjaSBmdW5jdGlvbiAwMDAwOjA2OjAwLjANCj4gWyAgICAyLjQyNzc3MV0gbnZtZSBudm1lMjog
cGNpIGZ1bmN0aW9uIDAwMDA6MDU6MDAuMA0KPiBbICAgIDIuNDg4MTU0XSBudm1lIG52bWUyOiBm
YWlsZWQgdG8gc2V0IEFQU1QgZmVhdHVyZSAoMikNCj4gWyAgICAyLjQ4OTg5NV0gbnZtZSBudm1l
MTogZmFpbGVkIHRvIHNldCBBUFNUIGZlYXR1cmUgKDIpDQo+IFsgICAgMi40OTg3NzNdIG52bWUg
bnZtZTI6IGFsbG9jYXRlZCA2NCBNaUIgaG9zdCBtZW1vcnkgYnVmZmVyLg0KPiBbICAgIDIuNTAw
NTg3XSBudm1lIG52bWUxOiBhbGxvY2F0ZWQgNjQgTWlCIGhvc3QgbWVtb3J5IGJ1ZmZlci4NCj4g
WyAgICAyLjUwNDExM10gbnZtZSBudm1lMjogNy8wLzAgZGVmYXVsdC9yZWFkL3BvbGwgcXVldWVz
DQo+IFsgICAgMi41MDcwMjZdIG52bWUgbnZtZTE6IDcvMC8wIGRlZmF1bHQvcmVhZC9wb2xsIHF1
ZXVlcw0KPiBbICAgIDIuNTA5NDY3XSBudm1lIG52bWUyOiBJZ25vcmluZyBib2d1cyBOYW1lc3Bh
Y2UgSWRlbnRpZmllcnMNCj4gWyAgICAyLjUxMjgwNF0gbnZtZSBudm1lMTogSWdub3JpbmcgYm9n
dXMgTmFtZXNwYWNlIElkZW50aWZpZXJzDQo+IFsgICAgMi41MTM2OThdICBudm1lMW4xOiBwMQ0K
PiANCj4gU2lnbmVkLW9mZi1ieTogUGFibG8gR3JlY28gPHBncmVjb0BjZW50b3Nwcm9qZWN0Lm9y
Zz4NCj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiAtLS0NCg0KTG9va3MgZ29vZC4N
Cg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1j
aw0KDQoNCg==
