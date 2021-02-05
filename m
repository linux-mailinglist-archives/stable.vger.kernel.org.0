Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1593831095A
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 11:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhBEKms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 05:42:48 -0500
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:43126
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231436AbhBEKey (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 05:34:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P66Rs6Tl6JKTXsCxX04l8rFKI4KBo0qCrGxLMbRV1lIKvZSLXHl2x8IsnC0ssQ0r2esCXPX867Ixazyhnut+vj1+zJoWwqNpbUkUcFUEZuseCJ+IQjYaHjysacwNMBNQoM/UCFdsEckZGy/USpSNPMxNw9V+CKKFHG9b42I6ua6AQvZkYgM8nOLaSLTI5yjlB5nyk4uaVFk6KcXOKpeo2u1ATqeBfk3mq2L2l/AICtSazxnbLngtoVELsWhuz7ikNf2yly7fWszPXZyHwLuKBFEhpyTP4Iv5Y54tyHgt2gbdiZRxuQ426PdDDXIG4T+S6melLg7cnPUqtmMwXnmF1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRzXn8aW11WIlU5e0WccjfvO531/XhQ7+NNJF9BivKs=;
 b=VwFloYTtB+smoqc9OxnD70p6wbXVzNya0aYW5ShLMyJJG2wYudrDtzsNxhnw+yZuXlFXmECP36RLHqhL4KFyiNfenXDTnr+0ibXBwHJ1xewgIy9YNRgRjFetAUM9Q9AppZZdPgqKqRUTmxGHq8WNi53Bk8abQCB1PspiN4MMsv3OR5t6OqXqkfq5vQ2ZrLkx21Ep5T+K8f4X7TNBz8lZFg2QQGsp7ZPB8r+4k91nnSGKsEqJqeviTwBbZtUFD8qLW+hGNJjb6TmxJGzaWPTs3WQUC5XQPCySXMZrfoD/Xo2iw8v3HFsTwgrXP3ohfs/c95rUhlt7RT6pe8odB+TIQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRzXn8aW11WIlU5e0WccjfvO531/XhQ7+NNJF9BivKs=;
 b=JKNZqLNds8O6yMg//vS4+x/3zcx7o+PFo6LL36LZ/7BEyhBRDUHNGsSwXUFlkNsL3DV6167z8hXKQ004O9Wwu6l2XmUmr4/x93hOk7bjPPlvxCTDeZEJPPUiwWuy8uqJ97Rzf3EeyWwT3feHbOeORx+z1rsOFZmPvcQF436oRsE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB0634.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:3a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 5 Feb
 2021 10:34:03 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.022; Fri, 5 Feb 2021
 10:34:03 +0000
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     Stefan Berger <stefanb@linux.ibm.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <04da066e-1c02-a34b-7ca6-b64ac17f12f3@kunbus.com>
Date:   Fri, 5 Feb 2021 11:34:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM0PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:208:136::25) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM0PR05CA0085.eurprd05.prod.outlook.com (2603:10a6:208:136::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 10:34:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f88bade-49bd-4ac9-1431-08d8c9c18ecc
X-MS-TrafficTypeDiagnostic: PR3P193MB0634:
X-Microsoft-Antispam-PRVS: <PR3P193MB0634C8EBCF280689D31FC0C1FAB29@PR3P193MB0634.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:51;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RPaecFLDimqHMuuV2LBoQzUHMX4sg8WtgNUcWG7QxspplTR5bB1OKmSDFRc54FBEwoxzslKFm+t+sFJnAqXa3ObdX724U25du7QjuCOc/csB2NoAhAQQVJ41lBZMwbqdHPlhx4anrdg0ceJzUiQZ3ScgCkxyloOPjnoAl7BpefvK4PPDZQeb1IXzfzieo7AxSAdWa9xDpX42js5GD9ErMUtEpJTDnv4skxffynOjRaIzjNYkDGMuJlyJlvct+TJXIizkcPZ7rCuZz/0vMumiZBDzMD1hRAj9KZ7PFCfhk4w31mNeoQhqy2QvsqGkT4jj2GUSOJdJYqk1+QNc3zcrccGdtGTKDC1CaploIbUBbmWqh8q2YxxbvU7PpVKxdEHbTsroawMoMuAFRQpsrdojupt6TRa6bCqg/E9qMCubmtIV3uylzn8B/MxKMyLbXjfDrznJGCiGgSNLA+xbKMHSRIRn5YTFQJm3reb/npvDLnGvGEKEMO/dLASWSuz3DrWupSDQOgKIARM3sw17FKHX8jcrEOnUwbDS1MIcMYjVx+yI97A6gfx33xr10F5+NFUh3lS26DQ4TGHZgpMpEQjl9XVX1PWishoeF4wMHjc6+fg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(4744005)(16526019)(110136005)(16576012)(36756003)(53546011)(316002)(6486002)(31686004)(2616005)(31696002)(956004)(2906002)(5660300002)(66946007)(4326008)(66556008)(7416002)(86362001)(8936002)(26005)(8676002)(478600001)(186003)(52116002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2wzbFhwbW5OcjlOOTNVTGRxT0JiZGNyaFJVMERsNVdmSmhqYUgyVk9rSEIx?=
 =?utf-8?B?ZktaM0I5OXpER05XZTlhYXp1VENiUlJCRVJtdThaTHNTdVBXY0dINmtEa3lt?=
 =?utf-8?B?amRIbzR2YUluSWcvUGFvRDNheXZoK2F5WlhJUWNFcXZaMWw5QUFjN2U5Z1pm?=
 =?utf-8?B?ZEI4c1JPY0NkUEh1RjZOTks2anFQRHBBWUNKc2pWNDJOdFJZM20zTXN1M2hS?=
 =?utf-8?B?dUg1Z1ZkRTR0RXlsa2J2SkVLTnpDeXNVQThyemVKQzNndjQvM3pKUUpSYVZq?=
 =?utf-8?B?eUpUaDQzcU5DeFFTRGFiZkRkVVhzaVZ4OERpbXNEVWp0NUx5Qi9vQ3kyb3pQ?=
 =?utf-8?B?WHN2YTJsRFNtVUlaemg4dnEzaGlVKytjQ2d3R0xIUWdEVnNRaGd0T3FqMU9J?=
 =?utf-8?B?RlIwOTJCMS8vRUJaQ2RnS0lBWHVqRkdJa3ljd0dqc3RqUHBwRm53QStSRkwr?=
 =?utf-8?B?cjVuSFJFMzRJOG5uUWVqZ2VXc3Q0Qm1YZUtRL3d3NitTYjdFMmtvSFpXSGZP?=
 =?utf-8?B?SHU5SDIzSTgyZXE3TE9jbzM3emYycE1oYTBkcmxvSzdlVkV0WG5nQ3VrSUxB?=
 =?utf-8?B?cWhzK0w2RSt1aElKZzM1a01ZSE1XSXF6VjA3emwyek02NXJYdTZxQVhvMU5w?=
 =?utf-8?B?b0NkamR2dWQ0cXZIU2ZUMUxLQnRlZVU1QXkwY3pLSXQ2L2hVaC9jSHF6VlV4?=
 =?utf-8?B?TGQ1MFlQMWV1elpRTWp0ck9WM3JzSTVKdmdzRkdnZisyUFdWdnN0RXd5YWla?=
 =?utf-8?B?MlpHVDJQZnp5ZVNLbUNoeXVkTWRpSFQvMEJvN3BHUDZTN1RNQTBzZEZscmVh?=
 =?utf-8?B?Y0tZT1pCL085eWVOSW1OSGIzYnBnd3o2MW1TUTFpR3VYTE56NjBGR0dpNzlv?=
 =?utf-8?B?VGNOS0tPNmJocEpVK1NrOThIWTUyWFBFeUJYb0xZTm1ZS3JDM2lLd0lFT1Y4?=
 =?utf-8?B?MTl4NXFhWmhDdExBUTBvUEQxRzU2VDdkWXBrNzVCd0xDLzZGckRud1FKMHox?=
 =?utf-8?B?b281cUZ2WWJjakYxVTZnR1Y5NExpS21LYkladEVpOVRvUHlKb21zREprTjBF?=
 =?utf-8?B?WDQ4b2xMdUh5ZnM4cFQ2WVl1cmZPZk45N2hIT3BndWkrSjBPTnlxZDRwUE5K?=
 =?utf-8?B?bVNXVk9lYmQrQkkrRDF3UFZOT3VkV2dxak13Sm9uWGlNMWpTb0x2VDg4UmlD?=
 =?utf-8?B?aGxIak9TT0plSjcwRFE1TzNVUld4M1JDc3BNazZnUE9jOUZRdlJMY1VSNXU1?=
 =?utf-8?B?bEM2QkFkK0ZpSERYcTVmT3Bhc1RzajdNT1UzbmpwdVRuS3kxUHF4REswUkpa?=
 =?utf-8?B?cGZWc0kxUWRkeW5BVnRrdDcrVEI2Q2ZSVlhDWERRZmJRMXJaQTNmYkQ0ei9Q?=
 =?utf-8?B?dm5mZTNybU8yaXpURUZScWllWmhKaWxZbVAzZXoyRTJHWUVDbkhKRUNXUlNw?=
 =?utf-8?B?N2lwZWlSRWVLMWQ4M1ZVVEV6aVVTRU1jOFoxZU9mbHBTOWs5aDQxWWdhSE1j?=
 =?utf-8?B?U2dKb3VTVmFBd2FsYnlReEZCZTVFVG5oazNrSHhoSGo0bEgxQWFndjM1RElC?=
 =?utf-8?B?cmhsWWNJdkZPQndFczJWY2hpQW9WTHY3UVNWUGNVb0NqMHYyQkZTRStnR3Y4?=
 =?utf-8?B?YVhLUWlzZ2UrNitjN3JqWi9qdklKaE1PVGliU1FPaExOc2hYZDRENllGaVJY?=
 =?utf-8?B?QlpxblQ1VG9iODd2QW5tL1VVK1pQZ2RMb01GOS9ESDQ1SGJxeEl6dEtlWGVQ?=
 =?utf-8?Q?vqcPsOomcezdic2C65Dj46SV8QHgvB5AEuQAxD0?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f88bade-49bd-4ac9-1431-08d8c9c18ecc
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 10:34:03.5331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PR4VJJnj6gVlBi9u/B7pKgIputW9LP4j4BG6mXHi6ZMtiHGcFtEsAdeuLZmeVpHgg+gPLFgKPLwqGq4ZE1j4tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB0634
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Stefan,

On 05.02.21 01:46, Stefan Berger wrote:
> On 2/4/21 6:50 PM, Lino Sanfilippo wrote:

>> Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
> 
> Tested-by: Stefan Berger <stefanb@linux.ibm.com>
> 
> Steps:
> 
> modprobe tpm_vtpm_proxy
> 
> swtpm chardev --vtpm-proxy --tpm2 --tpmstate dir=./ &
> 
> exec 100<>/dev/tpmrm1
> 
> kill -9 <swtpm pid>
> 
> rmmod tpm_vtpm_proxy
> 
> exec 100>&-   # fails before, works after   --> great job! :-)
> 
> 
Great, thank you very much for testing!

Best Regards,
Lino
