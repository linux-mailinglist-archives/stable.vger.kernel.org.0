Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3BF6663AC
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 20:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbjAKTWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 14:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239524AbjAKTWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 14:22:17 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0445F17046;
        Wed, 11 Jan 2023 11:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAS4awEIi6u91q4Q1PZdkFicE+bPkHzSRoG+0qKGwt+9WOTtsFOVt6CF/6CapZHCmJzHrApcYCSTBkJeulM1Bbo+WQTYeOm3NLy/K5MaA9/sH0+N5Y9x+q+BpG16l9MxEXv+Je4Z/pdyZXD0CIoJ9vb6z5hzsEzlOICibUr55pFFBElWelormRqz9X6KSbUY19GXXGn6gI7tyRlweEMTqTnnERMyxOkU11OcHLGJpJBLc8G4EN/silmdYbz2kI/1BJIWRN9LbOzdLZED8coUtWLrLGwN9ZbSRKIkZrhLOvfVUJQVKH2yMrnWJy+8yU1yz5MmcmCWvCCrG4GlNeHpEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DFMzcX5Wq22ECpbmlDpmFam1bJCRCI6ffWqKJme96h0=;
 b=gcq1gbvQSKhjb7vvyT5h9WPMSBJ6QQ2EWNukSKMugj/8PQq79aGa1c2Qt85u+D0/jd77Hx1jj1FegqdBbiiaGUriJ2wARbKFZUxkukhKN/AU2eu8rqi8vob0/O7s9PD1J5EPKNind5eRwm8RNfMNm+aOG7iEBjujWMGTvhJbnTJFhsDtQib7XdBoqY5Dj5tR9q2sRe7h8iSiXtNXvswU3En6tsDsXFy6yZlYKkG5rsVzCRnQZSLmFLy4+jzGkQTqEqYFDqeguULMDbPyhUWp2rXE6v2Ob7/bytFrps1w80GBnCvQI+cL8FUrR6FV4SdqIHtBybn+F1JIlZ/u5vqktQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFMzcX5Wq22ECpbmlDpmFam1bJCRCI6ffWqKJme96h0=;
 b=ohy3W8CWq19sEQZr8wpvbPNzTY6+CIyplmOzuIYY2wHXPvzC9afSVDc3zPm8pOC1WPcQXBnUKVMUcn3Msa4l6mcki/WsX+RNjHlHhRpLcbpxJdl0KfjdTo+GKWIwu4Pt7T0Qw5vrplWvsn3InYIqBsTrYijR75bUXM7d6+FqjGIbrGAARR9Qnr+QRgQP560Jhg+4hlrusJQtPXJYwlRflUn/bvF/B+9kWsNuCcmo7PLgliM9vMD293oAUsvqdQAt/THTymv6w1G+OJ7QknT+oqL3ibJuLGipMniNR9QdJZWAnkM/XOEyjY4Xs+XC6zkyrZH+66kIo+2R7HzTlZPwcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2981.namprd12.prod.outlook.com (2603:10b6:a03:de::26)
 by DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 19:21:20 +0000
Received: from BYAPR12MB2981.namprd12.prod.outlook.com
 ([fe80::fb2:fc51:3d5f:a2f4]) by BYAPR12MB2981.namprd12.prod.outlook.com
 ([fe80::fb2:fc51:3d5f:a2f4%5]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 19:21:20 +0000
Message-ID: <ad725823-f4ef-904f-c04c-90a6aad43323@nvidia.com>
Date:   Wed, 11 Jan 2023 11:21:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 11/11] video/aperture: Only remove sysfb on the default
 vga pci device
Content-Language: en-US
To:     Javier Martinez Canillas <javierm@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Helge Deller <deller@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
References: <20230111154112.90575-1-daniel.vetter@ffwll.ch>
 <20230111154112.90575-11-daniel.vetter@ffwll.ch>
 <fb72e067-3f5f-1bac-dc9b-3abd9d7739a2@redhat.com>
X-Nvconfidentiality: public
From:   Aaron Plattner <aplattner@nvidia.com>
In-Reply-To: <fb72e067-3f5f-1bac-dc9b-3abd9d7739a2@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::19) To BYAPR12MB2981.namprd12.prod.outlook.com
 (2603:10b6:a03:de::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2981:EE_|DM6PR12MB4202:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cdf686e-c09a-4883-dd8c-08daf409052c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 82ibdznMss12vRo/TJtT7nBR9sym10GxBOMBQrXef9lU0xOrvsQ+wkkyJXiaCIMbxsVyMoSgtJMdn2I2nR7+kp56nKx+EP4TOaxGG4dF+ul/IzDmXwP2ZFcNFuRPsLCMvMCy5xS19ogfv2uiSU1lTe+IJK0vnXKzKdVkWMOanoBiMUaAGSz8wscR2uYkXhSdy5tU6PZqD+OtqG1I8hdH14cveEmm474yzYinzooWgj0WtZjoU0psXIDI2CpI0byTQPRVpOHZLtrwZUlFSCHuZuf1lUoEQb2L084fV3IRycZPPChsT/c7QGt7OywzxEy+DhKw2XwAkHpfqldBpYQQTgaXXBOK1bHIFwxGmZ/+DfwQJzxo8gVQrni5khIbP211swssJHsRcwF2jvLsBKtRDLRLOWvrWxiz0vq3ab17VpHGdLkMGFD7hPkk5J1wSwKXHwT+FA1au6Y6RVcnhe0HkKDV/aS8xJ585Is64molxqd+c6PnIwuOjhEXTKYjtzItzMtBy6Qb/92Whp2En6n3/bSbVvqMoiH8Rsyq+b9iRNU6NBBvvW3FAjFuM2DZgNguFoZZKWMLnrv5oldrK9m7rBPCZYcV+3wLFYmP04kC0eus/uhPkDVrxQNIPlkJMGVrBgKPGBJ8b1gRNLe3Rf5bZoDqwcRA1inaAgNL1nTNMafXiCSQvOB22SoQ/nL/OBECt34i23zlFDcVRRU0gI/w3zS6RBIC5kn/gGr9LPfbbPwZmcVRG21Xw4BC+c9hyb4qStos/NL2gfUrPtG36yLnX3APJKZ2v7B62q+X/Xd3xnKvqC9Rnuyo7w/JD++W/zlE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2981.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(451199015)(7416002)(316002)(186003)(5660300002)(6512007)(6486002)(966005)(478600001)(2616005)(41300700001)(31696002)(66556008)(66946007)(66476007)(4326008)(54906003)(8676002)(110136005)(83380400001)(8936002)(86362001)(36756003)(53546011)(31686004)(6506007)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2xDWHFhc083MmxJdjM3bEFxQ3BGMC9xazJ5WGdZMStURFVuR1JmcTErVXla?=
 =?utf-8?B?V3pDa3NXdHk3RWZPYkVjZHhxYTFpaWZQb1hIMUlKNitkODV0MitEWUo2dEFT?=
 =?utf-8?B?c01keldieUlUQUE3Z21IRWNDV3kxUExpbzdZMFliT2MvVjlqbFpuVm41S0x0?=
 =?utf-8?B?RkU1TTErdGZJL1JTK3JHUWJlUDh2czd6YkZ3ZUVpc0pndVRJRzNMMkN5a3Z3?=
 =?utf-8?B?akNZME9OSll5bEx0VzQ1RUV5RUxqY012dmJoODU5cHBYYlFLQndpdmRMN2FQ?=
 =?utf-8?B?cEhOcmV5N1VpZ1JCRHNBVEZNTDNxdVUzMjNrL0lBMUFhWVVxVlhDVDA1VFF0?=
 =?utf-8?B?Uk5YcVNNajhZOGZPOURJWXh2cjdKZzAzamtjTXNsOVNjWVNBSnQ0ak5pZFAw?=
 =?utf-8?B?ZlpLanMzRUV2cmtNRHdNaFZ1dVgxTUM5TnpOMlU0RExZWHBieGlsOUMxYXpL?=
 =?utf-8?B?M09TTHRLN1dBK2NZQTBYbE5RdVg0anprckJndUhmd3RaR2xrY2RyMUNLZURu?=
 =?utf-8?B?RjNaMWV6cG01aTk3bldzZkQ3eE5SSFBmamhuUnVoRkxyQkVmU3dmSStWcENY?=
 =?utf-8?B?QUpZOFZmT0E0cnVMOXZpNm40R3hOUGppczZkNE9neU5ab2ZJOEpxdlBhTDh2?=
 =?utf-8?B?RTdjSUtmb2ZiRzJXZnJnRDhOZDNGa0xvbWpRa1hkSUVKY0FLUWtobmFhNUta?=
 =?utf-8?B?ZlBDNlZMOFdkeWx2ekJ1dHNnd2dBSkF4MkhOQmwyRDJMQ3NxNnAyMWhBczhD?=
 =?utf-8?B?K05NRVExUUdPMGE4ZjVwWFp0NWxZdnBIQ1U5VGR3bUw3Nmk3MDRDa2s1VDBI?=
 =?utf-8?B?ZFh3TCtKZnliam82WkZVOVVjZFRQSEJYTzZiT1hQc0FPNG05NE51cU9oRjhm?=
 =?utf-8?B?bm1ZelNEVVQvVGl2UXRVNm9hcGVTaU83S1JKWWFYUWZmNjlNQ3RMMC9vdGNC?=
 =?utf-8?B?c2JmSjVaazk5SnFGVGczRHcySWl5MFNxZ1ZWWHpKRkNjYUNPQW9lVnpNeG9K?=
 =?utf-8?B?eTNRa2RGaVBWNUVRSWhtZUFtTEgyREJhRVFJTTViSWU5TUxodURRd0llZXpy?=
 =?utf-8?B?RnNYc2UyR1BhRWVKZlVhUzNlR3hvczBTTXVUaURRTEIxWWRIL0lxWGVlOVJS?=
 =?utf-8?B?SytpWUVEc2p0bXJXckhSNFVwdGpxRHQrSjJrb1UvZzhYUXBBZ29jU01hRGRp?=
 =?utf-8?B?WlI0aW1iblpUeWc3WnpIOHNVbTJxcC9LMnRGVWQwdVZoSGMzUFFsNTJXUWtL?=
 =?utf-8?B?QlFWeUdESVNjd0RDK2NqV251a21ZWUN2bDl5d0hpbEdhWjNQMjRiMWpWU0ZZ?=
 =?utf-8?B?UnRLd29uczVwOWNyVC81ZzMxb1ZsVUVadDh0RnN6QTBWdlEzQzFndnNYYTNi?=
 =?utf-8?B?dmdGY2Zma2p3ZWV1R3pkS0l6ZGs5c0xIRlFBWExSMDMxd1VLb1pYT2s0c2l0?=
 =?utf-8?B?VjFGVnExc0ZWbEx5UFozTFI2U05DU1V4M3VTbVBVNGFQSis3N2krRlZ4eWlB?=
 =?utf-8?B?SHBhd0NNeFFXZTE4Yzk3YVI0WnJPMktBMVRUMVBySFFkSnF1K3F4cXFZckVX?=
 =?utf-8?B?eWgwL1M4QWhlTGJUTnFhaEVKc0ZESndURFgxTURkYlJNZEVwT28rM0RZWGdj?=
 =?utf-8?B?d2Z0ZDZod1h0Qzh0KzNHZmVrdFFTN3I4SGR4UlVLeGRXMDNKbDZxU1ZoOFJP?=
 =?utf-8?B?cldCeW9YRmxwS2FOQ0FwODB4VHhTMFBoKzRCSnhxL1dpdytIV21Kd2Rab01R?=
 =?utf-8?B?c0xoR04va1hLK25ORklmdzI2ZUVKa2FlZThPa3JXTGZpMVo5NnNqSUJmY0ZK?=
 =?utf-8?B?eUNxTTduSHo5QyttcHVnRm1CYzlReDBYYnJnWmo2Z2RDc09XcldMeElJZEVm?=
 =?utf-8?B?ajc4dzdmSzVXZ2F2SlVWQzZMQllhdnV1cnVSLzUwNzVtWXhxRjYxQzdiQTZn?=
 =?utf-8?B?NUs0TzRDVFJGTm84TExkNGRBT3BjYXhaSWNZcTBlS0JuNllweCtWbDdCVk1M?=
 =?utf-8?B?dUpRYUZVOEt1d3h0UmV6UVJIdHRQVXkyZDVTblhVc09uOVlYL0FpekFaQVVL?=
 =?utf-8?B?OFJ2TXc3VlBVbmpvZVRiMkEwR2toNTM5N2NBaGtvT25EQUszMW1Gd1VjMUpK?=
 =?utf-8?B?VVlVYUZ0cm1YenFuSHhOWm5BZFJwY3hqSmxyRkxORHhhcmRMZzZpVXBtcG5S?=
 =?utf-8?Q?V9zuCmgcBK4Fxri1uv37jIc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cdf686e-c09a-4883-dd8c-08daf409052c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2981.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 19:21:20.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5e/LLbc6EZKa8V3K72kZFfUB7Uf+zhqgIFj3Ly0so5CjlLCyLTd5E8iQS4qdWPwoPAgsBAoJbaDnRq9blZB7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4202
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/11/23 8:58 AM, Javier Martinez Canillas wrote:
> Hello Daniel,
> 
> On 1/11/23 16:41, Daniel Vetter wrote:
>> This fixes a regression introduced by ee7a69aa38d8 ("fbdev: Disable
>> sysfb device registration when removing conflicting FBs"), where we
>> remove the sysfb when loading a driver for an unrelated pci device,
>> resulting in the user loosing their efifb console or similar.
>>
>> Note that in practice this only is a problem with the nvidia blob,
>> because that's the only gpu driver people might install which does not
>> come with an fbdev driver of it's own. For everyone else the real gpu
>> driver will restor a working console.
> 
> restore
> 
>>
>> Also note that in the referenced bug there's confusion that this same
>> bug also happens on amdgpu. But that was just another amdgpu specific
>> regression, which just happened to happen at roughly the same time and
>> with the same user-observable symptons. That bug is fixed now, see
> 
> symptoms
> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=216331#c15
>>
>> For the above reasons the cc: stable is just notionally, this patch
>> will need a backport and that's up to nvidia if they care enough.
>>
> 
> Maybe adding a Fixes: ee7a69aa38d8 tag here too ?
> 
>> References: https://bugzilla.kernel.org/show_bug.cgi?id=216303#c28
>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>> Cc: Aaron Plattner <aplattner@nvidia.com>
>> Cc: Javier Martinez Canillas <javierm@redhat.com>
>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: Helge Deller <deller@gmx.de>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Cc: Alex Deucher <alexander.deucher@amd.com>
>> Cc: <stable@vger.kernel.org> # v5.19+ (if someone else does the backport)
>> ---
>>   drivers/video/aperture.c | 7 ++++---
>>   1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/video/aperture.c b/drivers/video/aperture.c
>> index ba565515480d..a1821d369bb1 100644
>> --- a/drivers/video/aperture.c
>> +++ b/drivers/video/aperture.c
>> @@ -321,15 +321,16 @@ int aperture_remove_conflicting_pci_devices(struct pci_dev *pdev, const char *na
>>   
>>   	primary = pdev == vga_default_device();
>>   
>> +	if (primary)
>> +		sysfb_disable();
>> +
>>   	for (bar = 0; bar < PCI_STD_NUM_BARS; ++bar) {
>>   		if (!(pci_resource_flags(pdev, bar) & IORESOURCE_MEM))
>>   			continue;
>>   
>>   		base = pci_resource_start(pdev, bar);
>>   		size = pci_resource_len(pdev, bar);
>> -		ret = aperture_remove_conflicting_devices(base, size, name);
>> -		if (ret)
>> -			return ret;
>> +		aperture_detach_devices(base, size);
> 
> Maybe mention in the commit message that you are doing this change, something like:
> 
> "Instead of calling aperture_remove_conflicting_devices() to remove the conflicting
> devices, just call to aperture_detach_devices() to detach the device that matches
> the same PCI BAR / aperture range. Since the former is just a wrapper of the latter
> plus a sysfb_disable() call, and now that's done in this function but only for the
> primary devices"
> 
> Patch looks good to me:
> 
> Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>

Thanks Daniel and Javier!

I wasn't able to reproduce the original problem on my hybrid laptop 
since it refuses to boot with the console on an external display, but I 
was able to reproduce it by switching the configuration around: booting 
with i915.modeset=0 and with an experimental version of nvidia-drm that 
registers a framebuffer console. I verified that loading nvidia-drm 
breaks the efi-firmware framebuffer on Intel on Arch's 
linux-6.1.4-arch1-1 kernel and that applying this patch series fixes it. So

Tested-by: Aaron Plattner <aplattner@nvidia.com>

FWIW, the bug ought to be reproducible with i915.modeset=0 + any other 
drm driver that registers a framebuffer.

-- Aaron
