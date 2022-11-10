Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A35624728
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 17:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbiKJQil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 11:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiKJQik (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 11:38:40 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977D83E0B5;
        Thu, 10 Nov 2022 08:38:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yz1rQM5S/kDDJir+pnJM6/NGK/bQc/mFM4H2EfgHNXcvT/kY9xeA7CJS+bbeCRpy8UfhsfJrAAvsPGCkKTDNhEU7Zp4Y7N0lz2fZKBKtt7fcg1POJiYir//wb8rXa9YD+ok28yxMGeSZNPgFgFqkRmkV+0oJeD3DicrQPouRN48iIpoyqbq833iTwJZ+HxWS8UpKzDoVESxetjJM41VByVKBfLAAFKYq/uO2WgBs1+rEVhV3Gtrv0WV5C0L2agddECiW7kosExd4QHTCBnC+JJ3llpBodF4yzdrEirYcTEncOZhcvEFm9d5KDSjfF2YUpaFrkKAKZYTuNi8azXHifA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/q1upbJEjrPMkjogCIQ+ocpnx/fTujl1PnOKdqoYDVI=;
 b=J6yuTjgMCd4SACiBxsGtWm1Dt3xynVOnxnCrb9Z6p2hFu7m8kDqAzvDQIgG7bjsUBzsZS75kTzovEGVuWrm4BycX3RZNQap7qE6f0KDTlV8bBjQUGH2jM14+mvB9OlefFpsOeyasAeJ+H/HQ5Cp8X//JPcEtw/vlvWdews16b/CrPTbreQEO+G4oiAc9u31IQoEaEiNf73MI4dMVExUxG6Hpn6Jc1P6RAA8td6Jz2kDAw8zMKFbq6BD4lmACyWMP+521IVMXSzrzAK6P8BtrLq2NR40MLeSzRVl2uSoQPR+FI5E/zqRVJPzol8fWBWRL/0lW9srD68MepXf+NC524g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/q1upbJEjrPMkjogCIQ+ocpnx/fTujl1PnOKdqoYDVI=;
 b=DLGH3xVC6GeX4RH3AJhvWuMpCD7ICJicKyO8ocND9jtmnkgcYB9gB4FFLIoy7SXTIyzkv2uP2SbvyHZhZJDlRAZBK1XCJbOJMFfCkireGvxl5ptLHsCg9z51VxjQ1rDW3Md5Ux3W+IQZ7XNfzuGynxpSxINa6Zh3oYYSwNSH4bw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Thu, 10 Nov
 2022 16:38:36 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::818b:be51:fc53:5adc%5]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 16:38:36 +0000
Message-ID: <ac3f48e7-b58e-4995-6386-22eab0a78574@amd.com>
Date:   Thu, 10 Nov 2022 10:38:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/2] iommu/amd: Fix ivrs_acpihid cmdline parsing code
Content-Language: en-US
To:     iommu@lists.linux.dev, joro@8bytes.org
Cc:     robin.murphy@arm.com, suravee.suthikulpanit@amd.com,
        vasant.hegde@amd.com, Mike Day <michael.day@amd.com>,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        Joerg Roedel <jroedel@suse.de>
References: <20220919155638.391481-1-kim.phillips@amd.com>
From:   Kim Phillips <kim.phillips@amd.com>
In-Reply-To: <20220919155638.391481-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:610:b3::21) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: c927433d-4be0-4213-8dde-08dac33a03a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Frbru1i0a96HZh5mn5M10enneIpOW0S3zwG7/6dkvth5Art0tgUg8BJuwwS32+brueIOsnUvHlXOcEeth/xE5TIvoM3aOCwifx/QAfD82GUNO/wjhC1ipUTnWuR1p/cYYoxBL1DPCgHG7nxlPhfYpcUsSOFqejw6aEO0sTAqEbNk3NifJp56mO4ZKtFRaISKEPdFlTmVLn2rZZzI++2NqbRBO9Q8nwDNUtOb11u697rXF1zpGvdyDcf4Jhw3g2S9MkA9C71RpinISynVu1pKh4iw3ScEgK09KaHkPeCsTzqs2MhGYfrZly6XS8tDRz8yNPeUvDDY2eWSzk/bf/Ot1Mu6+7CV5cYWECiM0cEg1v+huV2ej9PRi+zzhEoEIHQP2zRpSWF5UHDnyitaLsuzZMFbFt54/VKW4DzvBdhkjWYn6AUewYFjO6QCPBs0Iv6L/LO85QjJACJWWAUtojmt7mUOakiAVZiUD8xYDbPTT+KiosU3ADFhX4n9jDsdQ2MEJkR5l18vne9Gphcyrn2zb/IFV7vpAS+9H77+x9WdgU4M2YKFwtIw0VvjubGqEhTsHyFkrJ53G3xaXU3uulcUer1nNjhEitYMFWA/nSyhpjhhjvZf+Xzv1+QW7e2pfqJMat/ZoxcrXeveUfls6OAbf/DxbML4RNj2JUbJCv6FoQpUqFdNEqlUen5KUnRbpa0ASB82i2sj+mvRDlK9C6aGoGVUSBBls9gS1Hoiga1uRgLfocXyO7ZdU/6UMEMRX2fmMVegsrktMU9+Aj26JPT5EqFYl5Mp2MbS6zI0HmaEUWM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(451199015)(478600001)(66476007)(2906002)(66556008)(8676002)(4744005)(66946007)(8936002)(6486002)(4326008)(41300700001)(86362001)(31696002)(53546011)(6506007)(186003)(26005)(31686004)(2616005)(54906003)(38100700002)(5660300002)(316002)(6512007)(44832011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckcybVd2YUoxc2dNM25tQ1FvZTVNaVFSaGtQZE1CV0Z0R1BRREdxbDB1Ly91?=
 =?utf-8?B?cUNwczg2aFRZaW9TcW1INFpjTzB0bXFvaGdib1pIMW9WZTZYd011V3pDZzN0?=
 =?utf-8?B?K3Zma05oK2doV3VMRHdkU1Q2QlVsWkZubi84WjluUG0vSWZSazNXOTJwL2Vr?=
 =?utf-8?B?YWV0MlpONUxwNDh4V2FzU3l6ekN3bENPVXlWakRsMHJWanZNNjdjNEw0ZmRG?=
 =?utf-8?B?eXlNZm4rNnUyYXIwa29naTBrUUIvbHRUSUZ0VXB0N21WUFk3MFlROW1PQWFZ?=
 =?utf-8?B?bGZBR0hxc0hoMkJuRTV4ZUF0cVFJRitPRElUMHlXQWVGNWFFaWNOc3FtelF5?=
 =?utf-8?B?cjJEQ0dxM3VMSTFSTVVVUU0zMUpKOGtDZjFYTzBXdHJ2dGRYYyt0MW9MTTg5?=
 =?utf-8?B?QjRNczRmRG5jUzB4VklJWHB5N2J6UFFqRDJCYTc2ak1qZDFETUlkVmI0cGxN?=
 =?utf-8?B?Z05zN3Rtd2VudXpld2p3V3dpVUJvK2ZtZWlnT2psd3Y5QTg3L0dDR2Y1Rkox?=
 =?utf-8?B?dEEvdm5oMDRJYVZ2cFpnc0YrbG51WGtNbWM3bm1wSk1PODd2d1V0QytuT1hh?=
 =?utf-8?B?c1loTFNodDhMbFV2Q3loNWxjRDE3MFVMWlVhY2N5RWFLcnZFUEFscmRLZGth?=
 =?utf-8?B?NVYvR01wcXBQQXIxaFV3d1FBRmpqMGVQL2J5TFpRV0RoZnR6QnRCakdvMWZx?=
 =?utf-8?B?MnhDT2RXN3p1RGd5Mm16bkNVOFRHeHNWQkFyT1VWdDhZb25ubVhvVmpJOWEw?=
 =?utf-8?B?SmRMYk5TUzlsY2djWjRpYnVBKzA2UktzUUJieXhCWkRLUkRwcTJkcHl6QVVH?=
 =?utf-8?B?RGtYcUZLTGhIMnpsNy91SVhPeVl4YjFoaHBEK0VtVi9LMVNwdFpZanI2RG9z?=
 =?utf-8?B?K3BkYXdkb2JhYnBnMlVoSEl2b3R5dmhQNE1RbHJKSk5VZ3JsdFhZbGVpaEUx?=
 =?utf-8?B?a245bUlEd2xJRnA0RFkrcDZEbWZaVUdzbE1vRmZaMHY0WklmOFNHMytiU3BS?=
 =?utf-8?B?RUJ0TFhJWXMyMjlQVTVQcG1lZEt0Z3JvbUtsdXljRHU0dy8wcS9xZWR4Sk93?=
 =?utf-8?B?MEtPL1RLZHRtcVliWGFEMVVyUGJuNUVzSWxrU0hVMHRyNm0vMDFnbWh6ckhv?=
 =?utf-8?B?dXF0MmdXNGpia291clY4ai9xbjd1Q0lmUFpFQ0F1MXNiZXhjM0lxZUV4aEZp?=
 =?utf-8?B?RG1FNWRkckpiN1RTcndxUncweHN2QXlJZXo2OTU3Um9kNUR0TXJEYkg5YnUr?=
 =?utf-8?B?WkFsYkkrcGh1b3JQdWdRMXpmejAyK05VdWlzTXY2U2tyVzdNcHI1bHR1WjZh?=
 =?utf-8?B?M094Z2xFRmZUUlZ0WjMwdjhvTy9ZMjRJWVZ6cVA4OHUrZ0FpNUJDSGs4OXRW?=
 =?utf-8?B?cjFxM0tCRDV0UE5NV2NaY1J0Qnp0YS96ajQrZGUzaUVMRnFjeVk0cGgweFhm?=
 =?utf-8?B?eUJJcFVmUFlqSG50VEdGY3I4aXNrVTNVY3JON0lqQ0FkYjV3ditMaVorRkxm?=
 =?utf-8?B?TTZFbGZrZjhLQVZVS2cwRy9KMUZXZ1RLNzhJalFGRGI0cEVuZVZzNkhLdkpw?=
 =?utf-8?B?T1dsYkF2dFNKMDBBdjJpR3VRd0dXcm5TWGdwWlR1aXUrUFBrNjcvQ1lCNE1t?=
 =?utf-8?B?dWJWWkxNbWNaVTY5WmMxbkdiWEYveEpZYW1CdXlpbGZrTEdpZVNlNmQvQ1Ny?=
 =?utf-8?B?a1prT1V2bGg5Mm9iclp5b3d1R0ZiNHV6cHoxTzFQMmpERVFMRWVCYjNGY2Ew?=
 =?utf-8?B?dWl5SnVueGd6c2xLdURJdGdSa1pOalRnK3lvdENEeVovQ1NUemVDQTR6Z3Rw?=
 =?utf-8?B?OW5QOFgxbTNUWDFLR0RNd0VxU3V3aFFwSDVuRDJVSGFKaVFOeE1vbHJVM1di?=
 =?utf-8?B?a1ZpV0JaZWdiclZQMU5PcE5GUU1KT1pmeTAzeml6RG9pUWh2Mm92N05TS2Z0?=
 =?utf-8?B?REsxOTZGUDg5OUNFRXhieEo4WWVYbC9VVDdVM2hsUkVqdXIrcDU4OE5vYUx5?=
 =?utf-8?B?dU1ReVEvMEk4bW02RDNoM1lhYUUwUkFET1MrdXVnejU4N1g2aFRZelZNNWk5?=
 =?utf-8?B?V0syeUFFZU9yamdYb2JiZnpoZXB5L2xCL0ZCK0dPTHpRekFKMEQyUnVPNURH?=
 =?utf-8?Q?BK8JDG7jwSISXdGZW70I6YlB+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c927433d-4be0-4213-8dde-08dac33a03a6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 16:38:36.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zHiyDPS/Uquu12YJfm2H4iFSjZEEITiE7Lwf3mFLJJiXL2fQlQGC+tR54YQn8uwvAWap+wUGsW+aTVOuicBuNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/19/22 10:56 AM, Kim Phillips wrote:
> The second (UID) strcmp in acpi_dev_hid_uid_match considers
> "0" and "00" different, which can prevent device registration.
> 
> Have the AMD IOMMU driver's ivrs_acpihid parsing code remove
> any leading zeroes to make the UID strcmp succeed.  Now users
> can safely specify "AMDxxxxx:00" or "AMDxxxxx:0" and expect
> the same behaviour.
> 
> Fixes: ca3bf5d47cec ("iommu/amd: Introduces ivrs_acpihid kernel parameter")
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> Cc: stable@vger.kernel.org
> Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> ---
> v2: no changes

ping?

Thanks,

Kim
