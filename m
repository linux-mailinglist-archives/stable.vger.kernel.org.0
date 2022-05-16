Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED09528BE8
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344239AbiEPRZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344220AbiEPRZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:25:00 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8281ECFD;
        Mon, 16 May 2022 10:24:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM9h69cWkfPp4mWTw8v4yjJvJ2nI0Sg5/7eLuH7Z5XsRgi/eUyQnHrtm3UD+DDJtL/Ss+SblYxAY454cPnrKwwm5GoiaJmyW6zUWOFHhlOsD/Pn1/StkYWx+MmaVIdyOyPq45ALpH2pw9RX7h0Qie1NPXyH7CqBQhQtlJgLzr4NNa2LEODahmILOrBMBuyYv6HuZ2mqluPtMSQ4y2JSCaSyvV7WJAZJqrgdlCsQZTED04Vkd2ET4A3cRrdPrUK/ReAFzD1NdJ1VTXqpYFaqoZXn4VmKgoknnHZ4Oa+mWtCiDvxvAVqfptuH6TWq80dfMGwIOJCyVNu2uCz9wBE/6mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFIdozSQoe+5eUNkJC5ieMNeAjTmMrM9WbmW2mXUtiU=;
 b=lGIsDiZnBfnhCqz9+Pf8wCucqAoAaYmsGFjD3qX+3ukwQvedd8AoJWxS6U0JEbp7NDOiCiIDgBHdtpmJhtBgGtXabh3LyEe4AkWDcNJrCQMiyaXXtmNpPzT9+YM1r2oRkAuAsQYVNv0JS6dl5a/xtDBaJFwCrZKbO5XZEsE0EP49PuHrXqvA9PcjNMFqsrndtx6qJY+q0d11Hcq7hH1nTKf4hVWFAJqGmtlYGbjWYyJAFDSgO9XxVzg6f0lyvSwE9Zl5VwbWhzV0Mtmd0rF4qeB2LvmhuKOYIMZt1kBSut1ZkicDoyPNMsrOH1ypVSnDLMwgg87S8YWtpO8HXv3oCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFIdozSQoe+5eUNkJC5ieMNeAjTmMrM9WbmW2mXUtiU=;
 b=QMr5R7d1/JHUSCZNeU68PZwjGxnybGlPYR7mcAvqnMrcuwm+0R62l3f5haHqDx99STQG+FZmKfmLJMDuoEnmADM92Tof8tGdtRowQKIYGsJovp8gTGqFWiG9+/yryM5TFZgts4EuRmc8Be8ZRC81k14/hUQ5ZKUhUdhW8ykxbvM=
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM4PR12MB6109.namprd12.prod.outlook.com (2603:10b6:8:ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 17:24:57 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 17:24:57 +0000
From:   "Kalra, Ashish" <Ashish.Kalra@amd.com>
To:     Peter Gonda <pgonda@google.com>
CC:     "Allen, John" <John.Allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Topic: [PATCH v2] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Thread-Index: AQHYaTwUxoMisTo8TEW3VgseD18R+K0hp6QAgAABb8CAABTegIAAAVcA
Date:   Mon, 16 May 2022 17:24:57 +0000
Message-ID: <SN6PR12MB2767B4A3919E38C7F429CC2D8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
References: <20220516154512.259759-1-john.allen@amd.com>
 <CAMkAt6oUxUFtNS4W0bzu13oWMdfnzfNrphH3OqwAkmxJcXhOqw@mail.gmail.com>
 <SN6PR12MB27678261F176C5D9B5BF64EF8ECF9@SN6PR12MB2767.namprd12.prod.outlook.com>
 <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
In-Reply-To: <CAMkAt6q7kTGS5QgZRq9xc0HaEYyntmj3GRWehr-3Sb4y2eQ=HQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2022-05-16T17:17:53Z;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=cfc92ac2-a318-45bb-9d77-11ad4299d503;
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=1
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_enabled: true
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_setdate: 2022-05-16T17:24:55Z
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_method: Standard
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_name: General
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_actionid: 8e519a9d-82a3-4257-90f3-603ac85fc4bb
msip_label_4342314e-0df4-4b58-84bf-38bed6170a0f_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 58af57d2-1c5b-496c-ba96-08da3760ffb9
x-ms-traffictypediagnostic: DM4PR12MB6109:EE_
x-microsoft-antispam-prvs: <DM4PR12MB6109C71F656EC1AF6FB6F4698ECF9@DM4PR12MB6109.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t50+UuQgESMe+GsoNXORyfrui7E/hKB9f1oOU/RZ0pGeLEKJoupBudA60lbY2laHpuSETudmQS8/gTJwZFXPIft9Z0bNmSHliJ1W2I6u/PagNTZFWIKYHsSUkBEtCZHKj5/3O9w5W0PaWsdsOfJKsifdNOHW2Nmp5B8kh+yBxHZii5l6JyPJdXRuzCNntLR6DpP+BE7y79M51yl9wHuZA4xo02nrWHXvespor/YkRJGQay+0fXQ278QlrN1wq+T7p89DE4BG7Xf6SX9EUj5tNFtPwXIXMPEUYxHZ/+4riryI/Kkwte59Jm945D7r9s6FXNC4YnuNuvPWjoVmJKVZ5bxeUR9Ld1YmkaUfgwwn3E6sPwoGzqhtyj2gkf7YdXthyPlbWTH/c8xVRTPnOsjViLKfeIv51IvMVj0qS9QZLXUBITY/RvC60LsrTfRehdfzw1yP1P4YgNjrpSlOrRPOxRGyEcmfd5VHP5en/GZzSp5JX5HNNQrQ4ZXJWRSqC1WTPetpWQD506KmDOY3MRa8nCin2rFzrqww1prPYxT0lqarPz38dRrN+L7FucZD8OPKI90khWRZOpYzBYsfbnIKRXjLnK9djVbD4jNpFubfEWHm23LPe+cqDtp7+5YUUn++001fwk2wrLpA/NZZ0uh3Qbu4Zver5ppCm7NkTdCFGR6pvZ3Vf2fN2hZekqivhxZWUKsaPb0Qwa9QarMQBEplcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66946007)(66556008)(4326008)(38070700005)(64756008)(66446008)(66476007)(8676002)(86362001)(54906003)(6916009)(316002)(71200400001)(8936002)(122000001)(52536014)(38100700002)(5660300002)(508600001)(26005)(33656002)(186003)(2906002)(55016003)(83380400001)(6506007)(9686003)(53546011)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Znk5NkRMcjR6T25YYS9KQm82SzJEUVk1RDJmRVlIeXFpUWhOWGNsQmVzZmVt?=
 =?utf-8?B?bXpCR2RRdHppbDJPcnZzeU1yRnlJY0tPazdVR1l2OUlIM3owbmlhbXowVWJ6?=
 =?utf-8?B?SVhmVy9JTWVTeWd1Y054QUdFaGVFQlBLc29XQkkwakdwMXNKWkRCWENjNkc0?=
 =?utf-8?B?c0V4RVZnVm5xZGM3Z0FvOUdXR0RJT2xpaUxRVmt0U1dUcHlTNGFWYjViQnlU?=
 =?utf-8?B?TXU3N1YwRmR6U2NMbDA0cmNrUmc1SEpUWXl5RDRJUDdOUmFpYk5ReWZnTE1N?=
 =?utf-8?B?TmxwR3YyWFhiUkNadnd4VUgrT04zcjliWitQSzZ5UkRVY2h2dVh2WW9aa3I2?=
 =?utf-8?B?eldRZWdqNS9zQUU2Y3hKeWhlMmE3bVVoOHl3NEJYN3JSSmpRMnFOR0hMb1Vs?=
 =?utf-8?B?UHN5aWtUQ0M3UTlYNkdOMCtKWHF1R2RwVG83cXpoY3A0UnQxUElvWlBQK1J1?=
 =?utf-8?B?aXRJMjk4RUdyMENibXB1UGhmVS90NW5nbXkxNGxKVXVZZmRzOFZ5MDNLNlEw?=
 =?utf-8?B?UzlCMlhYR3FmQnB4aWRQS3JkeE5sd0dkTUhYaVIweUZ5Z3ZMKzMvb2F1T2or?=
 =?utf-8?B?V3VDOW5LYlNDTGJwS20wOVVTQVNNZkJtT3orbWc1TFpmdU9KTVBqOG5sRTlw?=
 =?utf-8?B?eUYrcmZuRStabFZxVUFmMjVETkE3bmR0MnEzU1lBWmVKMzNueWJ1b2tFOExs?=
 =?utf-8?B?cDJqcWttQWpzT3pGOG5DeEFxSnFzcmUzdnRCdXYyOUYxRTdkV1A4TUErVjNm?=
 =?utf-8?B?TTVVRnVRUnZYek1aNFVLYjFCeEZTNy83MGxLNUNHVXd1RjQzVm5uUU9HcEtC?=
 =?utf-8?B?MVRvczJDTVNZUm93bkR2a0hsOVNSUGxMZmZWNk9xMW9tWDdlT21GU2FPSVRu?=
 =?utf-8?B?UEl2RnJQRW1JM3NLZUVsWndlTVUyKytoVVBkRWhOTW5BbjlTYlBWdnBsM052?=
 =?utf-8?B?MzdZZGt0SVpNc25qVmNVYmZnWDRpRU0zNzhNZW9EMnVjYWdHeEM1M0xRamhy?=
 =?utf-8?B?aUVkOEU4NjZIOUt5SXVueG15dEdMUG1RdlBzc1EyRnFHSVBrR2VmUlp4K3Va?=
 =?utf-8?B?U2xXM3UvL1hhbDR0V0NsTTEwbGNVUGI3U3kwY2oyUVhIaXVUTlVINE1FRmpH?=
 =?utf-8?B?SFR4L1h0OVRhNSt5Z3hjQmlsU0RKWUhPT3FSZEZkODdMVFJyODJoZUlIWlFM?=
 =?utf-8?B?dVZISU1KTXM4TlVQUFo3YWU1VjlzdFk3ZU5kOUIyUFVybXNib3lhSGJYVCtE?=
 =?utf-8?B?ZUZwRzExa1F2LzZBRnRHTk56SVVtMEVmbERIUWdXbG9EWXZDL3lPdmt6cWlS?=
 =?utf-8?B?YTYveVNJbTNvclZsRFBTRkJRZFViQ1BkSXdsb3N4SHE5N2VmVEpxUWNFT213?=
 =?utf-8?B?eEdnSW10R3ZtcitqOWtZTDg5WGc1dzlWWXRPcjlpdHNTVm53akJoaFVGcjNY?=
 =?utf-8?B?RlZJZkJOOWtjUm50WkFwQnUybGIvK1ZiVnphcFNjZEJnUVhpLzY0UXJoc3VG?=
 =?utf-8?B?RHpmTGY5S0hvRyszQ0tUUVh2WUJZcVRPT3hub1lURUVJMUVHS3pMSlVtaXZJ?=
 =?utf-8?B?QUhoUEo5clFkZlRBTzlWQXZUZTVJQW5lSEFEbHJrZ1MzbEZKaS9mVVRZQVBY?=
 =?utf-8?B?a3VKYnBzSmlpM3pLSE1mNXpIdUJBSkFNTFVEU2J2RnVjZXdSMGhlQ0s1dTcv?=
 =?utf-8?B?L3VpdnIwcVIyc0ZKVGpGOG5va2RwdlFRaTZwUTNVRFJHZFE0K3RCZ2IxbXdZ?=
 =?utf-8?B?VVdMd1FWVHR2SUt3K2dWTy9SS2tjRGlIckJEREJWTXJRVWowQ2FBRFFPYlpR?=
 =?utf-8?B?T1lVOGE2QnpWN3VLb01lU2szSTZva3h2TGhGNk9LUEVpOU9OV2pmb2pmOVhJ?=
 =?utf-8?B?MHB1MnZyM3JHOEg5UFdPdHNKWVNXU254TG9PZklmdXhydzlYRURCQ2ZCaU54?=
 =?utf-8?B?MUpZcWQvRGk3S1J2OWFwa3FmMXhvbnBISnB4SnJGMTRxak5hNGp4b1hxK052?=
 =?utf-8?B?SHgrYkNsQW1BWCtrQ1QxYzBJdk52N1UyOG9mZ2hXdm9neGtJVUN0UjdzeVI3?=
 =?utf-8?B?NGduWXdPRkEzZWsxSDZqOUtwNWcySmpmTGE1TGtaclNwNW9WY2xSb3FEQlc4?=
 =?utf-8?B?endSSW5xWnZkdHRoRWVjREJnenRPdGMwL0lwRUJjdnV2aThvd1l6ZVd4Vldh?=
 =?utf-8?B?YmtqY3lBVjEwNnFJNFZiNFlabTdwVW1sRENmNEZKZURMeG9Sc2FSWkt6WjFD?=
 =?utf-8?B?MW5idk1vT2dEdnRERFpIbVQ3bXg5SFZOTkpId1dsZU5jTjE0R0h4TmtNWTdE?=
 =?utf-8?Q?8g1EApNKE+L25vQRa3?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58af57d2-1c5b-496c-ba96-08da3760ffb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2022 17:24:57.2784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AUXvxxEHx4pHfjIu3nKkAuiCeE9LMUc0Tuh1SM2VRcttxtK7AnxGIPNvRLAT5GK/NhiGb83Vs1t8nOfFjjIDJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6109
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCkhlbGxvIFBldGVyLA0KDQotLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogUGV0ZXIgR29uZGEgPHBnb25kYUBnb29nbGUu
Y29tPiANClNlbnQ6IE1vbmRheSwgTWF5IDE2LCAyMDIyIDEyOjEzIFBNDQpUbzogS2FscmEsIEFz
aGlzaCA8QXNoaXNoLkthbHJhQGFtZC5jb20+DQpDYzogQWxsZW4sIEpvaG4gPEpvaG4uQWxsZW5A
YW1kLmNvbT47IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFwYW5hLm9yZy5hdT47IExpbnV4
IENyeXB0byBNYWlsaW5nIExpc3QgPGxpbnV4LWNyeXB0b0B2Z2VyLmtlcm5lbC5vcmc+OyBTZWFu
IENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT47IExlbmRhY2t5LCBUaG9tYXMgPFRo
b21hcy5MZW5kYWNreUBhbWQuY29tPjsgTEtNTCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zz47IEFuZHkgTmd1eWVuIDx0aGVmbG93QGdvb2dsZS5jb20+OyBEYXZpZCBSaWVudGplcyA8cmll
bnRqZXNAZ29vZ2xlLmNvbT47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJlOiBb
UEFUQ0ggdjJdIGNyeXB0bzogY2NwIC0gVXNlIGt6YWxsb2MgZm9yIHNldiBpb2N0bCBpbnRlcmZh
Y2VzIHRvIHByZXZlbnQga2VybmVsIG1lbW9yeSBsZWFrDQoNCk9uIE1vbiwgTWF5IDE2LCAyMDIy
IGF0IDk6MDIgQU0gS2FscmEsIEFzaGlzaCA8QXNoaXNoLkthbHJhQGFtZC5jb20+IHdyb3RlOg0K
Pg0KPiBbQU1EIE9mZmljaWFsIFVzZSBPbmx5IC0gR2VuZXJhbF0NCj4NCj4gSGVsbG8gUGV0ZXIs
DQo+DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBldGVyIEdvbmRhIDxw
Z29uZGFAZ29vZ2xlLmNvbT4NCj4gU2VudDogTW9uZGF5LCBNYXkgMTYsIDIwMjIgMTA6NTMgQU0N
Cj4gVG86IEFsbGVuLCBKb2huIDxKb2huLkFsbGVuQGFtZC5jb20+DQo+IENjOiBIZXJiZXJ0IFh1
IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBMaW51eCBDcnlwdG8gTWFpbGluZyANCj4g
TGlzdCA8bGludXgtY3J5cHRvQHZnZXIua2VybmVsLm9yZz47IFNlYW4gQ2hyaXN0b3BoZXJzb24g
DQo+IDxzZWFuamNAZ29vZ2xlLmNvbT47IExlbmRhY2t5LCBUaG9tYXMgPFRob21hcy5MZW5kYWNr
eUBhbWQuY29tPjsgDQo+IEthbHJhLCBBc2hpc2ggPEFzaGlzaC5LYWxyYUBhbWQuY29tPjsgTEtN
TCANCj4gPGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBBbmR5IE5ndXllbiA8dGhlZmxv
d0Bnb29nbGUuY29tPjsgDQo+IERhdmlkIFJpZW50amVzIDxyaWVudGplc0Bnb29nbGUuY29tPjsg
c3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYyXSBjcnlwdG86
IGNjcCAtIFVzZSBremFsbG9jIGZvciBzZXYgaW9jdGwgDQo+IGludGVyZmFjZXMgdG8gcHJldmVu
dCBrZXJuZWwgbWVtb3J5IGxlYWsNCj4NCj4gT24gTW9uLCBNYXkgMTYsIDIwMjIgYXQgODo0NiBB
TSBKb2huIEFsbGVuIDxqb2huLmFsbGVuQGFtZC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gRm9yIHNv
bWUgc2V2IGlvY3RsIGludGVyZmFjZXMsIGlucHV0IG1heSBiZSBwYXNzZWQgdGhhdCBpcyBsZXNz
IHRoYW4gDQo+ID4gb3IgZXF1YWwgdG8gU0VWX0ZXX0JMT0JfTUFYX1NJWkUsIGJ1dCBsYXJnZXIg
dGhhbiB0aGUgZGF0YSB0aGF0IFBTUCANCj4gPiBmaXJtd2FyZSByZXR1cm5zLiBJbiB0aGlzIGNh
c2UsIGttYWxsb2Mgd2lsbCBhbGxvY2F0ZSBtZW1vcnkgdGhhdCBpcyANCj4gPiB0aGUgc2l6ZSBv
ZiB0aGUgaW5wdXQgcmF0aGVyIHRoYW4gdGhlIHNpemUgb2YgdGhlIGRhdGEuIFNpbmNlIFBTUCAN
Cj4gPiBmaXJtd2FyZSBkb2Vzbid0IGZ1bGx5IG92ZXJ3cml0ZSB0aGUgYnVmZmVyLCB0aGUgc2V2
IGlvY3RsIA0KPiA+IGludGVyZmFjZXMgd2l0aCB0aGUgaXNzdWUgbWF5IHJldHVybiB1bmluaXRp
YWxpemVkIHNsYWIgbWVtb3J5Lg0KPiA+DQo+ID4gQ3VycmVudGx5LCBhbGwgb2YgdGhlIGlvY3Rs
IGludGVyZmFjZXMgaW4gdGhlIGNjcCBkcml2ZXIgYXJlIHNhZmUsIA0KPiA+IGJ1dCB0byBwcmV2
ZW50IGZ1dHVyZSBwcm9ibGVtcywgY2hhbmdlIGFsbCBpb2N0bCBpbnRlcmZhY2VzIHRoYXQgDQo+
ID4gYWxsb2NhdGUgbWVtb3J5IHdpdGgga21hbGxvYyB0byB1c2Uga3phbGxvYy4NCj4gPg0KPiA+
IEZpeGVzOiBlNzk5MDM1NjA5ZTE1ICgiY3J5cHRvOiBjY3A6IEltcGxlbWVudCBTRVZfUEVLX0NT
UiBpb2N0bA0KPiA+IGNvbW1hbmQiKQ0KPiA+IEZpeGVzOiA3NmEyYjUyNGE0YjFkICgiY3J5cHRv
OiBjY3A6IEltcGxlbWVudCBTRVZfUERIX0NFUlRfRVhQT1JUIA0KPiA+IGlvY3RsIGNvbW1hbmQi
KQ0KPiA+IEZpeGVzOiBkNjExMmVhMGNiMzQ0ICgiY3J5cHRvOiBjY3AgLSBpbnRyb2R1Y2UgU0VW
X0dFVF9JRDIgY29tbWFuZCIpDQo+ID4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBS
ZXBvcnRlZC1ieTogQW5keSBOZ3V5ZW4gPHRoZWZsb3dAZ29vZ2xlLmNvbT4NCj4gPiBTdWdnZXN0
ZWQtYnk6IERhdmlkIFJpZW50amVzIDxyaWVudGplc0Bnb29nbGUuY29tPg0KPiA+IFN1Z2dlc3Rl
ZC1ieTogUGV0ZXIgR29uZGEgPHBnb25kYUBnb29nbGUuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6
IEpvaG4gQWxsZW4gPGpvaG4uYWxsZW5AYW1kLmNvbT4NCj4gPiAtLS0NCj4gPiB2MjoNCj4gPiAg
IC0gQWRkIGZpeGVzIHRhZ3MgYW5kIENDIHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPiAtLS0N
Cj4NCj4NCj4gPnN0YXRpYyBpbnQgc2V2X2lvY3RsX2RvX3BsYXRmb3JtX3N0YXR1cyhzdHJ1Y3Qg
c2V2X2lzc3VlX2NtZCAqYXJncCkgeyANCj4gPnN0cnVjdCBzZXZfdXNlcl9kYXRhX3N0YXR1cyBk
YXRhOyBpbnQgcmV0Ow0KPg0KPiA+cmV0ID0gX19zZXZfZG9fY21kX2xvY2tlZChTRVZfQ01EX1BM
QVRGT1JNX1NUQVRVUywgJmRhdGEsIA0KPiA+JmFyZ3AtPmVycm9yKTsgaWYgKHJldCkgcmV0dXJu
IHJldDsNCj4NCj4gPmlmIChjb3B5X3RvX3VzZXIoKHZvaWQgX191c2VyICopYXJncC0+ZGF0YSwg
JmRhdGEsIHNpemVvZihkYXRhKSkpIHJldCANCj4gPj0gLUVGQVVMVDsNCj4NCj4gPnJldHVybiBy
ZXQ7DQo+ID59DQo+DQo+ID5Xb3VsZCBpdCBiZSBzYWZlciB0byBtZW1zZXQgQGRhdGEgaGVyZSB0
byBhbGwgemVyb3MgdG9vPw0KPg0KPiBJdCB3aWxsIGJlLCBidXQgdGhpcyBjb21tYW5kL2Z1bmN0
aW9uIGlzIHNhZmUgYXMgZmlybXdhcmUgd2lsbCBmaWxsIGluIHRoZSB3aG9sZSBidWZmZXIgaGVy
ZSB3aXRoIHRoZSBQTEFURk9STSBTVEFUVVMgZGF0YSByZXR1bmVkIHRvIHRoZSB1c2VyLg0KDQo+
IFRoYXQgZG9lcyBzZWVtIHNhZmUgZm9yIG5vdyBidXQgSSB0aG91Z2h0IHdlIGRlY2lkZWQgaXQg
d291bGQgYmUgcHJ1ZGVudCB0byBub3QgdHJ1c3QgdGhlIFBTUHMgaW1wbGVtZW50YXRpb24gaGVy
ZSBhbmQgY2xlYXIgYWxsIHRoZSBidWZmZXJzIHRoYXQgZXZlbnR1YWxseSBnZXQgc2VudCB0byB1
c2Vyc3BhY2U/DQoNClllcywgYnV0IHRoZSBpc3N1ZSBpcyB3aGVuIHRoZSB1c2VyIHByb2dyYW1z
IGEgYnVmZmVyIHNpemUgbGFyZ2VyIHRoZSBvbmUgZmlsbGVkIGluIGJ5IHRoZSBmaXJtd2FyZS4g
SW4gdGhpcyBjYXNlIGZpcm13YXJlIGlzIGFsd2F5cyBnb2luZyB0byBmaWxsIHVwIHRoZSB3aG9s
ZSBidWZmZXIgd2l0aA0KUExBVEZPUk1fU1RBVFVTIGRhdGEsIHNvIGl0IHdpbGwgYmUgYWx3YXlz
IGJlIHNhZmUuIFRoZSBpc3N1ZSBpcyBtYWlubHkgd2l0aCB0aGUga2VybmVsIHNpZGUgZG9pbmcg
YSBjb3B5X3RvX3VzZXIoKSBiYXNlZCBvbiB1c2VyIHByb2dyYW1tZWQgbGVuZ3RoIGluc3RlYWQg
b2YgdGhlIGZpcm13YXJlDQpyZXR1cm5lZCBidWZmZXIgbGVuZ3RoLg0KDQpUaGFua3MsDQpBc2hp
c2gNCg==
