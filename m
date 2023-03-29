Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43D4E6CF6E3
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 01:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjC2XUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 19:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjC2XT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 19:19:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA082E3;
        Wed, 29 Mar 2023 16:19:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbnLoZd3fVjqPI8L7aFA11XA9nFEdVIOtp29qU5JkKpYFVZ1dBC8bx7tqshT0iLEoyZxjec+Wh3QKrKjERfyN3zfC8n63xdvTWI4yNCPtjfXlO2Is8G4CPrwAb1OkP+A1J34gynpK3DnT8hYueYMYvJqjIbauPgoqFD00ouKBEgQwPNXETxItZmJKpzxfV/MaQ5JuxwKfcXpf1TRMdn+vUGWgNNkDGTUvTSDIqfKFis38/tIPX8RIYwH4YY0hyFMth685P42a+g3KJ8AU/0OfWLnvGMCEc4r05KR9mWamMpv4mo748aIb2E7RrbuB01kGI7FkGf0aQccico2XEZ0CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/kX8qYNlXwuWrAPBMe748avmZtxV/AfEqDk7APmL8c=;
 b=au3gUphRTWGD0CR06DZ+SyIaD/IrgSOznN8vVusfOBHrzY4MD8Zs4H9j0ErefbpBkyyISJ+iOhwwyL6vehi50GRiTf5c8HhJiV1rby3s5mZQHbepSmy0IHVn/6FsEj25J8QKTaTQ3DPS0XZoCFbAW9XsUXfWCc/hu0ZIAs2lqpVx74jwUxCCsLUeBX49oBlsivrk87oCKview4dmxJnfKCZE6Y8H7u+QL8mUiTKA3CAvfh9UTJp0spZGzJt/9ttTef6zCi9jFKPMBPX3GTDnoI/3RUhNNV6KqrBvy0VJmgOqAv0vvr4jSWLEADqJCr/JF3tg6gSXHV4l1dleWB9I0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y/kX8qYNlXwuWrAPBMe748avmZtxV/AfEqDk7APmL8c=;
 b=IM9WLvruNBZpEjII7+92gcTtOdHoDbx3Q9l8v9pTFe+W6YOB7veQUEGJ+osxsvau5iLc4mALhQWr/gV/VdHp1z+O1e0EvI8h+pN46fQbYy8HuDaW6OR+d7PYxVVWccDr3ufgpbQsSZpZG/sOkumYL3MlUcqA4sK5j2YpxC8Ud3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by IA1PR12MB7686.namprd12.prod.outlook.com (2603:10b6:208:422::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Wed, 29 Mar
 2023 23:19:55 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%6]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 23:19:55 +0000
Message-ID: <839942af-2b48-a06f-7fc1-6be1ce7cebcd@amd.com>
Date:   Wed, 29 Mar 2023 18:19:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] crypto: ccp - Clear PSP interrupt status register before
 calling handler
Content-Language: en-US
To:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        linux-crypto@vger.kernel.org
Cc:     John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230328151636.1353846-1-jpiotrowski@linux.microsoft.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230328151636.1353846-1-jpiotrowski@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0128.namprd11.prod.outlook.com
 (2603:10b6:806:131::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|IA1PR12MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: 9540b5d4-7fb9-44ff-7d54-08db30ac1af9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMGPK2tTrR+DrPOCk+WLJpwaMNK5iZGnCcc6nzp+4nPS1QyfVqbpDTx8FWbOPYXbBt6qLb4l46DLCFkz3zCqZI/cNHx+2b96qxMhYU/6H5f/Ob4VjJj+orkBZxgeUSZiJ+fBc8Cwzj464R36F667LWnXaQy///HhyrBV/p7Mz+steofdcYgHvMCJg3Pmyn4VrH+GsikqS1dtli9VagG2JEDy10NAf/Ka3y4cqYGVBRGJIKXgjsqFrsPFaf/HRqGC4PMzPh8tJZG2ut58RqPy00K5ArkjXiKFgBu+6U8UbtduAMBCOViTBFAOy7d6Br2ELj6hHz1/7OGVo2ZtrUsdM37s4YuDWR14tVOZrMnudZri4+hEoK989DfaxXfsQfkeCPzCMlco8UIzyZNsnXAC1HUeoW3uh9P6Ieps5uooCRfsCqEuoaJRFiJkjq7hes3c+/nVW4HCSumFWXJc2NERfP/8xeK2UIZzU4/KiA2rRTx2h+MzHdERjBTDvr8ruS36XKVfeuxokWFZRlCgy3mOrzYjHWHiR1eHexWpjJCWYSuM5vRy04VsBE0jM/HggvwWRyG+cmNHhW37AStKAHh6m6AEBrdFoKbhU7n0+8jJFRlVangqdRWDi+5uHtj1ES1t5mxn4c0sGlr1BuD39DELCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(4326008)(66556008)(66476007)(8676002)(66946007)(41300700001)(6506007)(38100700002)(31696002)(86362001)(6486002)(36756003)(54906003)(26005)(6666004)(478600001)(6512007)(53546011)(316002)(83380400001)(186003)(2616005)(31686004)(5660300002)(8936002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z040czByUGFBSlUxTHhVbG1peFhCSU8zcnJxSW1MenNwOHYzdURRbk80T1I3?=
 =?utf-8?B?T05uUzN0aXprc1dMRmFJcGxRZWVZd2hiT1BsMG5hM2xUMmhZWFcxMVNybkov?=
 =?utf-8?B?MWVpbEtjY3Zpa1ZxZ3FVTjJ6ODMzMU9NVDZLbGdRT3RzZUZhbXBraW9MNjRS?=
 =?utf-8?B?T09SK045SWwwOEx5cUR2RDVCR2lETUxxMTFHSExTOWZGTUFVb0h0K0pRR0cx?=
 =?utf-8?B?Wk13RVJiWThsUVBsNjFoYy8vQW5LZUZsWVNiN0NRZ2EwOE95cUtaRUhSaTE5?=
 =?utf-8?B?d1lDemh4cnhCdGdwSGRObEFTZmM1S29XOU8rRDE0WlFrdFRjMjhkZVB1MWVu?=
 =?utf-8?B?M2dBYUlUbDVLUVNyamt2T2xlYU9zTW1OMlBpaHF1V1UvTU1TNjhPUWhnRDln?=
 =?utf-8?B?UGZHN0hRZDRkMGJKM2dKMjhlQmM4TExvcTJ3VG9XQXltTUdWSUNWVFpVekJ1?=
 =?utf-8?B?RmllUEZMdktIa0FmaU9EQ2U4TTVxMkFMMWg5cnhmRSt3cEtMWGdHTHJqMWMr?=
 =?utf-8?B?Z1hzSU44S3pSR2QwaTZseWZHTE9PT25SMjQweFlMdW55a2IwcHgrbWYvUmpr?=
 =?utf-8?B?dEdzQmVVeUVkbWl6b21HK3VCZXFTckVSSlM3OEZVTFgxTWtJaHZTY05LMjBk?=
 =?utf-8?B?ZUpWTmx4V2pzUkVLRUVUYVFkbEwxMGcvVnlzMDRxQi9XVVZpcUJ3ZWUyN051?=
 =?utf-8?B?b2JtOXh5L1ZUV1R5cWUxNE5ZSHVlZnlFbmNZMTJwWTdRT1VwSnYrWUN1cjlG?=
 =?utf-8?B?QTA3SEg2cE9iaThETkQ4MS9mVjZ5czhYcGhLWmdSSS9XZ01lU044dDFSRVZK?=
 =?utf-8?B?ZXIrUFpML2VoMkZwNFdJLyt5Mm5hM3M5T205SUJ2V3BYVHFFK1dhMG9mMEJL?=
 =?utf-8?B?UnVOQlh0b0Z6N01kanhHQkJIaE54bmhXMlV4UXFJb0tQWldSUmdiRXVGNUtO?=
 =?utf-8?B?MFI1OVZiUFNmZmx4K2NjRjhGSElwSzFwUWRNbmJCWHZxZmtzc2VJV0JjQzZ3?=
 =?utf-8?B?aXl4M21vMVlOd1V0ZHNROE1teFR3QWZHUXN3eDlmSk0zUjRjRjY1d0JGQnZN?=
 =?utf-8?B?cUhYOGRjSExSaTNTVi8yUWVtY3RIVE5GYS82d1doQlQ0eURqNjAwZGwrTUNj?=
 =?utf-8?B?WTd4VkxCaGRkeStSMnpvUDVlOTU4dnN0aGdxRU1NTG8vZ2NrM0E5ZGVNYlJG?=
 =?utf-8?B?OVNLTVNmdHdHVlgxWWlzMytBWncwak14cmtDZ0N2TlIwQ29ZZFlkbjNxaGFU?=
 =?utf-8?B?N2kvY3hWNEdrVzJsZUFMSzY4Znc2RFpkU0tsUkE2RnNjdHFrSmFRMU5NVHBV?=
 =?utf-8?B?T1pCaDNTZDd5d3FOZXI1VzZYVlZXS25GRjNVbER1YnFrWEx2TnFka2k3WThj?=
 =?utf-8?B?VHhyT29oN1N3SEdqeXErVU1HZWlKdkw1RlgzUGo3VDBLUXRNNTgvUHprdFZ1?=
 =?utf-8?B?OVNEZWhWRkZnY3M5ZXczbXRTanZaRHJXMzh0UmJRSFRYNXE4R21ZUWM3SmFS?=
 =?utf-8?B?Y2lMdTRWUVhTaGRFS0hyZjhyTEtsRktNZWZwd1hvVDIyS1pKdklSaWhuVTJW?=
 =?utf-8?B?ZWxxbkxHRnRWMzJpRnE5TmJjdlRDZFY2dVlETUZwd0hFemt6dW54ZkxkWVJ5?=
 =?utf-8?B?cElIY3I4WmNqRS9IMTJsTFFyVnVjeHQxU3IrNmJrOUsyTU8ySVhocjAyWlk0?=
 =?utf-8?B?SER1V0lDYjBPYkpFUlcvc1ZoR1N5ZHc5enhDa05FRlIrbTBXaDBPRndyeVh3?=
 =?utf-8?B?ZHNvQ2REenVGRG9VNzRoTENnWkJmQ3UzUkdwaHNsNlBSaDY3YkZTY0xJZVEz?=
 =?utf-8?B?T29yZXNwUkx6TFV2QzYxSW9WZytZZUZmMTZubnNXUTd3QWV6bjZJWGhYcVg4?=
 =?utf-8?B?TGVtQlJ1Mk1ka281MERvWFQ5S2psUndBZWZxSDdzVkxPNE1GdTBEZDJkNGNt?=
 =?utf-8?B?LzlZTzYvaTZUaU9YL1pWYVJKbGRHblZWTlZIMFdUUkFTaEZFL1JyV1RjcVI5?=
 =?utf-8?B?clpKcWxzTHRDT0ZIeElhTkx3Y000QW01ODhBRU5seWo5WGlwUGlTemlZQ2JH?=
 =?utf-8?B?TFhJTTdwVzYrbVhycnl5YjZhUk5jSVFoQlJNcFN4VWZFSWx1VkpxaHJFTE50?=
 =?utf-8?Q?vTS8lE0KiSZEGbiYn8e8GOfhw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9540b5d4-7fb9-44ff-7d54-08db30ac1af9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 23:19:55.0195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: By6fk5ij3SYHIVwdt7W4jM96jkSiEsomRn+F3ZdY4r3X0y4C8ziPSirvubMJT5RU3kIlXvD1SdYkh7k6/gkMog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7686
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/23 10:16, Jeremi Piotrowski wrote:
> The PSP IRQ is edge-triggered (MSI or MSI-X) in all cases supported by
> the psp module so clear the interrupt status register early in the
> handler to prevent missed interrupts. sev_irq_handler() calls wake_up()
> on a wait queue, which can result in a new command being submitted from
> a different CPU. This then races with the clearing of isr and can result
> in missed interrupts. A missed interrupt results in a command waiting
> until it times out, which results in the psp being declared dead.
> 
> This is unlikely on bare metal, but has been observed when running
> virtualized. In the cases where this is observed, sev->cmdresp_reg has
> PSP_CMDRESP_RESP set which indicates that the command was processed
> correctly but no interrupt was asserted.
> 
> The full sequence of events looks like this:
> 
> CPU 1: submits SEV cmd #1
> CPU 1: calls wait_event_timeout()
> CPU 0: enters psp_irq_handler()
> CPU 0: calls sev_handler()->wake_up()
> CPU 1: wakes up; finishes processing cmd #1
> CPU 1: submits SEV cmd #2
> CPU 1: calls wait_event_timeout()
> PSP:   finishes processing cmd #2; interrupt status is still set; no interrupt
> CPU 0: clears intsts
> CPU 0: exits psp_irq_handler()
> CPU 1: wait_event_timeout() times out; psp_dead=true
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/psp-dev.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index c9c741ac8442..949a3fa0b94a 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -42,6 +42,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>   	/* Read the interrupt status: */
>   	status = ioread32(psp->io_regs + psp->vdata->intsts_reg);
>   
> +	/* Clear the interrupt status by writing the same value we read. */
> +	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
> +
>   	/* invoke subdevice interrupt handlers */
>   	if (status) {
>   		if (psp->sev_irq_handler)
> @@ -51,9 +54,6 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>   			psp->tee_irq_handler(irq, psp->tee_irq_data, status);
>   	}
>   
> -	/* Clear the interrupt status by writing the same value we read. */
> -	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
> -
>   	return IRQ_HANDLED;
>   }
>   
