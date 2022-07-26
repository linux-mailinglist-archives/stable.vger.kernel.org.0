Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E605817EB
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 18:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiGZQvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 12:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239220AbiGZQvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 12:51:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6BCD68
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 09:51:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTXQSI6EzaVc9Z+mQgHP58jP+c7Pu/X6Yjpuw5Kqoox+CypYaoWSAWQ8CRzIqSlEz/4qSGAoWlZQQDZuPohdPkLpyLgoM3YWyf1oKftws7cujig3JbAKT3vxBX/fpuuhNisrxiqAG8OYNy2v1jLJRUGz6vU02XEQHK/twxglVG5KcHIqlWX1uokYFP+A7UmCsDfElqsBOpoQqsNHy4e3MBlqy9Yr0I7QrLsSSYET5P5EpV3txBXNnZ44Qfr83xmsnCmL3SQTxW+nd+lVVxyOpmTbPhnTbK0QLrUnHiP1KpnI4XW0dFay9N4UvAhxNl44TQ2S2H8OScNytZCGHfkqTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6AVumsvN4Z//YYl7osGcSqchGVSz5eBiBbSBOUhOWk=;
 b=Gf0BUOLaFLrUUTyRf1GdW0fIqJNA1s3mgXvluOkdZZLYld+CelVDQ6fP/fY4aANWTDVQbGR+Y1EUzWYKUl0VeOiOD96fuvyRpQtdPI0FDL2dV5qpO4ZU7l1l1HZCdGDAwOaHZWp5ROL/6bwE+W794d/4CUrA3XnUPZxJZKOCMzwA/3gw1R7+iaYGrtOkFt7EOf+u+FH9Li2+CPJ1Nmz1B03DcuqB0GbwewNolzypL0r8Ddjq6eCgJd54HkRH3ct52uEDUeK4jIvDkfmfLFk+nttx+4aXIs/rjjLtLM/wUsENt9Kx4Q9CMwZzh9FjH9quinPw4jVsiOcgqyj0RT0VGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6AVumsvN4Z//YYl7osGcSqchGVSz5eBiBbSBOUhOWk=;
 b=tm+540n3Y1R7PtslSmXF9K6mXhopXDe+FWmhdm3wBQw2NHjmOAkpiqP3H+zNV5jCcKb3vTtG45UPa4CrZVCTEDxmy5U0kzF/ACuv0buhhMkrTieEPZKH/GqoenGOApWF5LsG8fYgrFl6AmltOnzJUMFdswP6Vi8BENlO/+EDOyYXtKb98tgbNh+FFfwvdh/hvKThcu8Zt90RqbgPOSoIgzj8xQI/29weipqNxcZ7HgN8l9KvR/RRypziV1EbkQVgxVU2DBqKf3lkMebWexyqgvTqGAbS2zh2mkooNCDsdm90Ij7CJTJOHDtYBZlQqtowmybLd1bflt4JGoRuYGnP4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11)
 by CH2PR12MB3655.namprd12.prod.outlook.com (2603:10b6:610:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Tue, 26 Jul
 2022 16:51:28 +0000
Received: from MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14]) by MN0PR12MB6150.namprd12.prod.outlook.com
 ([fe80::30b4:54b4:c046:2e14%3]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 16:51:28 +0000
Message-ID: <13611387-35ce-b03c-261d-96ba305c9061@nvidia.com>
Date:   Tue, 26 Jul 2022 09:51:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] mm/hmm: fault non-owner device private entries
Content-Language: en-US
To:     Alistair Popple <apopple@nvidia.com>
Cc:     linux-mm@kvack.org, Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <20220725183615.4118795-1-rcampbell@nvidia.com>
 <20220725183615.4118795-2-rcampbell@nvidia.com>
 <87mtcwacg7.fsf@nvdebian.thelocal>
From:   Ralph Campbell <rcampbell@nvidia.com>
In-Reply-To: <87mtcwacg7.fsf@nvdebian.thelocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0093.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::34) To MN0PR12MB6150.namprd12.prod.outlook.com
 (2603:10b6:208:3c6::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e0c71a74-08c4-4e05-bc72-08da6f271545
X-MS-TrafficTypeDiagnostic: CH2PR12MB3655:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bV/UQUbh8YWhsXdkgvWptvmlzIQ8eCf7V38dmrWP6DnJWXt12HHLhgGdCz2R0ugZ/98XuxPRDcGrOpcZEkpvQcFTXnohFFKRlSVAjHTSC9xUniu2yNQ0WQ+Iyn4hpnqR9ihGgKwPieOwbitpHR7dYj/SbQZs/TW10zgog63GTpiso8EbbzXj4hljemNnm7pfIPCf4+FJ5B6uy5fivFaUBrTJ+GYiXhN65EyHv+sVK+gOzXmzHl0Vq4PAZbmR58wXxepMgSCcOqmjqh9znwqQwOL+6nULzxB7mj3G0y4chfpiG5Q+1F3eVQqpvM+a69HGej4BhUiIHY0FVYMcRDtclwDxDQaErO1Y1uuvKLYwdLp2idnIq+jKS+Sl1wIdM3jrtjQDIK6gOcfVwoJbsu+ZlavHyr+zFJOWMdS8DbF37BGLE+HefUzhbk02E/R8uEkDY2zO5dsNlztE+jRYnE6wLlA3jRsd1DHzmnMbc1b0qR9OVW4UspX/WoZjm6FifxDnL4cgBCMIyEc7r+Zt6gLlE+LhlkUjwuIJCEx9AdxTSv/5fLQoQqr2Iemi1YS9rJkt5GizJQtmZ5FKYSGTD1w6wNLMXyV2fjrx3vo2MTacEwB9sj+uacqO+ZVv3YspU7jIF2+Yky2GKI27zKtxWBX6CX1tv/adQ+sdavs6QG2fmyuvnsjk0RBzmpfALXxIIRQ2wjLCxUXjRulFUmOWDlKKX1u8bVUdcEi584irykxX6bsQO02i9OGBza9CvU25SG6yciyIcy7DTVMJs+MpP7COeeTUacjp2wCmOTLRLtef8+KPfIPxhsUEduSPvGlUZxUATBNS1KBTjcZHmvamSesfuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(6636002)(54906003)(86362001)(53546011)(37006003)(316002)(83380400001)(6512007)(6506007)(478600001)(31696002)(186003)(6486002)(6666004)(66946007)(6862004)(38100700002)(41300700001)(5660300002)(8676002)(8936002)(31686004)(2906002)(4326008)(66476007)(2616005)(66556008)(4744005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGNFV2NWUzEzV00rT0J0dDM0b0FLNlFxWDYrTkxTc2llUXZlaVduYmhTazVM?=
 =?utf-8?B?clQyUS9TRFIwd0N0bDlJcklVRGJTRURaRlVKTU05UnMrNkNjSGNnSmhhNTdK?=
 =?utf-8?B?VjlXeC8wLzIzc1h5QTNCNVY0bTd1WG1jYUY2S3diN0wrNUNBbFRTbm5jbjRS?=
 =?utf-8?B?MUFuVUJYbkREUUVEZm1wLzFabFc3NGkwTzdqYjZvMCtKRFR2ODBVWU41NjlI?=
 =?utf-8?B?OGxNeVhwS0Uyc2x4aGJuNzdKcjNtM3Bjc0YvLzBveUdWcCtsUzZad3ZEYnRY?=
 =?utf-8?B?VGdScFpRK0lCck04bjBndlpJSkdIV2piaVpFelVka3RWbXBSQ20xbUdGSm8y?=
 =?utf-8?B?WjJWVnNPKzlPRU5TK3BxaWtnNXFjQWQvWk1QV3Q2RkwrbTlGSmtVdC9tWmpU?=
 =?utf-8?B?c0tYR0poSUZzZkdTYkJKQVZUZXU3SnJVZHdFS2RHN05RU0ovVFZHakZjMEM0?=
 =?utf-8?B?OVdqMnc1SUplRFBtV292Q1hadWNsZk0wQ09pSWMvdmpySzFmODIvcUdhTG9j?=
 =?utf-8?B?UEx1WElYRDJ4VUVieVFpZlJ4MlYraFNKeEFuNklIaitCMnhVek05NlBPNVE0?=
 =?utf-8?B?ZHZTaU9IbVJUNzBwUDQzcERleGk0Rnk0SjhXL2t0U3NSU3ltK091aG1EdXpl?=
 =?utf-8?B?U250RUNWY1hJQXR2NUwvbnRGWFFkc0Foc0tWSTByVVI3TEtnaEdqUkNlaTNo?=
 =?utf-8?B?VFFya0JaZ21NV2MvNkd0Q2pIZ1F5dW1RSXFsZVNjSUdLN2V2M1c1czI5ZUpN?=
 =?utf-8?B?MUpBNUt1ZEJ4Nk5FM1hRQWIxOXZxTmZuOEI5MVR6VGFRc2IyM0g1L1pIWndL?=
 =?utf-8?B?bVdrNUozU3lMd09XaFV2TlRxYmxWK3F3R3NrZ09MOEJSZWgvUmNrL1VsM2Fk?=
 =?utf-8?B?eTNSWUxibWdUa1ErY212RnJUZ3N0eUJ2Q2hDVnR1YzNad2RXMjd1eFAyK0M5?=
 =?utf-8?B?ZkxURFpObThnT21oblRiZWtBVi8wa0d6Q2F5K2hGUS9hS2doaC96SGZPSWk2?=
 =?utf-8?B?OENwN1d5Q2s3c1dnQWxlUXJMS1YrVklwVHVocTZmVTBoWXAwNFk3YkZUMXg3?=
 =?utf-8?B?emV3SUZvblZRbTIxUnRZVjZHbmkvUHYxUHBDeGlYc1cyMXFua0Ruc3hLSXEv?=
 =?utf-8?B?UDBYMnFpSlkrRzJTcnBGbEtBTjV5dlErSGNDaE1GemkzbGtMSWtXN0lIdXFt?=
 =?utf-8?B?L3VFQXJwSFZYUlIxeXZvWkJXTGp6TG1UQmFDSzM3WTFPSzQrenRvelJwZXBJ?=
 =?utf-8?B?R0xQYmwrL1gxVDY0ZmtwazcyKzBCeDlRMzBrRzVjSnY0cjM5QUFGMzZaWFcw?=
 =?utf-8?B?Szh1WXhwU1VXQUNHWjNXU3BndEVlWEhwTkQxMnBwZ0hQb3FrTTMyN3BtWlJU?=
 =?utf-8?B?ODE4VFkrem5IV2Z1V2RFeGliVXBuZmdYUzhFSDl2RFlMRGluSHhMZTFxRUpt?=
 =?utf-8?B?Y1NDQ2U1OXIxNVBycTZOcnhrdkVyN09ZdENJYVhqUE4xMUNTcDRnalVHVlkw?=
 =?utf-8?B?cVFhWWVUUno4eGZQaGsyZUt5cDBHZ1F6alN1NnhTbmZ5cmJxQTQrbmlrek55?=
 =?utf-8?B?R25EU1M5N001Rklnd2JneWNDNVdwVWl4SWZlOTI5M3pyM0g4aHR2ZExDemtr?=
 =?utf-8?B?ZnZ1emRGMnplWXdPKzNGdm5DNitkZnFkblpiYlZVN3o0QXFOZ3I4b2ZwN0s3?=
 =?utf-8?B?WmFxSFJaVGx0YVRRRDNsN0NCSmNwTlYvQkxHQmdzNGJuSTRnNTVwMUo3ZVFr?=
 =?utf-8?B?SmxiT3R3eGQvdUFDM0VqRzY5NDh5RHpVbHRFNHc2YWxZKytaSXlicGRaQ0VK?=
 =?utf-8?B?ZWVWQVJNS3hKL0RMd1hNR2tIRjFCdEtERlQ0N2JaREFabVpOTFBYbkJVNE9H?=
 =?utf-8?B?T3Z3UmwzSFpTSG1jS25FbkMzbzViMmFXOGtvSzJOdTlkaExQOWQ2NTV1ckJX?=
 =?utf-8?B?WkN2TnEzTEpUdlpGTDdxejRWczZBaWV5WUdWenozNHY2NFFwZnUxdWtJSjBn?=
 =?utf-8?B?dC8zNW9NY3FnR2xjZUZDcW1TWEJ4QVVncWVjaEJQalZPcHpkOC9GK2Q4Tnlj?=
 =?utf-8?B?MXluNzBOb2dFbER4aDdIdXNiYUJlT3RVcVBGTGhxb1NPa0JLYmx0TFNmNmxx?=
 =?utf-8?B?Tk1MNGIrOGRXVThuRDk1dU44UFhKUFZrMUtrOEVEQmF4SnlpQ0ZCbHlJb3J1?=
 =?utf-8?Q?YdUTyxQwAsIXv+nuqcOCR/4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c71a74-08c4-4e05-bc72-08da6f271545
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 16:51:27.9833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O99lyfCT5oZQ77nocKxJ6Y1OFUR9NxqlXh2Sh+Rj6QXNvKCdN8t/XXrkeUGLo9mE4RJEmYPIyxHUQMvjMxIs6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3655
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 7/25/22 18:26, Alistair Popple wrote:
> Thanks Ralph, please add:
>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>
> However I think the fixes tag is wrong, see below.
>
> Ralph Campbell <rcampbell@nvidia.com> writes:
>
>> If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
>> device private PTE is found, the hmm_range::dev_private_owner page is
>> used to determine if the device private page should not be faulted in.
>> However, if the device private page is not owned by the caller,
>> hmm_range_fault() returns an error instead of calling migrate_to_ram()
>> to fault in the page.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
> This should be 08ddddda667b ("mm/hmm: check the device private page owner in hmm_range_fault()")

Looks better to me too.
I assume Andrew will update the tags.

