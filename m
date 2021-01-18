Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD922FAC41
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 22:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394483AbhARVKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 16:10:25 -0500
Received: from mail-eopbgr120105.outbound.protection.outlook.com ([40.107.12.105]:5268
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394389AbhARVKV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 16:10:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpbDrntTsDt5xG4AgxnAWCJAGM2Q1ilMSz8T+K/WhWIXlQq69JqIB7pRBFFhUWPcK8wOImYwDF6QWeIbNVjxEsO03hUk2yjhUdzaRsa4cUoe/IO0biEfu/GESim7vtERJIPqRPTrAVuPkL+Ez+sC5dSMbr7arfiGT5tyZgX7kzad4ehNuc/LxCcmzTA3mkTBiU6dHPETIG4qi/O+OhFT0luUX3B7HaysX+yRXh00D1EwjdfrA/hdhAHBCEOP+e1iNxZ1s8mu9Z9ZTuu+1gW8vVdV8uSmRlFJFpE08kZInJA1Y/5y8pq8LpUUWqr5IdSTU/MIjAnGnJNWxOhLl/Wv6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUbYJZ+aNqosjrz7sbBFjsJHDxuPa1QsvY1IKmFajfc=;
 b=RT9gZAA2Kby/t9CGk4hoAFflk1i9UbIGw3eq9j2gfpOSIe6TTewS8b9TI5REZw7YMENFEMf+VzPX+o8SnTOm2is8MnWoECF6bd+cKMxflysYSLpkh8OpDCHUrPte4zF+l8Pzhwkfm8asVGNy9f8F+rIfW3fjTTzZi1BEE3hdXyFL27coF/OhJhW7J0unFmvls5oZXrqPgOb4BoMoO/pqXaambwLVutbaR/UOvStqrKe7htPaL+S32ygzpTGY6gxhOIJQIU60pax4mpQNAKwl0+6hQdpWdcp9+3ytphMZR338qGvQEN0ZY31YgGVS4pzNnaNd9CIk+X1eRjAT4v3aEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ua.pt; dmarc=pass action=none header.from=ua.pt; dkim=pass
 header.d=ua.pt; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=uapt33090.onmicrosoft.com; s=selector2-uapt33090-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUbYJZ+aNqosjrz7sbBFjsJHDxuPa1QsvY1IKmFajfc=;
 b=D7T2i2QS2Aciv3KyCVTWi/wtVad6UEWNXFlmGw/oLB6T2V9YEuRmmzLnChGdYAsqfMnodeQZm38Bvy60yYrbrcio7utp6/tGZ5ByCVpF35PHtzPlK/69SxRvN0wbHoa1z1nfUxg1u2rDlRdsTDj/Ohc85xBppRxxJklWuAM1UuI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=ua.pt;
Received: from PA4PR02MB6574.eurprd02.prod.outlook.com (2603:10a6:102:fd::7)
 by PR1PR02MB4906.eurprd02.prod.outlook.com (2603:10a6:102:d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Mon, 18 Jan
 2021 21:09:35 +0000
Received: from PA4PR02MB6574.eurprd02.prod.outlook.com
 ([fe80::f171:802d:4fff:2a2c]) by PA4PR02MB6574.eurprd02.prod.outlook.com
 ([fe80::f171:802d:4fff:2a2c%6]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 21:09:35 +0000
Subject: Re: [PATCH] crypto: public_key: check that pkey_algo is non-NULL
 before passing it to strcmp()
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        stable@vger.kernel.org
References: <875z419ihk.fsf@toke.dk> <20210112161044.3101-1-toke@redhat.com>
 <2648795.1610536273@warthog.procyon.org.uk>
 <2656681.1610542679@warthog.procyon.org.uk> <87sg6yqich.fsf@toke.dk>
From:   =?UTF-8?Q?Jo=c3=a3o_Fonseca?= <jpedrofonseca@ua.pt>
Message-ID: <91cbcae9-2bc8-16ed-678f-46903e15aaa1@ua.pt>
Date:   Mon, 18 Jan 2021 21:09:15 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <87sg6yqich.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [193.136.93.218]
X-ClientProxiedBy: PR2P264CA0014.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::26)
 To PA4PR02MB6574.eurprd02.prod.outlook.com (2603:10a6:102:fd::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.94.190] (193.136.93.218) by PR2P264CA0014.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12 via Frontend Transport; Mon, 18 Jan 2021 21:09:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3c446bb-c239-4658-32ba-08d8bbf55bb8
X-MS-TrafficTypeDiagnostic: PR1PR02MB4906:
X-Microsoft-Antispam-PRVS: <PR1PR02MB49067FFFC526E965286AB90CB1A40@PR1PR02MB4906.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lVIlWWM4FFTLThWBjV729iuLcpzzQnyjE+Iyl5fes8biT4nA5SJWftzj/bUgDAllf1/pw4Gndw1YZ17a1009Aj3bXeRSRCotYMiC7Ov5OJBYSq0hPzffoX0cQCtYkCcmzrsD15Zylk6eJD0up6azdo75rMCWC4Z3vtnh2cw2Oh2u31dMHCbWiGNtP+ipTYTUPIX68fr5LolAuuo+ud9YataHu20KtYAuR6AUVqSI5jpLeF0cGIC8BwFlVd7CFwoyHjsAAeJXxAt4q3ru77IezJIahgB7647B1PsFuR+r8kfxi9qgKcAiObFuBTSFXXH7xYISzSJYTsVX8oTx3Nq0cABXi5T2NXfhTy6K/bbhcil2oq0CjaaN1o8UvwETEt0RyRu38050sdrQz8MRwoKcOSdNN6pEgoEVlesicDukBt8hiS/rvrjBAmTHEuWoiE9PbpaUMO2BE8dwMWru9P5eOLGiopAW83Ptva1/juaqbpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR02MB6574.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(396003)(366004)(346002)(376002)(956004)(31686004)(66556008)(8936002)(6666004)(66946007)(2906002)(66476007)(54906003)(4744005)(316002)(2616005)(16526019)(186003)(26005)(786003)(5660300002)(31696002)(86362001)(52116002)(110136005)(4326008)(36756003)(8676002)(16576012)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UXVQOU15d05WeFNzcjV1SWFVZUFDMklKOFd6T0JkUWkzZ2REd0dvYTQrd0t0?=
 =?utf-8?B?QVg5bzFRbFZoZ0F3YnNRQ3hhYUI5YmpuUE9wSXp4cG5wQnNiMW1kM01zTEpE?=
 =?utf-8?B?UHJ5VlM5Y0RZWU1rZUkzUFRpYi83bEFxOG8zeHhidUhid2l4RHpBOUdZaHFv?=
 =?utf-8?B?WFpUbFErajdVZXZMaC94SHJxKzRBVkVCY0ZBbDhGeDBRQlBiTXVwYnQxOEJq?=
 =?utf-8?B?b0RzRTRUQzltTmZkem9QMHhWU3Z6QnEySVBGV1pMcU5lQWRrRmJ3djQxK2hP?=
 =?utf-8?B?L3NDdUZlQ3QyL0tXYXlYam5kT0h6eFkydFJWeUh6WllRbUxrSDd3NkR5K3FF?=
 =?utf-8?B?WU80NExybG9TSG1NZFBiQ2RTUjFRL3l6dGJzN0pvR3JaMXB1WDJtVjN2M1Q4?=
 =?utf-8?B?OWltak1ybTkwM0p4SUsxNHJiZm1wVGxQblJ0dnJTUmJPOW5EY1Rxdkk2YlIr?=
 =?utf-8?B?dXdzSDVrOHdMNGNRZWRnV2JSY0t3eWlDdGU4ZUdQbGxBQStkRStZWHpVOWwv?=
 =?utf-8?B?MzB2LzBwZjJKRHR4NjJ6TTJjVDNTOE44SlEvR3l2aGlmbnNVY3lnUkswUXdo?=
 =?utf-8?B?MkI4Y04vRkwyaGtMMWY0eEdIK3FyN1paTElFeDk0Ni9lTjRuWFkvWi9ZSkha?=
 =?utf-8?B?YkR4enp3REdCb01XZUFxU09pMndFdzhqWnhWUmhVOXVlTUorR2tBVkdRb1E1?=
 =?utf-8?B?RThpWE9LQktXSklHMzBYUTdRSHY1Z2pqTXJra2Y4b0RVRUtmb2pGMU1wWjNX?=
 =?utf-8?B?NGVrQzY2Z3hKV3JCK3NxMXpNR3ArNW5FT1JRaThnWkpGdnJmOVpWQ29SeXB6?=
 =?utf-8?B?Nng4em1oK3VONU0xYVZza1loa1g5Q0orMEo0OUFrUFVmakVwUjdWck1mVlh4?=
 =?utf-8?B?L3l3V3QyTEk1RlFkTVlsY1pkN0liU2k3L1FmWFcrNUtpS21HWUZPbXUvTnc3?=
 =?utf-8?B?bHBIQ2R0QnAyLytMTE5DZ3NZSFVMcnZoVm1WNzIxNytLMU03azVHbGZBWTFL?=
 =?utf-8?B?V0w5QTRsNnJzQmZ6M3JiL3VNWG84RXAyZG9DWUV1YkpuZlF5bHE4YkFjUnBk?=
 =?utf-8?B?SXo2WGRHRVVQekdCN0o3UGxKODZJRUM5cjJoaVJPMGZnUVJWNGNvYnVkemky?=
 =?utf-8?B?Q01COGNOYkpFQVNvN2NTaXAwcVRlbjI2Q2o2Tk52eDM4R2lJaS9DOUZlOUtM?=
 =?utf-8?B?RE5EbkwxTHEvR1RRWUo2WEJUM2RSdm5oYlJNdWhTaDVwL05WbGd3NFhpWStv?=
 =?utf-8?B?d3VGMXA4K01oa1V0ZkMwQU0vOHFTdVFJMVZPUWxqN05Td3VhYlFuMEZSQUp3?=
 =?utf-8?Q?UJJ0SQXpAJy4zincf20hZnQi0R4dz4Qvh7?=
X-OriginatorOrg: ua.pt
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c446bb-c239-4658-32ba-08d8bbf55bb8
X-MS-Exchange-CrossTenant-AuthSource: PA4PR02MB6574.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 21:09:35.4747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c1025aae-98b9-4021-b4b6-c201214b884e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANv2pq42dKdL9kDe8+O8+O96ZkXWzMPMDsR+RzgARaXbW24dbO58kYgt/uzfkCmYM0qDzwSfWXSvjmigQowJiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR02MB4906
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> David Howells <dhowells@redhat.com> writes:
>
>> Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>>> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>
>>> and also, if you like:
>>>
>>> Tested-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> Thanks!
> Any chance of that patch getting into -stable anytime soon? Would be
> nice to have working WiFi without having to compile my own kernels ;)
>
> -Toke
>
>
>
I have also just tested the patch and it seems to be working with the
PEAP method. I would also like to have this patch in the stable branch
as I normally don't have to compile my own kernels.

Also, if you want to add another tester:

Tested-by: João Fonseca <jpedrofonseca@ua.pt>

Thanks for the patch everyone.

-João 

