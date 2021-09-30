Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD97D41D5FB
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 11:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349220AbhI3JIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 05:08:36 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:40161 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349218AbhI3JId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Sep 2021 05:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632992810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OVfz4VRWRaXqRI97xd+uemnUvb76OlJyPJSmnHbB/3s=;
        b=U7PInT8odxpTS4ipi1LokMohh7LDeucN1V042vWAXsZqJ8L87uxDSQnV6mcNsuuhBWp4cr
        EEwzuI4SzKzpS6Yex6wPKkTImSLTBj1fWoZgEBT0wtNH3c90IApCDFedN+turWcyG0duWb
        0fenirUlf/U0dHVzNwrRIFXqnUAS1PM=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2052.outbound.protection.outlook.com [104.47.2.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-eMHvK63hO_i6y8envZ2Mcg-1; Thu, 30 Sep 2021 11:06:49 +0200
X-MC-Unique: eMHvK63hO_i6y8envZ2Mcg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+vm0zeC6HECsfb6eH5hfwMRYw/znzAd5hNNj1RB8DE3f7flwrpAXgyck96B1WYngOnbZ5u9DLexfhHF+ua1F2fNQVLYoRFjlYi7fhaqZtseuMNN7cl/vHdn68Bc9KSn41jnfYemaxprEk6x1Yi3LGZVDAIIvV4gaodjs/3lB3AwDKiCA//bPH24hHPehwedEZyNtkp1X/RpuYfL2Y5lXMhA6+cQ2bmC718TCXXjjcIm9DIFpwaCFZ5koxSTEO3ut1XN8+8zifqP62H693vSa0djVwbx0xH+bRa5eHDpG/KjYJ4B6ThVuB9M/hE3tPwXcLHSd84Pdv1Js8gzwdKPYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OVfz4VRWRaXqRI97xd+uemnUvb76OlJyPJSmnHbB/3s=;
 b=kru9jQ/zgEKnf6AxDRqXMQl8sCn39W2ZrPB7GVXrG4Ez2OM9ZcOI7Tjm+8KRGvdCwD0AWjAJF0ZCgpWisvDTYiATkhY1PnKWFHk6pB/nEvjSa7tGsgYqSouVeJ4tVhG2xtCOmeTO4fJXXMvM1iHpzdNb05ezyQ9ZOk6sH8LUgzmCqsnnmTSSPAbCxw114oKjdmRv0QnnvqHCIHnznS/tnpeoJwJK8Ehh3Oc7v0mpZuVXQLatHXbNH6e9/SXrAFEsvptNuhR2Yu8+BPXNKyHrNk8fLZmx65Lb8wOfZVHE+KnXiZEhxQodULz6OjiqrQDb9tzhHNYHcaukIjaKj55HUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB6PR04MB3143.eurprd04.prod.outlook.com (2603:10a6:6:11::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Thu, 30 Sep
 2021 09:06:46 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.014; Thu, 30 Sep 2021
 09:06:46 +0000
Subject: Re: [PATCH 1/2] usb: cdc-wdm: Fix check for WWAN
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Junlin Yang <yangjunlin@yulong.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20210929132143.36822-1-rikard.falkeborn@gmail.com>
 <20210929132143.36822-2-rikard.falkeborn@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <f1e62c1d-b132-45e2-a213-2b2a3e91288e@suse.com>
Date:   Thu, 30 Sep 2021 11:06:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929132143.36822-2-rikard.falkeborn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM6P193CA0049.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::26) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from linux.fritz.box (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6P193CA0049.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 09:06:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40500d12-9fcd-4a89-2613-08d983f1a12e
X-MS-TrafficTypeDiagnostic: DB6PR04MB3143:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB31435C15BBEAA1A190EC6C59C7AA9@DB6PR04MB3143.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBtX+Rf2IScjlSEq7jy+IZi1XQXg+IfYY5s+7Q1EEGxGl5cMmMj2WINgN/SJt9Kx6MjbvbPC3SJNMby1dVMv0SmyBROH4z9HkIDS1+lqsem5o6EqKRzOWeiw+O2SLpKhmN0kUkbuFw0L5zmq1Xyi7/UfIAYj2D2dL0BgolEyltD+7oYxAEWqmIeR8U9InQNIvnt7arpQz7Z5AslOFSAcwz2ZzjJ7MXpNTUbJA//zFco3k25Y9st0ZwQXyk7qP4HjiMdS12KICKh5Axyy7BdObzXsKhHqpwLRrMc6yMtqNh4fzgZ2AklI6tREkxCYKftd87guNVAY/81JbeV/ziue8KkHWFC8Gix1wR50jpPCnSR1Gdh78tIaII8pjuhXd+Do/9lPFtq0M9XI66sMoQcNsriZIC5yMppNb1/JrOnE5U2lp/0QRWyoKKQ0fmgtOFqPoiR+m0TbzsnC5WA8mT3GPltmucmYoDmjYSW48A0ZVUhM7TVSrZsSyQF67dYD1k8iahM5r0KCX6EvSbP/INIYvhVamQwleYQlNhNLTLpGMmm3XujEkD2Lw/vnjWO2UvAkSxB1Z86ckZVTQioamqBE0roueT2iFOFmdgcE2aF7+TLbSajc/0Uad1i8UQ98+xAoCGxiw1cq/ZyLiW7GZmL29lw4x0LCGXpclBxkHFFDmXpXs3HzaskeqFUqun2fNutzZ0hYCg9ROBsTCekxqG2BbljO6esijtHHGBHENGt+qDA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(31686004)(110136005)(5660300002)(4744005)(186003)(53546011)(8676002)(316002)(6512007)(4326008)(2906002)(6486002)(86362001)(31696002)(36756003)(2616005)(66946007)(66556008)(66476007)(54906003)(38100700002)(6506007)(508600001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3VaTkEwd1lodnZ3VExhTkEzMEtWMHJhVXE4eGpCeHMrYWx5RFpWT0dHa2ZX?=
 =?utf-8?B?dnVNOWtNYTRGOXBIbmFOaWhUUXpqWE5adURWMHNzM255dm9OMmUwTUN4Z1do?=
 =?utf-8?B?S3RpckFHMmZEdnVhYXN3eEdaNjJwd004V2pZWktqZ3Q1d2VXNWRWaXFYWk1B?=
 =?utf-8?B?T1RIV3F6VzltYmdMS2Vydmx2MkxIZGVHd0E5UEZtRjhkMVZRN1UxRmw3a2ww?=
 =?utf-8?B?bE05ZUJzQXdBTUZUNjFCZzBrS09xVjlCSDlMSjZUREZxMWxIdjhJZGpuRFJW?=
 =?utf-8?B?UVZRSnVXY3VlVHQyamwvQ25BZXMzWFJKVGJGS3lSSERMUFpzSGpRSGlYbURP?=
 =?utf-8?B?TWZidFNFalhKVXVBV1F6U2RlemdIZ2pDL0NsWXdXNENvQ0RtUmdRR3Zab3Rn?=
 =?utf-8?B?K1QyVyswSE9YaUROZVJPdGhmbVVKRUZxUTVGL1dkaitnQWQ5Zk9BZzlOeVgv?=
 =?utf-8?B?ZkpkSmJodmMzTkI5b01BaTRiNlBoQkpoVVR0ZjNhMFR0dm1RcmNjSXhkZkZz?=
 =?utf-8?B?QVJFSWdtUnFZVHRqRG4wcDdsZ2lLVGNkczlIS3dvV3prQlJzWWcxSVA3Nkly?=
 =?utf-8?B?SE9mdE1EMkxLTlUxZ3YwL0x5OEV0WmRJVTMvR0xVbkQxNzkvMmZlR1YrNFBC?=
 =?utf-8?B?V004SjhFNXlQTlljMWpyUStxZFRkUDFMcVU2aGpodkxNWEV0ZXRYbHNxNkE3?=
 =?utf-8?B?aEFhUEJ4aEdLTEloUG5IZ3hUbm9kcFJ3bDdMamRRbUJGdGNyY3IwRUdNa2RF?=
 =?utf-8?B?cmF2ZHE4NDNmN24xODZHOUh0cXc3YTdsZHJpclBIUmVrVVU2M3R0ZmRhbDFX?=
 =?utf-8?B?MjBFTm0wNHo1aHYxaVRLVkhGRlpJTEtubVdIUUtNSWlYY3NWSXZYT0ZmUGRC?=
 =?utf-8?B?QTFJRnFlZ1Z3cC9RN1NHcllleFZCMmxPWk1EZ0xzWVRsQVJVdDNhNGhzWmVE?=
 =?utf-8?B?LzYwOTQ1STB0TVY1eStNOW1MQzc5Q2g3VC9adEJHQ2RGODI1NmM3czZRSitr?=
 =?utf-8?B?a3R3djJrem1XM1BOSFErYVJNdUhMRnNtS1VYcVBvVlFZQkloU1pZaFNmTnVw?=
 =?utf-8?B?RWJzSTBPN2tVUlhPakNubkpadWw4ekZrV3RDL0FvTmhDMDkzK1U4dGpCYzRO?=
 =?utf-8?B?bzQycHNURzJLU1lvRUhXUkZLd0I4b0dJb2x5eW01bVU4dS9FTmE4SCs1N2Z1?=
 =?utf-8?B?TDJCRmV0RXc4cHNOUmNoZE1lNG1BZWVwVFVVS1lPWThFOGxHTHJTZTY4UWFm?=
 =?utf-8?B?UDVreGRsZ3pXMmRFRStRUGtrVHlYSncybVVDVWRHbjBmcjlyN1J0T0pTNURy?=
 =?utf-8?B?TkYvUmlwbGpnMW9qM1RvV2l3V2puU3dYajAyRG8rVDRSZFlHWDkxOHIvdlEz?=
 =?utf-8?B?Q0t6SEo0YldMQkpySGVGQVFzbHgvTmYyWmNIb1dtK2NlMWtPRGZleENXTWNW?=
 =?utf-8?B?Tk5yaU9TbmRVeEVQVDVhajQyR3JnUkZ1Z05ZWmtDK2hZUkRaOUsrVmFEZHc2?=
 =?utf-8?B?bVAvOWJxdWFhWk5iLzE1M2VhcEF2Rmw2dEEvSVJ5dzBybHFkTG9YaTc2cHc4?=
 =?utf-8?B?ZDJZM2VTYVVQY0JVcmF0S3E0bmc2YXZBMXAvNmUxNFBUR0dNbkVDVlMwZ1Zh?=
 =?utf-8?B?cCs5c3NZb2srVDdycUJoTGpwQzlpR1htYjhzQlJEK090VnhYVGJkcHQyNDM1?=
 =?utf-8?B?WTJ3QzdCdDUxT3hMVFQyRlVJaEVueVI4TlZ2QzJsV1Q2VWlmR25RQUlJU0FU?=
 =?utf-8?B?dGt1VHFyR0c1akt2aWdpUDdtZnZlWmxSQ0VzVlQ2dUp1S0RZUkQ2UFRUODBB?=
 =?utf-8?B?amw1bFFFenBCVyt3ZldwUmFFbENMSmw4anllejNna3JSRGQ0RjRjOUh1MUIz?=
 =?utf-8?Q?vhiY2XQY2VBe6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40500d12-9fcd-4a89-2613-08d983f1a12e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 09:06:46.5558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IxAC6v0tbO3+JJJC/MSUAOzUVHRqpWoFEr3nt+a6Wo6sPoDqiE3d2F8lA5ng8v1GZY4djTJh2mCmhW4QOmbX1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 29.09.21 15:21, Rikard Falkeborn wrote:
> Commit 5c912e679506 ("usb: cdc-wdm: fix build error when CONFIG_WWAN_CORE
> is not set") fixed a build error when CONFIG_WWAN was set but
> CONFIG_WWAN_CORE was not. Since then CONFIG_WWAN_CORE was removed and
> joined with CONFIG_WWAN in commit 89212e160b81 ("net: wwan: Fix WWAN
> config symbols").
>
> Also, since CONFIG_WWAN has class tri-state instead of bool, we cannot
> check if it is defined directly, but have to use IS_DEFINED() instead.
>
> Fixes: 5c912e679506 ("usb: cdc-wdm: fix build error when CONFIG_WWAN_CORE is not set")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>

