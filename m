Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB83575CA
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356060AbhDGUVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 16:21:12 -0400
Received: from mail-dm6nam12on2103.outbound.protection.outlook.com ([40.107.243.103]:25121
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346362AbhDGUVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 16:21:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQgj04XQc2wTHEwVIL+Hk+k6vgh3ALpZ2RMcimfOrz1Gbtk/pE7/iOwcZ+sB9EZe/eqGWpLGeHPGAPiU3ZQYBZK85DuKkE1HunbLomeCHg95Iu685yfumF7gbugzlFSgl0ZnF0FHl0noPLbiprv3Ay301CrTgWeZ7FwY50F9HjZV+y2WIqX7qSJze3+5I9kV5wbIFk/FiXEM77Av6OJt/XbYNldqcMJ8UDPFIpK41dSgrTztNM7owpi1qiSo2yUhRWwSO5Se7ryeSf8DuI8uwqMDabmk5w2xOkgTVBFNJ3kMs2AHtPdUJ8ng70WGj8axrx/yx8QLve9DOGOUZUK9+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa6Z6pVxpom+tHRiEcNne4y/SJTBQIO1jtFss6t4Mss=;
 b=asmI4+0M/LKYKtVPIck23NvCDvJ8+NjbD/OhGn+o4AuDBIhezxva3rKLUp1HEc1lwsY/4If+9HKMbgedQUma4bGW/2EikzBmQvAQtIAV8b9CnDXOmgxgWNi/fGU7z/6nPxjabz1VA9UPdg2cp8/6NAzXf190oYoj9XSlQxG0a0LmJ4a7ksa7Xw3xGEd07h/JEsApeg5YqRfhjUpbrFhbOvC+Zuh2l+crsVmsShO6fMqPdQsA/taAyh9fKDnrKmd2/VXenkPqXzkvi3fwCR96qKzIG5221Ol65iWDEFai3/aQxnBNwG7VZ4TsETMj5mLV7EisJjxOgTPtPSRbtN/LXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fa6Z6pVxpom+tHRiEcNne4y/SJTBQIO1jtFss6t4Mss=;
 b=aYsNttQyV9OYuXeFlvDbBNQoU4Wd8Xdo+/di8yELhMZRvDZvR7eqhGHujwaXGbYTTn4+9RgA4XJ5maAYv10TFsjQ7G4ICBa0NtojREDFzfuJcn2Wcmrs7Za5s+MJPSl6pHZL9bj4SpevhX55ctRMQV+qm+g6HW2AFXjIj22qkYJ8L2UB0HDibttZxui325DtUvx/JNEt1kPdtgH7HNvyftegjSkDTOB5rh29taCXUFv+nZSPhvNOOL6hrb5QExyZ7hQLQaA9ENfNdG7sgDcfxRMDYqbtpKXfIgcqUWCGQ1AtkKyZ5KDV9XTRrQmjEYqfGgVsEowC6qUZZvp9eQfLwQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from PH0PR01MB6439.prod.exchangelabs.com (2603:10b6:510:d::22) by
 PH0PR01MB6309.prod.exchangelabs.com (2603:10b6:510:17::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Wed, 7 Apr 2021 20:20:57 +0000
Received: from PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860]) by PH0PR01MB6439.prod.exchangelabs.com
 ([fe80::75a5:79c6:dd14:3860%5]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 20:20:57 +0000
Subject: Re: [PATCH for-rc 4/4] IB/hfi1: Fix regressions in security fix
To:     Jason Gunthorpe <jgg@nvidia.com>, Ira Weiny <ira.weiny@intel.com>
Cc:     dledford@redhat.com, linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-5-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329183609.GA3014244@iweiny-DESK2.sc.intel.com>
 <20210407183341.GA551308@nvidia.com>
From:   Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Message-ID: <2dd3a09a-e0d7-8763-059c-3fcf4e04d1a7@cornelisnetworks.com>
Date:   Wed, 7 Apr 2021 16:20:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210407183341.GA551308@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.154.216.5]
X-ClientProxiedBy: MN2PR14CA0010.namprd14.prod.outlook.com
 (2603:10b6:208:23e::15) To PH0PR01MB6439.prod.exchangelabs.com
 (2603:10b6:510:d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.40.159] (24.154.216.5) by MN2PR14CA0010.namprd14.prod.outlook.com (2603:10b6:208:23e::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 20:20:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8c59e08-25cd-4a5b-6de5-08d8fa02a719
X-MS-TrafficTypeDiagnostic: PH0PR01MB6309:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR01MB6309477570D0DFE10D142DA6F4759@PH0PR01MB6309.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: al+N59UBiEt2LBQfi2k4Xb7+OVZ9AnOL8nMsv9XCUe0P6vCySyRkL6F3XI9L7Sn71PX5KPQhcznkPwiVwnezKYzGi6Vfg82zwhzEtD/RWqO1IpndBLVncqrvlInrcNlJ411AaJVl6aUf/r591LzyGpehsPzzyAcwsqb3Vyuihad5nW/eqCzO73z3Qhrk6ik1hlxAz6l6NveYFzVyVCxHMTRULQrtBgVr9jlQAphpaqB1RrBX5s4tMcg+RT9/Pa6pIv4ORjMZ/cZZAWg+8f1zEbCiYr2tfBCD8B7yIcBqEKJx4BXQMXx3B0Oe5mw1bm9ofLiD7O9CZ2F9Rzj3pyvf0BiiPLiYUQ0bAL7mI5hkL/uV7yshfDtmfy2pwmKbuxDa9TojkE3fmwpjVht0xOEq602RuzDUuEeoQSp3cBK8/b79rqvSycOkUMplqfA8hWs6lMD3oOxQZUC4tFS7GfPS2dP1h8ABhPFFOW+ayCTTprPO9/cOUBqyn8e8PPGP/hdhQBYzrY35UdTJsA5FrHwyM0OW0JkVGsPy4X6zde424TfDUh2bbbq8td7AjFyvACLzp4e3osYUbBh+0MIrysZkyTvWibHs55AtrJaS7ylgORWt/QGTqeZJHMS9g7Ll3Wky5gXFl5OY3gkRdGTP5K1oWUgNbxQC4/+iycTie12hVA5slvg7HNf1L3h8Efg7Nl4UYtargQh2TRKuPsvOr9fMTac2aNnF6BJVkU/6w+NrPv/m/eIIRxyyfpH0MddUXcnl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6439.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(39840400004)(136003)(396003)(31686004)(8676002)(4326008)(8936002)(5660300002)(86362001)(83380400001)(26005)(6486002)(53546011)(44832011)(6666004)(38100700001)(36756003)(186003)(16526019)(66476007)(66946007)(66556008)(15650500001)(31696002)(2616005)(16576012)(52116002)(2906002)(956004)(110136005)(478600001)(38350700001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d1U0WTZCUFRPYjZyS29ySCtTZFZDMGpRSzBoaEdxbmV1eFQwZkZHY0Y0azEx?=
 =?utf-8?B?WFNqMW1LWmlNc0NnUFZ4a0VQeTQ5Sm4zbmFsbytrdVRGb25NQzgyR3R2THRI?=
 =?utf-8?B?ZFFVMnFzSkN4TGFrWG9sWXBsU3hTUVc2QjlCZkQremVYam1jQTYwa3FSTFBh?=
 =?utf-8?B?bXdxZTMxa2JxbFZhcHVLNGp1STU1VGR2N1pEMEg0ZVd3VVFZakM0Ukx3dXJt?=
 =?utf-8?B?OVIrbmVuL2RBYmprT0YyanU1S2lUYjNZbCsydjRWb0gvRldoeXpRd080b2hs?=
 =?utf-8?B?cjh4MjI2bFBpQXlJaVVhOTZCZC9nay9jejFzVkNOcVJPajNGdGNiZVV0cmR3?=
 =?utf-8?B?cFFNWXN6MndRQ2E5blp2bnUwVXZITGtObVJoeWpEei84WUZTbFpBL2RGcllD?=
 =?utf-8?B?WXNKVFpHdWJZcm44Qk40ZDRNSTBucWVzUHdEaXB6SGc4OWMzN0o0QmFVSjM0?=
 =?utf-8?B?VVI1bXc0VXArblJ4ZXYzZ0FvNTFYZVVVWWxtYTU4UG5PTUtUWWo1VkJtbHhH?=
 =?utf-8?B?STFkeUZjdjltTzRkdmFlRXZ6Q1paTFJSZXVRSjVmdkgrOEpCRnZwSmFqT3Rv?=
 =?utf-8?B?b0N3NVRaVjljKzVGUy9jeWtscW9zdi9icEdsSW9wbVB2QXRqb1BBcG5JREt5?=
 =?utf-8?B?L1lGRGJYdEpWQ0E2SlNZaHlPZ1VaL0k2UUc4UkltMllRVk1DK2U3NHJ6VW9q?=
 =?utf-8?B?ODlMakxpM0wvYXUxMURIdEJxclB5b3Q5QnBWaEFSVkdiN21FL1hZUm1HMm9v?=
 =?utf-8?B?c3RUbExrT2lqQmFWOUJ5QjZkNjNqdmdvWE0yN05meEZRcldxL3hzRDhleWhy?=
 =?utf-8?B?NnVka25UYm9zVE5iMGIwVy9mdWI3SW1qdEN4cmtqQUE4UVoySGg5Z1pST2JB?=
 =?utf-8?B?UDFmNDlLaWxGZFlQd2szMzR3d0lwS2JUZk5YTGZpK0pTZ1ltNmgwcEsra2dP?=
 =?utf-8?B?MW1BZkdOLzBwNE9HeWVrSmRrNEtCaHcwSmdOQ2xtVXUxNFFaSDZoK2F3U0hU?=
 =?utf-8?B?RjNuSjRXR0hFMFBycE1zQ2VjaWt3a0hCZWtaTG1HL0pTNUcxYzBNbUdNOVgy?=
 =?utf-8?B?QkNqVkZncnZ2N1RiNjRnZWtPb3lzU0dYbHpneXVkZzNQQk51c296bGZrN3V3?=
 =?utf-8?B?TnRRa3UzalJiUmhWTm9pWW1UWkZ4ZS9wM2ZjcTV6UWxqaEtlRnBnWGhDajBY?=
 =?utf-8?B?NVE4OWpBNU5yd09oUHRZbEVyMDc2UkZ6OTNNOGNZcktBeDlrNHltcEZoZFpa?=
 =?utf-8?B?OHlyTGNkMmZqZ0Z2MDZ4cThJOHhOclphc3RROW1CNHhhbnljLzY1TWhhRG1h?=
 =?utf-8?B?b1NXcEJPeVh2aWFUWHJmTnFYaHRxQVZsR3JlWHdHR0dEaVhCU1VndGVLYnQy?=
 =?utf-8?B?Zmg0WEVsSkNsN1FES3pXNEQ5MUJJd1ZXakthN3VZa21oN3BsOVJvSlI5SHJh?=
 =?utf-8?B?THEvVHE0TzIvdlIyV1FVeDRpTTlwSGtXWjJ1aVJQMVNqaG9CaC8rQlV0Nm5t?=
 =?utf-8?B?alZJR3dTQWN1ZzYrUlA1TkZ0bENuWmFXbGUvRVpWRy9IZml0a0J3UDV6aGVC?=
 =?utf-8?B?OWNCcWlQSG5YOEZka0tGQkhhM20rNkdncVpJV0tERWt4bmZ4Zkt6ME9XMFZM?=
 =?utf-8?B?SEFvOXNPbTZJekVKQnNsOXdSUk9GdHF3ZWJQdVNtN0ZESmdMbEV5cW1sL05R?=
 =?utf-8?B?cVl5OHdXTlBSbXljWk5DMkRBcld6bXptWG5FNDJjeE5KVzB5NUEwSGRxTVM3?=
 =?utf-8?Q?JDshQlBA9LzwjjtjwerYP+V1lQy8gpPNvInLE4A?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c59e08-25cd-4a5b-6de5-08d8fa02a719
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6439.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 20:20:57.5266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XhZ7l8UvI6tbh146rOo43BiqsxLjQKvvYJSiaTjOU7sfqtmH07qCkolsv7haGGlz4LH2s7viKbJecm9agr8C/03NjTHKNFz3ht7TY6c6WaeeyatP0MUZ+nFK75l//RXB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6309
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/2021 2:33 PM, Jason Gunthorpe wrote:
> On Mon, Mar 29, 2021 at 11:36:09AM -0700, Ira Weiny wrote:
>> On Mon, Mar 29, 2021 at 09:48:20AM -0400, dennis.dalessandro@cornelisnetworks.com wrote:
>>> From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
>>>
>>> The security code guards for non-current mm in all cases for
>>> updating the rb tree.
>>>
>>> That is ok for insert, but NOT ok for remove, since the insert
>>> has already guarded the node from being inserted and the remove
>>> can be called with a different mm because of a segfault other similar
>>> "close" issues where current-mm is NULL.
>>>
>>> Best case, is we leak pages. worst case we delete items for an lru_list
>>> more than once:
>>> [20945.911107] list_del corruption, ffffa0cd536bcac8->next is LIST_POISON1 (dead000000000100)
>>>
>>> Fix by removing the guard from any functions that remove nodes
>>> from the tree assuming the node was entered into the tree as valid since
>>> the insert is guarded.
>>
>> Does this open up a child process being able to remove nodes which the parent
>> added?
> 
> Dennis?

I believe it does in a way. I'm not sure what we can do about it.

One thought was to check mm for NULL and if so remove unconditionally 
because that means it's coming from the kernel killing the proc or 
something along those lines. If it's not NULL check against the saved mm 
value. Ira, do you recall discussing that during our internal review?

Need to do some more thinking on the right thing to do as I'm sure there 
are corner cases that I'm not seeing.

-Denny


