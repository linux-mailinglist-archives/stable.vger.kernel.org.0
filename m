Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04893757C7
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 17:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235320AbhEFPom (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 11:44:42 -0400
Received: from mail-eopbgr60116.outbound.protection.outlook.com ([40.107.6.116]:16822
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235918AbhEFPoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 May 2021 11:44:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYbcDtUV3h5gflHqwz/pdQoi2tugSnvv1xZKBm/5kMVWozI71z7wiuPjoMyjwA9SzSmEsB/W4J3S7PbHHprlqG1s0BJXnfMqrMCBThGWfDFVv2+fO9/tCA9PV+godiFuRrtkrHgvAfkiqqAiGns/utBnF89O5VkrMS/fAfu3BzbNC1utm+2kCOsWIwm3YkCJWLzM9uJJ2IO2WPs2F8Oi0evlVSTfTnZf/VOG4dg20j7FN3/0VkGXfdFTXINl9nGCfSdOoyUStG5Zkk7jUJ/AE3poMmiqbTJGuGASb6jyeDvpmG1UWRUJFYBGaabZUGU4GeyKVrZiAYtzyuBnT9J24w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL4R/kII3oythvGuqeBBHsNdF+rsTE41GzaG3juNfFM=;
 b=Nf309YSGo1KhYb0jFWaalW3Rg8lo0NeJvCI/yaB+dXJY/1HFfvAaF71p1Jy64zE5mtSVfj8A7/JieHTe6Sh3g3NlOKWZQ39xYMKR+2n8aRbeYaTC4iU3njwh9tg3q5ZIXftHr1S1ty31A9MRUfRFQcpNYF0DA2r5TjdlAd9KhvLn/S9+Qum8vnUWVqXSrG0xgW/MtHT6Cyz6Nb4O0s8bs9F8IPHs8aEbguqgrdDNGJyYclKAw0kkI3Y5okK5q/JV3bhiQDoE7adYNq8SKnpMbkweUp41kfGSYMJgJqY0xoKDbhslo7/24mFUqzwKz9u9ThyL4tkS/zvtwaSyCiRYWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=axentia.se; dmarc=pass action=none header.from=axentia.se;
 dkim=pass header.d=axentia.se; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=axentia.se;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL4R/kII3oythvGuqeBBHsNdF+rsTE41GzaG3juNfFM=;
 b=GP6NufYJNab4ta1HHPn0CEtLeO9jDxAq8l7zGQ6iqJYVM/16quaogwOYbXVe3egmoJ3ORBVCOgeY6ZmrTfF8+/MgeIKZigA/FCfC0+X5SCYBaQssHBUye6LD0e/JirysisuqfhEXToCqNV2uYRz4o9qdzqaypib5YVCuyOsI9PI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=axentia.se;
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com (2603:10a6:10:eb::29)
 by DB7PR02MB3932.eurprd02.prod.outlook.com (2603:10a6:10:27::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 15:43:16 +0000
Received: from DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908]) by DB8PR02MB5482.eurprd02.prod.outlook.com
 ([fe80::d47d:ca8c:4fe6:3908%3]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 15:43:16 +0000
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
To:     Atul Gopinathan <atulgopinathan@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
 <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
 <20210506143208.GA7971@atulu-nitro>
From:   Peter Rosin <peda@axentia.se>
Organization: Axentia Technologies AB
Message-ID: <1912bddd-0788-5586-1cb0-0400630c32f8@axentia.se>
Date:   Thu, 6 May 2021 17:43:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210506143208.GA7971@atulu-nitro>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.229.94.233]
X-ClientProxiedBy: AM6PR0502CA0052.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::29) To DB8PR02MB5482.eurprd02.prod.outlook.com
 (2603:10a6:10:eb::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.13.3] (85.229.94.233) by AM6PR0502CA0052.eurprd05.prod.outlook.com (2603:10a6:20b:56::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 15:43:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2923e56-d940-4b3e-6154-08d910a5aa60
X-MS-TrafficTypeDiagnostic: DB7PR02MB3932:
X-Microsoft-Antispam-PRVS: <DB7PR02MB3932C3076F942D2C83673A6DBC589@DB7PR02MB3932.eurprd02.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dCaKCUupJwCUNn9aSqC6AF3Q7uCi50EzipX/7x5SDR3oUEbzRqxhjDW/1Kqh2n4ZobHSJmrpRkQh0izZpeCwNpwx/514+RAllLhj+FWJITwiSRK3/dc34HHZbC9uZJxUuKewWbwPPN0tHdP3aT+9ElHh6g/+G5BAGQblelvbNgpWbhfmoyMEQDnBbd4Xf/idvDdukFRYyN/ri1liT1YDY6cCpJyyiWvVdWNTai13oubdOxbxkfUz7QyC3/V3YfY/q254V2JRT+h/l/VIp6615AHMx6V9QckqhM5swObka6q6n6TZaI8jtQc9jo8JtjmAKjaLHA4Ta6ap/cty4nxlSDZAo63jKPdqCmxoRmnWeDzf64c0ox8UhI3XqNPRUGkDnXE01VXLWs61MDt6AHm4Gl2aS4tX1CtrxcxZTSLsSZ7WGQbMLp1ZkQdMswojDreoFjgHfQ7tBP7LY+CSvWPOJSW7gufN9uu/6Khl0/PnkABODZDGjhH+SMzGYX+RjZa3yrLDdl2UGaGm5fb1Eiif68t0ziTR1vVd39ejYbDv7JYeepDzVASW91gkG5Y9zOhwWm7oBtA5Lm1gJeuqlWLamP7MMuRBUcbGygPXSAAD/7WkYMHJhjBIyB3x5Re18LlUeBqKHxdcYfmkH/yX+CXzCu+B9ni1isnj+Pfn7jqjQNDZ05oiMSzHue/MNJcQ8ev
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR02MB5482.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39830400003)(54906003)(4326008)(66946007)(8936002)(31696002)(186003)(8676002)(31686004)(478600001)(66556008)(66476007)(26005)(36756003)(956004)(38100700002)(36916002)(316002)(86362001)(6486002)(2616005)(2906002)(4744005)(53546011)(5660300002)(16576012)(16526019)(83380400001)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzZEMW1CUWZMWUJibWNSWHJlSHp0U3pObGZxaGl3dWNheVhsNFJzd2JldEIw?=
 =?utf-8?B?TkorMytOQkZxREx2TGNKWXhkWjV6RTUwNlNyZENFUmFLVmxZanZuWG42cW9U?=
 =?utf-8?B?WVU3QnA3eEdnRnh5dWtQV05KZFpmZXE5YnBwZ3ZWNitTRzgyVHljVWZ6d2JJ?=
 =?utf-8?B?NGEramYyVnllNnlVSjBSVjVEQ2R3WEhyRFMxbWRJUnAxN2dZU1NaczBWcWNp?=
 =?utf-8?B?bnI5azJVdC8rY3dVYlJCV21yamdHRkFtYTJKMkhkTmZtWEV2SENESG1TUzJI?=
 =?utf-8?B?VTJjODFwOTNTLzUwUE5heEZlTE13VnFEdnZQOENhWk02SWlYSEZramtDblhX?=
 =?utf-8?B?MEgrS2VGVTBjcXNoaFJjOXMvVFUxcHFiemNZS2pUbUswcFVMWEV0OVhTVGI2?=
 =?utf-8?B?SUNNeUhjZ253Slo1S0lSZFlBUEFCTExXZlhWMlpScDhUY3FidS92SENNRllw?=
 =?utf-8?B?UFF1Rkc3WEc5QXhLeUlJVURGUmZXRUJSZnJrNVhMcHY0WEtXNVVzMnhPN2hp?=
 =?utf-8?B?dlE3cmoxMmJYSU1ISzZrQWlnMFZ5VUdUbXVDalFobC9OOHc1VXU4Z3hkVmhE?=
 =?utf-8?B?Q0VINDNDa21oRUVhZjlHT0NMSGZpWU5aQS9VVWZrSUFaNkExUEtrKzlSamo5?=
 =?utf-8?B?c2UxT0ZjT1F3MHdWTTFVU3BtUllQNG1rR09YbjFGK1dYTXN2NkZOSXpySmtz?=
 =?utf-8?B?YU5xRWprYUl0YUllRlluczNSWUR3Ry82clVHbGJXN0Ircnk4aFhnaGUyemhD?=
 =?utf-8?B?a2UxRDdHcXFiR29oMnBjdnJxZ1hDWm5pS0JHN1h1aHE0dys1amdONm9qdDBp?=
 =?utf-8?B?RS9MZ0NaMXdwM2I0WEp6YnAwd3Q0QjE0ZUUwR20rRmNLWEMrempTVFhDV01q?=
 =?utf-8?B?Z25UbXNCaTN1OWg4N2JPS2IzSjRZMkJ3TnRnT0NEcDQ2UnoxUzVJVTkyYmNw?=
 =?utf-8?B?cEVUUzFrTGZtTEdkVWZ6THJWSEQyKy9OelpsbzdTdnZmYVNGTnRYbm85S1Fq?=
 =?utf-8?B?VnMxUHQxSFcycnRWeGl3L01tM093UXJhTWZQSFpvd1VVMHZTcjVoVS8vZ3Za?=
 =?utf-8?B?cEhQTlZJMG05Y0lDSHBkTXNBcGU2Mm00bGxPc1dPU3A2N2xCcGQrNFZLd29O?=
 =?utf-8?B?SHgxcDZRVDZCc1ZERVNIZk1jVDVBc0JSZWQzWVBZYTNZQ0pmK1B4NVdWaHNH?=
 =?utf-8?B?eFcxem5NTEZROGppZm44ZkRkdmV4QldqNSt6WGZSZWN4UEFqZmZnQW1wdVdF?=
 =?utf-8?B?ajhtREI0VTRISWx0cDZPYXBMY2ltcDAzN0FRYWJlOXRZZzBWQW5sMkpHSzM2?=
 =?utf-8?B?R3g0SThJdjR5dzBtbURUY0hqcUlsSXZzMGliSTlrYkV5WkFFMk91V281NEVp?=
 =?utf-8?B?WTBuSTBmeGJzTEw1VmFDVEd6WW8vVHEveGF1R0lzeW9RRU1UUHVuQm53U0J2?=
 =?utf-8?B?UEhuL09FenMxMy8zMmU1Z3h2bVZQRzViamJPYWk1cnpua2ZPKzZKaUdsN2lS?=
 =?utf-8?B?c2NjWmxMbFRkR2RJQlBISkI0V0tkSStlc29KRjFqMm4xMXBqbS93Z1ZVSVc1?=
 =?utf-8?B?VlQ4Q3Uwd256WFFOT3c5azN4MFhCbWNvNDA3aE9hZzhYbUJGOFlUNzVrc3Nn?=
 =?utf-8?B?VldWVW96UWh3S2ZCdkhCcm9VS1dRSHhCOUx1QjJnSVBwYVJaeW0waFBsTGZm?=
 =?utf-8?B?MVFScjJYaFg0YWI5SHhnMlhETkQyRVFVTi9SVjRSY25ITEkyTDNPVW56YTVi?=
 =?utf-8?Q?FQ4Lrfhn+j1cNmt91LPxjQTx0R2MdJUx4nbvwEC?=
X-OriginatorOrg: axentia.se
X-MS-Exchange-CrossTenant-Network-Message-Id: a2923e56-d940-4b3e-6154-08d910a5aa60
X-MS-Exchange-CrossTenant-AuthSource: DB8PR02MB5482.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 15:43:16.5376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4ee68585-03e1-4785-942a-df9c1871a234
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UIkV4tnKe3t0/juW7Eq6F63qQVrjJWpwa6gIE0OtpkTCDdkSfyVntWDfUaO2K0LS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR02MB3932
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 2021-05-06 16:32, Atul Gopinathan wrote:
> 
> Apart from this, I don't see gdrom_get_last_session() being called
> anywhere. But I could be missing something obvious too. 
> 
> If you don't mind, could you point out where gd.toc is being used in
> probe_gdrom() before it is kzalloc-ed in the same function.

You are very probably correct in your analysis, and I can't find it in me
to spend the time to dig any further.

I simply thought it bad enough to hand off a pointer to a function that
uses a stale pointer to some other driver. I never dug into that other
module like you did. Relying on that other piece of code to not use the
function that was just handed to it is way too subtle (for me at least).
When you "register" with something else, you should be ready to get the
calls.

This is true especially in the context of what we are fixing up here;
broken shit related to people that are fond of weaknesses later to be
activated by other innocuous commits.

Cheers,
Peter
