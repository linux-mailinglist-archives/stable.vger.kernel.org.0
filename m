Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D46F6B1353
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 21:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjCHUpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 15:45:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCHUpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 15:45:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A968B05B
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 12:45:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIGtj/YzehEnrHvHiBJECPMcMJQDUl+Jx79IhR+37HFMkA8JuzjKhOTKgzSrE1+Egi8aNVND4shfh0kBvKpI1SXD8ukhNkWITVEZDP6XvWhTvy0Oi/aX6pJW7Fad5nYYLIGTacB6vLvrpyOwXs1dT9dOFnkubZSXuaAiajHVm4Co2nE0BaQ/Luy6NpwtNvQxiPbCuwIgu8J9cqphKdhsZ3uO0eq+I73Nm2p4+Q6R/h9zwziyvUueXCiFLmi00iEJ6Huq1FXF7OY3pPCcNvdbfTj3aF747luqOyKqSpAs6KawuYAAjN8fIMQHvAQCu2zjA02OxES56j8ipN0zYfEEaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pjh3XfK3NcdGCTB8uJjODwYe/XU5NWhLrf4Xn6qGFpY=;
 b=jF8L4v3zxm2y4ApWBedztKMH89rJa4xxaPmhljmR97n004lFq6voXG+L1fV1jmRhfVl3KjprdA3a7V3vmkQ+WM9bldHWIAmqT0A00hLI80+pHFqVL/lWt//jk6/EfwBiazIWN/Qs/NQp04+GdQdoRcA/dDpWE90tYehNCP252rJ9Af6JcRbTYDbPBgbIZuM9uH55+yYB2/vrocy8jNg1U9vmdKHlHCImeKcFAxSZr30M05U2r9ZHzunL+dP1v62U7+zg6A82h6J0f3RAvEKer5MFbHASSS0ajO5QH+iEzRMw2nQ2HBpPLGlgI8B8y9YeapYzPOXOVKgvqLzdsRHmPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pjh3XfK3NcdGCTB8uJjODwYe/XU5NWhLrf4Xn6qGFpY=;
 b=c33b5kWfkYY9YNNB/NfAm0+YpVGAuDgz1ahLkVKwRa4VfGoRjGORqiiN19rt5Wx9ufMDpXHBAqi8xn4znYPmZnwfcrMiayoQ/o4QefZBb3tZAfdnjyoY+we5rr4uRUQX8wAK16dA1ckfcfpGVm0df1iVrMBqE5xSoRUXzP4irHqMl0jPby1X4DQTN0C7abbYAkqPPts1UZhFvqc+2Hff00lUAoQg706ic9ek2sJUWQ1qgqtML0K/0YW3En00BRYZP75nvh2yJyuY4iuZm+iboGdzawJb0NlDYWdcDfoF+FCDfwGge2fnIUgDIMa5O0c3igdcIr6cRojx3nYbIcYAIQ==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 20:45:49 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::4aaa:495:78b4:1d7c%3]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 20:45:49 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Elmer Miroslav Mosher Golovin <miroslav@mishamosher.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000
Thread-Topic: [PATCH] nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV3000
Thread-Index: AQHZUdn9zVtjA+ozdkqnMuuH2GLWsq7xWjgA
Date:   Wed, 8 Mar 2023 20:45:48 +0000
Message-ID: <5a4081d8-ebed-1597-3fba-b7c2ce5f3dde@nvidia.com>
References: <20230308161929.18446-1-miroslav@mishamosher.com>
In-Reply-To: <20230308161929.18446-1-miroslav@mishamosher.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR12MB4667:EE_|CH3PR12MB7571:EE_
x-ms-office365-filtering-correlation-id: a4fb968e-b128-45eb-2286-08db20161948
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W06fI8+FyTtqnolUshIvgQxhFOCfEGK9U2XCwWPLf6cSl3v5cR1d4cqlu8lD8zPgTJ+QyIIzvI3mxlHDq9ZmwJBsWKU964CHyYMtrLSmHazhQdwVx1TNdBhglM/foCP0sg9MTDwiVmP2LpIpBzYUE7x+LZVV5XISuMi+FAvmXL7jTsH4uL/zUY9dGCGtAu9s02CY15k3gujsrnFoXG3ejTvM/IYeCTNQpk8yvvYQ+KlGEmtqAkNzXooOgpJwLRmAxwqJE2fIF9NH24KticrtsY1G1wJgcITWCmqMfuHWd2HjyouzFpTqYfNuYa6WKMrNqsPIXfbSL6BU5YpAX0k57OuWSHfYBAIoqRbu4hdd1U1hfOcU4D2j99130RO6JbJ484xkfdVDWGbM0sGpNeuQyQYeK1ch23hy/VwGTIhd4HU8CF0hEnJgKGVtzPKp6NsFt89FcX6Ga9LqSxx/xtJeP9d7mECmI8OrQnBHhaImSuwKtXtbYb2FuEEAkEcXIsYsh15YisEdGEA47VC59D08hle2E44wDwuB58oPWsWmuUqA9oKyniknI7a67ze++ejJe9m8hQyt6Ag2OnkbkqqlRL8HgT8JBlICCGSrQIE8m28gHZv2Kxq630OvVFT4Uu/sxPL5HymoAGIVv2Og4TnHsuphlE/RhUI0IRmyoMFmvXlPloqSpzmi6WRT3V5qjO4gDq28SxIdg5VwVVbkXe1+gXYw9ocKELWUjUzEloLlB88N2DoZvgixckhahjsBAEj0Z/z8XHg0/qXCAmkprpi2KA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(451199018)(5660300002)(31696002)(41300700001)(8936002)(86362001)(6486002)(31686004)(316002)(110136005)(54906003)(71200400001)(558084003)(38100700002)(478600001)(122000001)(186003)(36756003)(2906002)(6506007)(38070700005)(6512007)(2616005)(53546011)(66446008)(76116006)(66946007)(66476007)(91956017)(66556008)(64756008)(8676002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elFCODljMmhOTG8zcUg1MzYreHZiTU1GUXVhekZCeFA0dTE3NFFUTGJtUW14?=
 =?utf-8?B?Skk3NlpVb3pSWW1LeU9xaUhqTzFlY0ZFbmdNTEdNK2lTWVViUXNuMXk1RVlF?=
 =?utf-8?B?U3FzcGFnZVU3OHpkVFRFL0x0eEpjTm1nQ0wxYS9WSmd3amZ5emRRNDlOdUk1?=
 =?utf-8?B?T3dLT1MxQkNsQjdFV21aZk5sQ2pzbFFqdXRnQzRUMENjNHYrdnIxTThSajMx?=
 =?utf-8?B?elNCaTNiNHFZMUZ5eVlkUFY1UkFiM3c0YzlTMDlodFdkYzNPaWVwcWFIcDR0?=
 =?utf-8?B?STN0b2xUdmVqV2cvd0QzMVBLMStaZjhHYVBMaytKOHloMkgvUHo0Q0dGcllu?=
 =?utf-8?B?SXAzYzhTNkdCY2ZWcEZHTnJ1M3JVYkNEUjRCck9sZm95UTMrVlh1V3VmcU9Y?=
 =?utf-8?B?ZE9YR0RCT0NpT01ySngrQ2R2blhZV2paZkxmTVh5dWRZcitxZXJxa3MxTzJK?=
 =?utf-8?B?VkNnSnRqUFRna0FFM0VyZFBCdCtUQUhQcXFqdGtRRHpKK3F0cXY4YWUrOTAx?=
 =?utf-8?B?ZFBmQlErWmVjTEhMMUd6T2FwSEdSY2JnQXhya2ZhUzF0NXVKdVlIR1hMMHJr?=
 =?utf-8?B?SFEvaEh6QTBNWWx0OVJEaENYdWJjK2UvOUorcDlaOVlXdmZ0bHo5aEtIZVJa?=
 =?utf-8?B?KytlNkt4b2d3Q3pHQ05heHVEdGNTRXJ2aXl0bkdNVUd3NUVuQnVqK25zREJ3?=
 =?utf-8?B?ZnJUM2w1MnUwM043QktoOTFRdHVYVDZoOGg4NE92QXNWZUU3VjFNa0JET1pW?=
 =?utf-8?B?RkZXU0ZhZS9NbkIrT25xRUNqYU1INnl1eVl1R1gvNkQzS3NYZzd6Wjh5WHFi?=
 =?utf-8?B?a3ZFdlNUOStjcUlxQmtXWWFkc2xSYXRPUm9NVXhzNE9yRC9hL0ZNL0VEa01h?=
 =?utf-8?B?S3M5Vmg1NzlRZkV2cFRPUGNvZU9LU3hkWWhKTnE1MnJPVEhBSUhjZTNia1c2?=
 =?utf-8?B?MlFBMldlY0lvT1JiZ0diMWFIOE5QY2JoL3MwMlJOYXNpb2JJWW50aEtSMTlp?=
 =?utf-8?B?dFlKb2szZlBXTFpac3Z3aVdMTTZhRjAwM2F3MkJJSWtXNGRHUFo0OTVITDNE?=
 =?utf-8?B?bmN1eU9EZDc1ZVIyT0VtYm1qWkpZb092K1dJR1dXYkRXQUU0U29hQkN3dHhC?=
 =?utf-8?B?VWdtQml0Rk4xdmJpbWpIWS9hdndYYVZDQzRsVmU0NnBLTDB5T2k3VjNtaDl2?=
 =?utf-8?B?WjBQUUJtNGw3RTlVN2YxWGVyMEdldVdkNFNNQzhrNm4rN3B1Smp1MG1qV3JY?=
 =?utf-8?B?bmRzclcvc3hFR21hTytOeWE3SWp5NmtvUUdIcDVPK1NsN1dFK3FYaXNSNkZa?=
 =?utf-8?B?VjlJUGliaGZxTHNmY1VwVzhTZ2F2ZUc5Sk9PT09qdVhueVorVjdBT01DaWhE?=
 =?utf-8?B?RnVXN2dZZlJQYjRQekdwYnQzTHFSdTJmb2FqKzc5VUlSVDgrMGl2ZjY0SFkw?=
 =?utf-8?B?R1c5V2ZmZXpYK3N4Nk5mQ3lyRjVXeTZUM3o4ZWNtQkRlejRSNkUzVzFicml4?=
 =?utf-8?B?TmVMUG5FbHlDZmZqaWRPVGo4QXJuajFnZmNxYUJmOHpNYXJaS0RLMDY5Qlcz?=
 =?utf-8?B?VlNzNVNXTmtTd0o5bzBFR0tia3luNFdGdmxmeUVSeDdKNFJLb25kczZ3VmZG?=
 =?utf-8?B?cjdHUDhqcEF5VWNud3BTUGxzUlFWNGk3QVh3akF6TnVrQURyVUV2QVJ4Q2I3?=
 =?utf-8?B?QmZtUjlGRVYweW9CNGxjSUR2cS9PcjA2dk9WVmh2cS8rTlNtdlpGQUlWUlV4?=
 =?utf-8?B?ZVRTSEZoTDRUYmsxdHlCMFVQMENQNjhheXlDWDlUUEQwTDZsc21oRVMrN3kz?=
 =?utf-8?B?SmlIb3hTZ2YwL2V1dHNUL213WmRZUkhNdU51UERtNXQ2V0JscmkvU04xdXZj?=
 =?utf-8?B?TUFpS0dWTEo5Qm9FTEZ3ZHhpeU1GMy91V01kTzRrWlIzZmg2VHVzejIvWC9E?=
 =?utf-8?B?UFpOdkRyb21iYnlpb0o3VFlBRGJlVUtNWXo5cWxFd3lYUFNUb2pvMEMvcTQw?=
 =?utf-8?B?Q3RJaFRTUjJ1Z2tGT0N0WU5lMXJGaHprM2hsZXIwWDZiS0dXdmdCakVSU0Ew?=
 =?utf-8?B?SmR1L1hDZlArVkdHY2xudDFWSHdZRG9IU0ZtRnUzK3dzaTZIbnl2Z3pWSDhV?=
 =?utf-8?B?RUpBLzlRQnJBeXNmeWIxS2MrSmJjb3pmOGxWa2F4MlFuTG5UM3p1Tmx5Q1lT?=
 =?utf-8?Q?ObiEnWP7VC55f20R1wUun3cDdmtAYQeWYkSRsJ7A8AJm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B0E5B857D24AB5479C222A0B13A00B28@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4fb968e-b128-45eb-2286-08db20161948
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 20:45:48.8428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QlpgC0EGD3B+tSSsZgKKU/0GacA5qS4ILVbtFlClqWiY+Ebuy/7S9kPlC3pIkq9OV3wrp4fOcc2xPjx1/t54sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMy84LzIzIDA4OjE5LCBFbG1lciBNaXJvc2xhdiBNb3NoZXIgR29sb3ZpbiB3cm90ZToNCj4g
QWRkZWQgYSBxdWlyayB0byBmaXggdGhlIE5ldGFjIE5WMzAwMCBTU0QgcmVwb3J0aW5nIGR1cGxp
Y2F0ZSBOR1VJRHMuDQo+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gU2lnbmVk
LW9mZi1ieTogRWxtZXIgTWlyb3NsYXYgTW9zaGVyIEdvbG92aW4gPG1pcm9zbGF2QG1pc2hhbW9z
aGVyLmNvbT4NCj4gLS0tDQo+DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFu
eWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0KDQo=
