Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189C3A9684
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 11:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbhFPJyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 05:54:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:55866 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231513AbhFPJyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 05:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623837133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nvqSXTc9qRreDkQ/pbmsZdVQqBPgRdx/Z2HSpqNP6N0=;
        b=Znz5vEftehY0hTPCn427w2Zzu6IXIjahsxGLJGYh8bW9IvAiMhornKEfOt7vCY1kFWWDeG
        hlwpCUSCbATOZ3n5YpEPVFl8RfLvF73UvNH5OBSnVQoE5l++RxNUwnNDMvcEumHiWVuUxw
        RBhdVbZp0EnWn2v238HLsxKEQ0z+dbM=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-vGbijrSvOhCCfgHVyeH-1Q-1; Wed, 16 Jun 2021 11:52:12 +0200
X-MC-Unique: vGbijrSvOhCCfgHVyeH-1Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC10Br6y36hBvWKoUo/oarDNIq4lTQGETRDr/OgjPC7aa+RqkszowagqHmLbvw00b/Tj396BLwvtCSZesaO3nSs2lFw9Lir4rsgQ4UdLcVz4oYXU5ZxyTbIHORtCsrS/1Ts4PsIE4CUoCMhADtV4tD8CB3apwwKYam+WlIWBaOzW5ccC4XWAT7kIGWRfa8Rx3KmZiqDuKuuVsHDG5Thn1acCGunze4YOnzadro3Q8GyEJqY4uGbwc6AXvu/GRpwSjedO8dLMEU7UlhUpYGgtlPhltOdyxRPvxb4Moiy4KGcSM/lA54RwxkjAN7BOK86zL5qiRE7liKvL2XKug1vd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvqSXTc9qRreDkQ/pbmsZdVQqBPgRdx/Z2HSpqNP6N0=;
 b=R72IzlYS5Ei2XM5dOmMz8lXcjSD39HqCmIgAnWtg9ZB4Ahy0f0iER5gK2xy7dST8M1i43nXY8rIn/A98UT/RYaMnVaxf8AYxzmCUGBzYCFneqZyhDD3kn+dandaIcsAhwya4pSTy8oRC/bhjTnbRHFwDd0PTqqBLz9qRlYGYI4kQpru0+xBQT5aWrFET2u62aCt9I6MN0br/Ydb0Ra040jOzpvxAgwo8/J1v9lc8/hsGLNhsIaipgckAA4+x5ms/E5F48QhC8Nn9ORR0yOVjMd1MZHjJL2uEA6SVuK8M++zVyPIb5ahuL+Py3ndbTqd2kPmQnUa5r4xBHbSQVfKopg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
 by VI1PR04MB4384.eurprd04.prod.outlook.com (2603:10a6:803:6f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 09:52:09 +0000
Received: from VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::f06c:6f5d:34d2:1c36]) by VI1PR04MB5600.eurprd04.prod.outlook.com
 ([fe80::f06c:6f5d:34d2:1c36%5]) with mapi id 15.20.4242.019; Wed, 16 Jun 2021
 09:52:09 +0000
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
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <a3674ab9-40d8-c365-d48c-0e1c88814942@suse.com>
Date:   Wed, 16 Jun 2021 11:52:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210616073007.5215-2-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.24.206.209]
X-ClientProxiedBy: AM3PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:207::12)
 To VI1PR04MB5600.eurprd04.prod.outlook.com (2603:10a6:803:e7::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by AM3PR04CA0128.eurprd04.prod.outlook.com (2603:10a6:207::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 09:52:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c1cb976-7611-4f2d-cf91-08d930ac682d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4384:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB438425BF93D1ADF601327226B30F9@VI1PR04MB4384.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCI6gW+Oih2tEzdwvAsFCoc//7HZKyxDSefAaWpGEffrCeJrQV0zqL6ufRrpV3ONJjQjejRThkXXn4FNq9GWPnnSxKJFMukSzCz2esNHJn2737gmQ20gMjUWHWSqjAGXhO1SsSS5xh1OGDFX1Az0pUFVRkYrFWj/5/bxjqx5YKG6xuiw1+8zjj7Z97/EaqUE6aujK5RtArN200BRarcFAFTRyVieqC6ax6AihLhXvFrDVhn+Lydyt26IkmVZYKwHnOAnU0DGbLOJ+Y01gKRoEvvx+Bly0d0k3FxjIeQW4tgQf7WNrijqqe5WRCZ6IwmY2FEUKjDvBiMbo+TPcY1OZQFVkera3rjBvFTaKTyVtQlJ5dQ09lZRnxbecVAqaavYc/b5jFfHg4kSv7QFnwl9THVJfQPskQwhzZcK8+mRS47NEAf0BtRmOTCu2iXgDrVLmgbC42EcvNwOdM3fQ6eYi8R310fvyxL1AW1aQgT7iJLie7W3LnN6gfmEgZWvVb/Yu+WqeMPqS03pZkRMzdD/nICuij3Oo8g6bu449rPFWVZBo07OsgFEKi6mO/Gtr8aZHbQ7BMrqoNty/x4McGRx8ZBKG6jxaG2DmOuBDklkwpo3XABT2btAo/QqxzHnvBXtOgXwyksypPL+6hoaX7MYDTsR9xLHDbjozxNHw+g4jCqp/6rdCL3cnh2JQkecH7Lb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5600.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39850400004)(376002)(396003)(346002)(5660300002)(31696002)(16526019)(186003)(26005)(6636002)(478600001)(86362001)(2906002)(31686004)(6862004)(4326008)(8676002)(8936002)(6486002)(66946007)(38100700002)(7416002)(66476007)(66556008)(2616005)(16576012)(956004)(316002)(54906003)(36756003)(53546011)(37006003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFdLVW9TOFhucnFNdS9pOURUMis3bXVzaCsyL1BXMzBTN1NINnFqZDU3VkhI?=
 =?utf-8?B?NGZ1bjV3MUtnbUNkV1M0UzNXcG40WTlIbUNwalZOcGlmbDJlUy9xVFpCaC9y?=
 =?utf-8?B?R1lzQzZwZTRaRmVqNFVtWUYzV21DeFhVSXUxc1VML1Z4ak5HSFVNVFROdmhK?=
 =?utf-8?B?SmJ0MHZ4d2laWkZZbzVHZXNTeXE4dG1lOUVvRmt2aEREWENMVk8xMXVmZlBW?=
 =?utf-8?B?NzFEYTB5dE15OXk0ZDZYLzhWNHVBajZzbWFBOWVnWVR1TUk2RGFtK2I0bEcw?=
 =?utf-8?B?elp0SmpXb2RPWkxQVlErNnhnRzlXenIvdXdxRnpPdVNmVi9vbUN3SDlKTmt6?=
 =?utf-8?B?WExBSUtxYk1nV2tvV1BWZ0I3QmxZVXFMSEhWVitmRzZnbGNNMmQ5RTlzUjNN?=
 =?utf-8?B?QytjdVZHeVJ4QmYxbXNaUlV1L2l3TG5iN3RUNlZSemRyVndnSTNvbHh0SkVQ?=
 =?utf-8?B?cHFzL2ZKSkkvUGhjNGY1ODFvelplOTIrc2x6RnpUQmlrcTZpTmxaSXpqK2d6?=
 =?utf-8?B?YWV2VGM0NWVrVXd4NkdUSW9HcmNiMmRSMmlDdzBNWkE0bzNTS2w2VWVKWksw?=
 =?utf-8?B?NUZFaHJvazR4cS9FR3VWVDEraCtOYUorNE5QZkxEanpuSExEaVFEbVVSem9X?=
 =?utf-8?B?NFFNSlRuNHNrV2syR00xdDA4RklCRW40TVZxbUo2MXMwWDBGVXliZnhWYVhl?=
 =?utf-8?B?ODRkdUdOWjVjRFoydUFrdUdwcjQrbk8ycEkvUzZCdE9Rc3BXdDRtSVdXV1Rk?=
 =?utf-8?B?V0ppZThnUHpXTmVDbmtkOEdnTis2eWM3QW5LNUlHYnFFTWFNNmRyOHVlVlBO?=
 =?utf-8?B?QjgwVkp6UXgvSVFUeGxwRmk5MFZiYkZvZ2Z1RXBFZXN3anI1Yy9heDV4U1hI?=
 =?utf-8?B?UTYxUm80dGtKNVkyN1UyazRKSU5weGRheExhemJKM1A5TENPNDE0N3lFYW1i?=
 =?utf-8?B?NThPdlNVc2xWOXlyaS9ZQlJSY2dWYnQzd1ZUR3dHTzlZM3E3SGlpOHpPRURV?=
 =?utf-8?B?aG0xV01qMlFHYlJHR3ljNkpleHJicmpjUFl1dlo3M3lQcEVBM29NYXIrSjlD?=
 =?utf-8?B?WTlHenEzUjg4WURWWFV5d0JNWWovSlNlU0hFYzZmVnFqd0ZvbVcwYyt5ZGh1?=
 =?utf-8?B?TlhsOWpoZGlPU0FrK3hzK08yZDJJbXpacitqV1MxRWtqcUxnOVRoOUpQNDhR?=
 =?utf-8?B?K2ZYRTg1cFV5eXcrSnk4MC8zTGJqSk9takJrYWI5WjNnOTNCcjRuV1M1T0t2?=
 =?utf-8?B?QkxRT0YvbmliZUgvTkIyTzIzVlNiMTBwNXloaWdyNm1RZU1kOFpRdStibklw?=
 =?utf-8?B?eS9ibUxtTy9JUXAyQTlvUWJQR09kOVRxakE5SmVGY2xzQ3V6amE1WjR5MStG?=
 =?utf-8?B?WUs5OVZLS0kvUVFMMHIvQitGNUxsQ1MxTGY0aHpwLzBzYUoyKzBHT3ByVXRY?=
 =?utf-8?B?TWpKc1RFL3A1U0xGRDBURHhlM1QxdzZncE8weEhPbm8waUU4M01JdWVoOFN3?=
 =?utf-8?B?a0dJL1FPcStPS1BBTzlIU1FzQXhJb2VMVy9wVzdtb2FmS1pRd1JJZUY3QjA1?=
 =?utf-8?B?SlFBd1F0RklPRVlZRVFROGZGaEhvVTJXRGpXTXU2U2p4ZE5kMlNKMVFCVW5R?=
 =?utf-8?B?dGxDd3JvVkJHaDdWREZDS3pXN2RnWlUzY1lXV3Q5VG10b24yMWFUek4xV09r?=
 =?utf-8?B?eHJXVGJHZGk5L0YycGRuV2toTWEvRXA2ak5vWTYybnhmZlNaa0ZFU2xKWDdP?=
 =?utf-8?Q?1/E+t7pKBBIhHF+TFAmyGLfsXnaLHKLYhcOn1Ar?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c1cb976-7611-4f2d-cf91-08d930ac682d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5600.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 09:52:09.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v22s9K57WDLOl7ynke65U0dVXI3993OHUQFbSHSVvXtIh3s6nFDVFhLIwrsdKQiR+9FZF6UUc5uGiCbIHkkxAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4384
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 16.06.2021 09:30, Juergen Gross wrote:
> Xen PV guests are specifying the highest used PFN via the max_pfn
> field in shared_info. This value is used by the Xen tools when saving
> or migrating the guest.
> 
> Unfortunately this field is misnamed, as in reality it is specifying
> the number of pages (including any memory holes) of the guest, so it
> is the highest used PFN + 1. Renaming isn't possible, as this is a
> public Xen hypervisor interface which needs to be kept stable.
> 
> The kernel will set the value correctly initially at boot time, but
> when adding more pages (e.g. due to memory hotplug or ballooning) a
> real PFN number is stored in max_pfn. This is done when expanding the
> p2m array, and the PFN stored there is even possibly wrong, as it
> should be the last possible PFN of the just added P2M frame, and not
> one which led to the P2M expansion.
> 
> Fix that by setting shared_info->max_pfn to the last possible PFN + 1.
> 
> Fixes: 98dd166ea3a3c3 ("x86/xen/p2m: hint at the last populated P2M entry")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

The code change is fine, so
Reviewed-by: Jan Beulich <jbeulich@suse.com>

But I think even before the rename you would want to clarify the comment
next to the variable's definition, to make clear what it really holds.

Jan

