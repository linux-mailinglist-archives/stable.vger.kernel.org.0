Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A039954DE39
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 11:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiFPJd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 05:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiFPJd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 05:33:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B524096;
        Thu, 16 Jun 2022 02:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T+tBoqK9vUFUzSIuxeON7HY29Urv0HtBvbHkPcy4Gclv/sVuceUNYY9B+NHDi41SFJEsDXvaX967+WuQxugdGnYHlgsd+Lb7W8dkjOZcjMubz8tsepIS3wuEgk5xYXopS8V/e8tMSVq7+uOKm/Hpr3/XpG6dtQWy0lQIz4NRhlf/uSwkGqsTQBpUh2YQI0ggXVNn28xxB+yXfbl6b8B8JXwMpWrKphTXzaJk7Ah7asrr+frrjXk+GwFPpZNhD62tz6gEJ9oRJ7v2mORExtwO5IvrlvmV1OnghvJ4J6FvHTaH7fT2wLbRSG3XAaB0jJpGZKhAtAcNDvYpFeaL24e38w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1S5mpVh+ys8o4OhG6YKsP3W0nXI2CNWVOlB1yBTbe0Y=;
 b=A4r0F8bsnm3TCDxkXHs/y8BIOOIlIq18mIZmyH4HMvcrjnPCA/Y8T+hZYEGMhvmQIBqFqRlP7LaUiF5AoSFZ2QMhA2CgfZXVr9J9E5EaVcWVs+X8sFOYk/4Vgi6+vYaCBEQ2B+xsPoOyOBgKTMsEsm6rdmiyNsJp58Hg55HeHmJcYAvb6k00i9Rr7ktedGDDlmmFNzIZxqrq7GfyYK5MmmYtLiPYRmVPjs85oKfUti5+gSLMv5P8uxOj4MAU+VCJ6uEac6cnNl2TiaqHqCoBg9SaGcVTdxGHnZX+/YpbGsbcaVzFALNhbkJEo7PRC9ET6mzLZqrTQtpTkAFGs3v5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1S5mpVh+ys8o4OhG6YKsP3W0nXI2CNWVOlB1yBTbe0Y=;
 b=M9XpqzbawEv/3hu4zJg+iZP7FBi8LezM7jaVzEe6FKX7bvTOCaPWPKRckrn1s7oqhJGRHpgn1NfrA5g88651hENaO02ts1Z2WQfC52qgVoluAHd+5XdYYZq7gIq+fG/w18ET5P6ZaffbfRWXj8iFQ5EgOXenzjo9HK7rV3X8Ynh+ecIfGtSo57jWy9CQ4b36DFba5R3Vk+AuXQN5aMathiPsv3pQr71x3eSvp4fyuhSSQ1r9S+peah74rvRXN+UQEfwIJk8L3FaZa0WFvvY3Gw+g+HND6CCRuLSH1Bdo3ZCaEqTZujmrpQB+gxsR3tVJaX4VLWJBqdf6c+3TTOvhCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB6191.namprd12.prod.outlook.com (2603:10b6:8:98::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.13; Thu, 16 Jun 2022 09:33:54 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::f954:6840:ce82:c54f%4]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 09:33:54 +0000
Message-ID: <5dc14e20-7b39-d772-d793-d3ec7b07c047@nvidia.com>
Date:   Thu, 16 Jun 2022 10:33:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20220614183720.512073672@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad625cb5-97f1-43d8-9f15-08da4f7b5431
X-MS-TrafficTypeDiagnostic: DS7PR12MB6191:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB619113F56F114D628A781CC3D9AC9@DS7PR12MB6191.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLhVUvE3iKxAGmdTzIAtVznyU364RsUKiZ7nTNsr8SVsQ3v7ipwsziofdQ/IkFSBmBfn+YmCKk/BQD8a/kBSptFyZU1vz0UnSMnKcM7QMVC7ySmJaerrtzaBZC5SCuAns+xz/EORFWRPqfqLI0RY4gN1LCwEXHyPbzZYqgrEBovXgYTIxjzyuF4wpJ5oFCO1f3a6pT3vROIF+pTt8ZmrtCqGuTNSNyilt2/eqsCboSbhXcJU1krEi91j99BJ8BnifcX3JqHmjXbPpV6geDyVX3PckUrVrkQ/r6B9tc23ZDrmuCwCF7wbZF3BFIDkeL4M1qOS+hOjeIWn14IjEgnNWJaXbcfUIz0FyXPPpK9wTTzGtJp+M7PMoFy5dzmfKb6eE35mu+M1uOJj0WZqxWmnxSsEk/oQHL3bsjerl7418Y1LsGLY8RneizoI2SSe/h/KlR0kILHHIqS5Cmw7+WvODI8MIuEaEeR8/nii/kBlD1/qFdcePNXI1TpMlCm+tfPbj7Ksxe2D9IWFXDlK/2ypn0uKiSE97svPrLL3I61a6zlBEjR4bCgX2XIogegrhf9g6RVzEZ8VZzlW4NCDX58GOuUyiEGzp86gFwzqAKIv6ioDWFRXd/bv52hBipZxfGB06wAEFZ8zgM0gwISYSns1Xyakz6O9p3DoHryi9ykWjXZzRZ2NqT4g07nDUM47F6ioyvEhBafgYY97e0n7soMmpBraXspAQeWMHbL/rPDs/QKJ1Bcmq2/z3UZaxe33MH5YLklqPpODzTiystS16E+wfW8z0AmXIEf3crd47Cf5TZhAWmolUaYFf9Ykyvy5BohZEsf5RiFTPlLrdkQFQQKOKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(2906002)(86362001)(26005)(36756003)(6512007)(83380400001)(316002)(31696002)(66556008)(66946007)(4326008)(8676002)(66476007)(31686004)(6486002)(2616005)(7416002)(966005)(6666004)(508600001)(186003)(5660300002)(38100700002)(8936002)(55236004)(6506007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFFMUkxSSEtMOXY4dHZTQkdjT2dtN3Y4aE0vQ0lNUUJVa1UrS1pYMEdodWFO?=
 =?utf-8?B?MGVsbk02b1FSOVBUWHdVNXdDWlVYOEEvdVJ2aHZ1R0FKZkdJQytFcDA1ekVG?=
 =?utf-8?B?VkRWMnc3Q3E0cWJWUjBpUUZESytQbkV5RVNDSW1WRHkzT292YTkyNmM4NlUx?=
 =?utf-8?B?WUx6SzNyR1FTbnpGeXlGcUtlenEwaTVEdGluNlY2ZVB4N3N6Q3JZZUF1R2pW?=
 =?utf-8?B?TFNOWkhaZGtrblZDZUtiOTZBMTJ3WTNjcmRPSnNaN1FlT2l5aUY1NFByZDN5?=
 =?utf-8?B?SnFHUVl6S3JrYld0LzhFaE95bUV6TEovNmJNbzdIRm8vYkFGNXRqUnNZUHc2?=
 =?utf-8?B?WkVldjVSZC8yVGdWUmpKdVd6aWpTaFFsTTRTamU1VUtrRjZPZklpbWdmcTZR?=
 =?utf-8?B?NXUzajNOaU9wNEJDK3J1RkR0VGo2NVJmWGxRcjVXend2Z3dmV3pOTUNZWDd0?=
 =?utf-8?B?NGZkd2NVSnNsRG9DR0lUMk81TVN6bGxtR2NBQ2VTNkx2VW04d1J1WUU0WExt?=
 =?utf-8?B?VHNlbnU1cFgvVlpOYkZveVJkZDdCMnRVbGRza04wVURIa2gxamlIOVhQblFQ?=
 =?utf-8?B?dlRpTW44WjRYVGdqb2pLSVlPK2N6MHpORkdWTmtBaDJZVGx4STRVQXArMVhm?=
 =?utf-8?B?dkFDbmNGUXBUUTNqQWtaUXVGNldveFBNa0pDd0UrMHZiSGpldVZETldpd2NS?=
 =?utf-8?B?bE4zd0RwaTJwODdDclp1ZFFkS1RsRzdEdEhmOU9aOUFJL0FSQ01JNEROSjNE?=
 =?utf-8?B?VlJ2eXNaclQ1MHdIczFlNUwyc29XV1hSZHRZYUt3bVppd09VbmlvSkI5Z1pM?=
 =?utf-8?B?ckQrdlExR0NTNVVwUnlWN2dpc01VVW54NU9qbEFaeVI1RDRMUE1MTkpXd3Ny?=
 =?utf-8?B?WWRnQUVZR04xeHlnRVVLRVdQYi91S0NHN2pLTEo0RFJHOStSLzgrQXZLRDRX?=
 =?utf-8?B?Ym5UNzE4dHA4STJnSlFUQjdyc2VNRnVqK3hLdjFaWFJnWWFtUWloUHcreVRO?=
 =?utf-8?B?bDZCSXBpWlJHTW9EL1grWnFkc2J0THI0NTJpNkZGNTljVmREWmdtalB3T2Fj?=
 =?utf-8?B?NENnSkRyUkZxNWE5RnFrU0pieGRaMmp4eVMrUWJnUUlkTmUwaFdUOHZYZGo3?=
 =?utf-8?B?dU1Uc0pMY2xCczAwTFkwaHVLUW9pTmtUQ3VwWVpmZEFkVUtmb1VNVmEwUWFC?=
 =?utf-8?B?WloxS1RoNEFJQ1h6YmFQeVRuNXZ4NGR6aGpaWTQ3ZlRuN21xbzNFV0NQZExF?=
 =?utf-8?B?MlFtT1pxMDd1R3BvTk11Q3NiUWJQcUVUWFdPeDdFcGlVdDdGS05wcE0zaFZa?=
 =?utf-8?B?TSsvaWNUeGhVOTlJcDdVZVlHMGRzNmNUdGxENDRKdW9WejdubFlwbG9SYXFp?=
 =?utf-8?B?ZGFsQnhhblJOZVlodzg3alNveDBLY1dsRmF3SmRKYVYwYlZwdVM4aFhnTXZj?=
 =?utf-8?B?RE5ndDhQWDZtbGVTblA5SWdFR1NLNk9TYUtRYm0vVzFEOCtzdUdBU2pWLzVu?=
 =?utf-8?B?SVdvK0NNUjJKQnVZYm5jdGxCeGcxSEh6OUVwYUZUMExlQ3hQTEladVFIb0ZJ?=
 =?utf-8?B?MW1yRVBrOVdFN3h6UEJtS0lod01PQ1lRcVBBNWNSd3NxRkJlZ1JXN25mQjJT?=
 =?utf-8?B?aTdOQjluZm15YTFVRFBVSVJRQ1ArL29wSjZqYUhCTGMyWmlEMURDTGJhYjQ5?=
 =?utf-8?B?bG9MR2RySFMzNHJmSjlKZGdNQURDS00yaVl2Qk0zb3I1Y2Q4dzRUTjg5T0dt?=
 =?utf-8?B?OElaL25BR1BZRFo5YTFCVVQvc2VZblVZTzRGOGFpdllvUjZqcFdJM24xSitV?=
 =?utf-8?B?V3FLNytyNG9hT1JMazArOTRxeld3aCttRklEOCtkSHJxM3JiaDdaV3VBUjA5?=
 =?utf-8?B?eTROOFRsTGZWaXN1alVweGF0YzNNeHZ5N0V2RkpMY1V4MVBKMWFPbFRwNTNB?=
 =?utf-8?B?WjVOczMwU250TGQ0dVJBRjhobUhFeDlBZ2htci9zSHk1UzVFU040S0Q1M3hJ?=
 =?utf-8?B?b29ObEZ5WXN5NkUwU25QeERBYjU4UUp3MndSa2pjUVFSL1E5aTlQWUpCR0VN?=
 =?utf-8?B?aVFZcEpQNW00MGxEK0JMS2lzWElUS2loVVBtekNTbTc1YjAwbkd5YzQ5N3J5?=
 =?utf-8?B?cjl4ZjJ6dytCc2JzNGV6SnorTE9KRjRKSVA3ZHdJdXEvemg1N0VWZzNnTHZa?=
 =?utf-8?B?M3dja2lncTF6cyswd2xuWmc3ak8rZnh2NVdJNkRSYk5aWERBdzBUTDNQOGVs?=
 =?utf-8?B?WjFKTlBLYlBnNWFhaUR6RUc0eTF0WjZaSjU5UHBuaU0yUkdqYXRVR3V5YUFZ?=
 =?utf-8?B?eElpR3VYK3pHbTFYZUdKUFlLUFRyQWdBWnNMa3BUUlByMVg4Qm92VWNxekpr?=
 =?utf-8?Q?Pu1hxJix9tJ/3MZ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad625cb5-97f1-43d8-9f15-08da4f7b5431
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 09:33:54.0955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYnYR0oTIvp7tQ82ipZXm1VYwL6nacDzqvFXxcu3eTl6wpvrbpI4lCCokVscR6GgyZjwRkib6nQlU4cGG8DuOA==
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


On 14/06/2022 19:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.48 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No new regressions for Tegra ...

Test results for stable-v5.15:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     114 tests:	113 pass, 1 fail

Linux version:	5.15.48-rc1-g2e65f63d5e2c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                 tegra20-ventana, tegra210-p2371-2180,
                 tegra210-p3450-0000, tegra30-cardhu-a04

Test failures:	tegra194-p2972-0000: boot.py

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
-- 
nvpublic
