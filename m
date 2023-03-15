Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E04036BBFE6
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 23:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbjCOWiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 18:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjCOWiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 18:38:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE332F796;
        Wed, 15 Mar 2023 15:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWpIqIohX22vVz6NW8bUGTxK2qOFTFNHzY43BJhihrWt5FKdveh7mgWKvIhu2l0KHxnUEsuhyn/jS7mAZpWaUEQ5PVkhMyJoLUU9xst9jsH3iT+TyWEF9RjOg7D4p0mjLZZ6s8xB61gF/4pQGfiYhhZH/Umlr9gJUs4fAuegZgPWY0dR+ROHb9zi7N+kwn/ak/pZFlVULy6pBg+3yjyRose6VWG9r3dtZVrUoadyNoXnKy1KqobqNjTpvugaJL+9LPavtMQQ3ELnVnzkgDE719NT6v+EOOOMf4BWwkMnS8TYcz7XswvA+zaI7CKGHXzymveBB/KtnQPvdOo4cW2hvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rvJ5UA3GiETLKmHsopgzKaWOEPTz1Wcu4iU0LDX3GXs=;
 b=U4c4pc8eBqAS/suInF4Czj/HdFyLaiJe9b9oVZM7ov88EymJV3z84+5OSEO+mg6xu0XiAjA+lRM5YTActAQHXLFmUHeCfdE8Nzuy+/iFHZrgjiwCjvpXzSZy1tikvB4GgQWVWYq+22aBeEktCVlLOshMKnxtZpX7gEfyrZZyQIpuC62zYQnNlCkQ1aquOgu1QVKl7ljfkpAC9wxJ4vdE0aKJudX4ImLLrPF0ua9V9gnHythGuVZ6jxG/WCGLFGbmU4zxJzEjFpyNLmiPePWtTLrzO0JY9lKuwzwAb75ERqD7af3Ydhq6vSNLwQPaajl2Lo6prYb+2buSLxHrhb1d7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvJ5UA3GiETLKmHsopgzKaWOEPTz1Wcu4iU0LDX3GXs=;
 b=i3tKH/AbBmY61RDGPRwreSW3Kpt78muPNm4/eS1h1+Uk92nLp1dz5FnbHd0nidrHeRq75WOyzoc/BopzZY0hcYrv7eEh2KQihGARHLPMiKt7L6R9UrxTDCYK7kYNDSE4EfxY9rlshxN/7aXIwlT2ync/D0IFcT77PgUhEixq9PJN1ym/XYTKccJMoG9OoxBuqOvjA11TsOMEL8ny8hENUrm5SDye+jt26qVkX9MHXvguNgMvM21XX5SnI9KAEDS0u0GAllZ95WKIEmjpeIqg3gg2SR0xJdSEf8zsFoDmHssuSPIgMH3/bULterIVJYaBFy/3wC5QthtZ5Ej4RQDpdA==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 22:38:04 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 22:38:04 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung PM173X
Thread-Topic: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Thread-Index: AQHZV46CtojKxk3vM0idzIsv2D3Z0678bn6A
Date:   Wed, 15 Mar 2023 22:38:04 +0000
Message-ID: <6e2f1122-ed1d-1097-874a-0ebb2ad1c26c@nvidia.com>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
In-Reply-To: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|DM4PR12MB6662:EE_
x-ms-office365-filtering-correlation-id: 41365b86-b096-455f-ef54-08db25a5f0ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GojrHDiZKoXmD53N6WbYvYn0kwah+t+IdMJ3nBzWugTpyBj6ILKQsFihlsrCyBnMPXqYbbKsYp7J78wnI3/GNNh76+weLqgzICvPQ98pTpp8T+XQ8D07gi8wqd8OOXc7XvEPdhFCnaeJjx0Ox2UOLXzXU1k3hmvAt49GoGZDKXv375qbLfLfufGHAaQB+eLwuAPtGEyiX3wicaJm5llqJ+agMg0A+FBAKQ5n5rSw+hve0i7n5QRbXVlX+J1xduMLslkuQuC19mdXFz25Ja6xKUXfxB2CyddO5nE8UalUeFtmvKytNRmsqiZdWnegTbd1ZK5vqXHt79M/WxbtuAbJSF5CFBdeobcJTxPa7pcETwjLPh1UY9eLUAMjRGr03fsQ1xTVPsyiKJkZMVpjzDxwXUlj+0vJvCRumyHxyZ9xQ21GMy6NIcyo3gPfp0ljkHjTEeM8XcV/uu+o47LAN8q+W+2CbnRSnnv6zX+IRTBFf5HWMA6M9ObUHYcrtKtXrZPPKywWs2IntsdRkFlcyZenBp/OeCwpzcp44WcdpaEQhWATUet0Mdhtz041oNVRPTCSQegaEgcVYXaO177ULnPkxH/Xci4mIrvLDbUw8fc8b8+luFHbzaUua/c0a9fIg9mKev42bemT6vFranFarzC2A/uqmeXt7NuC3SeJtxwJJlvNdfFnrCDvOQd+9Lz+a2G3IonWoByZnDIB/kDjBm+PXHCowMo8GNqCoaSzEHXeTgywQbBNiWQRHUcCzYsgqaNIKQgvli2NbiKRI7dhKELQWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199018)(5660300002)(41300700001)(4326008)(8936002)(558084003)(38070700005)(36756003)(31696002)(86362001)(122000001)(2906002)(38100700002)(186003)(2616005)(71200400001)(478600001)(6486002)(31686004)(53546011)(6506007)(6512007)(110136005)(91956017)(316002)(66476007)(66446008)(66556008)(8676002)(64756008)(66946007)(76116006)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0FvS0Nma3l5cEJkZks4b0sxdG1SNHdqWjhmY3ArbVBPb3Q2QkNYa3dYRG5G?=
 =?utf-8?B?clp5YVUwemVjVHB1VXJGbzcyME5FNDcxOXpQK2pwK2VsdWQrWU9sZ1htV29y?=
 =?utf-8?B?NVpmUkl1dzdUZGc5YUlaWFAxS0tpd3VzeHJpanhtWEVxc1BFakI3NDRPb2ZT?=
 =?utf-8?B?eWpxRHFrS0Z3d2VZekd4Y1lQSnNwV1lBdVVaRHRqUnF2a2U0c1NaMjBqd2tC?=
 =?utf-8?B?eUlWenJsRVRDZ3JuMWhWSDRYcWlFVXd1WVhaNVZBL2M3WUxiNjVjZHM3blRi?=
 =?utf-8?B?K1hNZ09YbVROb1lKTkJ2UWF3UzljdDl2cTVoRWNOVTQ2cHRuV09Ga2I1WDYz?=
 =?utf-8?B?YUxwcmN0WVpXalovb0p6Ym0yYmp2OWZDZlpkbTc2NDN0QjlJK0lpWDBMazBK?=
 =?utf-8?B?TU5yUExJQkgrVFhpenVqSkVaWS9zRG5UUzh3c0hoNnRFcEJJYy9xWDZpZUVJ?=
 =?utf-8?B?bGZLdHRkSGJsb2FmdjZmMmQ4NlhpKzlKUnRTYnNCQVo0WG1Ga0FYQS9mcFBl?=
 =?utf-8?B?L3hPTHBDREMzdVRDT0g5b29JN3dKVmdienJoYUJyUGxrckU3bCtPWmRkSE9s?=
 =?utf-8?B?empiMEsvRGN5dXUyakU3MEJXQkFJaGJhNmp6Qm9JenJIV0ZCaEh1Q2ZvMUx1?=
 =?utf-8?B?a2YzNmdoZmpXL2tTSWk5N1pGSWk2Nzd2WjRqekNwS1ZuVnJHaDFnYTdKOHJY?=
 =?utf-8?B?blFDeHNORGJNOUtyRjJHQlhMSkMyOG92Ym9ZYWsxWmtzTi9YQjQ0TkxrNUF0?=
 =?utf-8?B?dlppejBZTDAzNFlvQUI5OVpFU0kycUtBWDRIeUZEemJGUFJLWndmODNsaStO?=
 =?utf-8?B?UnZFdkxvYURVRDQ0ZDVWcGtGOTJEWXdONDBpRlYwQW1ZUE5pM1pEa1NXY0xT?=
 =?utf-8?B?SHIyWTlmenc4ZzB5REt4Z2M4bEtYYmV5TkV3OFltUGYxaDVHNGx2bUxOU0Rl?=
 =?utf-8?B?TWdvMHZHVzRidWN6TVk3bC9YemEzdGVCMWFjbEd3NWNKQmNDVjFiVkJKVFcr?=
 =?utf-8?B?V1Jrdms4aERJK3g1ZHpDd01YZDVlVzNsWHlwaWZxNThvMnVBa1pzTlR6NXF5?=
 =?utf-8?B?alB0VXVpdTRla3FOU1Nna1p0ZG5ZdW8zdDc3N29VeEx1M2ZUOTloaXR3ZjlB?=
 =?utf-8?B?TG9ZY1ZwbkhYa2ZWa0Vlank1UjFTRGxJL1lsa0tVcXFwRlp0OTVtRysreHpQ?=
 =?utf-8?B?bjRFOVVmQ0JOa2lwRUdrOU5zemdqVkg4aWxCM3REcUd0aWhqYUdhVTg4bHVp?=
 =?utf-8?B?VndDMEdzK1U2KzNnaUR2bGdzSkRQNWV6aVJXTXByOGdHMEFOWjBIQUZTdkhi?=
 =?utf-8?B?eUZWeGZWb3lOQ2d3SmU4bjViK2ZEOWF1c28wNGxTSXJMVG4rcW9XOGI0eWZX?=
 =?utf-8?B?ZXNWclVpVmZOTmtTeVNnb2pXenZqQWUwL1V6dDhpOWxNclNRZy9xbk1LZUlm?=
 =?utf-8?B?SkVBZ1AxUHh3UCtHYWk4MlA1c3RsNStER252VjdVaDRLOGxxRWxTUTR5L1hL?=
 =?utf-8?B?b1NGREUwZFNsbVZkZTQ1TzlUbkU5ZlFUdVQ2eFExNFNmdERPdFo2eno5ZFNN?=
 =?utf-8?B?ZFhleUprL3BYamUrY2NXSHJlQmJOajZ1MTNybEdDZG9ZYlVsMzZyM3VqZUdh?=
 =?utf-8?B?LzVpZXZ5K0hNcncydndRYWwvZ3pLa09lYWk3bGQ1K2Fxc2MyRmJKOXpoT3FD?=
 =?utf-8?B?a2pCVXVLb29nN0lSOUZOZTZ2WHdrV25aeExwSU13NVpjS0U0TUgwRVVKcjhZ?=
 =?utf-8?B?UzVWZUN3cUFEUm56d3orNWtNZUVSRTZjMlVNcXZJVXBicmFDTVBsaXNEMVdo?=
 =?utf-8?B?LzBiRHhadG9OUlA3cC9XSjh0WmN3dkczajlqdjk4VXFLUUZvK1RDWHM5bGYx?=
 =?utf-8?B?L2hub1Y3OWJ2TDgzWGlvMUxQSi9qa0ZHM2svQ0VEc0FBdU1WZ3FVYmFlOXoz?=
 =?utf-8?B?Rm1BMzAxcDJmclViSzRCaHZtSTBZUkltQzJGVy90cEwzMklsN1dUVEg5ZzFQ?=
 =?utf-8?B?ZWNLdjNSNUN4Q0VKMHMvUVZnWnVxSE0wZWd3RlN6dWFKVW9QTWxJd0tmb2pi?=
 =?utf-8?B?WFZDMmJVVFAzMjE4WEM1c1ZFM1pOZm56ZWw0VzVVcm0rZmpGR3pXWEZESmxP?=
 =?utf-8?B?TjdHc1JlVi81akhSSUJ3S0JJZG5zS3J4TlFXZTVoSU9SVHkzLzFDem4zNWYr?=
 =?utf-8?Q?eL+jX3bqF4j1StVxVTWqFPqtw1e2llX0QWCKJphYzBGv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E54DB603F278D442A7ADEF01F8B6E520@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41365b86-b096-455f-ef54-08db25a5f0ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 22:38:04.4479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8XsUM4IioITNVCbE24bD1cColVjt1blFt8tbNi4Yl0KhkkxIjY1JbevelWYZPKOV+yjQo1S/eDhL/i7Btn1ABg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy8xNS8yMyAxNTozNCwgU2FlZWQgTWlyemFtb2hhbW1hZGkgd3JvdGU6DQo+IFRoaXMgYWRk
cyBhIHF1aXJrIHRvIGZpeCB0aGUgU2Ftc3VuZyBQTTE3MzNhIGFuZCBQTTE3M1ggcmVwb3J0aW5n
DQo+IGJvZ3VzIGV1aTY0IHNvIHRoZXkgYXJlIG5vdCBtYXJrZWQgYXMgIm5vbiBnbG9iYWxseSB1
bmlxdWUiIGR1cGxpY2F0ZXMuDQo+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4g
U2lnbmVkLW9mZi1ieTogU2FlZWQgTWlyemFtb2hhbW1hZGkgPHNhZWVkLm1pcnphbW9oYW1tYWRp
QG9yYWNsZS5jb20+DQo+IC0tLQ0KTG9va3MgZ29vZC4NCg0KUmV2aWV3ZWQtYnk6IENoYWl0YW55
YSBLdWxrYXJuaSA8a2NoQG52aWRpYS5jb20+DQoNCi1jaw0KDQoNCg==
