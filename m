Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1854BF2CD
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 08:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiBVHmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 02:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiBVHmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 02:42:02 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707B31225;
        Mon, 21 Feb 2022 23:35:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhHa3+I5x2pknbXvrDqsnLFeJUS9oGy55NCcDfj2sEJhJR6vPJqlYcDitQLB4xt/mXj3kwUUDQfuhIKPH2Z3ywLwqYStDu2UT3PdVUiazZtCiRGZaASUr+MHH/TczHSpgt0BccvDLSLOfLXTudxiwce8iLiYIWZc2RSDvvW9Ku6V2EpC0QIIYkHl+YIQL4SBAu743C6I4I4XSteg9/ZipiEayBaemaUlI2/QeMuSw9nfWmInqutH+HHBAKkT84cderEeRhqrz126KwWG+kEYTu/kHQkYf3ZJBxn9oES1hmTrNX5bXy1dHet76kQotKIEJZAlqw7c5AWKdpUjI0g8JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6Oi5qE7B96XPO1n22VEWUDdlhwx4gtusBsH2DH1meo=;
 b=mksEeNfVBjE8P8T3YBmF5ospy6JginMJDy6X3nX/AwxZx/4Hy1tpchvJKMfIOUKG5JYYqf2QRMJjh6mVYb40oFbbyWVV87T3/lpM04mkpSSBtveDD77XqgMZk/IuuF3tSuR/iVf59X4UmsWywiP62x5Ojzz059dgLvJPSie/tx84duokyAzxWQsYimLchCcbUf7miQ3AW1LIu22uuMCI8gcEghKs/q+wT8ddQ9XtbbOPTB8MTt0aL0ggQXmOxbXGxSGRWVy3XsogjEy6aKO0XUtou2Hgnvwu27Rz2ePd+FITJER7M+YzF/DyyUCcf7+fKGEyMBN9Kb4ncYwuuGhwQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6Oi5qE7B96XPO1n22VEWUDdlhwx4gtusBsH2DH1meo=;
 b=SUiiHLhoNQ5R9aBc4RDpHtgwXfD0yo9V48asCPBFHJdx5JiME5heV7BwaQvXXgUPct09WDyUpRcC98oPJN9JSmrFbxy//JF4TZJE26IZjExQ1GxfTUpE2KEYjBqaS515ZC0TNVrVpjqcfV9+VKOLsFgabUQCMmjZqPT6ugf+F7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MWHPR12MB1181.namprd12.prod.outlook.com (2603:10b6:300:e::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.22; Tue, 22 Feb 2022 07:35:19 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 07:35:18 +0000
Message-ID: <0bf88000-b508-3032-6edd-0e6175601fd4@amd.com>
Date:   Tue, 22 Feb 2022 14:35:07 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v6] KVM: SVM: Allow AVIC support on system w/ physical
 APIC ID > 255
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, mlevitsk@redhat.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com,
        wei.huang2@amd.com, terry.bowman@amd.com, stable@vger.kernel.org
References: <20220211000851.185799-1-suravee.suthikulpanit@amd.com>
 <5dd76348-f89c-58d9-1f6b-a6031b984330@amd.com>
 <3ec04333-7988-16ca-a176-2eeb237851a7@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <3ec04333-7988-16ca-a176-2eeb237851a7@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR02CA0214.apcprd02.prod.outlook.com
 (2603:1096:201:20::26) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29690f8c-4c63-4978-2f71-08d9f5d5dfe8
X-MS-TrafficTypeDiagnostic: MWHPR12MB1181:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB11810AD7000EBCD7C133381FF33B9@MWHPR12MB1181.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0yFdkH/3OmyQJLj0aq2ddtO0J43vMIG1DqEnjml/nhN1hxe1++JFQxCky3/VNim/3fZpqlozw5Zp/jegfAYeNF6bpoAh3XfZXeSAbaayHRWlTioZBxsMOR6u0LYUsxP4aW4xx0jRNhYZ5Sru9uG+g2ZJy+ngYlKEv/eA7K+N4smFoeqryV8rTmGxGhMe2RtSdwF7+g20kdFQFjFzzj/uYqn7+JURw7NrSLjN+l67VjU/q8XPN2hOQgx1vQbdE5sLvoorqJFHBUtOyXEQASu9jBpHuBgmmt7LK8PaEOQzNGPcTDuxPrs8G7RO6ovmnm6AxrQ/zg6c69KTucqygZcnD5bRk+lHJvKW4DWkZR7u2JDNMvTaqDqjQ2mBl+Kh8v+Rh+wkJtLMPDY52ShLSneIpMCKQdFG4xF0ukiKjcfb9KWkF/JKueCWpX7MsXF2j2Jcq2+bEwLMgb2s0Ot9wMbFoIYHmSM/CEWjiQ4PA88AdjePc3Pp10XK+7MulRRqC1jEtR0m17jGAadzbjVpvQLJgFRKNMjwe53psAuoQyZk1qlKMYp/8n7NEkcruk6NiYc8+spWf7plZd9J492snmbvTnYkU29GetVi/PTytWRoDKNVsf3ulv3yXPSAwWjrgN3VYxuDFbSD6tqUO6Wp79Sj+bi56jcNt8//G1cWDyV6OvHdHuUTFGVNS274ShxaN8fV76nUf4YIqbniOYtNBiXOgpj/0KPhdat4vfEf6UuXzZ+GKBy4RV/HPryfvRHJWl1q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(2906002)(7416002)(53546011)(6666004)(4744005)(6506007)(31686004)(8936002)(5660300002)(36756003)(66946007)(186003)(2616005)(6486002)(8676002)(4326008)(66476007)(66556008)(38100700002)(6512007)(31696002)(86362001)(26005)(316002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmY2eTgwSHZUOUlkRmNnYVllZVpOQTlURm9OT2YrNE1EYjhCeFh6L3g4djBI?=
 =?utf-8?B?MW9OSUszRlNXUHRoZzFXa1NvZCtPQWdJRlBqOHJzZFJjNTVnRzcvYStndGFq?=
 =?utf-8?B?RWZlYy93ZHRYVmNMUVk5TTFycy9Eak1hSGhqWDlJbHZZb2J3ejFlTmV5T1Jr?=
 =?utf-8?B?dTB5ZGNaWGM4b3pwRjNsbE4rclN3L1RLWDdUZXZnWEhvNmNuNVpoSGxHTlFq?=
 =?utf-8?B?b0s2ZC9WYWtSRzQwdjZHNVBkc3hDdFozcXNnMm4zck1HaGtaTnpmc1JhSThY?=
 =?utf-8?B?TS9DSHpXSDZob2RwellOKzNNaU5Rak04ODFqNWtjbDU1U1NwVm5aeFFOczNK?=
 =?utf-8?B?UGRidFJsVSt5Q01CemFSelVDajN5OEE1TWlsOTlsSmlHc3FFRFZPRnY2Ti9D?=
 =?utf-8?B?RUk3ZmJtS3F2ZXJ3eXVpS0ZTbnFPNm9kTzRtaEtTTVZVaHgxa29BSXczZ2cy?=
 =?utf-8?B?OGpnQmx4YjdXTjFtTGgwMkxDSE1uNnhEanZVU1BDUC8rM0RyOENRczJ3V3Rj?=
 =?utf-8?B?Q205Sk5obUpLSFZ4T0tYcUU2Wm8yRzdJYUFJYU94NVpRaWhyZGRxR0toSGdO?=
 =?utf-8?B?VVk0czBHa2hDL0lXa09MU1hlVlk1RlN3b1lCSkV3b3plb2VOYlp6YzlZV2ZH?=
 =?utf-8?B?M01paUNIWm5RUFFmazJLY1B2d0c5U0ExTUcyRm5vcGtvKzJoaS9td1drSDdZ?=
 =?utf-8?B?dmx6STJ4ZUs1RStDRlgyMUd0Q0hlZk1PbmVUTkNDa0dORjU4empOekRoN1Rh?=
 =?utf-8?B?TmVaeVgxY3lrZHNBS3kzeGtkWERYaXpEWGgwNXI4ZDFlMGoxRlk4L1FLRllE?=
 =?utf-8?B?V3RTeTQ0dGdMeVQzSm5VMTUzbDAwQmxJcWxlMlFMOXhNbm16M1J1UHo4bDZF?=
 =?utf-8?B?NWQwNDlzMXJHMGpPMzMyb2dvRFdSdXNReVFsTVMyVFozK2pxckNNaFRMSmZr?=
 =?utf-8?B?aXZlZHY1VEtDcHhON09mTFZydjNESzNNaUpHUWpnZEJQdU81R3FJYjVrWlVq?=
 =?utf-8?B?amZ1TEZ3c1JMTC9WYUxFejA1U1VuV2c2dzVwU3h2dTVjc0ltN01xeXdkS1gx?=
 =?utf-8?B?aHlXTE5uWVFmeG9wdTVQdzNjRW5NUWpyL0ZYOFhsODdTWkxyeUVqbUVlWUEz?=
 =?utf-8?B?dXF1SCtIUDhBZEp3T2hJbEc2cmVzdDZSNUxOcDY0VFpzQzVrR2MwbWFsSDl1?=
 =?utf-8?B?MFJSOFIrbXdBYmJ5OTU3R2pVa3hiTVRMZG5Kbld5aHozbjRWeExtb2Q5MDJs?=
 =?utf-8?B?VVV2SEZSZ1lYT3hQRXZHbmxRNjYwSm5jL0gvR0syUWNPdkRmUkxBdk43dmFr?=
 =?utf-8?B?b2p6dXhiM1FCT3dqQVNrdlkra3VJYTVuY0c3cC9obzlJT1B0dTZrTXFEU2Fu?=
 =?utf-8?B?dy84UnZGVXF5QUZKbXQ3NEhRWk5OQldLMS80K3c5elhpTXl6YTJKb09iY01w?=
 =?utf-8?B?dVptd3p4M1dOa0U3LzY5ZDM1VHdLdUszOE1IbnVtbnRFamoyNVJWaS9JeXRI?=
 =?utf-8?B?UkZndFhXVFp6ZXhOV2RrQTE3K2VaUG12NHhMeThaUXNtV2p5NXdaK05sYTgv?=
 =?utf-8?B?RGhvZnNacXJCYkU3azdtNE9EK2VXNW5PZTBTTmRxVklwMTVMTWdLdzByTUQ5?=
 =?utf-8?B?N1U1dU0yV2FObVJDdUp1Ym5MaWdtZXljc3drMWZycFdrNkFVaE95WWNUeEZj?=
 =?utf-8?B?K0dqMVdZWUF1UW5TN2cvVnpKMW9wUlp2aHkxTGtFdEJ4Z1ZjMUJUekRUY3dp?=
 =?utf-8?B?R3lFeUU3LzN5aVAyd1J0SkRNQi90S2tVSjBDYXZTN1ZYQVpCY2xGbXJkUDdP?=
 =?utf-8?B?Q21FaUhtVFVuUWNWeU1GYzJXd1YvN2x2OTkram9nOUVhNEJ4MXVZcFMvRFEr?=
 =?utf-8?B?N1U1dUxXVTkxc2NSN0l6ZEJyQ2loRmF0aVNLVWVUZ0tSQlZ1c1lsem4zRFFK?=
 =?utf-8?B?MmxHa3IzWkhlcmJrSDI3Q1R1VGFoMlNsYjhBdjA4aXljSFpOTy9NcGVkc0VM?=
 =?utf-8?B?Q3JEMUpkMTlYeTdNUTE0V0NaVnBVSUFTYjdDUmV5UVc4L3d2S002TWdkM0gy?=
 =?utf-8?B?eFd6b1kxbGV1cHh5SFFsOStMY0dBTlc3RU9lZFhZSk41bVRKTnVHWXUrU0NF?=
 =?utf-8?B?Y2RXbGN4T2JwenJUMU5SeUVUbkg0ZG1CeGFQS0crRGtEUWpuVlpPMmRRR2hz?=
 =?utf-8?Q?rB88QihybAZTXH85/JT6FDo=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29690f8c-4c63-4978-2f71-08d9f5d5dfe8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 07:35:18.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SI3uv51TSZQKhLGXclOY2gTre2IsqH3K2KyPBFu+6O7i1rSbzbyABvs/YbNzfPA7mfWCdpUexruQ2EDuUtaOUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/22/2022 1:32 AM, Paolo Bonzini wrote:
> On 2/16/22 23:59, Suthikulpanit, Suravee wrote:
>> Paolo,
>>
>> Do you have any other concerns regarding this patch?
> 
> Queued it now, thanks.  I had left it aside for a second because it didn't apply cleanly.  I'll include it in 5.18 for now; we'll then have to repost this version as a <=5.17 backport for Greg, after the merge window.
> 
> Paolo

Thank you. I'll repost this for <= 5.17 backport after the merge window.

Suravee
