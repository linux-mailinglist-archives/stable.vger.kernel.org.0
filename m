Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB60C3757D6
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhEFPsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 11:48:17 -0400
Received: from mail-eopbgr130132.outbound.protection.outlook.com ([40.107.13.132]:17482
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235136AbhEFPsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 11:48:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcUHNKIKlns4QpdO0DAV/uN26zdHNO+iIq6a6VpA2Z+5XIJKYcR9JyAiXZu4PmulZPyzZexTJgJ/PFRsAG5uUiYxdUEPjkYj61vO4rSn1y6coY18Cdimd71joM57Z7dSOLDm9ZobysHMYVwK/HOBWqcwL64RqA7zIOtKYjdjULVcbQZELeld+OUATjuD2RSZDM5L2fSlEOXcKV6JH3UUSuSKemzPKSx+7v9lwZiErUsEiK9bA5HUO08PKY33ZDNXgvtaaga/LBGJ/TRVBbzcZIDPdUl97PCRXvZmrUxdOBhYkpoAMMmmfSD/jcwdhoH+KeFNT+su1yecuHlThI001w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtQP8OnWW5olJIvv83bwysVgMOK5+lRb93ialpCuXYM=;
 b=HSHrGxFyES4yvtgjdIIUs1gONR7g0SGxK8j06SKBiCPSGTCaSopEE6Yo3DA0kpH+BwYF6BYKVCd1Gm7sgdaffdmWhQln/eprGYC6mS1wdpEq8B7Iw5Zv/szSIqT7OcLB/HkIH2rd6R9jPkLuH4gzE4bFSim+GLbZZQSCKBerd4/olEeLhix8nzKniXoRNkVFaEsWKHVroCw5zcCVkjQI99YAiLTEmZYSa6mcHGILeq+4sGUHov9LB/8oWHunLu+b1A34OVXjGHxlUSVNECymGoHnGGO5ft0ZYS+Nai2BdlXwgHmGIFv57sZoo8pWzo8Od//1Tyt0a7L3htE/H+rQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wtQP8OnWW5olJIvv83bwysVgMOK5+lRb93ialpCuXYM=;
 b=a2Xo1UFLcE9bcmTxS2zX9/0GRBmWKMtT9uR5rb+c5qj1OPdvBbhwcatuFaOvIfxsIjcQuwMxA5jPTyf0Hj76LBWatOoKvd9KikSmAtiuk9Xbf0ueoRMcY9kYwd64/n8IpbHR+1aHM7LEgPY0Q9cMQIu1+pb51AKYpTDXMuL29fs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=axentia.se;
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com (2603:10a6:10:eb::29)
 by DB6PR0202MB2613.eurprd02.prod.outlook.com (2603:10a6:4:1b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.43; Thu, 6 May
 2021 15:47:15 +0000
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908]) by DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908%3]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 15:47:15 +0000
Subject: Re: [PATCH] cdrom: gdrom: initialize global variable at init time
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable <stable@vger.kernel.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
 <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
 <YJPybgcWYKLpyBdK@kroah.com> <YJP2j6AU82MqEY2M@kroah.com>
From:   Peter Rosin <peda@axentia.se>
Organization: Axentia Technologies AB
Message-ID: <418f72b7-0161-d7b9-2747-3ee9c9372217@axentia.se>
Date:   Thu, 6 May 2021 17:47:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <YJP2j6AU82MqEY2M@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: sv-SE
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.229.94.233]
X-ClientProxiedBy: HE1PR0502CA0020.eurprd05.prod.outlook.com
 (2603:10a6:3:e3::30) To DB8PR02MB5482.eurprd02.prod.outlook.com
 (2603:10a6:10:eb::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.13.3] (85.229.94.233) by HE1PR0502CA0020.eurprd05.prod.outlook.com (2603:10a6:3:e3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 15:47:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3177d551-911b-4153-91b4-08d910a6388e
X-MS-TrafficTypeDiagnostic: DB6PR0202MB2613:
X-Microsoft-Antispam-PRVS: <DB6PR0202MB2613BB2E9F5A6339A8F4DD22BC589@DB6PR0202MB2613.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfTMbiAzYs9Pl38dnYTRTCYuwzTPr+4+hvoNsfG6R9wfIjIrxG7ohA2XSlHOTijTGy2s3MN/GjNrxcTpB7xp2/xLcGIn/Cz2pYQH7MDPCoSllKooCgrKm/Wt//Yrxef01KaKVyyVpywA6VQLt1lWK2hsTbbuIM5IbZNLlSD8bIx5crx1gWuEHgJbZ036JoLb6ij0k0TPJeO96RTocWSXhy3qvVBSRmLc0MK94KPmtZvAnK4iaFxnX1G+j37OyVAFMcG24bJ9Ujcb2n4abt2+IGdbfLBT0vZB/IguYb5JnQQoWvSbpcN7wiOPtIoGoRNgJ/0Y3+9hJAGv+gJnn0co0TZcMFABcJmZitdE+TrZvWFq6hKYwV09wCqEoc9s2JlUYG5UgZoKKRnf6UYhU17upadPWddyCb8ntVcFKn81cvDzeDX/85Zms2f4V0wz+ryDoYeEuQwgzyqUbqMfOGKgZagGDEycx0gzkZFtxc4b5zflWjnw+0u2iRdJr2Q/BXNz9pE8oS1qV+wH2e+1xdnf9wRhB+1ywATjaJmRgI41t22dH56QZiv9KRlSkG+bua4VbCCbc0VXIKxQf+zL0fdpnWZUpk7srwYNeDX+P4D46CO4IdJyWZ/1XXQG8WBcycsee8Wm50cz+rc0O+T1j8DoaDUJC6paeYB+1VGRxj24sBvNfGmADQAocD0PMDXp8a4f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR02MB5482.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(396003)(346002)(136003)(376002)(66946007)(5660300002)(4326008)(478600001)(36916002)(26005)(66476007)(31696002)(8676002)(66556008)(8936002)(6486002)(53546011)(2906002)(956004)(2616005)(6916009)(316002)(16576012)(54906003)(16526019)(4744005)(36756003)(38100700002)(86362001)(31686004)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmJMNFFsZmxmeXk3NHJCSi9JbWZpR09HQi9EWU03Wm13YjhIei83eEpjMHcz?=
 =?utf-8?B?Ukk3bDZZbUdsQWxDeWFtenVUYUJqK24zWEVoL0JGZFd6cGZrZDcvMGNDdC9G?=
 =?utf-8?B?Qzc0dVJrT3lDNXczYW91b3BGL1dsZUs0ZktCU1JENkVYZHU5bDh5azM0bWpz?=
 =?utf-8?B?bzFQTXMwa3JvdkkwR1hWaU1hR3RkQzlpUUhldmdaSXJ1Zm1lTXpSYmdDb2kv?=
 =?utf-8?B?QnVvL2RzdkNRWlFHSk5od1ZoNGlsWWovMHY1YlMrc3NLWDJuWm5SdUdBU3k2?=
 =?utf-8?B?cW9NVU1CYmlkNVVOSWhOcURlWll4dUg4Snd1T0J1VlpMN3FFZkNKanA2RTli?=
 =?utf-8?B?M0tuNkhabkZXam5ZMjgvcHNOMUVlQ202RTRBUllPdFVTcUdVS2JIMmJnaURV?=
 =?utf-8?B?Y3hIODlQT1hIV0t3ZzdMeUEvRmlpVW93TWcwRDdPdUh6RHhqbldwelR3dWlt?=
 =?utf-8?B?QXlrZ1ZYWm9TbWdwbE9vOHlMdVVtWVcwSm5FWlNlSEgzdXBRNWNxYzd3M0ND?=
 =?utf-8?B?cVl2bWlYcDNZSUx3ajI4T0RXRWI2WE9XS2ZWVzBVSFBlRFBBZ1lkd2RnRlVO?=
 =?utf-8?B?ZWxwZUMvQmVya1hoRG80U1EzV3lQM1crVUQvR0JKUjRmbHpZQTMydmIvbENv?=
 =?utf-8?B?YzNNbW4zcHhFd3dnWjNqbWtBNXMyL0F1Mk1FbC90THh5OXJURkVVOTVtZmdW?=
 =?utf-8?B?aXVubndsbFQzNnpCTURuKzNicm1mVE1uZFJFU0t6T2phTHRmaHhZeVFtbHBW?=
 =?utf-8?B?V2REamc3bnpiZU1YZER3VnlENkcwWmpqcFFyNUtrcHlHZklaTzV4ZWc1eVJ1?=
 =?utf-8?B?em1naWl4blBkYlNQeEZQTXdnOExUVityd1VFWSt1NlR5aUcvWVlnL1FwY1NL?=
 =?utf-8?B?OVRxUzFZRHBSeFNxck9JcFZBazFyR1JtK21adTdac2VsZ3FPMUljTGJVWmho?=
 =?utf-8?B?MXlicFN0MXdURFNhbDJlRndFczg3QUcraExyTDBlWUhWTXQ3d1dFTm1GTHZX?=
 =?utf-8?B?SjlpQ1l4MG5EcC8xNzlxaDJleUx5SmJ6VG5PeUE2ZG4zRFFXNTg1eEFVYjlp?=
 =?utf-8?B?c2pWSVZ3VUpBOTR4UW9IYWlpbEkvZ1ZVWW5xRFdvZ1ptVDYvQmQ4STBTRmsz?=
 =?utf-8?B?SVI0b0o5M3dRWGtFdTJqeXA0aWU1bXAxTUNUNitRdWJocmw3OU5QMzFzTlJa?=
 =?utf-8?B?eDlBQnZESEprK1B0Q2QxbHVEOGNOSFE0UlRyZzJvTmJ4bk16YWhjM3RVWlEz?=
 =?utf-8?B?Z01uTnpWclRpUzFvWXRlVUJtTGt3WXlQV0cxdWYxNnpYVThsZElqYmdWMW8x?=
 =?utf-8?B?enBvTnE0QmExVDBtSHJUc2lUSU1UdUdKOXJ3TmlHdGUvVFNrd3RPUHRvOUho?=
 =?utf-8?B?eU11SzU2d2Q4VUZOcEtIVUJHdkhPc2FmbnlGdlBXQXVqY1A0VlVTVmsyVUFy?=
 =?utf-8?B?NlR0RjZVRUlObnZ0ejA0MTlrVDBBbTM1VW03NHhUVGhGU2Yva0xZeHBiSmYw?=
 =?utf-8?B?WURKay9MZ0tlOTExRFpRRU10eW42U2RZbUNISUcrdHR3eWZnMHZnbWpaaXZr?=
 =?utf-8?B?WnJnTXcwL0ZRbVA1OG9PSmZ5RDVJczlteEtNaTRZRERpZnJjRzFaZGE2UTcr?=
 =?utf-8?B?MUx4VkEzS2ZsdkdQaVpGUmo4cGRFL2laM0xtcDR6emRCZ29TVWE2LytXcHVu?=
 =?utf-8?B?Wmpad3JZbmVITVlnL2d3by8vUjB0NEZWbDQvY2taVkZPRVRuTWp6SkF2S3pu?=
 =?utf-8?Q?jAyt2irr5A4fN5rOIbY8tBpV8pt/2VMlskQmo0q?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: 3177d551-911b-4153-91b4-08d910a6388e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR02MB5482.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 15:47:15.0108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SaDA4rPUa4PuOyMiXskzwSOpnxo1BetBqvaJeWEfEfKBjVohB55O1Qx3uDOa3PQs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0202MB2613
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 2021-05-06 16:00, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> As Peter points out, if we were to disconnect and then reconnect this
> driver from a device, the "global" state of the device would contain odd
> values and could cause problems.  Fix this up by just initializing the
> whole thing to 0 at probe() time.
> 
> Ideally this would be a per-device variable, but given the age and the
> total lack of users of it, that would require a lot of s/./->/g changes
> for really no good reason.
> 
> Reported-by: Peter Rosin <peda@axentia.se>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Looks good to me.

Reviewed-by: Peter Rosin <peda@axentia.se>

Thanks,
Peter
