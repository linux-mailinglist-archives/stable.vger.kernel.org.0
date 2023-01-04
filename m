Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98265D418
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbjADNXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbjADNXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:23:00 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDC1C7;
        Wed,  4 Jan 2023 05:22:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hersbnBT5gvOMkQi3Il51BHLStgn2OUKWJlrXIOe3xbdWDYO2484o7f5Tl2zexqDATqBGgqC+0KlrrhXa3KAjiEEqO+uLyNfiW7XTAHzS7ILsv+r4GLCT4hGSsXEbxpGi6nZ1yLPL8uuH4ltQZg/hGcSjH8fdDibK5QfGi7LVDq7sEzwasKdHFvcaeDzgVoMgtBoYmelU6czyykLtpzhU5pFaWtRMniElW0TAj421+rHLO1AkC3Gz1uRMv4DCXkPegZXJL8Srgmy/jBPI5qnO6jW8cx/XuraVdHGs/LJaaXqsa0G6ZCaSHiRKUqembfLJfaVi3AQXqkAEW3cBPoQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EN7omMrUAdhffwN1JUpKvypl0w7SbUZidKbe9uLB81Q=;
 b=i2rOvFJ+Ohoupj9m6cnQdyGNh5XqFl4z1S7y7dUbkAnEGwsQTI+JXNfvgbQqTGsMkbA+RT6WY2jvOEuAAeByT7W0MNDbOyZTrmaFG0R7Mg8a019DG8t+r8CS5NqAvb7Llm1DYOUhkwQwkuwOlqxNVq1pZ4aiTdZ930meZTfS6xHkcWSzuwvdtf1LTu6DgEzyhca81tivgb8oM0IhrEq+lZJJ5QcO9hHFMUw1wL8gEn86Rdt1jte7bYFxNNRO58nyk/fl2YuM10ACLHH6DU8Py7hPnnm999W35hl9NDtW7nPXCOEtyCkPUcliDIkMzSANfXIYU17mVW7ZdPg1ulZw7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EN7omMrUAdhffwN1JUpKvypl0w7SbUZidKbe9uLB81Q=;
 b=q6tYD3ygZxlKWUpmavV1NAH5q+c1wsK5M1EF3STSgHqLaNmGrc/1ayIpYli94SI1dLSzrsEDu77vvZRPXvzV6G6eJnBOqekx3DSMU85WI6YkNUSO4ViNRsENQzU3CblqNDt9eSXaojroFcTvKzkO/WGMSorwhZyoeDEO3U/cAAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 13:22:53 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::80d8:934f:caa7:67b0]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::80d8:934f:caa7:67b0%3]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 13:22:53 +0000
Message-ID: <a8c6859f-5876-08cf-5949-ecf88e6bb528@amd.com>
Date:   Wed, 4 Jan 2023 14:22:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.19 1/1] drm/amdkfd: Check for null pointer after calling
 kmemdup
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Dragos-Marian Panait <dragos.panait@windriver.com>
Cc:     stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20230103184308.511448-1-dragos.panait@windriver.com>
 <20230103184308.511448-2-dragos.panait@windriver.com>
 <Y7Vz8mm0X+1h844b@kroah.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <Y7Vz8mm0X+1h844b@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::12) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|PH0PR12MB5481:EE_
X-MS-Office365-Filtering-Correlation-Id: 879ca667-62b5-45fb-285a-08daee56c89e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2O63e7YsKDq2eZhq7dXjN0sk54pZwYVckyp3LVVJvMjzCp6qwuaMDdeGVdtpvtEwZK6CWe/5XXP08YIKJknDZoT/UrZxaldyyacBrOhPrZpSs8w4Vl2jyWh0K8FZh2qh1SvyDJkT9lEfLJhXQeVdXHFF0u10eZybpAIjyfDFrUipzA7K9PKWWqMFL2/6IBMA1I+C+LY2xksgNlPGRZBIubSoLjY5T0WnmIhJ5jp1tFLlayvt88JWDHFeILqQF6m5+V07D6LkjqhRvpQJFNpCJMdNLthAG5MEfJppYoK/8FctG3Mz1eM1LcquARAf/Zb+ENSisRx/7k307TsetJ9DFErqQu7AbsnF3TM5CpSTjEkanceotHSGDwQK6QsMZBF8beRkZLprAQ35Ho1CCmxeRgO3LV75DcTQjZEfcvr0CWm0g+NJhqItJmyxauP32kHLzQBvKFdGHBXbuaVTrWd0qDzIwWFp7ohtq+qKAPIafQM1j39nYZ7PYcIXoxiLr6ASABw+Jfqz0tfy1qIODljZfgx2iYXNcEETLvWgiY08MqdVZSvjYVfNNICVP00W7iRHXxSfM2jy1N0EFPmS48hV5SQCotXJ4WBUbHVSYtmjBsvX85f/m7atS9cX5fnprLx877tk7pQFIZPN99Jf6iMNh3IwcWg+kbO0+cxTPDlBKcxAf3epJxQIqVwlHfMowtjJim12aXZIe6vImcSk1r2vlvch06Y8n8jG2TaimbcTFnA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199015)(5660300002)(2906002)(4326008)(41300700001)(31686004)(478600001)(8676002)(8936002)(66476007)(66556008)(110136005)(66946007)(316002)(54906003)(6486002)(186003)(2616005)(26005)(6666004)(6506007)(83380400001)(6512007)(38100700002)(31696002)(86362001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0xPVUVxNFNob1hVM1hJekRUb0UyM3I1OWtjNVJHZ056dnBjcTYxTjNSYXhw?=
 =?utf-8?B?NHdmenFBNDdHbTJYaHA2cHlKdXViR241czlvOGN2WWFOcVlLWXdVaDR5ZzZt?=
 =?utf-8?B?UlA1bnIrTXRobUk4TFZlT20zVithTzhQQ3JhWUQ3bmJvZnorb2ZrS2VhU2FR?=
 =?utf-8?B?a2xuNG96b2lqL3lsMDZQUG1QVWJMQmtsazZFbGk4ZFNZeERJVU9BT0dmUVZT?=
 =?utf-8?B?NENSYTFTNXJpZU96YU15aFBQS1o2TVhZWTg5OXJyREFWUjRxZzdzR1IzT1hx?=
 =?utf-8?B?Y3FYUjJtNThDazZoVUp3aUVFenh2aUhEK0RJK0pWTHVpa2RVYW9KZkNEQ1RV?=
 =?utf-8?B?ZktGV2Z5SWZ1ejlzQWdObU5IcUU2OCtVOERadUE0VTBINjE1MTVqRWNYWldD?=
 =?utf-8?B?Q2RFMy9NQkcvelpZMVZySUJNSHovNkdoNTZMVlovVC9IdUtyeGEzdW1OejRL?=
 =?utf-8?B?RENlclhIV2dSSkNUNmdqQ3JERzVSMHp4aFZZc1VyTzNrQThRblhuN01kenFD?=
 =?utf-8?B?N0M1YjhQMmN0cWpnbWd3bDI3aTc3R0FUcGc0T3F4b3VMMHpiYjdTSTdsNW52?=
 =?utf-8?B?dC9vSU5JdXk1OTE0UHRIaWRnTWpTVXhRQ1pHK1hyeWZxU1Q2M1VWMkpPNXdE?=
 =?utf-8?B?NmxRd3BCS3d0TE5jK2NPUXdRdDBTVmZlQTJjbnV3NWY3S1UxejFuOFBYOGJD?=
 =?utf-8?B?TmpTWVprc05heHk2ZTV6ZHJQZ0Z5cFJtMDl5ejF3Wm1OWHlJRzlqU2lZbVdF?=
 =?utf-8?B?ZHFvdXQ3WiswR1ZKMldBekNVRnJxelZRSTZPek1rd3ZTMkVyYkdQNFNuSG5i?=
 =?utf-8?B?UXduM2hWU0tMYkhKRFlYeDdqSlQweDVwb3F3MlRVamoxcFdlejhGZU83RDJr?=
 =?utf-8?B?dEFjaUpmcTM3NENWQ21OanMrUjIxb01iaVVDVWxzZnNYelNCRUR1OCtqSno0?=
 =?utf-8?B?c3h6RHdFRnJBa3VMdklMcnRjNTJmcytQV3ptMWpQamJid1IzUkFSYjl5UDgv?=
 =?utf-8?B?K0RpbGkzTEVRU2VWWE41TCtoOFpPeERHN0djdlZxWjhIUjZIRjNLNUdoNXhy?=
 =?utf-8?B?aHhEa2pjQTZ4K3A4L2NkYUZoSmtKd0Z4cG5wblNQYk0xaU83blhqSFh3WFU4?=
 =?utf-8?B?cUJzMUJ6T2M3ZS9KaTQ3L2hsZWdON0EzcFZsbmU0eUlTT1pwWXJxL1hVNU5m?=
 =?utf-8?B?ZVkrVUJxYnRoandpZkMwaFZoT3pXdlBBa2xHVlhGdmQ4N3YrQmY1V2w2eXFo?=
 =?utf-8?B?eGw1NHRRZjF3V2hXYU5XUzRMQVh2Z1haTkxtbmtLUVpNQXFiamt2clVsc1lQ?=
 =?utf-8?B?bHk0U24xamNHbjIrWnpkdWpnN2NTbnFFMnpKeXV5d1hhMGEzR0FEalBrbFcz?=
 =?utf-8?B?TnkxdUx6cGhBNE9jTVdWUkxCNFhDanp3ZE5iZXc4RFB3UlVmSzdHbTlVQzMr?=
 =?utf-8?B?ODVKWEFkenVhVlhyLzBXeDJKMzdzZTJYL292dDJLd1diWU1SV2paZGNOVmhV?=
 =?utf-8?B?aGx0N3FsdUU1VjhQRmFwK2NtRTVndXZoVnhrZ2JHRnltdW9FT20vbFJQZXV3?=
 =?utf-8?B?YXdzUEV0TGloK1lKNGtJbDdoZWdYeWNYTlZRdlFiY3ViNnZMelFZVy8xWDlh?=
 =?utf-8?B?SlhFd2N0RTlOMzN0TjlzaktsMWxNQ01iS1IrMktmanRoNDYzZmFBY0Z2amhm?=
 =?utf-8?B?c0d0Vy84RFR5ZHJuTjZHYjVicXIwbDFXWEFpWTFCWFZGbjdZTGpZWkdnQnJN?=
 =?utf-8?B?VWtnV295SG5ZM0FLWkNhUGZDT2hsQW1tc3pEZGh6RldJV0t6Ni9tSnNNNFli?=
 =?utf-8?B?UEF5L3Z0QWtBT21TdXBGTU4wdlczT2orTHV6SjRIalRHaHVKcWErd0MxYm9L?=
 =?utf-8?B?SjlrU1p2c0pPV2RXQVMrSUdsZDRCQ0pwRkRLZExFTEVURXFtRngrL0ZncjJy?=
 =?utf-8?B?aGk3dWp3VHNJekhXZGkzWU94U0NOVmd5QnNieU9xZDFpdGxUQjIyUzY5bFRj?=
 =?utf-8?B?MWNVbTc3eGZWcnlVZS9YNFFObHVPM3pPZGxTendOM3Z6RHJkUmZhZ0Nvc1Np?=
 =?utf-8?B?dWdrZTNLZERFM3FHeWU1dWhiQlgvT2EwR25iUXhROVhSYnRrYmZKRWdSVENH?=
 =?utf-8?Q?qUKoOTDX2d831jcRCZhaQ2Thh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879ca667-62b5-45fb-285a-08daee56c89e
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 13:22:52.9877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CvneUi/G8MloubSFiJ1HBmH6FixBqKOVozeazR6XWrWUqAOClFWbNueVDyK/CR+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5481
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 04.01.23 um 13:41 schrieb Greg KH:
> On Tue, Jan 03, 2023 at 08:43:08PM +0200, Dragos-Marian Panait wrote:
>> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>>
>> [ Upstream commit abfaf0eee97925905e742aa3b0b72e04a918fa9e ]
>>
>> As the possible failure of the allocation, kmemdup() may return NULL
>> pointer.
>> Therefore, it should be better to check the 'props2' in order to prevent
>> the dereference of NULL pointer.
>>
>> Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>> Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
>> ---
>>   drivers/gpu/drm/amd/amdkfd/kfd_crat.c | 3 +++
>>   1 file changed, 3 insertions(+)
> For obvious reasons, I can't take a patch for 4.19.y and not newer
> kernel releases, right?
>
> Please provide backports for all kernels if you really need to see this
> merged.  And note, it's not a real bug at all, and given that a CVE was
> allocated for it that makes me want to even more reject it to show the
> whole folly of that mess.

Well as far as I can see this is nonsense to back port.

The code in question is only used only once during driver load and then 
never again, that exactly this allocation fails while tons of other are 
made before and after is extremely unlikely.

It's nice to have it fixed in newer kernels, but not worth a backport 
and certainly not stuff for a CVE.

Regards,
Christian.


>
> thanks,
>
> greg k-h

