Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B0B302BCC
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbhAYTlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 14:41:51 -0500
Received: from mail-db8eur05on2127.outbound.protection.outlook.com ([40.107.20.127]:26689
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731591AbhAYTlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 14:41:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K9m1awrnJ4lKmSeETmCVTKSaQk9mrJXeSNVj5HfES4B8d3t/VC/qkRvWn7NiiM5FePnE5Tra+Eek/gWn/aamJ6/MutM+RUVNnfc8GDogZfI/dHIDCSBwNSd/zkWT+RqUWTUi2qJbuI3qxBxuHfX3i3zXZzR+BDhKo2CAsk9P/6boEPv8swEY8kEn0L/Q2x/HnqWHQDxlScsakwhAaawjGwwThK4dS9Cgp3On5MkS23NYC98hFOAhRJRt7BhgdR+D6xhtK5CUQxt0zw1WrjdJg6Cxr7bN0UPUegzXBXVMWRgdET5IEla9Bfdr0sp+NvAN0F3/FkQb4/7bzWp5Vlm9Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIXp8o1MhupFiQBDqSx9MnIwprLCjdZ0D0QPzyEw+rI=;
 b=cuEjK3wCF5dxtknfKIHvHDqhXgPnv042vxaQobqLB2tm3TWhSt322Vz9q6deCfdhIm9ecbCMI6TvT73H2sC3sML4NnxVEBxq0w8fojRQnrx1BoYxB2F1AqXc+s/PPapn3NtXWAvCV5rdNOXEUpighfGVtRNYJqStGHkRYzulbimL73cqCnpkR5RQK3DlKAOva9/JxXImx08qXtiPTscak6ziArPApaBPQbtZw5C7L6A3tDkrpJGZgNm3PpRS+IuwpRMBa7h9UBoSAN0vNcMEy/hi0nxgORftVudmZ2gKoo23dgWECtgMicA/WklDOu9vtz1BzIAvO5lniXzDfImgrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IIXp8o1MhupFiQBDqSx9MnIwprLCjdZ0D0QPzyEw+rI=;
 b=WfCm9c0E3t/kzR49qYgkw0nCJDdyDzAeSUdQugGFZ9UoyWEiRsTXuI079gFpGjtH1rPJ1ba+QZPYiAWdUpKmbo3s4z53RBqkMoSWPJOn2VFjyWnminDf9ac1ql//ula8fs+pRR4xdNvC0dxdrHYQ+tQR/2zH5MW5Sjkb3FINsNI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4529.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:26e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Mon, 25 Jan
 2021 19:40:53 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 19:40:53 +0000
Subject: Re: [PATCH 4.19 46/58] net: dsa: mv88e6xxx: also read STU state in
 mv88e6250_g1_vtu_getnext
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210125183156.702907356@linuxfoundation.org>
 <20210125183158.687957547@linuxfoundation.org>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <8447247a-6147-32b6-541d-0dd717ac9882@prevas.dk>
Date:   Mon, 25 Jan 2021 20:40:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210125183158.687957547@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P193CA0087.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::28) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6P193CA0087.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 19:40:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bf2759b-b8d3-428e-a766-08d8c1692042
X-MS-TrafficTypeDiagnostic: AM9PR10MB4529:
X-Microsoft-Antispam-PRVS: <AM9PR10MB45292336F05C60159576BE7093BD0@AM9PR10MB4529.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NFL3DpvanRXDp0PadHnusAP8EO9LWQAqNTRg0p7dD9n3wjJbqRJfOknlq3kn+ut00ODAKV/oZUvQm4LmkLILiMOwaNnhCVW2REH0FTqeilh8GDGgq+iY0lJNbuyyeM/9j+iaVVrUtQWj/nTJTLfixccUh/3sj5885b1sNXlwFa7iPqa+ZP+MclQ7YWftqBaklxmM1rA9SlbZ98VmGlQFzcfoPto1BKUJVMt6N+KPis4wHZ+3j7odvbUsJQ+lyM5U4eI/gV0kOEtt7MlA2Q0LSdgltyuEHiUjR56oWwFr9NKgQcXHoGOuXJVrcO2jnefcjISmGvlppWi6ri9LxVq5jdtGXALspWC3zU+VhqS9kTCZcXJglQWpy2ciX4OrAunitppEYL+sVth4NL/Og2lxbtTakxK56vXQtR8AtNM1qbxadUq1r9xz42IzEylYC2AaoyoWCj1+RrS05iBcVKz1vxB8gPhzDRvLHVg11zeytLE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39840400004)(396003)(376002)(478600001)(31686004)(956004)(52116002)(66946007)(8676002)(8976002)(26005)(8936002)(16576012)(86362001)(16526019)(2906002)(6486002)(54906003)(31696002)(36756003)(186003)(5660300002)(66476007)(316002)(2616005)(66556008)(4326008)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGkvOEc4S0Q3NWZBYjZUYWd0QnJsQkh2T2gyZDRiSTJyTC9TQkJkSk1QVjdG?=
 =?utf-8?B?VndnRkM3bExid0xEcGd3b2E0YUlwaEFYam4zcHlNTHlJRWFrTzNVVnB3Y3o4?=
 =?utf-8?B?ZEtuOG8rWTZOTGVlOUU5a3VWZEs2WVN1YWlCNDJCSlY3QzZKUndKc3lBQzNU?=
 =?utf-8?B?aDBmTzVwbWw3WHdJZ0lXOVhRbWovMU4ranEyUktGTElvSVFzZXNxY3FBZlV5?=
 =?utf-8?B?d1NRYnlTeCtwb2ZtRS9kYlZHOEFGUTBNbWFHclpEV0dXVWVBbG85azBpQmpD?=
 =?utf-8?B?UFJFSDNCT050Y1FGMkNFOW1JZGN6UG9SR24xaFBCNjJMYlIxZ21XK0p3NXpm?=
 =?utf-8?B?TUVqbjN2RHhjcHJYUTRDWVRpVlJjYUxSVmtsbzZzcExmeU1admdIaW02djU5?=
 =?utf-8?B?bldkQkNndi8rS0RxNlIrOGMySTBjZitnT2FMMnNISmMzY3ZpRG5oSHlvYmMw?=
 =?utf-8?B?bTMwSVQ4cndwbmtXUitVNldKNjQreG9oaUE5eGVBQWdNVjlsZUVPNmVQYnlG?=
 =?utf-8?B?TTBDZ3hjZStjMURSeXBOVWlScC9OZGJCTzI5VGFjNVgrRFJmT1J6TTBoRmJh?=
 =?utf-8?B?S3lyeko4RGFlMVIvT1hrYWt5dzNZU2JuSTlDZWFXcXM5MWtFSDNybHdaejZi?=
 =?utf-8?B?MTJnNnBrUXpwWGRQZ1ZKS21uQmhNRElNU0VORHNtRTJTRW9Uc3hNTDRaTFEy?=
 =?utf-8?B?SVp3Wk9PU2FudTJSUlgrSlkrY2NNS2JBVFRJaE8zaTNVSnU3WGZ6TVkveUlm?=
 =?utf-8?B?U0h3MXhQNkxaREw4dnl6UmhOcWNmS2tnU3lFL1VmRkI0TE40SmJJVVRONXdG?=
 =?utf-8?B?VDA5ZWdGZWV0SVlvMkYrUlJ5TkVHTEhnQnF5U2xtU3owQmErcEIvaWk0Ylcy?=
 =?utf-8?B?S0dKYUhHQzJYSEY5MDJJRUJ4MTFlODJvelZ6MkFGaUhzVnBURkhQTDNCdU1T?=
 =?utf-8?B?dWNQUFdjWnp6SW9ORHNLUkhGd3JYUkVkNkZVT0tYV2kvQ0RyOTlNTVRyU2xo?=
 =?utf-8?B?OXFqbitaL0dHSjZHdU9KeEFyb0VMbFJUVHJ4bmltTkd1Wm5pcTNuVVRONkZK?=
 =?utf-8?B?cVNNTDBNS2lVc3lvd1RKRmJ5UkpQNFVuMS95UFhuZTY4UlVGOEZPeFlRV2Z1?=
 =?utf-8?B?WmFhb3dPcmFqTEdnY0lhbmNGeEpYVDl5OWt2MnljeDBVTEswd2FwZHVoS2gx?=
 =?utf-8?B?STRvVStkbktHS2FMN3lqbU4rSDRqQ09BOHgyY0J5NE1sWUpZTVV3K21pcDd1?=
 =?utf-8?B?ejFsSm8ySnhMTnArV0p1V2FVcC8wY3A4anRPOWUrUmc1Q0I2WmVBU2hwazR1?=
 =?utf-8?B?bDQwOWxFV3NQM2RDVldtKzJhREFwZVY2RzV6MnJCMGczK2xMamFEaUh3VTZ6?=
 =?utf-8?B?b0FNY3RZa28zUXBNeHdyME05NGJKL01iUkV4VDM2UWpkZ1VmenN5OUtZOEtO?=
 =?utf-8?Q?evrThiul?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf2759b-b8d3-428e-a766-08d8c1692042
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 19:40:53.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lTqPIomXceUHevbHNxz4wDt8xt0odWHgRuFj2wIqFpphjsszt9sumu6lnw5HQvn49xmigmoFfb4+dDv3jS3NEZwPqYM9scTXfZfqOsbRUZo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4529
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25/01/2021 19.39, Greg Kroah-Hartman wrote:
> From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> 
> commit 87fe04367d842c4d97a77303242d4dd4ac351e46 upstream.
> 

Greg, please drop this from 4.19-stable. Details:

> 
> --- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
> @@ -357,6 +357,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
>  		if (err)
>  			return err;
>  
> +		err = mv88e6185_g1_stu_data_read(chip, entry);
> +		if (err)
> +			return err;
> +

The function that this patch applied to in mainline did not exist in
v4.19. It seems that this hunk has been applied in the similar
mv88e6185_g1_vtu_getnext(), and indeed, in current 4.19.y, just one more
line of context shows this:

    353                 err = mv88e6185_g1_stu_data_read(chip, entry);
    354                 if (err)
    355                         return err;
    356
    357                 /* VTU DBNum[3:0] are located in VTU Operation 3:0
    358                  * VTU DBNum[7:4] are located in VTU Operation 11:8
    359                  */
    360                 err = mv88e6xxx_g1_read(chip,
MV88E6XXX_G1_VTU_OP, &val);
    361                 if (err)
    362                         return err;


IOW, it would be a pointless noop adding the same call again.

Rasmus
