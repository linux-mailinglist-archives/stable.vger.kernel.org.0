Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B4F4429D0
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 09:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhKBIvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Nov 2021 04:51:06 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:30800
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229577AbhKBIvF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Nov 2021 04:51:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq8RuqBKTx5N7IsM7SPxedprAsNOdLhmEY+nu4dNeVw/SRLqFRW5wg377hVdlUl4BIbj9M6MIwlf3+PEyifYzxlcSxOAice4p+98X3uh/a9MfXACQWeC6NtdK6KueoUZXVkr+y+mwancOeW5iI/W1IAfceHrRKsz1SjBjj1zR4aD5SiM91tCoZ7+LPpRcw+2oZPe2XmMILlqFqlgcSFx2QgpDHzGscC57mfAGcM+ozb63Qq/5NfF6JwHCG0xzWt1KIUhmZPPO2QFC6piXBj5JCYp7+ID2/qbLIX+tTdsHpvb3vcBWDDZ/La9fKsGnkRkavQvz+jD+MuhVO+FLWujwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XM04TBaevGid90G0CuSXb62tOUSZqFOircyN26g3K9Y=;
 b=Sog9ucsvk0g2vxNy7YMpiHrjnI8fvXDUQcfgE2tBQizr4gILJVGtETHd5wEJkns/SRr/fBgquQa6Jd+PSIBxqX4poNF+eRAarWaTU9AWS46mRK8WlTE5e7mbT+MrJvcrmfdNitzcUcmSMvDnIS81Dj8HQfExDAKUjEI0GIwf/rKU0OkwZ3oTUB3VhkgwJV4qAaDdLK2o5UrDkPKNIckMl0UpE0CTUziwqLr+3vU7mgfNd51sVlO4KGSF5EVVdL75mUAA83YWusIrVnRfG+b3hwsmRjUx8DBylRwfefOO6VJtakg+ncWLB15G9zLRcJmsbOxvyruZJkAyQN2ZDTtZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XM04TBaevGid90G0CuSXb62tOUSZqFOircyN26g3K9Y=;
 b=As6QM/DwG8RixzH7cHV5acD9GN/PFPjXLXrQV5Go8MWL3/Z1rJjWjC1sqNzCNJA2SNJ4+GsENt2qVHhg87b3ITaSnrtPB1bhaaRxh47lQHIz+orVWCKMeI+B+/2iuD2wKkX6c9c/If1rxbkYycNU8LRPl2inCs7ar1OqPcV35NU=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by MWHPR05MB2989.namprd05.prod.outlook.com (2603:10b6:300:64::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.5; Tue, 2 Nov
 2021 08:48:27 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 08:48:27 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Oscar Salvador <OSalvador@suse.com>
Subject: Re: [PATCH] mm: fix panic in __alloc_pages
Thread-Topic: [PATCH] mm: fix panic in __alloc_pages
Thread-Index: AQHXz1zvSxS/i+mFgUadpM+6bJvGtavv3QcAgAAG4YD//5TPAA==
Date:   Tue, 2 Nov 2021 08:48:27 +0000
Message-ID: <C69EF2FE-DFF6-492E-AD40-97A53739C3EC@vmware.com>
References: <20211101201312.11589-1-amakhalov@vmware.com>
 <YYDtDkGNylpAgPIS@dhcp22.suse.cz>
 <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
In-Reply-To: <7136c959-63ff-b866-b8e4-f311e0454492@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1afb9ff-81f6-4a49-8271-08d99ddd89cc
x-ms-traffictypediagnostic: MWHPR05MB2989:
x-microsoft-antispam-prvs: <MWHPR05MB2989812C66EAD29FF25E6D31D58B9@MWHPR05MB2989.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7QdaaBhADToIgi7NN52d65Y37fgCUmL0OlhL/Hs2fRWzo18iuaw1oHFGm6s1wLnV4rw9sQDicbyJ3F5FffR/cpN3MuexSA1f0I0pZIJJ02YOUJtCUbbJJ6LQB/5fPclZE0HpICvo/a8vRJWxg7qx4Z4EMhwRPUbljL4KxWaKrTVUmtLZye6RHDZ4bN+bTcwwloQLdyJKwuzrqMd+88o39lheYnlQo0wVhNMeN2tqesU8D+9tFeStq/Jy6qEsw358BZeUXyy2cRFb4zEiOYCn43RAJgO+evXh7OGU4qSZUaItv++i8n2ELHcgPhqEV90OhDgbABgbLwpzBuZ0srANGwuhvoq+BlVQ2o2LGknzC1NGW6rOISaLaYB10J5kdE7n7KbrwTNUk530xK55gQ4Kgyu7i9ixhetjbQmeRiI7wAS0j9HwzevTbm/yafdq/8VKYSwUBOpep5RAmpNAPWPn2bb//tw3dXyEARN4JK8GeXvLY0zX7fQByj6+4/w0SvqJWFlRR8/TtQnewGRSZb3FkG988SzbTMH2TC5f6t+RObzJNfyqoEnnDZuHzVowsQZ+nfo8Bxhm5rCgeA/IRo6R4lLR3zfu197wjJsWHtORPv1Od+pfn2KG/t29KHnP7FiMONe7CfSXLcd2YvoxBbz/4ZGQ5bDIzGNk6eEWY9hrRRVI6V+8HNQNCe9yFYURajGBJwXsNt559z92k5Mm6SJ3GiHNjSvb80VFCoAWn9xXxZxMpUgSRRYVZXYt7LVlBICy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(86362001)(26005)(186003)(2616005)(2906002)(6512007)(8936002)(66946007)(508600001)(83380400001)(316002)(64756008)(5660300002)(66556008)(66446008)(6486002)(110136005)(38070700005)(54906003)(71200400001)(36756003)(122000001)(53546011)(8676002)(6506007)(38100700002)(4326008)(76116006)(66476007)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dXAyTlorS1Y1NkM0V0ZZL2pZMFEyYzdKL2E0cmg1VXNoeFRIRFlwTENnVHZ6?=
 =?utf-8?B?RDlUTzh1aTVjU2NrdlhhSElHUlVsSWVpL2RNUklEVkFrNG1jT2VveEFRYWlu?=
 =?utf-8?B?eHQzMzNNdkNKRWZXVmV3UDA1SURpNC9nYk4vbmEyV3VpMDNtMzJraHg2dU8w?=
 =?utf-8?B?TE5jSTZlVnhRd3cyVWE3TGFleDlnRHlxZXFoVERUOFNmL1Fjd1paSmdSazRX?=
 =?utf-8?B?ZXU2SW9HalNDbUwycnlpZzRXQUQ5S1RyUlZFb282QzYySGFCbldFdUM5Uy9i?=
 =?utf-8?B?cHo3WjhjTTA1R0trUFR3eUVXWWJTSWFvOHIxU2ZWYTdvcjQrNm92cXNjQ05o?=
 =?utf-8?B?RDdyOWlMT0dTaWtmSWFpZ3dIL3IweDBEbXNJR2tPREZiVXZMRnBEN3NLeUs2?=
 =?utf-8?B?YTNIRlZuSXpkb3lzQ2w3T0NxemN4TlNCOUZVZzNzSFVHeWlZVTBtK3plU3R6?=
 =?utf-8?B?WEd3S2trSzB2N3E3R1NsTkZoMUUzdWRpZ3RBdDhINVhlRk92VHZzc2lldW9O?=
 =?utf-8?B?MTV6bjNMUW9GSExhc2g3RlZNSi9YbU9DaXJyMmJsTy9TUS9oQ29WRHRHRk9h?=
 =?utf-8?B?RXpyTThuUmNUMVdHbjdXZzAvVUdJa0Ruem1RRnh1eUorcTN6cWRWZkVJa1hB?=
 =?utf-8?B?SjRyb0U1S25Ed2c5SjhjQ2daMlU1SzBkYzcwZklrYTZDWWxlam1ZKzUzV3Z1?=
 =?utf-8?B?KzE2MmxBSXBmTVgrdEw0WDczZjB2Z1FHYzBYQ3ZhcmJwY240T0h3c0EzU3lN?=
 =?utf-8?B?QS8ydGdlOFFOR3dGY040ZTUvN0Y3ZzkyalQ4TUdUdndncGx6SUN0aDhMbTk5?=
 =?utf-8?B?T2daQzdDUDVMNnpXalBLdlhuU0VHVXUwQWNRakZtM2ZqQUxvcFZwUFU3eVBw?=
 =?utf-8?B?YUhPUjVpSmNnZkpRRDMxamhDalRidDJwK1ZZdFcxNXZTUGkydEpnT1hsekw4?=
 =?utf-8?B?bWxON2V0dm45N3R0bEpsSStCM2dyU0FZcWphTjZxMktzYXU2b2NFT1VWM1ZU?=
 =?utf-8?B?OVRXVmhHWE9iQm9FRHlQY2psUUFxdE1Xc3UySzdsdkZRRlNQTmNxZmVpWk5y?=
 =?utf-8?B?V0ZONktXQTNXbzJzd0FpdXNZKzNBZ1BxME00eVh1TklZSzE2WEZtQk5UNWxP?=
 =?utf-8?B?OWhvcXBTMC92UStwNkQrNnl6UUsyY3dPblc2MmtVRFJYOGVkaGhORTdkd1Rw?=
 =?utf-8?B?TWFtTHFNYXovMjV2OWRYZXkyYXBYS3oxQm5lZUx4ZWQva2FVeTVDUXBSNGVM?=
 =?utf-8?B?VFlCMnMwTHFEUXZ1Y2R6Y3ZtZloya1UvcHlMWG5wOERmRG1FZkdQdmUwUWxE?=
 =?utf-8?B?OW1zdDhBczRTektDcThJM0VDdEJNZFY4VjlSakREYndnc0tXZk9Ea2N5UjJk?=
 =?utf-8?B?MXo3dWhWZmVZWUpkc1BIaE9ZL0pHcGlOdy9wSnZrS240UGJXSjR4MU10ODFp?=
 =?utf-8?B?ZTluYzIzeEt5djhHUVdLUldrR3VGakNXOUc3Unh2emtxOVhyYk5ZTDBHaDBU?=
 =?utf-8?B?MnliZGMwNXZNWTlUMGlmZUhGQ3RnY1NDK09POEJRSFlucHUwOTMrZURidWlT?=
 =?utf-8?B?VjBFTGZkSURwUzc2MmJRWTY1ampiYzlYRUsvdjhMejR6R1VYdHkvWEQ2R2lN?=
 =?utf-8?B?bVZyYlhhNEZReGkxVWlxVkV1VWYzVGRRK2NlSWFRZDMzRUdLWHMvdnVoS0dy?=
 =?utf-8?B?OTlMdklubGY0KysweUJVZXU5aSsvdmsyTFk2OExIc1JrQUF3bUtQMnIxTEs5?=
 =?utf-8?B?Wml6aVV5TklUTEp0T2dYbktnUWgzcGRLaHUwOG9TcHJTT0RHR2hmbWkzYU1j?=
 =?utf-8?B?dlN5T1NnanVxVHZuWUt3SkpoVlp4VXFNejRFWnQ1bjRmNzBLOHIxR21uOXg2?=
 =?utf-8?B?WXhuRTQ1eURLd2tHazAvbDR3N2Q5b0JPZCtZVDZ4ZkFjOGtvTkFTSENsSWwr?=
 =?utf-8?B?Qi81Y0lkclVBbzU5NEZUSk9wSUo1NEl1Sm5Ja3cyaHc5a1RubGtKUnBaaDBB?=
 =?utf-8?B?Z21JTHV4QmZ2M2t5cDljNWJPOHRCT1VQSU84OFJrbFNDUFlSRVllMlhZWGVu?=
 =?utf-8?B?RlRsRElhTnZEZDN6d3JHY1A3Ry9uSXo4NzRRdHhpRmpCNW5QcjYrM2ZGOWtp?=
 =?utf-8?B?dmhERUVrQ0RtN0ZhSWZxVEJZUGhHMkxvRVJzOUZteHBON2NLSmo4V3Z5Z29W?=
 =?utf-8?Q?LhfZNrx59Hb/qBF9c3sI1LY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C24AC720ADFB9642B0582D6229E6C4EE@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1afb9ff-81f6-4a49-8271-08d99ddd89cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 08:48:27.3251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDVmOlssBhkPYxWr8252FZ0VNdRAW5XfH37ypJ0YoQkX1qw5K6lncp9CxxhZhFfL3QJtqttulV6Krot9pQZqsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR05MB2989
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCu+7v09uIDExLzIvMjEsIDE6MTIgQU0sICJEYXZpZCBIaWxkZW5icmFuZCIgPGRhdmlkQHJl
ZGhhdC5jb20+IHdyb3RlOg0KDQpUaGFua3MgZm9yIHJldmlld3MsDQoNCiAgICBPbiAwMi4xMS4y
MSAwODo0NywgTWljaGFsIEhvY2tvIHdyb3RlOg0KICAgID4gW0NDIE9zY2FyIGFuZCBEYXZpZF0N
CiAgICA+IA0KICAgID4gT24gTW9uIDAxLTExLTIxIDEzOjEzOjEyLCBBbGV4ZXkgTWFraGFsb3Yg
d3JvdGU6DQogICAgPj4gVGhlcmUgaXMgYSBrZXJuZWwgcGFuaWMgY2F1c2VkIGJ5IF9fYWxsb2Nf
cGFnZXMoKSBhY2Nlc3NpbmcNCiAgICA+PiB1bmluaXRpYWxpemVkIE5PREVfREFUQShuaWQpLiBV
bmluaXRpYWxpemVkIG5vZGUgZGF0YSBleGlzdHMNCiAgICA+PiBkdXJpbmcgdGhlIHRpbWUgd2hl
biBDUFUgd2l0aCBtZW1vcnlsZXNzIG5vZGUgd2FzIGFkZGVkIGJ1dA0KICAgID4+IG5vdCBvbmxp
bmVkIHlldC4gUGFuaWMgY2FuIGJlIGVhc3kgcmVwcm9kdWNlZCBieSBkaXNhYmxpbmcNCiAgICA+
PiB1ZGV2IHJ1bGUgZm9yIGF1dG9tYXRpYyBvbmxpbmluZyBob3QgYWRkZWQgQ1BVIGZvbGxvd2Vk
IGJ5DQogICAgPj4gQ1BVIHdpdGggbWVtb3J5bGVzcyBub2RlIGhvdCBhZGQuDQogICAgPj4NCiAg
ICA+PiBUaGlzIGlzIGEgcGFuaWMgY2F1c2VkIGJ5IHBlcmNwdSBjb2RlIGRvaW5nIGFsbG9jYXRp
b25zIGZvcg0KICAgID4+IGFsbCBwb3NzaWJsZSBDUFVzIGFuZCBoaXR0aW5nIHRoaXMgaXNzdWU6
DQogICAgPj4NCiAgICA+PiAgQ1BVMiBoYXMgYmVlbiBob3QtYWRkZWQNCiAgICA+PiAgQlVHOiB1
bmFibGUgdG8gaGFuZGxlIHBhZ2UgZmF1bHQgZm9yIGFkZHJlc3M6IDAwMDAwMDAwMDAwMDE2MDgN
CiAgICA+PiAgI1BGOiBzdXBlcnZpc29yIHJlYWQgYWNjZXNzIGluIGtlcm5lbCBtb2RlDQogICAg
Pj4gICNQRjogZXJyb3JfY29kZSgweDAwMDApIC0gbm90LXByZXNlbnQgcGFnZQ0KICAgID4+ICBQ
R0QgMCBQNEQgMA0KICAgID4+ICBPb3BzOiAwMDAwIFsjMV0gU01QIFBUSQ0KICAgID4+ICBDUFU6
IDAgUElEOiAxIENvbW06IHN5c3RlbWQgVGFpbnRlZDogRyAgICAgICAgICAgIEUgICAgIDUuMTUu
MC1yYzcrICMxMQ0KICAgID4+ICBIYXJkd2FyZSBuYW1lOiBWTXdhcmUsIEluYy4gVk13YXJlNywx
LzQ0MEJYIERlc2t0b3AgUmVmZXJlbmNlIFBsYXRmb3JtLCBCSU9TIFZNVw0KICAgID4+DQogICAg
Pj4gIFJJUDogMDAxMDpfX2FsbG9jX3BhZ2VzKzB4MTI3LzB4MjkwDQogICAgPiANCiAgICA+IENv
dWxkIHlvdSByZXNvbHZlIHRoaXMgaW50byBhIHNwZWNpZmljIGxpbmUgb2YgdGhlIHNvdXJjZSBj
b2RlIHBsZWFzZT8NCiAgICA+IA0KICAgID4+ICBDb2RlOiA0YyA4OSBmMCA1YiA0MSA1YyA0MSA1
ZCA0MSA1ZSA0MSA1ZiA1ZCBjMyA0NCA4OSBlMCA0OCA4YiA1NSBiOCBjMSBlOCAwYyA4MyBlMCAw
MSA4OCA0NSBkMCA0YyA4OSBjOCA0OCA4NSBkMiAwZiA4NSAxYSAwMSAwMCAwMCA8NDU+IDNiIDQx
IDA4IDBmIDgyIDEwIDAxIDAwIDAwIDQ4IDg5IDQ1IGMwIDQ4IDhiIDAwIDQ0IDg5IGUyIDgxIGUy
DQogICAgPj4gIFJTUDogMDAxODpmZmZmYzkwMDAwNmYzYmM4IEVGTEFHUzogMDAwMTAyNDYNCiAg
ICA+PiAgUkFYOiAwMDAwMDAwMDAwMDAxNjAwIFJCWDogMDAwMDAwMDAwMDAwMDAwMCBSQ1g6IDAw
MDAwMDAwMDAwMDAwMDANCiAgICA+PiAgUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAw
MDAwMDAwMDAwMCBSREk6IDAwMDAwMDAwMDAwMDBjYzINCiAgICA+PiAgUkJQOiBmZmZmYzkwMDAw
NmYzYzE4IFIwODogMDAwMDAwMDAwMDAwMDAwMSBSMDk6IDAwMDAwMDAwMDAwMDE2MDANCiAgICA+
PiAgUjEwOiBmZmZmYzkwMDAwNmYzYTQwIFIxMTogZmZmZjg4ODEzYzlmZmZlOCBSMTI6IDAwMDAw
MDAwMDAwMDBjYzINCiAgICA+PiAgUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAwMDAwMDAw
MDAwMDAwMSBSMTU6IDAwMDAwMDAwMDAwMDBjYzINCiAgICA+PiAgRlM6ICAwMDAwN2YyN2VhZDcw
NTAwKDAwMDApIEdTOmZmZmY4ODgwN2NlMDAwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAw
MA0KICAgID4+ICBDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUw
MDMzDQogICAgPj4gIENSMjogMDAwMDAwMDAwMDAwMTYwOCBDUjM6IDAwMDAwMDAwMDU4MmMwMDMg
Q1I0OiAwMDAwMDAwMDAwMTcwNmIwDQogICAgPj4gIENhbGwgVHJhY2U6DQogICAgPj4gICBwY3B1
X2FsbG9jX3BhZ2VzLmNvbnN0cHJvcC4wKzB4ZTQvMHgxYzANCiAgICA+PiAgIHBjcHVfcG9wdWxh
dGVfY2h1bmsrMHgzMy8weGIwDQogICAgPj4gICBwY3B1X2FsbG9jKzB4NGQzLzB4NmYwDQogICAg
Pj4gICBfX2FsbG9jX3BlcmNwdV9nZnArMHhkLzB4MTANCiAgICA+PiAgIGFsbG9jX21lbV9jZ3Jv
dXBfcGVyX25vZGVfaW5mbysweDU0LzB4YjANCiAgICA+PiAgIG1lbV9jZ3JvdXBfYWxsb2MrMHhl
ZC8weDJmMA0KICAgID4+ICAgbWVtX2Nncm91cF9jc3NfYWxsb2MrMHgzMy8weDJmMA0KICAgID4+
ICAgY3NzX2NyZWF0ZSsweDNhLzB4MWYwDQogICAgPj4gICBjZ3JvdXBfYXBwbHlfY29udHJvbF9l
bmFibGUrMHgxMmIvMHgxNTANCiAgICA+PiAgIGNncm91cF9ta2RpcisweGRkLzB4MTEwDQogICAg
Pj4gICBrZXJuZnNfaW9wX21rZGlyKzB4NGYvMHg4MA0KICAgID4+ICAgdmZzX21rZGlyKzB4MTc4
LzB4MjMwDQogICAgPj4gICBkb19ta2RpcmF0KzB4ZmQvMHgxMjANCiAgICA+PiAgIF9feDY0X3N5
c19ta2RpcisweDQ3LzB4NzANCiAgICA+PiAgID8gc3lzY2FsbF9leGl0X3RvX3VzZXJfbW9kZSsw
eDIxLzB4NTANCiAgICA+PiAgIGRvX3N5c2NhbGxfNjQrMHg0My8weDkwDQogICAgPj4gICBlbnRy
eV9TWVNDQUxMXzY0X2FmdGVyX2h3ZnJhbWUrMHg0NC8weGFlDQogICAgPj4NCiAgICA+PiBOb2Rl
IGNhbiBiZSBpbiBvbmUgb2YgdGhlIGZvbGxvd2luZyBzdGF0ZXM6DQogICAgPj4gMS4gbm90IHBy
ZXNlbnQgKG5pZCA9PSBOVU1BX05PX05PREUpDQogICAgPj4gMi4gcHJlc2VudCwgYnV0IG9mZmxp
bmUgKG5pZCA+IE5VTUFfTk9fTk9ERSwgbm9kZV9vbmxpbmUobmlkKSA9PSAwLA0KICAgID4+IAkJ
CQlOT0RFX0RBVEEobmlkKSA9PSBOVUxMKQ0KICAgID4+IDMuIHByZXNlbnQgYW5kIG9ubGluZSAo
bmlkID4gTlVNQV9OT19OT0RFLCBub2RlX29ubGluZShuaWQpID4gMCwNCiAgICA+PiAJCQkJTk9E
RV9EQVRBKG5pZCkgIT0gTlVMTCkNCiAgICA+Pg0KICAgID4+IGFsbG9jX3BhZ2Vfe2J1bGtfYXJy
YXl9bm9kZSgpIGZ1bmN0aW9ucyB2ZXJpZnkgZm9yIG5pZCB2YWxpZGl0eSBvbmx5DQogICAgPj4g
YW5kIGRvIG5vdCBjaGVjayBpZiBuaWQgaXMgb25saW5lLiBFbmhhbmNlZCB2ZXJpZmljYXRpb24g
Y2hlY2sgYWxsb3dzDQogICAgPj4gdG8gaGFuZGxlIHBhZ2UgYWxsb2NhdGlvbiB3aGVuIG5vZGUg
aXMgaW4gMm5kIHN0YXRlLg0KICAgID4gDQogICAgPiBJIGRvIG5vdCB0aGluayB0aGlzIGlzIGEg
Y29ycmVjdCBhcHByb2FjaC4gV2Ugc2hvdWxkIG1ha2Ugc3VyZSB0aGF0IHRoZQ0KICAgID4gcHJv
cGVyIGZhbGxiYWNrIG5vZGUgaXMgdXNlZCBpbnN0ZWFkLiBUaGlzIG1lYW5zIHRoYXQgdGhlIHpv
bmUgbGlzdCBpcw0KICAgID4gaW5pdGlhbGl6ZWQgcHJvcGVybHkuIElJUkMgdGhpcyBoYXMgYmVl
biBhIHByb2JsZW0gaW4gdGhlIHBhc3QgYW5kIGl0DQogICAgPiBoYXMgYmVlbiBmaXhlZC4gVGhl
IGluaXRpYWxpemF0aW9uIGNvZGUgaXMgcXVpdGUgc3VidGxlIHRob3VnaCBzbyBpdCBpcw0KICAg
ID4gcG9zc2libGUgdGhhdCB0aGlzIGdvdCBicm9rZW4gYWdhaW4uDQpUaGlzIGFwcHJvYWNoIGJl
aGF2ZXMgaW4gdGhlIHNhbWUgd2F5IGFzIENQVSB3YXMgbm90IHlldCBhZGRlZC4gKHN0YXRlICMx
KS4NClNvLCB3ZSBjYW4gdGhpbmsgb2Ygc3RhdGUgIzIgYXMgc3RhdGUgIzEgd2hlbiBDUFUgaXMg
bm90IHByZXNlbnQuDQoNCiAgICBJJ20gYSBsaXR0bGUgY29uZnVzZWQ6DQoNCiAgICBJbiBhZGRf
bWVtb3J5X3Jlc291cmNlKCkgd2UgaG90cGx1ZyB0aGUgbmV3IG5vZGUgaWYgcmVxdWlyZWQgYW5k
IHNldCBpdA0KICAgIG9ubGluZS4gTWVtb3J5IG1pZ2h0IGdldCBvbmxpbmVkIGxhdGVyLCB2aWEg
b25saW5lX3BhZ2VzKCkuDQpZb3UgYXJlIGNvcnJlY3QuIEluIGNhc2Ugb2YgbWVtb3J5IGhvdCBh
ZGQsIGl0IGlzIHRydWUuIEJ1dCBpbiBjYXNlIG9mIGFkZGluZw0KQ1BVIHdpdGggbWVtb3J5bGVz
cyBub2RlLCB0cnlfbm9kZV9vbmxpbmUoKSB3aWxsIGJlIGNhbGxlZCBvbmx5IGR1cmluZyBDUFUN
Cm9ubGluaW5nLCBzZWUgY3B1X3VwKCkuDQoNCklzIHRoZXJlIGFueSByZWFzb24gd2h5IHRyeV9v
bmxpbmVfbm9kZSgpIHJlc2lkZXMgaW4gY3B1X3VwKCkgYW5kIG5vdCBpbiBhZGRfY3B1KCk/DQpJ
IHRoaW5rIGl0IHdvdWxkIGJlIGNvcnJlY3QgdG8gb25saW5lIG5vZGUgZHVyaW5nIHRoZSBDUFUg
aG90IGFkZCB0byBhbGlnbiB3aXRoDQptZW1vcnkgaG90IGFkZC4NCg0KICAgIFNvIGFmdGVyIGFk
ZF9tZW1vcnlfcmVzb3VyY2UoKS0+X190cnlfb25saW5lX25vZGUoKSBzdWNjZWVkZWQsIHdlIGhh
dmUNCiAgICBhbiBvbmxpbmUgcGdkYXQgLS0gZXNzZW50aWFsbHkgMy4NCg0KICAgIFRoaXMgcGF0
Y2ggZGV0ZWN0cyBpZiB3ZSdyZSBwYXN0IDMuIGJ1dCBzYXlzIHRoYXQgaXQgcmVwcm9kdWNlZCBi
eQ0KICAgIGRpc2FibGluZyAqbWVtb3J5KiBvbmxpbmluZy4NClRoaXMgaXMgdGhlIGhvdCBhZGRp
bmcgb2YgYm90aCBuZXcgQ1BVIGFuZCBuZXcgX21lbW9yeWxlc3NfIG5vZGUgKHdpdGggQ1BVIG9u
bHkpDQpBbmQgb25saW5pbmcgQ1BVIG1ha2VzIGl0cyBub2RlIG9ubGluZS4gRGlzYWJsaW5nIENQ
VSBvbmxpbmluZyBwdXRzIG5ldyBub2RlDQppbnRvIHN0YXRlICMyLCB3aGljaCBsZWFkcyB0byBy
ZXByby4gICAgDQoNCiAgICBCZWZvcmUgd2Ugb25saW5lIG1lbW9yeSBmb3IgYSBob3RwbHVnZ2Vk
IG5vZGUsIGFsbCB6b25lcyBhcmUgIXBvcHVsYXRlZC4NCiAgICBTbyBvbmNlIHdlIG9ubGluZSBt
ZW1vcnkgZm9yIGEgIXBvcHVsYXRlZCB6b25lIGluIG9ubGluZV9wYWdlcygpLCB3ZQ0KICAgIHRy
aWdnZXIgc2V0dXBfem9uZV9wYWdlc2V0KCkuDQoNCg0KICAgIFRoZSBjb25mdXNpbmcgcGFydCBp
cyB0aGF0IHRoaXMgcGF0Y2ggY2hlY2tzIGZvciAzLiBidXQgc2F5cyBpdCBjYW4gYmUNCiAgICBy
ZXByb2R1Y2VkIGJ5IG5vdCBvbmxpbmluZyAqbWVtb3J5Ki4gVGhlcmUgc2VlbXMgdG8gYmUgc29t
ZXRoaW5nIG1pc3NpbmcuDQoNCiAgICBEbyB3ZSBtYXliZSBuZWVkIGEgcHJvcGVyIHBvcHVsYXRl
ZF96b25lKCkgY2hlY2sgYmVmb3JlIGFjY2Vzc2luZyB6b25lIGRhdGE/DQoNClRoYW5rcywNCi0t
QWxleGV5DQoNCg0K
