Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B26A3A9839
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 12:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhFPK6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 06:58:50 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:55777 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhFPK6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 06:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623841003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4T+Y4Bmfu4hOBK10YfuO2pb8j7kiTpMxBLpw8+PnyI=;
        b=QehCBG57AA8mvgIowLX3sp60oKnW2GJZkXZkK+OO61yZe8UcfohmnidYlEMltn/glVxK+n
        pB32kISH/I975iOc8V+r0YzZG/k5kOMhOSuifuY5FPS/zzHc2sxBj4OQXDtCUKGi6APnd0
        wk/C+qLXSyVdN4bOR7ET+mHE4F2kqo8=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-DRxD3Vd6NDeS2PRc23dUgQ-1; Wed, 16 Jun 2021 12:56:42 +0200
X-MC-Unique: DRxD3Vd6NDeS2PRc23dUgQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqampmMQAY3EyMlwGWYh2woIyNC9CcybqTx4slcegCJIisw56wU2zFpjUjFWLE0+KDY72yRe1JetJoG10U6XnOFTiteigTGCNzkVnZKZKiFIfHZdInkLATdkwrbkFgrajIoxQDh5T0nZ6OwV7b9T55i64B4T8cbsqJi9IshIVR93K6pTgg3Ru3UvCCmkrH7zRaTZ8mlk/c5+uK6N699lWqJJTDvjErCrDglBRumBR0wYDjCvp/v2uxsWVL51kUx/SfL/jPrA4fenPIXl+BwS73ZfhCk6d1q+/EP5qkVOGlhY4K8tnlTGUH2wXVI90bH5rlfObBgKLwfrL762B1xKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4T+Y4Bmfu4hOBK10YfuO2pb8j7kiTpMxBLpw8+PnyI=;
 b=C518WbVDfLd3/Rd0BhutK76ssuHKlm60SaBbuIniW9JhNcgP/00xhCxnsuSkLv2E2X/v1oWoq4bz+vSkwHI2BFnH/8UCb7r6ba5LbSOZJ9aTU4lUbMPFBvswJy784+bnzKrXU1AiJKVqwf9WoY7MnDGHEy0V6elKCQLTBBrRciTTPQ+2F79gz8ssQ6vmlNfVTZZ4Q/N7mjdx8OpZsXxTHfwIuZ/Xy02d+EKyfdr3lRlgYtyKjX0HxjXrMgp3ordYFVq54YtdDk7frQ7u2x0WaMffCFc2CVyCAj1mtsAuQwKPPVf29rmJtPb6gefp5QgHoU5bDM7dWb7CESyRCSriwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB7040.eurprd04.prod.outlook.com (2603:10a6:800:121::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 10:56:39 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::f06c:6f5d:34d2:1c36]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::f06c:6f5d:34d2:1c36%5]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 10:56:39 +0000
Subject: Re: [PATCH 1/2] xen: fix setting of max_pfn in shared_info
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
References: <20210616073007.5215-1-jgross@suse.com>
 <20210616073007.5215-2-jgross@suse.com>
 <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>
 <97de842a-f095-3a12-ab16-beca0f97ba67@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <a5747064-cf3b-4ccb-5b46-3b6e069e7202@suse.com>
Date:   Wed, 16 Jun 2021 12:56:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <97de842a-f095-3a12-ab16-beca0f97ba67@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.24.206.209]
X-ClientProxiedBy: PR0P264CA0094.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::34) To VI1PR04MB5600.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR0P264CA0094.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 10:56:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1f2dc08-82b8-4575-e304-08d930b56b36
X-MS-TrafficTypeDiagnostic: VI1PR04MB7040:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7040A929C61582A619CFC443B30F9@VI1PR04MB7040.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r27tALQEcW+UccV1NrjecLgyuTmf9w9Xf+1PIBCjl5K0rhkLyi3vdzBauzgUG68zNPaSumI5dZrebjkvv7SfhxlqnecIS+wcuoHODiliNPzH5kpw9TrlNjySKiuWZORvk28GoYDnp6Y+6vh6u3a9THqOERbyGJUNavk6cZn5jaQp6tXco77izfbPVV1hqNpPK96u+4ic/kPRiM6NBya/FK+ixq/B/62g5AEuImtVm+7GwRuembOzRo62AkEMn/mrfsu7M2gKIrvCM7DatQUwXXCFAsoxuoxSQ2X8AozPw8U/wepnNJIAB69DCrLYXprdLJNlvRhNyVGGNgXAGt9G2LaBCOoxVHmiabk0rOHM9Iow8SqnJXzNKXLnHAlaMkzdPG+ukjQkhGm+HW4mtWjAWlbNdGG4TIZWr0xkuMajyusaztGhCynxlkSkFhVq3U+vUjTb4hJSJuhUMdCDRH8a5if3xFYQY5JUrnjkJJV3SRcdnT+vHaU5Wew/4LbC146p6wnZlO8QDZKdnbWLQyxqqmuQdNM9137wmrWQWknWkqzFR9ws2UUEFrMs0B0VG/aKmP6zNy3+6JYttx09s9d+JiuExZV/zqgbOcpjpKdJSUpBtvTFWryV73f1emT0e0uuulxvwkoRBtD7QfsGeNiyF7XGK3OvV3fKLwd7GCPvHs+3Yf9Qp7APaeNbRxdaTbt1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39850400004)(136003)(346002)(366004)(66476007)(66946007)(7416002)(956004)(66556008)(37006003)(38100700002)(8676002)(2616005)(53546011)(5660300002)(54906003)(478600001)(83380400001)(86362001)(4326008)(186003)(8936002)(26005)(316002)(36756003)(6486002)(6862004)(16526019)(6636002)(31696002)(16576012)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Wk5WZ3VzWmh5NXY4dVVuSW5hOENhQXROTDYrb2IreTdCWnk1VmJTRUlvL1cr?=
 =?utf-8?B?aldTVHZ1UmVoc3hIN3I3UTlvZHlxOFZjbi9FWTZwNU9RSnBvQVJ6UmhnWm93?=
 =?utf-8?B?OTQrS1ZGb3U5eUkwVTc4OU16S0tYZ2VXOWd4Y1Q0UUMvYWt2ZTJ1UDd0WjIx?=
 =?utf-8?B?a1RXL0ZXVGJkVXp3U3gzMjJsaFFNM0ZzYXdUbGoyVWJ4Z0gyUkMwMFBCbDhZ?=
 =?utf-8?B?Rm9oMU5ER2Vpc29Ic2FsaE1iRHRJd2dBL1UyeWVSaUhIYWZ1TFJwVFVGTHlr?=
 =?utf-8?B?M284c0YyR1NuUTNaSTJ6SGNkT09uTGVvNms3MVVNVHJuME5KT2ZkTEZwNFhE?=
 =?utf-8?B?TFVkL1RWY2pxRjFFaXRaTFFYYmhtQTdCQ0lUaGM3Z2tSbGJFTEplWXdMcGx0?=
 =?utf-8?B?aDZzWEkyQnB1VktBNW5OV3dYSTZaK2xqSWI1OUVuU1hwc1hIT0JVd2hPZ2lL?=
 =?utf-8?B?TEFCcGY2U1E2UnlRZVF1OWFzejBRL1RyWEtwRzZUMlNBNGllZ0FaUDNRWTh3?=
 =?utf-8?B?UFpvamp4Y2h1dVhxZUtkVVFhamVCMGE5YnZKSG1CcFBNZk1CcEZzTzhLVjVC?=
 =?utf-8?B?UjZZMzdHSy9xblpLOUpIWFd2MHlqN25kNW1NUWxrWUM1Q3o0bWI1TWJDbno1?=
 =?utf-8?B?L0Y3N1JqaXE2RUxGQmtGem5HeXlkcERjV2luMWJWeTJ2eWpadWZKbTJ3R0hY?=
 =?utf-8?B?LzJCcDRUWng3Uld2U3ljNnpLSG5oczgxWm9SdjlUT0tIYy9vK0ZIQXRHTHEz?=
 =?utf-8?B?ZXpPcTZmYjJYb01EWTYvd0lPdXI3YjJHc20vMGRNVmpBdWRXeE4yTVp2SzRV?=
 =?utf-8?B?d2g1bWRLbW5adFowNTdwNURleURMak1oSzRsRkJHcjhVTW1BQlBzakpDdEZM?=
 =?utf-8?B?dm9KVGVHbURzOVdVQjhlOWdhZG00OUgvT0VmR3RCNzdiS2xDTFJHc2kxMEsy?=
 =?utf-8?B?QkFLTFVCUzdlcW5rQklQYWVUT25vVlA4ZjZ4OEJyVG93NS90ZVM4aFlrQnJV?=
 =?utf-8?B?UEY1ZEM0S2JDYkdxMXpwVmRrdFNQUlVETUJicHE5YmFmTHpOSVVPR3g4aDRG?=
 =?utf-8?B?S2RWcGFVSHBoSU1lM3BrQnZtcWtWaFV5a1B6RVNQZUQ1RWVHQTJIMERGcFpD?=
 =?utf-8?B?ZThBNFhmZXJjV3BYbWYvSzlCZmM1b21lM0pvUVd6S1JDUjhGSFg2N21kZkRH?=
 =?utf-8?B?eElQRzNjKzdNS1BRdWVDRExWY2hiTkRsYkpVbWEreGFSZm1KNXVCRkxHK1Za?=
 =?utf-8?B?cUQySGR3aStncG1mWWhFRlhPYWEweDh0Zmhja1dXM01EbTZPM0JtL2F4K0lh?=
 =?utf-8?B?dk1oL2tLWUw4VVpjREJmeEc0TWprZ2wxaXlCNEluNng2L1JFZmFEVExwcG5D?=
 =?utf-8?B?WVp2L1NpZDlPc3JCYXVzSXk2dmJDNGtKUkFNTkhMdkl3dmd1VVZNc2VpWGdk?=
 =?utf-8?B?akxZQTQ3Qk5nei8rTDB2Y2duWnFoMG1lK0E4QlVSR3NxUkNON2JkckhjRC9i?=
 =?utf-8?B?VndpcjVIWWhsbFM3K05qQzVaMFdBSW1ZVktVaGlsd2VUOCtzU0szMlJrbTZa?=
 =?utf-8?B?UlFmZWQxQnV6QnNzd0J0SStqQ3hBOTZTZWIrT1I0VEx5czFMTzkxTlFQcXNI?=
 =?utf-8?B?QTlTTnFZZzdIM0ppMEtRREFPQytCLzJqY1g0akYyK1p1MVN2TnY1d2QzNzQ2?=
 =?utf-8?B?ZjY1bkJYYTMzbzQ4L21VNkNuUVkzcURvbWVDbTRmYkQ2eXJSbExzdHFSTGdv?=
 =?utf-8?Q?VN1qYCk0UCqiqDMNNliXToGtlXwM/rrzT2UfuXn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f2dc08-82b8-4575-e304-08d930b56b36
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:56:39.8177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BsBXyF1UkiLS8mAKsjsrayNDh95tDeO3K3mu/H3RlUWtbJZM632/lyWKNsJbwPdv1sIeRBrO9x/PYPlvD54UKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.06.2021 12:37, Juergen Gross wrote:
> On 16.06.21 11:52, Jan Beulich wrote:
>> On 16.06.2021 09:30, Juergen Gross wrote:
>>> Xen PV guests are specifying the highest used PFN via the max_pfn
>>> field in shared_info. This value is used by the Xen tools when saving
>>> or migrating the guest.
>>>
>>> Unfortunately this field is misnamed, as in reality it is specifying
>>> the number of pages (including any memory holes) of the guest, so it
>>> is the highest used PFN + 1. Renaming isn't possible, as this is a
>>> public Xen hypervisor interface which needs to be kept stable.
>>>
>>> The kernel will set the value correctly initially at boot time, but
>>> when adding more pages (e.g. due to memory hotplug or ballooning) a
>>> real PFN number is stored in max_pfn. This is done when expanding the
>>> p2m array, and the PFN stored there is even possibly wrong, as it
>>> should be the last possible PFN of the just added P2M frame, and not
>>> one which led to the P2M expansion.
>>>
>>> Fix that by setting shared_info->max_pfn to the last possible PFN + 1.
>>>
>>> Fixes: 98dd166ea3a3c3 ("x86/xen/p2m: hint at the last populated P2M entry")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>> The code change is fine, so
>> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>>
>> But I think even before the rename you would want to clarify the comment
>> next to the variable's definition, to make clear what it really holds.
> 
> It already says: "Number of valid entries in the p2m table(s) ..."
> What do you think is unclear about that? Or do you mean another
> variable?

I mean the variable the value of which the patch corrects, i.e.
xen_p2m_last_pfn. What I see in current source is

/*
 * Hint at last populated PFN.
 *
 * Used to set HYPERVISOR_shared_info->arch.max_pfn so the toolstack
 * can avoid scanning the whole P2M (which may be sized to account for
 * hotplugged memory).
 */
static unsigned long xen_p2m_last_pfn;

Jan

