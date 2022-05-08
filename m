Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E69A351EE61
	for <lists+stable@lfdr.de>; Sun,  8 May 2022 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiEHPAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 May 2022 11:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiEHPAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 May 2022 11:00:51 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2122.outbound.protection.outlook.com [40.107.243.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E3DBE07
        for <stable@vger.kernel.org>; Sun,  8 May 2022 07:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liEwCADH6gdJa67Y6AUxIs8ekYxT5/ap24bJETzucN7Ih8aDH2imd4OzvVb50qEf2Qh1NK+p5iQMUkoMKF+ov8fSJQm5ljEvzkOcVXm7XrV7aUDjNU8yhMUMj/YZpymaUeYUiuodus5RR424AS8FW0CmcPfrA8TlGXyTW0UIFSsJyXkUI+tgiLogS6ZJf+nu3ysFqnddLH52YRpXCcxsC/R/NM4wwMSP2dt7MAYq6+SyMexQ7y0vWK57YktD/h15INRS2y0JWiqjhJ+zLh5TUm2SZ5ki/qITaz+vGtKbBMQF9Zo3onKldREdL0aYWnEJDdQQDp75lp7Ea1sm1aGXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYUwkWrm7RjvwTz3Dq1GlaAq2jHn3wGJ9Ap8a+8d7mY=;
 b=BB8841GDoOnyquoIogwI51JY+2fLMueoJtEI4UywAITBVXWzimaFlvb9a8BENOmrU7k5plZETDhWG/PuIDXJv6wUAyamQhChbYERnYGbn81UU8B6TGugRrbtrYda5xq7BXIdgnHoChghVRjDxEG1xxoEPAmRhPiI/vFvrLkcfm4jOQyQuDP1SbU0Ga+BvMD88isnI/yfgKBvMLdB1wVM6ZcIq1eUZDrsgBD3Znzdk1dA3HMJhumupk6KLgHIt6UDFLTG/oFTtqVvy9qCigWirfnfIrXrqUdry3JPrGgtuVdKHip0a5X1WLgFOjEDzfOxqMruEwE9FmH/7ZnfeZt93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYUwkWrm7RjvwTz3Dq1GlaAq2jHn3wGJ9Ap8a+8d7mY=;
 b=EHu+mH3OXO9OErxcesAtorvrBAOklhRDEiVe4h6acvMx9LEMDcvbA6emOoqJb0PzOA66EpWT9rKTEtPG1Xyk5QuAC47eKxsWCwlp9yVvHdjAvQ6dk2aM/u2LumeXDIq3MXXWZYZYKIpz38BZnJLGqHgll3EEJaP1EBv6bM/m33A=
Received: from CH0PR13MB5084.namprd13.prod.outlook.com (2603:10b6:610:111::7)
 by BYAPR13MB2792.namprd13.prod.outlook.com (2603:10b6:a03:b0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.12; Sun, 8 May
 2022 14:56:55 +0000
Received: from CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5]) by CH0PR13MB5084.namprd13.prod.outlook.com
 ([fe80::694a:6bf0:4537:f3e5%5]) with mapi id 15.20.5250.012; Sun, 8 May 2022
 14:56:54 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "sashal@kernel.org" <sashal@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Please do not apply 892de36fd4a9 ("SUNRPC: Ensure gss-proxy connects
 on setup")
Thread-Topic: Please do not apply 892de36fd4a9 ("SUNRPC: Ensure gss-proxy
 connects on setup")
Thread-Index: AQHYYuvbdLvbuAa+6UWBsvxB8rMczQ==
Date:   Sun, 8 May 2022 14:56:54 +0000
Message-ID: <ac5fa5c1d6eb33628bb528d1e67dc5a45fd7151c.camel@hammerspace.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hammerspace.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05079a44-bd99-4866-ae38-08da3102fde8
x-ms-traffictypediagnostic: BYAPR13MB2792:EE_
x-microsoft-antispam-prvs: <BYAPR13MB2792E97D427FED86C31F5B42B8C79@BYAPR13MB2792.namprd13.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cUR0JJ5Oy01l6OrsyLYS45IHf/o3XXppCcgqB6ZQUnXSVth1PJPjBbvmlkT9S+fr9SEdaaMBzSy/4JR5bOG7dV144SC3e6jmy1xDihnon20xqloGOCdFxVLWeGOd+WONqVCiOSW9hwH3T4HnfCg2apT5vtceqVOCXTMZ3Z3qBx81lztqKbpvg/f5QHeVMiTn567GxD7DH0tSFdqxc71UK5ggxLfseUk/ioD8wPakZ+C7icWrZj+Mrbz1mcUw6f/L3gf0sm9qbu3aJog26QqHND8U3eZRyt5rfyRcXlJPpDOMad3xRHCvd0K+BwK1RIGU5idIT8GN6QEkFT6/WYrtmw4RQnMZ5+hopQUacLQhaXQ7AAKDOKuz+ITwxkvi3iFzQiokojxTI9iL6MzZ9juTAZ6wm4R0jvH7NGiXVdvHSwP6YSQTpaRdtGRc0IAeOq2RYmKCpKP0WoEXYHB5ih+mmpGP3jADypvW6oSANPEA2Ugf1a9MnoN2BMfsQRmhoekrrIS7itXpBiowILDh0DayHme5zDIw5uwuGQ3/aYXjNnlOsPUxeAjdAgfILKYJc/gFeyawnB+Zd+IyQ2o+7OReM3oItyBEW0X699rAhOtm88yH3uoGTQ/saYPutS1wtRnFo3bIVcR3v2EavlXVT1AnE69thCQPoX9TEB1Rnq5/LOfg2d2fN+vzW9vR7Hz7kEd0sBXEoTCdlKYkKqW1OAfEig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR13MB5084.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(2906002)(76116006)(6512007)(36756003)(8676002)(4326008)(64756008)(71200400001)(66446008)(5660300002)(86362001)(66556008)(66476007)(26005)(2616005)(4744005)(66946007)(508600001)(6486002)(38100700002)(38070700005)(110136005)(122000001)(54906003)(186003)(316002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkdoUVFITkpieEhyKytzYThZYWlDelp5ZTVBMXZHK04waUpwNW04bXdURkMw?=
 =?utf-8?B?cjZQV21UNTBBNlI2bi9JaFFEcDRJVDhNK21HUEJaUW1nRmFPQWJKQ2NXREZC?=
 =?utf-8?B?NzhLMSsvQzRJY0V4dXJFQVRkcThub2d2ZWpHUFNsbXJsZXpLT1F3Qlc5dml5?=
 =?utf-8?B?OG4ySDZZV09QdEJtT3BsZElCR2FIS2orS2FOeWlZZ3lvL21pajhwYnkyUzgz?=
 =?utf-8?B?THNlcnFJSGpKVDNORVRaU3F5Z0pkWDQxeWpqcURQYzlSd0JJZVVRWkRjdTBm?=
 =?utf-8?B?ZmlwR1hrNmFGdU04RkVuWWlvVE1NcUNVaUgwaG5zb2wxaHhjSmhObHV1WDlP?=
 =?utf-8?B?NUVxVEZQSmhnL3BNemtMNi9KOS9NRFp2a2NXbXFhTFFCWjliWnRSSkZrdGNF?=
 =?utf-8?B?OWFOeUJlcVdqM08xaWgraVlWdVQ3RTl0TGpoVUlxdlluNGxzWHZYOXZWeGJo?=
 =?utf-8?B?enN1enUxKzUyb3dyRURHaE80RlpYNkpsVlpsZFBTRVlUQ0ROVUZ0Y1IwdGF4?=
 =?utf-8?B?UW9wWERIRkVsWlQzTmY1cDhjRlJqOG1FS2dacVJYRGJrOGJqTlc4RW5jWnph?=
 =?utf-8?B?dklSS2t4Sjdoa3N0OXB3c2tOeUZSdTMvUkgxNjMvc1JCLzAzalBjckZMMDZM?=
 =?utf-8?B?ODJ5WHdhT1dZMTRndjJ2QXQ2Nzl1K0ZjMDRaYy9ITklXVlNjb2hQVXNUUm9O?=
 =?utf-8?B?N3NHcmtFSjNJOGJ2MDhjTk45WkcrZXkwNFBSc0tMQWM3OU5vT2FMQm9UNnAx?=
 =?utf-8?B?dnJFREVmNXltNkpJOXhPU3VMNDA2Y0I3ZkYxL3YwT1hZY3FDOWR6c3MzbzRi?=
 =?utf-8?B?RUpqMG1NK2tyRUpoTmpiQXJaQnhKRkRhdmwvMHZVVTBqT2wxaTNsWHR6NGVq?=
 =?utf-8?B?K0lBN3NlRDFUK2FEcys2Tjl6cUNJdzV4NWxoNmkvem5IRjdNdHlnS3dRRjJt?=
 =?utf-8?B?cjFmM2lrL2FGSngzU2h6VlNtb3VBaFI2VlR0WWdGOTZRbTVnL2dtR2ZNNXd2?=
 =?utf-8?B?MjlzeVJwMTFVTzJZdE5kOHVqakdUanJZb3VUS0hkZ29wT2FtQTJyaUVVTkRJ?=
 =?utf-8?B?NlBqMzcwczlZcVVyMmd0SmJkVUl6S1ppRi9peUp0M21YUjY3ekswQkJtcjQw?=
 =?utf-8?B?UGZZRWhZeDZMbitZR2JJQTVRSUVMOXRjeCswdVFSbDUrZkIzWXI0cHU1cHEx?=
 =?utf-8?B?R3JCUmRPK283dEdWbXJqMGUwcHV6bUZrUlZWVHdTWEdJVjNTRlQ1RW4vSFRS?=
 =?utf-8?B?bVpKZGRTZXo4MGxsRG1VTnJBQW5NRnlUV2VaZWsxVnliT2tTOFJMa09yejJM?=
 =?utf-8?B?bGNQYkNqcFlhYmhoVW5aZnIzT0EzZy9EKzJsMk5COEVxSmU1YlFBREY2amlP?=
 =?utf-8?B?Wmo2bXB4Rk5maWxDbnZoNkdreEVLRThMb3RWNE1UK25zTnJYZE5WUTBMbkFO?=
 =?utf-8?B?R003WE1jME45ZytvMFJGdE54Y1pOcW5EaHJDSjRqQlNNRGlvRktOOW9DeTF6?=
 =?utf-8?B?NU5aYTF5K2dGMlBFcDFhdyt6K3FEQmh6bktEU1NwVzIyMmxhaW5HcVppYUhj?=
 =?utf-8?B?Y1VPeHBwbTN4ZDJ4Q3dzKzc1aUtTWUozQ3JjdEdESmlLZ3ptSUFLNmR4WUFN?=
 =?utf-8?B?bFZpbTZBdHNyME9wclhVQU5ESXZ1VTI4TkZDb2g2SU5FcDgxNngxelhqVHRW?=
 =?utf-8?B?YUlmcy9UZko2Q1BYSVVDL0VpSXFMWEd1MGVsSlJGTjdIRGxDVklOMkpxYUtw?=
 =?utf-8?B?TmJLVDhNS3JXa3BvSVhuVlB2a3FEUDVIaVNZRld0SHpjZHBHcmRTb1BpS0RY?=
 =?utf-8?B?cHFSeGhsTGd2NHlHUXVZOTJVcUdISjN0Ym1LTHkzaFZYL21qdStqOWdDdVJG?=
 =?utf-8?B?M0lsMTJ1VjNZUGdyb1hHTXY3L1Nsd245Y3VRemVjYncweXhoR05qR28zVlho?=
 =?utf-8?B?Um0yS1E2VWh3cnplVjFxd2JkVVFPeWxXK1B0TnZrL1NQblNEbGVJUWtGRUQ2?=
 =?utf-8?B?OFgrVXVxc09wbjFWclBIZ3RDTStXUWNaUERNdWVqV1JlY1Q2dE8xeFRIL2wy?=
 =?utf-8?B?SXUxY0owT1ZQbWx5R3kxZzFqeHRwUUJqaTVZa0ZWWjhBWGgwUHpLYnlPaXRj?=
 =?utf-8?B?WUl3bEx1RTBxTHRSalpBK2xyRmY5SXYzRTZ2aWJoQUFnd3U5ay9lY2tRSTVG?=
 =?utf-8?B?djk2dWcvdjBEa0xwYzZWVGg1eUs5dXBTQ3J1QWdYSitXQjN4UzJaNVhQekU4?=
 =?utf-8?B?ZlR4NVpFVTJaaU82YlF3UktGWCtOZ0RpbW1TeVh3WXphaWdFUitmN1BkMFlj?=
 =?utf-8?B?TzM1ZU1BbTZibC9NOEJRLzVhcTcxeHJBd0lNKzdrNUpyZzg3ZnhZQnJ0aGF5?=
 =?utf-8?Q?rA9Kpum7f8QO9y4A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5CE0F3519DED8419A1BB649586966EB@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR13MB5084.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05079a44-bd99-4866-ae38-08da3102fde8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2022 14:56:54.5614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: exU7GopsrDCNtll2NEZsauaO43hdgKH41ak2QL2wbXk+qVuQZWDqism3WnG9XJCUa4ry0pEzy5RhagZbE0vhOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2792
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZyBhbmQgU2FzaGEsDQoNCg0KSnVzdCBhIGhlYWRzIHVwIHRoYXQgQnJ1Y2UgRmllbGRz
IGZvdW5kIGEgcHJvYmxlbSB3aXRoIG9uZSBvZiB0aGUNCnBhdGNoZXMgaW4gdGhpcyB3ZWVrJ3Mg
TkZTIGNsaWVudCBwdWxsIHRoYXQgd2FzIG1hcmtlZCBmb3Igc3RhYmxlIHBhdGNoDQppbmNsdXNp
b24uDQpUaGUgcGF0Y2ggaW4gcXVlc3Rpb24gaXMgY29tbWl0IDg5MmRlMzZmZDRhOSAoIlNVTlJQ
QzogRW5zdXJlIGdzcy1wcm94eQ0KY29ubmVjdHMgb24gc2V0dXAiKS4gSSdtIHBsYW5uaW5nIG9u
IHJldmVydGluZyBpdCBpbiBMaW51cycgdHJlZSBhbmQgSQ0KaGF2ZSBhIGRpZmZlcmVudCBmaXgg
dGhhdCBpcyBxdWV1ZWQgdXAgYW5kIHRoYXQgd2lsbCByZXBsYWNlIHRoaXMgb25lLg0KDQpIb3Bl
IHRoaXMgY2F0Y2hlcyB5b3UgYmVmb3JlIHlvdSd2ZSBnb25lIHRvIHRoZSB0cm91YmxlIG9mIHF1
ZXVpbmcgaXQNCnVwLi4uDQoNCkFsbCB0aGUgYmVzdCwNCiAgVHJvbmQNCi0tIA0KVHJvbmQgTXlr
bGVidXN0DQpMaW51eCBORlMgY2xpZW50IG1haW50YWluZXIsIEhhbW1lcnNwYWNlDQp0cm9uZC5t
eWtsZWJ1c3RAaGFtbWVyc3BhY2UuY29tDQoNCg0K
