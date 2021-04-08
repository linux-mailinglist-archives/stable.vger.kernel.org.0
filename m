Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DC83584B9
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 15:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhDHNam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 09:30:42 -0400
Received: from mail-bn7nam10on2131.outbound.protection.outlook.com ([40.107.92.131]:3040
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230322AbhDHNaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 09:30:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjBno8ZM88ZOL96AQWnrtefSwKothK0EvawmTCyH7FClMVVJ/KGPRdhw+eU80mwi47UfdqDebQEpaDyiZ3XzMMYYjTLCvCp2WV9/I9eBCmR9TbGuO9RPNBkbQWC62uKNz5uDmhqHwSqYNHXNhCrW86x9p3sULRmG4WsGv5rQFve+rRSqbUyojlnXC5LCzWnVaPEkKD9czMgMik3GTkw8obs+dA/W+fxgxi+x9WI8/cVbCtX5aUQk+wKtMLyv3JVwY7RZ6WGZXTkShG1jdLHuwW/wVs84o9suUEOO/VDmKPFFNrnCcP0oXWnaTJhP/0nV6LqNpF4yRG3PZXHcbz4iEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35i6bl/o9ZNA9nW8LXuDR4La5j4A2jEEhvJHU38usW0=;
 b=iDldxWZxx7xMqKnqc5fVPT6GlYDv30yBdwSsMxO3UlPCzZx0FJPpl/4R0F/HRDE6Rik6mGWeB6qGeX8Oj0r4UtQmSD1mztwJxcjvSGVJc3P0yKrtiNPf4jfzz0+P8Z3A8jTgUS36Zd/vjRuydpFMasSoiN3FOY3oY7ARQp9B0txBneBRopycuRK+1Dv+K8zj62lWLKyhKsNq8+NRaTZ2X6L/7iSOfwht+l7IBbsP4xMpaD98yc9HG7gZOPv67yVRVXx/pIDAk/evdVANzOq9JBG2HY3epj6O4U/KRs2/cB2w3N9UmJo2Qrjwbf3j1c0DwL0uYD7I5Ze8KL9eLrGrxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35i6bl/o9ZNA9nW8LXuDR4La5j4A2jEEhvJHU38usW0=;
 b=D1UO7r0r19/ws2sKGSOwT44eJcl2k58DLJbrH+7vwaytSDqofqNhTyrbZIJeY4RMN4hRNn8JPjOcF9RGyP6prizn/PJ/zbWgPr92b458ImctTcIpIiyiSEhq2mHECijsIsrQ3ahDAH+LV2WnE8szaIE8MhSY54nCUHFP/cukU+hn7S0tqhX7+MkPn0FZigDB2H8z2WrOhXGYA/VFjv7z8eussnW5UTdfQyiog5wq0oQfOIpH9vYGcLPa50IGcK/h2/nKZWu1doT9PuclN57KkINaWFX+fZtobuy4bcUhFIffCBcCAmfYZcmfP3wkFif0XKymqvCxw2kiykKfSaavVw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6453.prod.exchangelabs.com (2603:10b6:510:12::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.17; Thu, 8 Apr 2021 13:30:26 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 13:30:25 +0000
Subject: Re: [PATCH for-rc 2/4] IB/hfi1: Call xa_destroy before unloading the
 module
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Kaike Wan <kaike.wan@intel.com>, stable@vger.kernel.org
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-3-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329141123.GQ2710221@ziepe.ca>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <0e09841c-2dd1-2f3a-c77c-950d7d19bf50@cornelisnetworks.com>
Date:   Thu, 8 Apr 2021 09:30:16 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210329141123.GQ2710221@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.154.216.5]
X-ClientProxiedBy: BL0PR01CA0034.prod.exchangelabs.com (2603:10b6:208:71::47)
 To PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.40.159] (24.154.216.5) by BL0PR01CA0034.prod.exchangelabs.com (2603:10b6:208:71::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21 via Frontend Transport; Thu, 8 Apr 2021 13:30:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1d6cf3c-38cc-44b2-ad94-08d8fa9277df
X-MS-TrafficTypeDiagnostic: PH0PR01MB6453:
X-Microsoft-Antispam-PRVS: <PH0PR01MB6453C62D4B31D59085AC6C3FF4749@PH0PR01MB6453.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aYLeIuyaPT2bcenVAg6fgtsPolzQOvifNZanr37x+PzJyIplIfyNpAOHXXP2HRM0jn7uI4yMzMqUGwKNk4lCGG1o/V7WbgBi7TAgIwoSPOVEsKw71DdwD8BfnbKLDmZ6XcpkF1Ci6Lc/AveRAPJbA38CoQe8PbMxMahevyn3xLRIm975zQUzeOeYYu+KsFNMk5yvsZdM3jFs/ND1T3UKpxCsUAJ1nnChbWOYKEDfGF9Ylm+zDXSjeEIqM6lhaE9MXGbZy0yMOgpY8mqyz0kklVVTKzzELgHa1joJPn2RnDxjt0F8YMcyg6RExhKOG67jgvA3Sv+WEK8L1KbNAc3ECvnpSICgMZ2iHgThN3icsrVz9HOoAPN0mj6c/QL+6eGHZMOabc1oz8zMniP7yTTCbogGKjJoO/VELnLLO2PepNoLF9rQes5Nhm3d+DSDkkB2Qv8vXiL6MD40kw/C4CHcswiLWojaO0vVFBEp03KUs0SxY31y63FQRMXkgIFGB8469F0utu06B0sQ81KCQ4JL4RCAoDmkOLM2oO62WSH+1ReqrHVL/e5xOtsLZWCPJSL2wzkOH7t0brgV119I5NpD9JL5ktg/AElG+cV//ieXnQ8ge/lMsj4SB0ZUpLOQLpnLZvoQmtzfJijaQ7PeFmUy8UQWYCPkrr++/DYwiNjmTTNMNLGQTV4ceDnhSGI/Uzpw4MQ2Oa6D8U0deftSmhZiaWxPk3kgv9J8dCiYjmtHUQ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39840400004)(136003)(346002)(8676002)(478600001)(6666004)(53546011)(5660300002)(16576012)(36756003)(52116002)(6916009)(38350700001)(38100700001)(26005)(66476007)(66556008)(2906002)(66946007)(16526019)(186003)(4326008)(2616005)(956004)(31696002)(44832011)(316002)(6486002)(8936002)(86362001)(4744005)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RjZLakRMV0ZDM0ZhT0R0cGZpcnhuOHNhWDYyOTJtbUFoQ0V6SUdVTGEyY2dZ?=
 =?utf-8?B?NkxHaXVXc25pOU94b2E3K2x2czg3b0ZSL21Sai9GZWFxbklIeHRzUzZUcVdO?=
 =?utf-8?B?SmswQWJQVlBwZzM5dGhYaVl2TFpkRXR6U3haeGkvcE02SXZSYUpnM2hlTXpy?=
 =?utf-8?B?REhhcmZ1K1U0VUx5M3VuR3dPTzFVb21BS3RXKzU1QmZuRUlDRVhDdnMyMzVU?=
 =?utf-8?B?Z0REc09sM1BuZWpFdGpoRUtKeGpYNFNsY1NvNytoTlpJd21rakNNTENsZ29v?=
 =?utf-8?B?SGhXSk9WMnB6SHo2WFJDU3o1THh2RnBzUDJPSERucjBMNXNiSFc4UXJmdkJm?=
 =?utf-8?B?RkYrSWZEL0I2bkxvaFpUejVzam9VV3hnMGlicTRoUytCcGdQU2pZTThTRXZn?=
 =?utf-8?B?MTlUbkh4aVZ1aUROUENBcUwveG13ckxwVGJBT1dSU3QyOE9LSExYdUdxVWdD?=
 =?utf-8?B?Mkl6VmxFcFZqYTFkb3pLOFRGaW9GNFhMakJXR1hhc2lmVE5FVlJUQngrc1Fr?=
 =?utf-8?B?UmRiUDRWMXU1REVzWWdlcDZITngzaEE3NXptRWJPZENQdjNlQmRHYjgvZU9w?=
 =?utf-8?B?eGNIcXk4UDhyd0tINk1qRFJuZnQzbTdnMDVKb3dxc084TEZ2YkRsM1JxYTgy?=
 =?utf-8?B?WVkzdEJXMGtMQWZJM29KTHBGVzJJSWNzZ0I4R011UFRNMU8zUm1PbThpMVZa?=
 =?utf-8?B?VnFhaEx0MnhkdzNUT2xCMVArZTNWOWlVNU5NSFhKNTZpLy90WVdmeWFLWmVw?=
 =?utf-8?B?dnc3MEIxdExnRVRsZkNnZkh6Y0pqbmhHKyt5TG4rMUNWMjIyK1JaU0M1UjR5?=
 =?utf-8?B?K0t3bXlwZHRrTTQ5V1Z1a25kZGJTQ0dTaFJLNVdRakZ1VnhKN2Y0S21OYlRY?=
 =?utf-8?B?eVpWOWkra3llTTAvWXFiRHYxa00waWM5cFlRMEdoQTRPYm91RGh2aEhXODlo?=
 =?utf-8?B?UGhSMURVYW5CZmJyN3JZRVhBSGUxM3FMczVmdGZXQ3ZrNEJyaTNOYUhhZVFB?=
 =?utf-8?B?U1huSEZnUDNFbEx5VXVzMzB3dTdKVjlrZlFzYkFGVjlGanVaQlhhbkdvaU02?=
 =?utf-8?B?bDYyblVSWk9VaUswT29MRVF0RDUwN01KMDQzMXVTQStXejFIVnp0OEhoZ2JZ?=
 =?utf-8?B?NVVIa2xDSmhEMm1ob2h4dThsdE4zNEVLUDBob0t1Z2hzaUN0TGE3aHFGZDMr?=
 =?utf-8?B?ZmplZ3NzL29jT2VnclJDVFF2TU5qVzJGeVZvdmp0TGlKb3BXVk1kVDh3UGZH?=
 =?utf-8?B?azVGRmprcVhQdFFWUGJ0Y0ZmY0VMSGZLZVRJU1Jya0tLaExvZnJNKzd5SGNQ?=
 =?utf-8?B?NHhMdWMyTWdja0Z1dGh3Q0FsVEM0d1RtWHhTR1BHUDN1OHpadXh6akp6WTNI?=
 =?utf-8?B?bkh2ejhPMCsxQVlIbmFSaXRyL2dMTEdoTklpUFJUeVBnQnovVHVwV2ttMzBC?=
 =?utf-8?B?Zi9iRitzczZPSGZQNE1mYzR3S2lWZW9iRmRlaFB1alY2aGpjR1JmdmJQRUJs?=
 =?utf-8?B?OFhrL3BSQUtIZlNKUG1vYzZ1QktBVjc5d1RJcjc2dzdMWUdRdjV4ZjVJYVg5?=
 =?utf-8?B?RGJjdFVlTFFxVGtHNXZxbitYNlJqSXdoOHlTaHpCQUd1bXN3RVdGRVNVR3lS?=
 =?utf-8?B?UUtldzJYTVg0NWUzOTlGL3p1QWR5NXZWVE90Y2d5eUFadUY0NVdrdEx1eWY5?=
 =?utf-8?B?VitMbzljT2Q5NUVURVBXSXlQSk41aVZIMmRoeko0Ny9KSENBdUJDcXFwSjMv?=
 =?utf-8?Q?jYY642jn4sJb9pDetAE5VnH/GxhQJjoo28t7un8?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d6cf3c-38cc-44b2-ad94-08d8fa9277df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:30:25.7795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hxz9dGFJImoj45yCC8+JuJSmupPhXLvosn4yX1ezqtYhClZOYFmdUA4WTs4+qtWeU9VC2lAkWA1TPh5EzAVQTvnrlrCiq/oDmfkpaFaGh5M1KhpkpVeFVdNcT7roKKhw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6453
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/2021 10:11 AM, Jason Gunthorpe wrote:
> On Mon, Mar 29, 2021 at 09:48:18AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
>> From: Kaike Wan <kaike.wan@intel.com>
>>
>> Call xa_destroy for hfi1_dev_table before unloading the module to avoid
>> a potential memory leak.
> 
> Do you hit the WARN_ON or not?
> 
> Is this all just mindless?
> 
> If the xarray is supposed to be empty because everything was erased
> then you don't need it, the WARN_ON is correct. An empty xarray needs
> no further destruction.

Looking at our internal bug that corresponds to this change, I don't see 
a WARN_ON that had been hit. I think we should just go ahead and drop 
these two patches for now and if we do hit the WARN_ON we will revisit.

-Denny
