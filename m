Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192B92A0D9D
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 19:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgJ3Sjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 14:39:39 -0400
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:58977
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726625AbgJ3Sji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Oct 2020 14:39:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHMOsuV3sisUVqfYGg5UF6U8f0G7/M1ZxUC3CP1QJBuZAKxSA/rlSCI9xkW+SKanxLhjkD7wMMi/4O1o9Mqfu74CfG+fikO+PLSF+/UhZbUhtbDH2myur3jqE1i5DTL+onUyzWLcFC8XcNoi/EuZ85LpkZwv7alenvwAzxNb4dOWDP+dLXrpnwNba0N4SA+QBDUZsoikE6T3OSDb06E1silYQA62keGMnswyJMgEAM9wQawe5xFAX7WwE4ye1Lv4xYVcwvayEVg+P61w41GP+OAAIhs5YUuQnGQp29CrhQiZXkvl/CC8nUCrd5063VRbSnY3ch4fsIWPWEghqrWm1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD+KsBoE89wYiqxRaEzRInzuYTIguSMEljgzGRZ62bs=;
 b=mSmeGJ7YKpPlBsYkwD6R4v8CEBlzUyNPM+nXT0Y3c7CnOW/ibwljJKkVLXtlT9jq6qCbEay3ZTzXYZYe0BfxgkijR4lz4vqEP3hoevitp3DvKZzYAYm16vYz320SPTg526JypwrBnGgxXr3R+4cSXOdlES0YimSjDph4LMw2MLS/ykSPGXpr03e5jtBVSW0xAXpp9UWROyJHg2dtuiOXGPv6Kmq/nFTZD96pzwcLYuuWrJQ8XfW3hQgZr/y9qd+n6z+jh1pf25mwevKkUtFCeZTzrXjLMG1NnUgCIiZQdjF9Evf8RYyi/GVxVVqHw/2V5l1QzehUGyWC6Gq9OX24dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QD+KsBoE89wYiqxRaEzRInzuYTIguSMEljgzGRZ62bs=;
 b=SaBzx+pRZdJpF5lPHAOBYP3Q8eRHEFJWPK0mC/Jk6TB/+M1+1QhDf01uvgkmCR7cyVhdxLndGrlZ9uBY/EvTJcR0DenIiU19ki8HMl1LL76XuqwpEauMUzzw97UoPnaFpKradzn+CNi70MeVvA1BHk9aN+bDm3saArLANo4eWkc=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1398.namprd10.prod.outlook.com
 (2603:10b6:903:30::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 18:39:36 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::a4b0:cd03:3459:6853%2]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 18:39:36 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "miquel.raynal@bootlin.com" <miquel.raynal@bootlin.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Topic: [PATCH] mtd: cfi_cmdset_0002: Use status register where possible
Thread-Index: AQHWqIpTWSfEXw2OaEiocc+ivq8o4KmweGwAgAAOhQA=
Date:   Fri, 30 Oct 2020 18:39:35 +0000
Message-ID: <aefef0187e5ebbe315e57e834ff1ba756ba88817.camel@infinera.com>
References: <20201022154506.17639-1-joakim.tjernlund@infinera.com>
         <20201030184736.4ec434f5@xps13>
In-Reply-To: <20201030184736.4ec434f5@xps13>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 415e5e83-554a-43d2-36db-08d87d0326b2
x-ms-traffictypediagnostic: CY4PR10MB1398:
x-microsoft-antispam-prvs: <CY4PR10MB1398CF5A796790AF19AF8F4AF4150@CY4PR10MB1398.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ENB6h4Baehfo35Dj0v0BAhkFxiYdQiDPyfbppHpVL9mnY5xjOOf02bTBT1rURgjVit0Xh6lCVjmD/a+FFmC9ntk6gABfamxdTM3y0cpWQdDJSdh7J/N3dHbmWy0pLEwfMG/zCRgpd9GO5ND2qjkhSBfa638wc/EFOglOz8SDUL3vRV//uVmfVBQARFLyhKpMar9HGAonOjugSHxJPBRckf3nnfMljuq1uGjSPiUP5UQJIsEf2qzz3M0tatb0fo0Vsya0FH54Tdr6nCYzDXrRfAfoJusHV1orlnFgLYAGUALqf1a6hxwiEJv78ucAaS9lenN56XJWe2ALsSdE1aiWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(5660300002)(4744005)(54906003)(478600001)(71200400001)(66476007)(6486002)(66556008)(64756008)(316002)(66946007)(66446008)(91956017)(76116006)(2616005)(4001150100001)(186003)(6512007)(8936002)(2906002)(36756003)(8676002)(6916009)(26005)(86362001)(4326008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zH50pg0dS1wKwdWhf9PyDOabYzZfCasin82WkLndsSNUrJlJ7CO5VyWCmrJMfFVM4TY4D1nCDT5+6iP+6QaQuFZbntw6zSrg+XqRXtEvlGskm2GPaNAar7sx2Hk5rSyLanaK/vJUH2GVlizwKSW3sKKoy5IW3/QV7LghZeA+hZCOTzLRv95+4Pkry4mfzXNaVUlcSPOxsjQJI3BimdFe40w4RBS2B2PkoMR75eKQ8WNtveNUkg89Hfizeiw4fV37tJ2iinE63tRq5gHQcravjFTJjKvyjHlq1ncpw2sEw9ueTcK2LBVyAXvsBbzlF34VEGrlNf3dK0GBiIBYLNSCcUpoxENDShVgavX3yFS+dIaIUspP2m9PokaxHAK8SgoagN5i7NknLXVhK50SMYATgzqjLJnEfpQsMxw+1mtrl28Z4uFEWi4UESNw+ILvpo3X5ZkXyp1jJ6AsEIMA8CeQDAfmOItj7RyGJbpudegJJ2WM+YBuU6w27hbffvET8nmfW8k0A+GZH3NNH/5VVRl+ozOQsn4VhblqCGDwwnVYJw6r7DkzKtn/ccuecHg6AkC/h8wliFmpf2ewqqDupBTNhSug0Luj8qvA27m7fzba4+h5eC8KEiFLYOtM2/DkNvqHOPPT9clsv53mfQ+0uvRKnQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <158E47E8AAC0444885D1EB4BCB9D5B6C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415e5e83-554a-43d2-36db-08d87d0326b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 18:39:35.8623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lLHGeuLckQfNQlv5AHH2ZLj72uGWFTbeViq90Jm3qX7/5xWf67e3mbtaTQjqMyKH3N57cWqz/KfDeJslr2cBFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1398
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTMwIGF0IDE4OjQ3ICswMTAwLCBNaXF1ZWwgUmF5bmFsIHdyb3RlOg0K
PiANCj4gSGkgSm9ha2ltLA0KDQpIaSBNaXF1ZWwNCg0KPiANCj4gUGxlYXNlIENjIHRoZSBNVEQg
bWFpbnRhaW5lcnMsIG5vdCBvbmx5IHRoZSBsaXN0IChnZXRfbWFpbnRhaW5lcnMucGwpLg0KDQpJ
IGZpZ3VyZSBhbGwgbWFpbnRhaW5lcnMgYXJlIG9uIHRoZSBsaXN0ID8NCg0KPiANCj4gSm9ha2lt
IFRqZXJubHVuZCA8am9ha2ltLnRqZXJubHVuZEBpbmZpbmVyYS5jb20+IHdyb3RlIG9uIFRodSwg
MjIgT2N0DQo+IDIwMjAgMTc6NDU6MDYgKzAyMDA6DQo+IA0KPiA+IENvbW1pdCAibXRkOiBjZmlf
Y21kc2V0XzAwMDI6IEFkZCBzdXBwb3J0IGZvciBwb2xsaW5nIHN0YXR1cyByZWdpc3RlciINCj4g
PiBhZGRlZCBzdXBwb3J0IGZvciBwb2xsaW5nIHRoZSBzdGF0dXMgcmF0aGVyIHRoYW4gdXNpbmcg
RFEgcG9sbGluZy4NCj4gPiBIb3dldmVyLCBzdGF0dXMgcmVnaXN0ZXIgaXMgdXNlZCBvbmx5IHdo
ZW4gRFEgcG9sbGluZyBpcyBtaXNzaW5nLg0KPiA+IExldHMgdXNlIHN0YXR1cyByZWdpc3RlciB3
aGVuIGF2YWlsYWJsZSBhcyBpdCBpcyBzdXBlcmlvciB0byBEUSBwb2xsaW5nLg0KPiA+IA0KPiAN
Cj4gSSB3aWxsIGxldCB2aWduZXNoIGNvbW1lbnQgYWJvdXQgdGhlIGNvbnRlbnQgKGxvb2tzIGZp
bmUgYnkgbWUpIGJ1dCB5b3Ugd2lsbA0KPiBuZWVkIGEgRml4ZXMgdGFnIGhlcmUuDQoNClRoaXMg
aXMgbm90IGEgRml4ZXMgc2l0dWF0aW9uLCBubyBidWcganVzdCBhIGh3IGVuYWJsaW5nIHRoaW5n
Lg0KQWxzbywgSSB3b3VsZCBsaWtlIHRvIHNlZSB0aGUgU3RhdHVzIHBhdGNoZXMgYmUgYmFja3Bv
cnRlZCB0byA0LjE5IGFzIHdlbGwuDQoNCiBKb2NrZQ0K
