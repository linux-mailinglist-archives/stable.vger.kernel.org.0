Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A78521E13
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbiEJPXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345376AbiEJPWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:22:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0608ABA9BD
        for <stable@vger.kernel.org>; Tue, 10 May 2022 08:06:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9AapQ7/WGnKAzlXuOXDwV/1ct32AiquALi3IEnX0gqzT2rxupjjgkOBdCXRTxRpy2eTwME5AMjbDNMivuXzF+i3PBSTzntYEpzT+4VPQktOC/eDDCEXoDhUNJw7KCvWSO5OozZ1cX86oO/LF3TwaKd0IFZOS8XWO5Ba6ErU/jLFy++7vU9ZHewlmB55FGt+o2Ara/waLyprSD0P7M3qBFqJjYvZS/TpWnl8hhlSSdAK0ol42tQiPyoeovbadXZmWNbC4rkPXnhvdSyGnXm2i4SJEe4/O96R9jqPYEFY6H+4tpJCRl9L6siS7l0nOvASBqLZuCSi1BcR06S/HOuewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FrsBRd1qFGFLL/dW//PLv+nwtU0gn3Q+8atS1JyUDx4=;
 b=oKTJjX29G9IgF0XXpVlvWWRUhAFrTqHZXtI2RaqHo6Yz0MsabYwEoTUGS9ZYPOBMR9QpSNSA8YWRHdKVuLXhRTlIYivtCqWaVA6SAwgKo675Rq4UH3hF6wns8+REv7yEtNCf+CwxNLOAXp4GSHVEKp9IWTOURFJ+cuxOlczpk/YTJexjeubXS/ICi0bYkjYS2a1I4UHUXYftIzvj8BTt7RfTaEoVBukXHIH6Nu9dkaiWZGxUBdh/6nZjlsrp6QT7etRk22HMAgSzphirBxVBvlwursNERWIuCTmKYphuOqr/dAEe5STM4RPALhDVvD7lreJPWpFR0duWYr4SFmNh7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FrsBRd1qFGFLL/dW//PLv+nwtU0gn3Q+8atS1JyUDx4=;
 b=Kps5C/BhIxpR8IwGaz+KfPK9qZXyNhe2aaABf4ocxBa7OSov14649/F9RSBBJMgk2VIQ3urHkSAjsvylXtnwPfUNywIpc2VRB/wvOU4Kqatojvy9UAAgElIyCWh7H28W1OwW1GiZtWB+snZXxlDnEUm39cZ/5KUln4cZ7ny/5sM=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by BY5PR10MB3858.namprd10.prod.outlook.com (2603:10b6:a03:1b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 15:06:29 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::dc1f:39cd:605b:5588%7]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 15:06:29 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "sean.wang@mediatek.com" <sean.wang@mediatek.com>,
        "nbd@nbd.name" <nbd@nbd.name>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Thread-Topic: Please backport to 5.15.x:
 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=602cc0c9618a819ab00ea3c9400742a0ca318380
Thread-Index: AQHYZFAI+01uizJOjUCyscMmeK6+9K0X5nAAgABP/AA=
Date:   Tue, 10 May 2022 15:06:28 +0000
Message-ID: <cb4467d882a293eb46b765517b1eccc2757f4e70.camel@infinera.com>
References: <18d76e36dd24bd03cb470ce6e934533f7ef88b87.camel@infinera.com>
         <Yno8XLdZ+fWZn0ke@kroah.com>
In-Reply-To: <Yno8XLdZ+fWZn0ke@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42d04002-36f9-4ae3-935f-08da3296a915
x-ms-traffictypediagnostic: BY5PR10MB3858:EE_
x-microsoft-antispam-prvs: <BY5PR10MB385829B95CED495759128B5AF4C99@BY5PR10MB3858.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EuDKe6VVF8i8LZd+Ba25vK6zOEAHg9STSsj24WSZqokx5/zcSfNLdFf5sPR/CZ8X3jbYdbTeGfA7TBK6afdn3ukts+vdg0zvnHC/vTUz1lE4J1Fj8Tv8VH63oNXQZVuRePHIxaRPAXnBrKxcbCxVvEfm24NISRrzHKtB/cmra6xSStKscAgCVs1/tpQklscqv6Ah8KCZqau7HF/lIj3F8Gr3kGQyZ1VwlwXNnC1u0etZGlJjqnsd/N83B0xQTecdVJf8yMXhouodG44EQHbgI9pEUdi0PA3k67CXFiTaFdrEHUxjo/IrHxfpNdfTrJC3etWK0J05Y4rGpzDsiu+1lD3yMmh7vSpP8VrI6nNFsq3OT2tk/ivKzXOkeyDslqUZh4500VpLYNRPZRsmI6ZBSLphBD1jxHUfPFMQOx5ZG4JfYlVOwEUGn5Ij7NXTAMAaCOw3LHvzQ0hHY9qCXoQKasBKJ0RUPw28NrfbTHGFr68WzDuE8JkEyi0zsBxSUGZ07n9u05eu6F8UHrJ3aNr8PWNwEbtF0tWH3VP3hLi3Bzw6UF4Z8HJ5A77u3SRBRl46AbYrTJOjIu5kCw1y3bmNoEIybWrrdt/G7B5KRE7II9iSzlXZ0BIeD+RK6xx/Q0pLBwE6SYZsv21CC4rZ+wMfJESIhSgR+C/cgCiAqpkKe1nu0EdlkUNnZ9PV6G+tVGIaA5CJ+5bvg/8gODAWq0kWU3E/AQfn5Dk8X6fj2I6PABzX6vmzjfDLpNHbrpsm0/NoWC3sbwRwZd6xsPNujMsLqPNPm67MnniC9PxQlY+3wjA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(966005)(45080400002)(26005)(6512007)(508600001)(71200400001)(316002)(186003)(6486002)(86362001)(6506007)(5660300002)(2906002)(122000001)(83380400001)(36756003)(91956017)(76116006)(64756008)(54906003)(66446008)(66476007)(66946007)(66556008)(6916009)(4326008)(8676002)(38100700002)(38070700005)(8936002)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0JjUW9oZ3dtdE5UcDFtbnZ4Qk5YNC9PVFhEdlA1SGY2OEQyNE9sWUI1SGIr?=
 =?utf-8?B?Zm00TnpkNnlsZ3AvTWtYSTRYZzVzVTUwSHR3SGo1dmRETm5hK3ZDeW9FanJW?=
 =?utf-8?B?a1JlZUowTVRCbWQwMEovdUtoUnJRc2YzS0dwTDBDNWsvYkgxOUROQitjZWR6?=
 =?utf-8?B?OGZ0bVcyZnJhdXFnUmdLeEJPQmE0cTZpZEt2a2lIdnVLb3NHQmlYR2xXUk1F?=
 =?utf-8?B?TkNpWUk1cDFjOW5sVEJrREF1TEIvYWJFSTROa29xbEF4Y0ZDdmV4MXlLRWd1?=
 =?utf-8?B?SkZyYk5oN0I5WUNvZmlaeGRrWkQxL0xkZERMTGNpVW9XUlMyTlZhNVkxa1RN?=
 =?utf-8?B?VEJPQ1dUeFMyNHQxTFVOS2NzZG1tRFhqQzVjMS8xZzRlWEFyMTBwTGlWQWxl?=
 =?utf-8?B?T09IVlVBYTU4ZkV0M1BmbjQ5b0FIaUp3M3p2NUkwZ1hSUGhMMy9tSmFiMkEv?=
 =?utf-8?B?WC8wWGJORkxQZTBycFgyMGlENXA3MDdPbkx1ZlUrdC9IRGVyYk9Icm1JODRM?=
 =?utf-8?B?UWZLOW9SaHNva2poUVdxOWpQTVI1WXdOTEp6VnBNTkZFaUZNeWFQak1FTlY1?=
 =?utf-8?B?TVRVMWxmMU8xNXpBek9ZazVBTURYVEQzaHNXbWtBaUEraEpKYmx4UXpOYWZn?=
 =?utf-8?B?c2lucGlWVlFwYUFJaC9PSnhBVDVCODJkbmlDN1d4MGJhemhwOXJyL05zVGhw?=
 =?utf-8?B?NEZOcVhTSXI0K01oS1RKZ0dVTkJUNmhaL0p1VU96M3p3RmJQTVhhVXpwNml1?=
 =?utf-8?B?cVp6MStVYkNoMWQvN05LeEtFMzdYdURnS2Y5SG5jc2JqVlNud2VmNkdvZ3dY?=
 =?utf-8?B?M2ZVdWk5d012VG91QWVBZFY2TXVSOThzZlF1Vy85R0F4V01LOXMrK0daT09u?=
 =?utf-8?B?S0JKZFNoWmFDQ2s5a3dyMDBHNUJ6dll2WlVLb2FXZUZkd0NGVlNPSlZBZ0xZ?=
 =?utf-8?B?SVJ1WmhydUdRVzBnUzk1MVdkN3puVFhuZm9FV093Tk9UZyt6VkZ2czRXY2pt?=
 =?utf-8?B?QUppVk1DcENTRzhGSXNTelo4Rlc1RVY0NXlPRHJUUGk0SmM0eWt6TzlWWkUz?=
 =?utf-8?B?RHFUV0ZFMzQ3WFgvcFUzNUZyZFIvMkJVL1cwbUQ5MUp2OHJWSFd0NjJTYTZW?=
 =?utf-8?B?OG1KVFF1UlE1KzZhTDBoRFkrREQzKzdBeTNIOU5FdTF5OTNmcVl5ZUJucDdx?=
 =?utf-8?B?cTlTTEZrREMwVWVCcWprdW5GallHaTdrNFhYUUlKMUNqQTAzNTlTTXpRZWpy?=
 =?utf-8?B?aVlXNWFNbG1rQmNPNEcvL3hhRitqVnZFN3ZvcjRJaG14enNidW54WHJhQnFu?=
 =?utf-8?B?UHlzQ3RKSmd5QmxaSzQ4b1J5dXNUWEZuTCtjOGx4K1dkNUNTclVZbW1qa05i?=
 =?utf-8?B?L205eEZZSmlrRkFrRUlxWWpYQWJFZFV5aFV2OEFNai9rRHhOSzRENHdQNmgv?=
 =?utf-8?B?Ukh2T1ZIUWJBeDd4U0JkYlNSRWVGVGdNVm1DV3B6a1dJK0FuTUp0TWd2T2Fv?=
 =?utf-8?B?bHNhRXcxdk1wK2JSS1ZBMEdKdHB6RmgySWp5cGlTT0Q1VkZ3ZTZmVUhyUit6?=
 =?utf-8?B?Y3Zjd0I4K0lJejk1WnBUU2NNSjhhWmNrZ2kraSszREN3KzRqSWFHaW5YeVU4?=
 =?utf-8?B?bTFTSGVoVlVyUjgvUUpCVm9UNTBzTEpybDMxSUExVmhONEdFdEhMaTNHVFky?=
 =?utf-8?B?a3gyUWl5Qm9sbHpRS2FUNFQ5eGZCZUZTOGVKWlhpZm1WN0pEN012bTR2TjRm?=
 =?utf-8?B?SGNkbnd3Z0lhSloyQW5oTG85R3VoS1ltbTVISWFtYlZNM1VxMGcwZ3UyREow?=
 =?utf-8?B?RGt5NjY2TkJPSnlTcndlbXBjUzRWeiszc3o0QW5aUW5XeFQzM2F2cTE1bHZH?=
 =?utf-8?B?ZE5hRGR6WWx3VHZFeURMRDRhenUvZ2RhWld4MVZxUGtXUld5YkV2bm1UT05W?=
 =?utf-8?B?MVZ6bzRzS0d0ZEYwT01CdVQ1OGZSUTA0ZHNiQ1lGQ2U1QWdmQVNwMGorU3Zv?=
 =?utf-8?B?RWdxc3NHaGNVbmhwaC85ZWRCZ0dyK0ltMHl3UUo0RW9WSUF1eEJ3bFVWTjdk?=
 =?utf-8?B?ZUpudmdNekxhSzJodThBYlJhdVpCcWtaVjYzNmxQelljUWoxcVlveDdBQnhD?=
 =?utf-8?B?RU1Mc1JnK2dpdmtUN3FDNXFCRkpLU0FIRm9GalZ1UEdKOEtlakd2SEdxYmho?=
 =?utf-8?B?dkx5c3dCU3pGczJBVkV0QkszbUE1eDF4anFiUEhkNG5yNmtsQnlaR1h6SXVi?=
 =?utf-8?B?TCtWY0dGWjNERS9vSkpFRGM3UGpySHA1SGh0ZVZIQUN5dDNJeTZ6QkVueVRt?=
 =?utf-8?B?MjZJQkhBdElDamhOdDBpNUJreFQzS1pHd1BEd3dGZ3BVQ1FGYml3WjYrWGo0?=
 =?utf-8?Q?81eYa6XX6lYZPwlM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C12AB1DAC2464F46941C0878F64C5745@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42d04002-36f9-4ae3-935f-08da3296a915
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 15:06:28.9436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X5o0CNVo+Buye84uz27QU/5idwtoBt22iIcH5V9MBLuc+DMr6GQWd/8DRJIiiZanpgRaRwhY5bGuGBWU67LAaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3858
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDEyOjIwICswMjAwLCBHcmVnIEtIIHdyb3RlOg0KPiBPbiBU
dWUsIE1heSAxMCwgMjAyMiBhdCAwOToyNjozMUFNICswMDAwLCBKb2FraW0gVGplcm5sdW5kIHdy
b3RlOg0KPiA+IGh0dHBzOi8vbmFtMTEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20v
P3VybD1odHRwcyUzQSUyRiUyRmdpdC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJGbGludXglMkZr
ZXJuZWwlMkZnaXQlMkZzdGFibGUlMkZsaW51eC5naXQlMkZjb21taXQlMkYlM0ZpZCUzRDYwMmNj
MGM5NjE4YTgxOWFiMDBlYTNjOTQwMDc0MmEwY2EzMTgzODAmYW1wO2RhdGE9MDUlN0MwMSU3Q0pv
YWtpbS5UamVybmx1bmQlNDBpbmZpbmVyYS5jb20lN0M1OWZhMTI2YmNhMGM0MDRjNWUxZTA4ZGEz
MjZlYWYxZSU3QzI4NTY0M2RlNWY1YjRiMDNhMTUzMGFlMmRjOGFhZjc3JTdDMSU3QzAlN0M2Mzc4
Nzc3NDgyMDkyODUxNDMlN0NVbmtub3duJTdDVFdGcGJHWnNiM2Q4ZXlKV0lqb2lNQzR3TGpBd01E
QWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwMCU3
QyU3QyU3QyZhbXA7c2RhdGE9Q0dzd3dKaTExelBuQ25VTGxiNnNPUmg0dmxsTkU4MEslMkZDN0JB
cmY4YzdJJTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gDQo+ID4gSSBzZWUgdGhpcyBlcnJvciBvbiBU
aGlua1BhZCBUMTQgR2VuIDJhDQo+IA0KPiBCdXQgdGhhdCBjb21taXQgc2F5cyBpdCBmaXhlcyBj
b21taXQgYmYzNzQ3YWUyZTI1ICgibXQ3NjogbXQ3OTIxOiBlbmFibGUNCj4gYXNwbSBieSBkZWZh
dWx0Iikgd2hpY2ggaXMgaW4gNS4xNiwgbm90IDUuMTUuDQo+IA0KPiBIYXZlIHlvdSB0ZXN0ZWQg
dGhpcyBvbiA1LjE1LnkgdG8gdmVyaWZ5IGl0IHdpbGwgd29yayBwcm9wZXJseT8NCj4gDQo+IHRo
YW5rcywNCj4gDQo+IGdyZWcgay1oDQoNCkkgZ290IHRoZSBzYW1lIGVycm9yL3N5bXB0b21zIGFz
IGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE0NTU3DQp3aGlj
aCBJIGJlbGlldmUgIm10NzY6IG10NzkyMWU6IGZpeCBwb3NzaWJsZSBwcm9iZSBmYWlsdXJlIGFm
dGVyIHJlYm9vdCIgYWRkcmVzc2VkLg0KDQpUaGUgcGF0Y2ggaXMgbm90IHRyaXZpYWwgZm9yIG1l
IHRvIGJhY2twb3J0IHNvIEkgaGF2ZW4ndCB0ZXN0ZWQgaXQuDQoNCk1heWJlIFNlYW4vRmVsaXgg
Y2FuIGNvbW1lbnQ/DQoNCiBKb2NrZQ0K
