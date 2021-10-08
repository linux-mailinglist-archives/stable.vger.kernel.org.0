Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE25427111
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 20:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240176AbhJHS7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 14:59:41 -0400
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:12192
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239603AbhJHS7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 14:59:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AvTXwC8eOIb6RNKywISt5UVN7oUJh0yc1i6a2TIalNJ0T+0CMn54gzL8qAlRP0FphlRJB1EXaiaqKZoGxV6pBmT7HFS3kntTAPpxjw7Gxl7iTIUT0mRjJcaltZHMXs10dNNDmyloQB0+9sXNSvbRjMF3+QkuRLP/NbkDoUwNpZiaHiIyMGalibW1FxPDxy9xixKtr2/5hoWGBL6jpTf3IDef1N6fH7j9PecC94NnLIY1PuAz6FPzDWRJlT8ndbd0BxR2WIfpe1f340Zr4P69/Y6PrP8ESq82tXqPXIap/BtCf8By2jvr0eDBcGpZcoY+W0sq0ES53FM5InlkQniqVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KeigKWyuVkgZc0qX7KOFRxsZrTYSGV7JhMI8RoUXpaA=;
 b=oWvohOSRnpyaOfeA5Sea0/83ti00ZWCFPaP2FYVu/m7VNIKX9eZZviOTS94WkoH6FH4uCkvNYuReiKaKv8vLIR01U6UjszMfewR6QQme2A7HFbPgYdrypx3O5pm8r6ahLut6F9dVRBdTkAtZss1r/hnXQvRr2Ig+H1ThLK3SRgoMOIn9TlubaoTM8mYj+JPZp9wjp3gp7zVSoQnqgZ98Sk+gXGFbSHXLLpPxLghiTKhFWj9eSUCfhuPVU3QjlnJPK745svhbodYWLM38E+D4olGVIxqVQl1vw3oUVAIS9qEVrzCfBVkXb1PyZfZdTmkvrCl1LouBgQcdVlXd4fp9sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KeigKWyuVkgZc0qX7KOFRxsZrTYSGV7JhMI8RoUXpaA=;
 b=l2+1BGXqUPQhz5M9mn5ccm9nOj/uwwVARaYQ1c97pRjTGK6uwag/gWW9sR7VfJeClokj6M/hthQPzL88uzinD+FCJtCNWcH0b9ETvaaZ+aM8c5Uo1bC2gRzmNj3NDISRdXJGGtnXBgTk5NejqgkypF9I+3arM0VG6hwGJeNxB/Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN1PR12MB2512.namprd12.prod.outlook.com (2603:10b6:802:31::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 18:57:41 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 18:57:41 +0000
Subject: Re: [PATCH 2/2] ACPI: PM: Include alternate AMDI0005 id in special
 behaviour
To:     Sachi King <nakato@nakato.io>, Shyam-sundar.S-k@amd.com,
        hdegoede@redhat.com, mgross@linux.intel.com, rafael@kernel.org,
        lenb@kernel.org
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
 <20211002041840.2058647-2-nakato@nakato.io>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Message-ID: <b6f30267-6693-1b4d-8ca1-1315bb247ad7@amd.com>
Date:   Fri, 8 Oct 2021 13:57:38 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <20211002041840.2058647-2-nakato@nakato.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0074.namprd13.prod.outlook.com
 (2603:10b6:806:23::19) To SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.254.54.68] (165.204.77.11) by SA9PR13CA0074.namprd13.prod.outlook.com (2603:10b6:806:23::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Fri, 8 Oct 2021 18:57:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8386513c-977b-480f-5105-08d98a8d80ff
X-MS-TrafficTypeDiagnostic: SN1PR12MB2512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB25122C115AFD410A619700A5E2B29@SN1PR12MB2512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILlf+3vthcUCGDz1sj0jpwNllKEcTkeMMiMXYHLgCHsH/CmAfWo6I8BU3tsRJ60Ww+Sx9f47uuvVb1IPbQ7dgHKta/dwckQzv3QFKUe+/24A8Oc1i0ZiSaj9DEqVS65ALBG9LTZybDtODko3VDIPiIigltIJa41OVfXGXNneanalaI0sXEWCjad8uc1KtfKuaCn3i1xPPRGVYt/1s9xVf9op8c24IBMgtGncN07ABJ8Y8fflpAUxLQShHAgDHOPNnxE7XQJpS+h+cvXBYTcJN7ICnFgdab6PV4xCnFG80K47nxwlE0b5OfO858k4N3opauXpKHCvRTEG8eS0NrkfV7ydTn+cwgIVjCkMdfFOxdOGZuu9Cj/mJhuLbMgvmrMlO7JrgdlihJ22ztlotob95cAIZ7+1bxr7ZayL6HyLRrt4Ja4L6FEs68veBOglCO9RuoqdjU4PbRwSxKTiF02+Jm5c+IxHfY+q/oxn75flgOgXAUYqM3IbZF8WbSxBBW7EG3zbzPqzS4JxH8ymt06CUj9cM4tn8+Fb0QuPJpAx5LqhvmPaOmnGhcz8XFMrHKG3RqzUwYdTu5iX17y4vLN7Sa8JUOBFx3ZIdhq28AaJeyOUoUzsP/WamBXt2LQwPQOv/nvYqXUd+U01qXEz/nZq45DF6MQ9jOmcUm5KXNAz8eeUCGoLonrzO9Q6lkk7QPHgCl2FCsfw6NzrhR9aitmKyPY95BrSP0/cHmikTB6R8FkqFZxBFIZYGChtxO6cNqBaFJrn/NXwM2YKLLiOrlsShjm6bFKAv+todk0+RLNUUaEHjIwD5G/5dqjQSh8liXxQgGGlRpzTK/kOgZT/XgUqCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(508600001)(186003)(83380400001)(26005)(45080400002)(966005)(5660300002)(53546011)(4326008)(66556008)(66476007)(66946007)(16576012)(316002)(36756003)(8936002)(31696002)(8676002)(6486002)(38100700002)(956004)(86362001)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGliOTZva2VGQ2Nhc1VJZ0FPNDJHK0k5ejZ2MFRZQnJlSmxYZ2dtRDltaHRV?=
 =?utf-8?B?VnJEZmdQOUtKT0llMXlZN3F4akxKY0R6WmhXUHVZc21IbDJUQUt2a2ROdnpX?=
 =?utf-8?B?bExPNElTZGR1K3JRL3JFcFppWmhUc2gvb2xhakJyNjNmNTY3SGc4elNYa3Zp?=
 =?utf-8?B?ajNjYVYweVAvbnVJZklGVEdwcHkrUjlUT0VaRkVTaHJydlFLVGgyU2x2MjBJ?=
 =?utf-8?B?YTNkUUZqQzV1THJNbGRWMHRuRUgwSWFiYXpqMHNoYWovOGxnODdGajNwdXp4?=
 =?utf-8?B?dHZFY3VSU0hyT2ZKWlh4ZFNxbVZNdG9YaE9FU3NPYStRQ3hXMGxJMVUvUW1v?=
 =?utf-8?B?cWowSVBXSU1tVWtob1c3TUR0TGZvRDdwTXJBcHZLNHRSYS9FS2NxQnpCaDNy?=
 =?utf-8?B?c3IycWJXeGRKenZ1OEx0VlRzRlM3bVN2cXhEUzU4S1AyZlpPU0NuNTgzeGha?=
 =?utf-8?B?ZDhDdWhMVEh6S2UwcUs4NlhRRWtZOXRUMmk3WStzTWhoN2Z2dE9rNHI4bTk2?=
 =?utf-8?B?SEtUVTBSZ21PVmRxMFhRNms3MHR1cTRqK0I4dTdhWUhvemowSXFOc1NIcnlV?=
 =?utf-8?B?S3NSWHhmaEtiNEFOYThkcS80MEIxVXZwb1A0UGdiNEdHT3NVZXBpTFhlZStZ?=
 =?utf-8?B?U3hUalhMbDhpcS8rYzZNWENZMExQS1ExSENFY0xkQy9zcWpkR21PWGI0ckJx?=
 =?utf-8?B?WlZGcGUwTWFyM0VKempEc0x6SFRQL3BUQ0YrOHA4NTN6MkdqSnY5UmpCallR?=
 =?utf-8?B?Z242TFA5L2pydVJqSkxNQ2ZaZ1ZuZFozQjJySmJaWmQ1TmE5Vy84RVpuN3Nl?=
 =?utf-8?B?bmd0MmY5dy9WQ1E3Mms4aDZIMkZyb1JZNzB3WDBVNmlTSDIrWEJsUzE2N2ZY?=
 =?utf-8?B?S1lDZ2x5YUNOL1FxeWJiZDFQcWZYWjdpbUpzNzA3bWlpTlRzUG50YnoxbUpN?=
 =?utf-8?B?c0dyQWlacDE2WmhGOXF2ZGpiaktpUTVhRFlqaTFEYnl2VzhvcmFpekxOaG1L?=
 =?utf-8?B?dXlacjV0Z3RMU2FvL2l2N2tsTExmbnV0QVlaN1E2b3B3cHpyQXJkVk9FNENC?=
 =?utf-8?B?andmQjlFM0t2MTNzYU5tZ2V6LzJuNFBNR3lRWDVDeEt1YkZGaVJXNDhpRVZq?=
 =?utf-8?B?YkRlSGFlUS9CVHRVbWdtNlRnSlNHRDdGWmVxYXBnNk42cnVob1BnczZ6bHBY?=
 =?utf-8?B?bnc4MDdxNXMrWHhSaE5LTFY0YjdmaC9SVndtWWFlRmlGQ2FLVTVkUFRadVZl?=
 =?utf-8?B?WnBPblpnSEJWVEdZTmNwdnhSdEIwOWJQZjB3ek8wTk5VeGovOU85QTZ6SE56?=
 =?utf-8?B?cWlmQksxaUFSalVMckpUSlRHYnp3dG84T05JVEFBamJCV2ZuMXkrdTg2aHVB?=
 =?utf-8?B?Mzh1RzAzS1pzSFpUMGg2YUZzb2dpTU1Lb3JBSWphUjJYSTBVQlVzYUd6V0Zt?=
 =?utf-8?B?Y2l3TGdjQlhoSU85NmxuVmRGNGNyNTcvZkI5a0F1NTllMkVVS0hPRlNYeTRX?=
 =?utf-8?B?VnhxVHBHdVNNQ3dsY3lwWE53WWVyNnpyWjE5L1BjR2tVdERlaXkzNG1ZSlJl?=
 =?utf-8?B?SmZ5Y1NXVkM3Z3FaRkZOYTJEYW5jUkJVbDBSaGlyY2NyUTFWelBERG1DbnFY?=
 =?utf-8?B?R1QzTDNOeWp0MVd6M1ErYk5xU3lmMnI2aWRldTBybzBwclZoV2Z4emZrU1Rh?=
 =?utf-8?B?N01TYUd1WDJRSy9pMkFmcDExZVNaV2s5d1ZMUXRNNk9rNmQ2bFBjRXRCWXZH?=
 =?utf-8?Q?DCayiwN9kuc/E4H9TFrY+KzBsFdwyc9xGaGipe5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8386513c-977b-480f-5105-08d98a8d80ff
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 18:57:41.0217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tffHBQ+G3Aw+tImtvcQo1REo0cij4XyTu1KC+GFEj4fkgXPzViSwJXS6sYZP/Iwxcs6Lm9hRrtdfu4QXiILEAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2512
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/1/2021 23:18, Sachi King wrote:
> The Surface Laptop 4 AMD has used the AMD0005 to identify this
> controller instead of using the appropriate ACPI ID AMDI0005.  The
> AMD0005 needs the same special casing as AMDI0005.

Rafael, if you don't mind can you please add this to the commit message 
when you pick this up for future reference in case we need to come back 
to the ACPI tables that prompted this:

Link: 
https://github.com/linux-surface/acpidumps/tree/master/surface_laptop_4_amd

> 
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Sachi King <nakato@nakato.io>

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

> ---
>   drivers/acpi/x86/s2idle.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
> index bd92b549fd5a..1c48358b43ba 100644
> --- a/drivers/acpi/x86/s2idle.c
> +++ b/drivers/acpi/x86/s2idle.c
> @@ -371,7 +371,7 @@ static int lps0_device_attach(struct acpi_device *adev,
>   		return 0;
>   
>   	if (acpi_s2idle_vendor_amd()) {
> -		/* AMD0004, AMDI0005:
> +		/* AMD0004, AMD0005, AMDI0005:
>   		 * - Should use rev_id 0x0
>   		 * - function mask > 0x3: Should use AMD method, but has off by one bug
>   		 * - function mask = 0x3: Should use Microsoft method
> @@ -390,6 +390,7 @@ static int lps0_device_attach(struct acpi_device *adev,
>   					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
>   					&lps0_dsm_guid_microsoft);
>   		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
> +						 !strcmp(hid, "AMD0005") ||
>   						 !strcmp(hid, "AMDI0005"))) {
>   			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
>   			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
> 

