Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EF354DE3D
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 11:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbiFPJeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 05:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiFPJeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 05:34:00 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E038F39BA1;
        Thu, 16 Jun 2022 02:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjBLJFuglHOCGEkzL40Q07VeS4VRSN5uEUp27mrC0ebZr9CMFIHbCDifs6DpN9n/Reyfv4cyWBb/dFIFjfO/N4h9bEbgHj+ogrl3HWvOHbLc4Y+ax7dDZouE0scsOmLuvnOUMwEHdCec9jJxBkKiYEhIogbwJPLz2BEo5af0tD7Gbz3qTINl5bZgVq+acfSqyzEhyEjVhrVO0aMrmgTq/FqWfKACCfiTkeV5tDtDA2oRvHU37H22C2l5hQWuGJ2lVR80cp35o2C7iXZSdO64i0f6eLJc/Tc89KowOsjwo5U6QIMt8hQX/Hh+hhqUAsf4EfzcVQP2hOTOQWXzwYLaDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r3mq4gfR5CCT14N6v+dVmWLVX1kDNxlsPElmXv2wvF4=;
 b=UAx02rVWiUyrlum0nNmeymeBPUACvvr2PF0dYkHtZ1TNZ0SnUUDDbReS/yPdKJFEKVsu7BpptMoKotx9Wb1f6Qg57Uw7XRxDQSANly5JQTx4OMhKbjbLbFv1k5OrBrM7Nnjmk19DCvkyEdr55ECR1EXDPBwwKGqmzgCfye34MvJyW8rZK0rihcdd3JpZWIzJyNrNQBMIHgFgIGj/uGIpfx0THg3TOy0NHu1zJWaM24lhv8e1EVcioNF8IqmZFIImzMPK2tn9ttr7DFyg1kVTcuBz2SVNW4qfNnBzgYvs6uG6DxKvlvUcK1nwVDxjPYY8uvBrdN8AHRg4qNYdkjGRzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3mq4gfR5CCT14N6v+dVmWLVX1kDNxlsPElmXv2wvF4=;
 b=dpv87ayEDuLGmMAVxiyEPbr7h6Ynx/4An3avBL5DLHWuk7SjW7JObnzsdOBICoXt/R21RV0MFrsyjmOfIZD4PuRhfE20GOpCtiGlliVzXAWGvmcbE+ixW9wLBAsF6b0ABT/zn4mjjbPO/EuoaZ5yzsPVAPmnf/quStJXV8lxlMx19NB9YHQqhEih2WNvd8eC39lmd94ToL0gp0EBzRTfNrwc/7+3Mcm4k6qyPg36HhYto2q/Npw/J/oJuSh/yRgnFGJFRpOiYguVGNEr28M48tQxGq88981REXGnDwsBm68qbi398ej1XSz3PCRwYq3t3lFsxyhy1DmFFI+yqCnYpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB6191.namprd12.prod.outlook.com (2603:10b6:8:98::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.13; Thu, 16 Jun 2022 09:33:58 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 09:33:58 +0000
Message-ID: <59ea5034-9f60-95d8-8536-286853ad22c4@nvidia.com>
Date:   Thu, 16 Jun 2022 10:33:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220613181529.324450680@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::21) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e1a0b9d-d727-41c0-6443-08da4f7b56d9
X-MS-TrafficTypeDiagnostic: DS7PR12MB6191:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6191003A39696D05B92DDD9CD9AC9@DS7PR12MB6191.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2qbpsZuDqIWwBPp1Wmfohu/P5lqV4pwGLgktASV9lFiJjwxYqCufwEL2ovSAEcg8Q7PO+nJGZR5fgNhI2JCRbJMXa2wZ0ysFOUl/M3WTzTf9NFlOxlL+rO15zS2T9amLKYif6vjkoAd7SI8uiYVhzMBhhBM4zf8N5crJGbqEuAdZmiUWqd+Qsaymw6/BLmJ5UQ+jXu6ufK68EPAbANniWUV4sIk35Uqn6qxyUVWGUaLnzMRXz2BoRpR1sqGX3Fva5OFI5vO+Qz3/aH7jSNxk/wlRjYusS26m5jFJDd/eu5k3HRzdhLbAjaPA2zpw3juB16Dbv0lM7kMigx48kzTr1s3V1U/V2rIKWgmdHSX3d1o3E2GPsxz/DTB69lIaBKKqrT+nYcyaiKWtupdlpSb5W51zGv8/lrjo7gKJIgnEk+ryw4O1NVCwnuIwoKAFfaqIuH01m9IhLtVCn0W42IyCmzmYFkmwV9gCCgR1STg3thBr7SfgQYbTOofyR1nGIBSle8ITdkOBRCQZzaNTOrhVLucl7bUD2Y8x7rjJcpKovomyk1Vz0WR8DSYrHpvjGwxtOPnTO0/Bxh6/wMweEb7AkSup6twGaL0SYkjNEEdVzvFnGSpKVj3sFqvhKdaQL72yRTj24iPYDPgbjFY0XcsRhTZ/B+ey2gJ9JlyeXgPU+9Ei+uq/J0nQz3XxSOlaG4HvsFcK0HSqW2SU68oMtDMJ6YlW8XHbM3gpPlb0dtrJfKpFDVC3scCujiOCwiYjIfZlJTQI7G/o8tiHjXXERbVvKiAgk/8CeKA0VA+qQLCUZZeZNXW3UzZcQuEujF1yDsnC+90n70M5uOHsWCs8Cj5alg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(2906002)(86362001)(26005)(36756003)(6512007)(83380400001)(316002)(31696002)(66556008)(66946007)(4326008)(8676002)(66476007)(31686004)(6486002)(2616005)(7416002)(966005)(6666004)(508600001)(186003)(5660300002)(38100700002)(8936002)(55236004)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eW10RmFZWEVJK0l2M09YTXFKd0RHZEU2N2puNGtMWWJPRy9oWEtwcXY1UDd3?=
 =?utf-8?B?U2pHYk80WTFXMkxpZWNNdHM3eWlyV1dLRTFtOFVlZk1uRUtGendYdnFsRlds?=
 =?utf-8?B?aTB6aitBQTVwSnpaZVNpSFovMzVENGxTRk5pZ2tBb3ZVN0ZEcU5EaDgyWm9O?=
 =?utf-8?B?M2NSMGljUW9SVjZGZzNtOGNycDVsNnMxY2s5cEZmZ2ZRNis5RGFPUUQ1OXFN?=
 =?utf-8?B?bkwyWG9iVVRTTmpOeU0xeGthUVBjTjE3anE5RVlkYUdQOTczM2NIMWtjeXU5?=
 =?utf-8?B?K00zZlpCclFjdEFDVFMyTjFUVFpUaW5WY3IyWHQ0MXJiQ1lUalBTOG05bWc3?=
 =?utf-8?B?bnlLRGM0c1RhZWZqMzZPRldEbVd1bEVYbUkrRkJtMWF6ejVIRHNxcnRSTUda?=
 =?utf-8?B?TDlNQkdzVGFYbGx2Vlo4WFFLRVUwL2wxTGo1aGdxaThZVVJNQktxTTdGUmJu?=
 =?utf-8?B?YmFYQUQ2aGhReUx6d3pQTzgxMSs3b0JULzljQnRpRno2UDFQeFZHS2NKamxs?=
 =?utf-8?B?dlhkOHhzSzZTYW40OTlRVUhVMUtvS3VzZTBJK2h4UXEwUUhUQ3d4YU5tZU1u?=
 =?utf-8?B?RzFGZXdaRkVIUTZFSkUxdXFIWitOcm1Wd0pzNHhNM2dJOHMzbHkzSklPeG1Q?=
 =?utf-8?B?SU9hazlSVzAwNkc4L1cvOHBPbHR0UnBWYko4VFhaOEpoMjlPaFB6ckhRYzJk?=
 =?utf-8?B?WHpZWHM2Mm13cWQxTmdDTkw1L1BudGk4NmU4Rkh5OTVvMDI2eVY5Wm5uRDZ6?=
 =?utf-8?B?QUE2OUhZSDUrSmFiZFFkWStYdWgxSkRsaG9CbVUwb0hUQUZtSVd2c2pFRkRy?=
 =?utf-8?B?YVhtdkJKU3RaK1dDTFJ1Vkl4L3Vacnh2VElRLzdLZ0dNU2hZUEwrdHlRbWNl?=
 =?utf-8?B?OFBaYnNpZ3hHUXlBTUgyWG5rb2xabGN3QTAxa0hQbnlzSERhNXhwdlNXTlc5?=
 =?utf-8?B?OVRCdHFKZ0M0clljcEtIL2dnNFBLQmtvcUkwaUJLeGpvUWcvRnFmaG9ZSGc3?=
 =?utf-8?B?K1VJNzN3ZWZ3VzF4ZFZtSkptSmVrUjA0cExKZjFVdVBpWVR6di9nSDlOUEFk?=
 =?utf-8?B?RUk5djNXSHlvL0xlOEpUVDlUNmEwWlkvZ2h5QzJaQ0hGY2NONys0M2d2TXR4?=
 =?utf-8?B?SW5ueGhrQnNRSyt5Z2kweFMzTGF5QUVEQnhBaGNsSnJyb3I4S3NzVDFOT0wy?=
 =?utf-8?B?ZEc3RGZ0ckVGR3QxU21oRWplQ21FYTc5cmVSZERrYUQvVVpzVXFMR1MxaDlE?=
 =?utf-8?B?TXcrMnFhZC82UjJIY2NpeWVJUnBBVDEzMGUrZ1dyRU1jdVk2eFNlUVhQNWRD?=
 =?utf-8?B?TjRvMmg5WGRxSlBISjR6cUlJMUx3aFpMaTR6VmhpdTd1aUFGWWMrK3lkeUdp?=
 =?utf-8?B?YlQrdHpjeXlLNU9pVG82ZkhsL2ZOYWN4ZGRId2xkQmtvZTQxNGJqTDdaczVx?=
 =?utf-8?B?S2ZrU05GOGs0OGdvWVY2aUptME1uNTdlaEhadVpOUTlsckdrS0xuZVlVT2JW?=
 =?utf-8?B?OE1nQ29saW1jY2dDTlYvY3Z6MTdjZDFvdFRrRVpWYTBNQWhwZWFOb1lNTUxD?=
 =?utf-8?B?NTJnbzh3a3FzOGFrT1RVa1lMRTJDd0ZvTk5rYkNHOFlwcnlRdk5Zc1FSN1lW?=
 =?utf-8?B?ZE16OVVieHYzRHE5UkUyTDVzY2ttV0dnSjltVENuZ0dQSGQ2ZlVhYi9PcHMx?=
 =?utf-8?B?ck9GbWdFWE5hemtoVTc4YWhkRlRnaVZ0M0F3eEVpK1l3bEwrS0pLYm5ldkpD?=
 =?utf-8?B?cngzT2ROU05TdWhmOW9sbEUyT212aFBsblkvVGlTZnByVDBDVyt1Z2cvWk5i?=
 =?utf-8?B?YVdQSHlGbHM2MWwvQkgxTjBXYVMyYTQwR21HSW9kZlVHVmpBRmdyQ25ZMVAw?=
 =?utf-8?B?R2c5Ui9FN2htUHNNUjljOUVRVHgxd1ZwMUVJdTVUOHRjaHFVL0pRdHBOa05Q?=
 =?utf-8?B?MzRIZUlBQjF5YVp2NzlDWVZSS2VwaEVndy9vZkRCSjlBeXB2Tmp0dHNRSTFI?=
 =?utf-8?B?YThudEdOdVluN0dGNVAwaEhpbmVHZTNxODB4LzNTT0tCRG9UQW9LZXlCWlVY?=
 =?utf-8?B?ZHE4QlhaL3lQOVdTMng2T1Q1dmhEM1g1VzE1UUtlWnArZjBVc3l3aHJZVStX?=
 =?utf-8?B?U2dkZUw5cktlUWNscE5vOVEyUDkyWEx0Ujd3QzVIeFZlZFQ0enAwdmI1eXdh?=
 =?utf-8?B?VkpsN254TTh2bUpINTQrUzcyRVhkaFZ4Z1hFUzdQd3RqMGw4bkx4RVhacTFG?=
 =?utf-8?B?OHNhMWpoWWY1WktRK2YyQUo0Wmt0akZMUWhrUE9PdVIwVWF5VWNiRzRCQm1W?=
 =?utf-8?B?ZGc5eERSWVMrRHhtc3JFcVdWZFBHZWlmOWpueGJlNGg2T2lXNzF4TnBqQTYv?=
 =?utf-8?Q?XgtE63WoRct0ljxQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e1a0b9d-d727-41c0-6443-08da4f7b56d9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 09:33:58.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rvNAe5Ip4KnPJSLVx7tWqfjVOMvYabxbH7bD9RjDoq7K7GoI4wQzL0FaynWJX1UN+wStN7EFPOMS33DuFTYj6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6191
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 13/06/2022 19:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.15-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions for Tegra ...

Test results for stable-v5.17:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     130 tests:	129 pass, 1 fail

Linux version:	5.17.15-geed68052d201
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
