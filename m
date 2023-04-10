Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F3F6DCCB1
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 23:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjDJVSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 17:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDJVSG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 17:18:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93706E43;
        Mon, 10 Apr 2023 14:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681161483; x=1712697483;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=UvaseFH2g0t/3H29th/muPBc4x//tKLoTKLmuhYBEjc=;
  b=PSFz6i4VCRb1I+D6X6hHWntbM6HmdQXIzmvPC2QN4LFH3VSABW4FgLrK
   i1bKK5xd8JoBNxGfFSavLFo4U05ofZnkjmrLbla7h9tzpWP56qZ7ObjE8
   eBscpg/r/YMntGSYwo5ju8rH+Ub6MAcapf+qMFLbnLeJJgkBp3TKkmY4a
   tFZ6/lswEE1mGYtKusyyzUaPLTs3yOQ7MWuwZI9hB6st2f/sDfBOT7qOK
   2jNNkkLdDyCUDh5q5CnRQdVF9spPTDLILnnMw0PlRl6M+nScuJ6jH1xZN
   ftgdCiesc+6Yhlgw/3486aoVLhPHDGPqc/J3qeMDGDuKnvv1mu4LcvWqO
   g==;
X-IronPort-AV: E=Sophos;i="5.98,333,1673938800"; 
   d="scan'208";a="208937777"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Apr 2023 14:18:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 10 Apr 2023 14:18:02 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Mon, 10 Apr 2023 14:18:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQUdKlAcXNdICwsRwfzdZV3+YLBcClqP3d+1AinFizItClMThWgOwDYDhu+ioDECsI+fjVpSuFAYpjHbngzZDGfINz4pGg1I4mT+S1z+53YuktL61k1gqqrH6iNPdBvi92sl3/pWdJDd6/kPZnMDTHqgqF0dpHhAvCBmQNONXU/MvatP+/iIWC06+lmC0/OeoBYCHND2x4tn/SBQpnoLIW0BNs39i1Xv/gbxj2CBitRZ3Y869uGhc+epLOh85XYZueh6SONi4aNs30W3IKpjJEiU60olphuiY9LxCXv/8cyjeYxcxypxK+SVL97OzIzAsucISY0bNrQYIG/JVb7iUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvaseFH2g0t/3H29th/muPBc4x//tKLoTKLmuhYBEjc=;
 b=ARKkoLNwbMQNiiXj4qR5eWtZN3vSc/Bpukc9Q6hc2L7pDwyb5d3VtiiR9h9KWKDERv4nW0ie56YgHbGkzj+DwHaDbPv0sXV7TTyiHOd6O3H6IoKpYHQTHj9gu9B/NKd4J0iltW5f81sTYP/mBJxpXWrn2GEd2Xti4tXTyfR4PQgygKI4LF9zHnl12O7+yjDhSKHYGc53CETy4ztiH0a1Vm8H+Ss7J0yDH5XR3y9jAnQ2gGIitjAtCwspHFl2CagDGECSr3v7RGEZrnaAw7lPD/3JF2SUPTXyTsSyO1o93484JZo9KMhCbPDBR1RWJlYhi3f5B2htNsS5PMDRI6QxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvaseFH2g0t/3H29th/muPBc4x//tKLoTKLmuhYBEjc=;
 b=IPWG/MVlYod4eFv3DBX/+nVtZpYsgp6f8YzjkCJVvkqVuM1Nt4BfJYdxwGodnFlu4x9Vda1QMLPBZvG4HXNpVb23lh9Ht9xEd7WAU2PEKADumkBU3QFBG8ILtbHDP+FqIMwGzMP+kI+t3MAUesH2PEBpsCVTc45BuX7uIhoUhK4=
Received: from BYAPR11MB3606.namprd11.prod.outlook.com (2603:10b6:a03:b5::25)
 by CH0PR11MB5692.namprd11.prod.outlook.com (2603:10b6:610:111::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Mon, 10 Apr
 2023 21:18:00 +0000
Received: from BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::9393:4ac0:f1bd:1c1f]) by BYAPR11MB3606.namprd11.prod.outlook.com
 ([fe80::9393:4ac0:f1bd:1c1f%4]) with mapi id 15.20.6277.035; Mon, 10 Apr 2023
 21:17:59 +0000
From:   <Sagar.Biradar@microchip.com>
To:     <john.g.garry@oracle.com>, <Don.Brace@microchip.com>,
        <Gilbert.Wu@microchip.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <brking@linux.vnet.ibm.com>, <stable@vger.kernel.org>,
        <Tom.White@microchip.com>
Subject: RE: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Topic: [PATCH] aacraid: reply queue mapping to CPUs based of IRQ
 affinity
Thread-Index: AQHZYb4PYBI21vPRIUeRtFcfEd9THa8RVvYAgBPI3YA=
Date:   Mon, 10 Apr 2023 21:17:59 +0000
Message-ID: <BYAPR11MB3606BFE903D1BBE56C89D31BFA959@BYAPR11MB3606.namprd11.prod.outlook.com>
References: <20230328214124.26419-1-sagar.biradar@microchip.com>
 <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
In-Reply-To: <3bce4faf-e843-914c-4822-784188e3436e@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3606:EE_|CH0PR11MB5692:EE_
x-ms-office365-filtering-correlation-id: 81873835-bc25-4d39-a4d0-08db3a090f79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZdebJGDeZIzjqFgqb9ireGNjXac5JZasshIrGDsFUtEiz4t3URIXNhVdJEd+ACCvz0DeccJ6Cc6vdI6TrSdmSGNMeEDk5cVECIsEcqiUFcN2/zGoC9nZPRF+Txx0BHrtxUh34NynD4BngJwLsIIiat/PzO2kJiSJ67liMUvfk2qJuMKz7d2W1lGsrRydMgIIqwkE3XO3J/98UzicWIx0TCfmSKZP8GJkgFKWl6rubAC3uN857cPw6lMEp6YsMtPgK/WL3CPdwgoYUNUztaQBKFo0GLgLmdOO4n5s2i3KtOm5hxmq7O8U0zq+Lrs8W1wTNhOqI6ldQym9k5ih/dQBTZHs0/j55JvFPwu4woU80yhxhC3nB8Miullu9GvX0W/RdahKbG4xiFPK04NL/KGBNApyATVExWVW3F2TPmfkNtau1wRJs6zOWzQhAbIDXGxHaJ9n5pScU4PnVyFEt/ZmZ8TX2XV+m54ybYpAa0SYl/A6qqOoIh1ewQBwxlDTUvCy9EiT5l/HkwafWAtJpEOVYTAxb3Q7TT6yXn35RXC1Xryy+QzPedQ7k+nvvDAd8s4e+kI2M2ZZZXx5NXxx6LY4MGNJeGeIeE6t8JMi2nuIBA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3606.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199021)(71200400001)(7696005)(478600001)(55016003)(86362001)(33656002)(83380400001)(16799955002)(122000001)(38100700002)(38070700005)(2906002)(110136005)(9686003)(53546011)(316002)(6636002)(186003)(26005)(6506007)(66476007)(66446008)(41300700001)(8676002)(66556008)(64756008)(52536014)(8936002)(5660300002)(66946007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmVtRlpvNnFiSzRJNVFnbXljQ1BGMmhscy8ycDNlUVVCaUdMZWE3cFlUK25T?=
 =?utf-8?B?a25SSnpEWHRGVGFaMXVOMmthUDJuUnZhOVIyaDUrM3dLZENnUi9Pd3Y1SnYy?=
 =?utf-8?B?QjJLYmdQYS9rUkpsOEY5Y2NyZlhUeGxIcE53Nko1NVl3TzNDRjl2WVhGcDVD?=
 =?utf-8?B?bTA1SDFvL2VUU2xsRjY3L3ZUdlVReU9VYXBKeTNNTnBZNEczNzR5ais1RGZS?=
 =?utf-8?B?WUR1L0IrcE14a3R5ZUlVV3hIUTlRZnZyd1EvUW9IdVQ1K2ZxdHM4UWlpc2lt?=
 =?utf-8?B?b09OZnAwM1dOMll5ZE5TK2paUDdQcENEM1FLeE1ReFNDb2VMai9EaTF6c0ww?=
 =?utf-8?B?K2VoK0tTc2t6L2dsenkyaUU4dXV3NUFMTWRZN3AyMm50VTVUUjlTaklmUWtR?=
 =?utf-8?B?K3RHa1ZzcXBCejkzY3dLSmhmWUlQMkIyUm43ajNlZjRCdnMybHd2dytxUm5Q?=
 =?utf-8?B?Y0Q5YXA1T0R1L083eStQb2h2MEFmZ3F3Q2YwR3RSVGNkMDRsSnV3ek5mQjdl?=
 =?utf-8?B?VDBlWnpLOFdQa2M0OUdRZ1A2Rm01QkZJQ1laU0F2eXNUdUNuYzAzYlVscjdG?=
 =?utf-8?B?WFNiS2RHbFdZWDk3VVF0ZW11K0FpYzhhR3pVRkdPWUkrbHl3VVZXeG5RZmt2?=
 =?utf-8?B?NGw5cVFpUW0rMlltdHcyaEFJNFJrMkhnRmlDUk9zSVVRcDhMVW1NMDdDWG9x?=
 =?utf-8?B?Z2IranNhbW1wd3licW51WXBFNzB3TDBrK2hKYmM5NnJCUkk2czh4N2wvbnVv?=
 =?utf-8?B?QWpYSk5Bdmd5TmRFL3RaM1B2M0o5S0VWNllVNDhVdjBadE83M1JlVzdUNnJE?=
 =?utf-8?B?eDhpZXVuYVQ2NGtScmxqYy9QdElOdktpOE9lOVpqK01Tejc2cVNVWkg5SWVv?=
 =?utf-8?B?T0xtQ1RvR0U5UnZTTlhMd1FCQmVzSzhGdzJ5ZWFpdVJLc3E4UXIvaExKck4x?=
 =?utf-8?B?N3VtUVJnVmRMdVNQVjQ1M2YwZ093K3k5OWpNdWNjemxXbnZQVy9ZWWE0WHRI?=
 =?utf-8?B?eGw4MDZtSjlibFZuNzl3Q3REUjl6U2E0aEQvQzAyby9PSmlDQ1krTzVkR3d5?=
 =?utf-8?B?Qy8xenAzcTdWMDZhVzNiWmdqR1pvczFkN0dYS1MreEtHRzRBcEt6ZnVZRHk2?=
 =?utf-8?B?VzFONi8veXcwZDhRRFMzWURUeWRpZkVaeldwWHNnMElwd3pudFV0cVhBSXJB?=
 =?utf-8?B?V1p1dXM2TTJaSzZnVjFleW8vNlZoVlhJL29VR0dIVk8vV0xLd1RJQ2hKUlUx?=
 =?utf-8?B?MWtzaTB6QUxVNkZ1RzVQVXM1cU1mRUYrcWljR2x5b0haSjVSaGYzSXBsRWxv?=
 =?utf-8?B?NktDeEcvSHBlcFdqcTh2QzBpNkpJZE10THUyMG9hZ1JzcGc3RlE2eFV3c2hn?=
 =?utf-8?B?YnJxakg1L1lhNjkwK0dQWUp2MDltelE1QU13andYUGZZOFkxTDBYSHlVbjlh?=
 =?utf-8?B?Qng5QTE3cThzYms0UStabTR0UUQ5cC96UU1XU3F1NEFsVDRYckF6OVB0b0lS?=
 =?utf-8?B?emx2VFJlQmZqT3ZTL3pxUTFmQjI0KzZ5aTVHOXM5ZDhBWlVGMHIzeVc3bSt0?=
 =?utf-8?B?SWhRR2dIL2IxdFNSSml2YUpVNTFEQkgzL2NlWko4V3N6UC9aNDhIZjZtNUp3?=
 =?utf-8?B?bG1tZVR0VzIvUHYwTkd5dnhOZlRnMytFTWVFd1g0R0loZXMzd3ZhMW11eGV0?=
 =?utf-8?B?MVNzaEdBZDlFTVhqc2lyaklKRGdzbzBSa211Mk9MQVNiSlVZN0dhbTRZckhN?=
 =?utf-8?B?R1pnWDJpck02eDBGQzJYZVIvVitraVZ0SHJiZ2hmZkUxV1JBc0FoZDU3VEdH?=
 =?utf-8?B?SURvRXJadzlmZGNtOGRjcG9Xamk5VmpHeHZFZ3hJSmppajk4WGdxTlRFNXdz?=
 =?utf-8?B?b0ppNml6UTRRRDNKSzZGSkkraysvMkMyZnkzeENCWlEzZFZmb3hsbjlLUkV3?=
 =?utf-8?B?SDJaNjQ3cisvV3ppeWZsYTRaaTllN0hJY1RKUCttTzhaclVmbzNYNWpEWnVx?=
 =?utf-8?B?a2pLcTBkcTJiczVpcUwxUUgxZ0ZMWG14b3poVmhRY2RtMkZUckd3NXd6ZDND?=
 =?utf-8?B?NlgrQkpyK0lRcGQ1dk8wT3RwaDNCRFgzdkMrNCtXQzMzTXhBMkZFek9oZUxa?=
 =?utf-8?Q?a6/nMVPV5rWspCuB12rEjDK17?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3606.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81873835-bc25-4d39-a4d0-08db3a090f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2023 21:17:59.1470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y93nnylGoyk07vWr8rTy7A7rTQ76ZYhFYdnkXVv+yx14XrnuJypzdum2YjMxkPZtNz6aLUw76R+prV5NiR13Kmtl9Gsv7cgMux1oDzbw/F0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5692
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBKb2huIEdhcnJ5IDxqb2huLmcu
Z2FycnlAb3JhY2xlLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIE1hcmNoIDI5LCAyMDIzIDEyOjA4
IEFNDQpUbzogU2FnYXIgQmlyYWRhciAtIEMzNDI0OSA8U2FnYXIuQmlyYWRhckBtaWNyb2NoaXAu
Y29tPjsgRG9uIEJyYWNlIC0gQzMzNzA2IDxEb24uQnJhY2VAbWljcm9jaGlwLmNvbT47IEdpbGJl
cnQgV3UgLSBDMzM1MDQgPEdpbGJlcnQuV3VAbWljcm9jaGlwLmNvbT47IGxpbnV4LXNjc2lAdmdl
ci5rZXJuZWwub3JnOyBNYXJ0aW4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29t
PjsgSmFtZXMgQm90dG9tbGV5IDxqZWpiQGxpbnV4LmlibS5jb20+OyBCcmlhbiBLaW5nIDxicmtp
bmdAbGludXgudm5ldC5pYm0uY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZzsgVG9tIFdoaXRl
IC0gQzMzNTAzIDxUb20uV2hpdGVAbWljcm9jaGlwLmNvbT4NClN1YmplY3Q6IFJlOiBbUEFUQ0hd
IGFhY3JhaWQ6IHJlcGx5IHF1ZXVlIG1hcHBpbmcgdG8gQ1BVcyBiYXNlZCBvZiBJUlEgYWZmaW5p
dHkNCg0KRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1l
bnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQoNCk9uIDI4LzAzLzIwMjMg
MjI6NDEsIFNhZ2FyIEJpcmFkYXIgd3JvdGU6DQo+IEZpeCB0aGUgSU8gaGFuZyB0aGF0IGFyaXNl
cyBiZWNhdXNlIG9mIE1TSXggdmVjdG9yIG5vdCBoYXZpbmcgYSBtYXBwZWQgDQo+IG9ubGluZSBD
UFUgdXBvbiByZWNlaXZpbmcgY29tcGxldGlvbi4NCg0KV2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRh
cmdldGVkIGdvZXMgb2ZmbGluZSB3aGlsZSB0aGUgSU8gaXMgaW4tZmxpZ2h0Pw0KDQo+IFRoaXMg
cGF0Y2ggc2V0cyB1cCBhIHJlcGx5IHF1ZXVlIG1hcHBpbmcgdG8gQ1BVcyBiYXNlZCBvbiB0aGUg
SVJRIA0KPiBhZmZpbml0eSByZXRyaWV2ZWQgdXNpbmcgcGNpX2lycV9nZXRfYWZmaW5pdHkoKSBB
UEkuDQo+DQoNCmJsay1tcSBhbHJlYWR5IGRvZXMgd2hhdCB5b3Ugd2FudCBoZXJlLCBpbmNsdWRp
bmcgaGFuZGxpbmcgZm9yIHRoZSBjYXNlIEkgbWVudGlvbiBhYm92ZS4gSXQgbWFpbnRhaW5zIGEg
Q1BVIC0+IEhXIHF1ZXVlIG1hcHBpbmcsIGFuZCB1c2luZyBhIHJlcGx5IG1hcCBpbiB0aGUgTExE
IGlzIHRoZSBvbGQgd2F5IG9mIGRvaW5nIHRoaXMuDQoNCkNvdWxkIHlvdSBpbnN0ZWFkIGZvbGxv
dyB0aGUgZXhhbXBsZSBpbiBjb21taXQgNjY0ZjBkY2UyMDU4ICgic2NzaToNCm1wdDNzYXM6IEFk
ZCBzdXBwb3J0IGZvciBzaGFyZWQgaG9zdCB0YWdzZXQgZm9yIENQVSBob3RwbHVnIiksIGFuZCBl
eHBvc2UgdGhlIEhXIHF1ZXVlcyB0byB0aGUgdXBwZXIgbGF5ZXI/IFlvdSBjYW4gYWx0ZXJuYXRp
dmVseSBjaGVjayB0aGUgZXhhbXBsZSBvZiBhbnkgU0NTSSBkcml2ZXIgd2hpY2ggc2V0cyBzaG9z
dC0+aG9zdF90YWdzZXQgZm9yIHRoaXMuDQoNClRoYW5rcywNCkpvaG4NCltTYWdhciBCaXJhZGFy
XSANCg0KKioqV2hhdCBhYm91dCBpZiB0aGUgQ1BVIHRhcmdldGVkIGdvZXMgb2ZmbGluZSB3aGls
ZSB0aGUgSU8gaXMgaW4tZmxpZ2h0Pw0KV2UgcmFuIG11bHRpcGxlIHJhbmRvbSBjYXNlcyB3aXRo
IHRoZSBJTydzIHJ1bm5pbmcgaW4gcGFyYWxsZWwgYW5kIGRpc2FibGluZyBsb2FkLWJlYXJpbmcg
Q1BVJ3MuIFdlIHNhdyB0aGF0IHRoZSBsb2FkIHdhcyB0cmFuc2ZlcnJlZCB0byB0aGUgb3RoZXIg
b25saW5lIENQVXMgc3VjY2Vzc2Z1bGx5IGV2ZXJ5IHRpbWUuDQpUaGUgc2FtZSB3YXMgdGVzdGVk
IGF0IHZlbmRvciBhbmQgdGhlaXIgY3VzdG9tZXIgc2l0ZSAtIHRoZXkgZGlkIG5vdCBzZWUgYW55
IGlzc3VlcyB0b28uDQoNCg0KKioqYmxrLW1xIGFscmVhZHkgZG9lcyB3aGF0IHlvdSB3YW50IGhl
cmUsIGluY2x1ZGluZyBoYW5kbGluZyBmb3IgdGhlIGNhc2UgSSBtZW50aW9uIGFib3ZlLiBJdCBt
YWludGFpbnMgYSBDUFUgLT4gSFcgcXVldWUgbWFwcGluZywgYW5kIHVzaW5nIGEgcmVwbHkgbWFw
IGluIHRoZSBMTEQgaXMgdGhlIG9sZCB3YXkgb2YgZG9pbmcgdGhpcy4NCldlIGFsc28gdHJpZWQg
aW1wbGVtZW50aW5nIHRoZSBibGstbXEgbWVjaGFuaXNtIGluIHRoZSBkcml2ZXIgYW5kIHdlIHNh
dyBjb21tYW5kIHRpbWVvdXRzLiANClRoZSBmaXJtd2FyZSBoYXMgbGltaXRhdGlvbiBvZiBmaXhl
ZCBudW1iZXIgb2YgcXVldWVzIHBlciB2ZWN0b3IgYW5kIHRoZSBibGstbXEgY2hhbmdlcyB3b3Vs
ZCBzYXR1cmF0ZSB0aGF0IGxpbWl0Lg0KVGhhdCBhbnN3ZXJzIHRoZSBwb3NzaWJsZSBjb21tYW5k
IHRpbWVvdXQuIA0KDQpBbHNvIHRoaXMgaXMgRU9MIHByb2R1Y3QgYW5kIHRoZXJlIHdpbGwgYmUg
bm8gZmlybXdhcmUgY29kZSBjaGFuZ2VzLiBHaXZlbiB0aGlzLCB3ZSBoYXZlIGRlY2lkZWQgdG8g
c3RpY2sgdG8gdGhlIHJlcGx5X21hcCBtZWNoYW5pc20uDQooaHR0cHM6Ly9zdG9yYWdlLm1pY3Jv
c2VtaS5jb20vZW4tdXMvc3VwcG9ydC9zZXJpZXM4L2luZGV4LnBocCkNCg0KVGhhbmsgeW91IGZv
ciB5b3VyIHJldmlldyBjb21tZW50cyBhbmQgd2UgaG9wZSB5b3Ugd2lsbCByZWNvbnNpZGVyIHRo
ZSBvcmlnaW5hbCBwYXRjaC4NCg0KVGhhbmtzDQpTYWdhcg0KDQo+IFJldmlld2VkLWJ5OiBHaWxi
ZXJ0IFd1IDxnaWxiZXJ0Lnd1QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhZ2Fy
IEJpcmFkYXIgPFNhZ2FyLkJpcmFkYXJAbWljcm9jaGlwLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVy
cy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oICB8ICAxICsNCj4gICBkcml2ZXJzL3Njc2kvYWFjcmFp
ZC9jb21taW5pdC5jIHwgMjUgKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIGRyaXZlcnMv
c2NzaS9hYWNyYWlkL2xpbml0LmMgICAgfCAxMSArKysrKysrKysrKw0KPiAgIGRyaXZlcnMvc2Nz
aS9hYWNyYWlkL3NyYy5jICAgICAgfCAgMiArLQ0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgMzggaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3Np
L2FhY3JhaWQvYWFjcmFpZC5oIA0KPiBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaCBp
bmRleCA1ZTExNWU4YjJiYTQuLjRhMjNmOWZhYjYxZiANCj4gMTAwNjQ0DQo+IC0tLSBhL2RyaXZl
cnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaA0KPiArKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9h
YWNyYWlkLmgNCj4gQEAgLTE2NzgsNiArMTY3OCw3IEBAIHN0cnVjdCBhYWNfZGV2DQo+ICAgICAg
IHUzMiAgICAgICAgICAgICAgICAgICAgIGhhbmRsZV9wY2lfZXJyb3I7DQo+ICAgICAgIGJvb2wg
ICAgICAgICAgICAgICAgICAgIGluaXRfcmVzZXQ7DQo+ICAgICAgIHU4ICAgICAgICAgICAgICAg
ICAgICAgIHNvZnRfcmVzZXRfc3VwcG9ydDsNCj4gKyAgICAgdW5zaWduZWQgaW50ICpyZXBseV9t
YXA7DQo+ICAgfTsNCj4NCj4gICAjZGVmaW5lIGFhY19hZGFwdGVyX2ludGVycnVwdChkZXYpIFwg
ZGlmZiAtLWdpdCANCj4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21taW5pdC5jIGIvZHJpdmVy
cy9zY3NpL2FhY3JhaWQvY29tbWluaXQuYyANCj4gaW5kZXggYmQ5OWM1NDkyYjdkLi42ZmMzMjM4
NDRhMzEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1pbml0LmMNCj4g
KysrIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbWluaXQuYw0KPiBAQCAtMzMsNiArMzMsOCBA
QA0KPg0KPiAgICNpbmNsdWRlICJhYWNyYWlkLmgiDQo+DQo+ICt2b2lkIGFhY19zZXR1cF9yZXBs
eV9tYXAoc3RydWN0IGFhY19kZXYgKmRldik7DQo+ICsNCj4gICBzdHJ1Y3QgYWFjX2NvbW1vbiBh
YWNfY29uZmlnID0gew0KPiAgICAgICAuaXJxX21vZCA9IDENCj4gICB9Ow0KPiBAQCAtNjMwLDYg
KzYzMiw5IEBAIHN0cnVjdCBhYWNfZGV2ICphYWNfaW5pdF9hZGFwdGVyKHN0cnVjdCBhYWNfZGV2
IA0KPiAqZGV2KQ0KPg0KPiAgICAgICBpZiAoYWFjX2lzX3NyYyhkZXYpKQ0KPiAgICAgICAgICAg
ICAgIGFhY19kZWZpbmVfaW50X21vZGUoZGV2KTsNCj4gKw0KPiArICAgICBhYWNfc2V0dXBfcmVw
bHlfbWFwKGRldik7DQo+ICsNCj4gICAgICAgLyoNCj4gICAgICAgICogICAgICBPayBub3cgaW5p
dCB0aGUgY29tbXVuaWNhdGlvbiBzdWJzeXN0ZW0NCj4gICAgICAgICovDQo+IEBAIC02NTgsMyAr
NjYzLDIzIEBAIHN0cnVjdCBhYWNfZGV2ICphYWNfaW5pdF9hZGFwdGVyKHN0cnVjdCBhYWNfZGV2
ICpkZXYpDQo+ICAgICAgIHJldHVybiBkZXY7DQo+ICAgfQ0KPg0KPiArdm9pZCBhYWNfc2V0dXBf
cmVwbHlfbWFwKHN0cnVjdCBhYWNfZGV2ICpkZXYpIHsNCj4gKyAgICAgY29uc3Qgc3RydWN0IGNw
dW1hc2sgKm1hc2s7DQo+ICsgICAgIHVuc2lnbmVkIGludCBpLCBjcHUgPSAxOw0KPiArDQo+ICsg
ICAgIGZvciAoaSA9IDE7IGkgPCBkZXYtPm1heF9tc2l4OyBpKyspIHsNCj4gKyAgICAgICAgICAg
ICBtYXNrID0gcGNpX2lycV9nZXRfYWZmaW5pdHkoZGV2LT5wZGV2LCBpKTsNCj4gKyAgICAgICAg
ICAgICBpZiAoIW1hc2spDQo+ICsgICAgICAgICAgICAgICAgICAgICBnb3RvIGZhbGxiYWNrOw0K
PiArDQo+ICsgICAgICAgICAgICAgZm9yX2VhY2hfY3B1KGNwdSwgbWFzaykgew0KPiArICAgICAg
ICAgICAgICAgICAgICAgZGV2LT5yZXBseV9tYXBbY3B1XSA9IGk7DQo+ICsgICAgICAgICAgICAg
fQ0KPiArICAgICB9DQo+ICsgICAgIHJldHVybjsNCj4gKw0KPiArZmFsbGJhY2s6DQo+ICsgICAg
IGZvcl9lYWNoX3Bvc3NpYmxlX2NwdShjcHUpDQo+ICsgICAgICAgICAgICAgZGV2LT5yZXBseV9t
YXBbY3B1XSA9IDA7IH0NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xpbml0
LmMgDQo+IGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYyBpbmRleCA1YmE1YzE4Yjc3YjQu
LmFmNjBjN2QyNjQwNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQu
Yw0KPiArKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jDQo+IEBAIC0xNjY4LDYgKzE2
NjgsMTQgQEAgc3RhdGljIGludCBhYWNfcHJvYmVfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBj
b25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpDQo+ICAgICAgICAgICAgICAgZ290byBvdXRf
ZnJlZV9ob3N0Ow0KPiAgICAgICB9DQo+DQo+ICsgICAgIGFhYy0+cmVwbHlfbWFwID0ga3phbGxv
YyhzaXplb2YodW5zaWduZWQgaW50KSAqIG5yX2NwdV9pZHMsDQo+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIEdGUF9LRVJORUwpOw0KPiArICAgICBpZiAoIWFhYy0+cmVwbHlfbWFwKSB7
DQo+ICsgICAgICAgICAgICAgZXJyb3IgPSAtRU5PTUVNOw0KPiArICAgICAgICAgICAgIGRldl9l
cnIoJnBkZXYtPmRldiwgInJlcGx5X21hcCBhbGxvY2F0aW9uIGZhaWxlZFxuIik7DQo+ICsgICAg
ICAgICAgICAgZ290byBvdXRfZnJlZV9ob3N0Ow0KPiArICAgICB9DQo+ICsNCj4gICAgICAgc3Bp
bl9sb2NrX2luaXQoJmFhYy0+ZmliX2xvY2spOw0KPg0KPiAgICAgICBtdXRleF9pbml0KCZhYWMt
PmlvY3RsX211dGV4KTsNCj4gQEAgLTE3OTcsNiArMTgwNSw4IEBAIHN0YXRpYyBpbnQgYWFjX3By
b2JlX29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQg
KmlkKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFhYy0+Y29tbV9hZGRyLCBh
YWMtPmNvbW1fcGh5cyk7DQo+ICAgICAgIGtmcmVlKGFhYy0+cXVldWVzKTsNCj4gICAgICAgYWFj
X2FkYXB0ZXJfaW9yZW1hcChhYWMsIDApOw0KPiArICAgICAvKiBCeSBub3cgd2Ugc2hvdWxkIGhh
dmUgY29uZmlndXJlZCB0aGUgcmVwbHlfbWFwICovDQo+ICsgICAgIGtmcmVlKGFhYy0+cmVwbHlf
bWFwKTsNCj4gICAgICAga2ZyZWUoYWFjLT5maWJzKTsNCj4gICAgICAga2ZyZWUoYWFjLT5mc2Ff
ZGV2KTsNCj4gICAgb3V0X2ZyZWVfaG9zdDoNCj4gQEAgLTE5MTgsNiArMTkyOCw3IEBAIHN0YXRp
YyB2b2lkIGFhY19yZW1vdmVfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQ0KPg0KPiAgICAgICBh
YWNfYWRhcHRlcl9pb3JlbWFwKGFhYywgMCk7DQo+DQo+ICsgICAgIGtmcmVlKGFhYy0+cmVwbHlf
bWFwKTsNCj4gICAgICAga2ZyZWUoYWFjLT5maWJzKTsNCj4gICAgICAga2ZyZWUoYWFjLT5mc2Ff
ZGV2KTsNCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NyYy5jIGIvZHJp
dmVycy9zY3NpL2FhY3JhaWQvc3JjLmMgDQo+IGluZGV4IDExZWY1ODIwNGU5Ni4uZTg0ZWM2MGE2
NTViIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9zcmMuYw0KPiArKysgYi9k
cml2ZXJzL3Njc2kvYWFjcmFpZC9zcmMuYw0KPiBAQCAtNTA2LDcgKzUwNiw3IEBAIHN0YXRpYyBp
bnQgYWFjX3NyY19kZWxpdmVyX21lc3NhZ2Uoc3RydWN0IGZpYiAqZmliKQ0KPiAgICAgICAgICAg
ICAgICAgICAgICAgJiYgZGV2LT5zYV9maXJtd2FyZSkNCj4gICAgICAgICAgICAgICAgICAgICAg
IHZlY3Rvcl9ubyA9IGFhY19nZXRfdmVjdG9yKGRldik7DQo+ICAgICAgICAgICAgICAgZWxzZQ0K
PiAtICAgICAgICAgICAgICAgICAgICAgdmVjdG9yX25vID0gZmliLT52ZWN0b3Jfbm87DQo+ICsg
ICAgICAgICAgICAgICAgICAgICB2ZWN0b3Jfbm8gPSANCj4gKyBkZXYtPnJlcGx5X21hcFtyYXdf
c21wX3Byb2Nlc3Nvcl9pZCgpXTsNCj4NCj4gICAgICAgICAgICAgICBpZiAobmF0aXZlX2hiYSkg
ew0KPiAgICAgICAgICAgICAgICAgICAgICAgaWYgKGZpYi0+ZmxhZ3MgJiANCj4gRklCX0NPTlRF
WFRfRkxBR19OQVRJVkVfSEJBX1RNRikgew0KDQo=
