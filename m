Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F8069C643
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 09:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjBTIEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 03:04:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBTIEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 03:04:35 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2064.outbound.protection.outlook.com [40.107.243.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4BA1027A;
        Mon, 20 Feb 2023 00:04:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jd+T+/croQtdUx7oK6yM0oVEutZiqv8xhzTMcWpTjcUSJV/d1X4nSTsKoH6tNfifY/sAPbrW2inBtOLzt19yWotwij08tp5ScqzH/Swpxl2nHyDQgPf6u1+h2ClgKwvWPy7u2jM+0qvpnFHJ7WLWdx8neTns2Z+ZbM62xxBHwR1ZrUbgg5C6nzA6XQ6i+f8c6A4oUvDCucco9us1ksGNj74btQDACCseTfQYj3CPnu1UWnQwNYjKlQdkw/CFAa7ePvEP+QQvviYwjIEafGOhJefSCQtipDWR2WyDG6TkAh2pfmkvz3nU3k/pRgR/VUReu1NwpfPoi9epxWVszy6dNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qAiPI7tUTWcESZw35R3Po7VANLTtIOSox4x2htHyQc=;
 b=PohPij7CDX+Y8yigAX9O+KM8cNMhDZRG9FqlOx+LX58siOEou/ZYIk1dtvwfvocjKtOMqP7RG5bhXmM0SBaZ3QVe64JAicq+6Hv7qPlE083jrvOfiQMgxr0ZvVzSvBqrxcWqu5X/ulA82eg5NrBEbYEQ+vPknDmb6v/ykJRBNDF9HXfaOfoN0ffaHfAHSj4sLn+vWJf+rSqszraE4yGtQj0APhoNGTAilW4qmCPa9KKOnRGdCVdthRL0G5h0NoEVNDfjNSNNOmrF1sLDZNRXhnzXasLE8cj/9PcfMxmp/A0/OvWm/sy5x6arUK1B/rOKiPNE5LdUmTb7/jnKMsm55w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9qAiPI7tUTWcESZw35R3Po7VANLTtIOSox4x2htHyQc=;
 b=UMCb6ld6Alk414bQCNW5WvQKTtWyczX46sk0AJjUWFxmw7CCAbQtKIggQurYLYEi2ZocYgIRgvOAoPUAje7+L7aZW4nWi8EzB8YhjiW2HOuwKxm+s1Kp8ecq63apVaWJgojkRGxqXHsU1YVqvB//cYyz5Srd/IQyLMOzLq5x8rha2mipBlCsJlJ2v0S2Tr8Jv3a6+UsphE3rPg5hhJ6sgNR36EY4/23FfmBbVnAHb/P+rafGsQs8KgZQ1CrxcA4kWsHgunhXdjwJDEcACJ6IIc3TnpbXbbLzEQW4/HDfmNxo/g9F+K/aRJ8lA0CKVirp9ir4/zNaAhz5N9N3WG3WPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by IA1PR12MB6457.namprd12.prod.outlook.com (2603:10b6:208:3ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Mon, 20 Feb
 2023 08:04:30 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::4bd4:de67:b676:67df%6]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 08:04:30 +0000
References: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Alistair Popple <apopple@nvidia.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, stable@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org
Subject: Re: [PATCH] dax/kmem: Fix leak of memory-hotplug resources
Date:   Mon, 20 Feb 2023 18:53:01 +1100
In-reply-to: <167653656244.3147810.5705900882794040229.stgit@dwillia2-xfh.jf.intel.com>
Message-ID: <87k00coj90.fsf@nvidia.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0095.namprd05.prod.outlook.com
 (2603:10b6:a03:334::10) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|IA1PR12MB6457:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d04dcc6-c1b7-4d67-9178-08db1319182f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQwjyptTjqpZUAN9N2TRLNbjSTAxMg6KxxTDYNO3uWCGtfXTkWJHDLsp48Si1WXNXivO/xWn61METRkTPlqLIpUyYMylp/HkYVFaZxgukpVd9042bYK/eTGNwzyoxG/hOFWqPV5HCfiBFAPBF77QIiBTIApYMqYord+o1msgUg25FdFa13h8KLl+2CpURy5otu0wh9WldApD8Mn2dtA2oIoU0I6yobQ0eCD+iwJ26N//wuab2dwHYEX5X8UbQnfsbKxXu/nIkilTMdDCNBvKL/1gD8ULL6tPD5RNIJlm7cVab3iXGKH1q1V8W10zgqB34SOBAYXQuP4BN/cUof5kUKVnsJX4hkpzgk7ByIuNxGLe6JIpkSnOA2rPHmKrimIBVx18lvNEqm8qnvcIwqtbkVq+8pvo7VL+46HYVGB43WcRhFYTh+XtsBWz75znqSyfoTFUzRmmMgxAy8pl3Y2BKAe6St2LJWbHL2pAMo3dWl7WWl/7eQ4+KcUIWyzt3L32hg97LoTxpA2csV7s7PrO4H9umBnvC6UDsvP7DoH3xaChFnNPhGpdEHXr3PsgtI0IkiNUHdKD7X3LgqANtLzvFDXdxtUnpsWq5+/TuxQm5vl1GQj7v23Bx+q8xoT3NK4HYu292RC7Qniv9RDb/449Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199018)(86362001)(54906003)(8936002)(5660300002)(316002)(83380400001)(478600001)(4326008)(66556008)(41300700001)(66946007)(36756003)(66476007)(6916009)(186003)(2616005)(8676002)(6666004)(6506007)(2906002)(6486002)(26005)(38100700002)(6512007)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zu76a2vxGY7D6MmZsXRgZLqugANQlJnVl4zSyJ0MXo9T05BBdoelB41kQcbf?=
 =?us-ascii?Q?jErYoYFD27qwQS6VxeBdxsZn6YwnLaQbQXsz6FmCQmrxCCzrD+f0CtooPHEE?=
 =?us-ascii?Q?Hxxv3vtYO2qHb03RBs+w+Y8T5nFj4q15M6sFK/z1sPrtQGJquwduHA8nHUtR?=
 =?us-ascii?Q?PxOtC7eBGpOS3a2Sy3BNI4Q2hXUP4vKV4jyVCBpUKPKPpKGIouM2TNPLkkQI?=
 =?us-ascii?Q?mpMmSSJ4GyYFwW4j/0Q1yWEgQeNilRqa7I24p4mLtlStqyUd9f99PVUrOrDw?=
 =?us-ascii?Q?ZI6xSA7YNWNbbV8vbBaNVpCTA8ABpnNNId7q6KN7MBGHd4IS6L+bZlbFa6cV?=
 =?us-ascii?Q?ysnOl0kJptKpgQEUhA2G5aaodMhn0qVnuHeumaiWjiBQl2H/uK+Q2khGab/C?=
 =?us-ascii?Q?/1fTpC3VCr52JKT6XbcZlkPhLTw8bS8k9CPep9ALFNezhugAR6GAVTHL2NWi?=
 =?us-ascii?Q?Q56cvbug3UvYPr4Z/e684A2WwPpmX5kf5o6P4cpixd2UQys7Piv1SdCbkaNn?=
 =?us-ascii?Q?8Kejt1LVGzs6xOenVVNWFdGCVmLE7pjLg0E2/iWaqmHCmkO/DdF/fYDpy6u8?=
 =?us-ascii?Q?5FxJO5enfGLCIX5x0ipWIizzDXbe3NOXS0Z14pONKKoGPUJNeFiOr3M5e5kx?=
 =?us-ascii?Q?WYc1H+zXum++G+r8+YdthNdYAP0rvW69GYD7KJJ3nuTF4OYTkKMHSFH93BL4?=
 =?us-ascii?Q?25Ze7pDOTiDGb/sbUDAQ4MElbxTzdcEBYVZ1h5XzSevA8uB6eXkitY9tRRmH?=
 =?us-ascii?Q?VGdVS0+wUhtx/iRKi/XR1wkxXzXXEI3PlMImYvB7LHP7mH3LVCjrSlc+HQ//?=
 =?us-ascii?Q?QSvSxAAuNYfSP5XHl4nDzg+XNtI53vBjzfEum+rivvmq83lfQxe2X25a0lNe?=
 =?us-ascii?Q?7iSvonI7q2Rq68qjuPNYIhTf6BVlcFNyHpSxEhxPf7Bd16TMxwLloUNmcG9x?=
 =?us-ascii?Q?9psJwhz4LdyZJGB3KQHvpoDKz0uKEq+BzrqBgXaAydbEoACBylvZcVmjTKgn?=
 =?us-ascii?Q?20FYiNrVlZSj4+MsJUaO6UKocVfHt8RHPvyeRJjhTy5RcglPZOiGJA/WBH3H?=
 =?us-ascii?Q?J5/ZpUtR0mPHvoE6Ih6QA3g3A4lyCfXhMY5W37ybRts/AmZ5S3usPeFyc8E5?=
 =?us-ascii?Q?qtL5rB51wrhfOqOmg35/LOVB+/RSOYVIiqmRiiiZJkChQnIbFf5clGzhBweS?=
 =?us-ascii?Q?q6LFCJ2TmNPlNtUi9T1wGIOoCfGyXiPeMSe9mUTxuwAbPzvJNNT++LS4B6EU?=
 =?us-ascii?Q?uOWFU9mrRfCaQCTGYaaCW/Q2hwrgdKhDzrbHh9ypbVf/+7E7W4dxj8SXQba0?=
 =?us-ascii?Q?R8dIrh/wSWBZkuxNRQxh12x14VkpvHIwfZyyEcY8MUkEaplyuCzaIYaKhUoV?=
 =?us-ascii?Q?h1ZMLqD/UIODMUFiDrfF9GjXfgY57TIZuBKkJFroBEVNcjAtr6sXzLiP3JTC?=
 =?us-ascii?Q?WG5GJ/gC01Qx78uLe4/oH0HEIZYswR6+T8hLrLkrl9jEvvIA9tWNZfUFCMek?=
 =?us-ascii?Q?TM3A1a/bYEunwVy8u/Xth9dF3lwqwblYspiRN6EBHW+bfxlbrpJkUYrWtu9O?=
 =?us-ascii?Q?53FlrLh1T/tA7mz/A2qRcsAUV3rY2FWqw9hE4N/E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d04dcc6-c1b7-4d67-9178-08db1319182f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 08:04:30.5344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PYqqAXPA+sd9hHt/uY5zGEWHDlxYJQfGd4MnJKELAGqScinvwWLpJ5ZUEhvjybtrDyQHDKJmAwpHV5kotH8JyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6457
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Dan Williams <dan.j.williams@intel.com> writes:

[...]

> First up for the fix is release_mem_region_adjustable() needs to
> reliably delete the resource inserted by add_memory_driver_managed().
> That is thwarted by a check for IORESOURCE_SYSRAM that predates the
> dax/kmem driver, from commit:
>
> 65c78784135f ("kernel, resource: check for IORESOURCE_SYSRAM in release_mem_region_adjustable")
>
> That appears to be working around the behavior of HMM's
> "MEMORY_DEVICE_PUBLIC" facility that has since been deleted. With that
> check removed the "System RAM (kmem)" resource gets removed, but
> corruption still occurs occasionally because the "dax" resource is not
> reliably removed.

And re-added in the form of MEMORY_DEVICE_COHERENT, which is pretty
similar. However I can't understand why that commit was needed in the
first place. As mentioned in that commit message "we only call
release_mem_region_adjustable() in __remove_pages if the zone is not
ZONE_DEVICE" anyway, so I don't really understand how this code path
could ever have been exercised. I can't see why it's needed now either,
so for the change to resource.c feel free to add:

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> The dax range information is freed before the device is unregistered, so
> the driver can not reliably recall (another use after free) what it is
> meant to release. Lastly if that use after free got lucky, the driver
> was covering up the leak of "System RAM (kmem)" due to its use of
> release_resource() which detaches, but does not free, child resources.
> The switch to remove_resource() forces remove_memory() to be responsible
> for the deletion of the resource added by add_memory_driver_managed().
>
> Fixes: c2f3011ee697 ("device-dax: add an allocation interface for device-dax instances")
> Cc: <stable@vger.kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/bus.c  |    2 +-
>  drivers/dax/kmem.c |    4 ++--
>  kernel/resource.c  |   14 --------------
>  3 files changed, 3 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> index 012d576004e9..67a64f4c472d 100644
> --- a/drivers/dax/bus.c
> +++ b/drivers/dax/bus.c
> @@ -441,8 +441,8 @@ static void unregister_dev_dax(void *dev)
>  	dev_dbg(dev, "%s\n", __func__);
>  
>  	kill_dev_dax(dev_dax);
> -	free_dev_dax_ranges(dev_dax);
>  	device_del(dev);
> +	free_dev_dax_ranges(dev_dax);
>  	put_device(dev);
>  }
>  
> diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
> index 918d01d3fbaa..7b36db6f1cbd 100644
> --- a/drivers/dax/kmem.c
> +++ b/drivers/dax/kmem.c
> @@ -146,7 +146,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
>  		if (rc) {
>  			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
>  					i, range.start, range.end);
> -			release_resource(res);
> +			remove_resource(res);
>  			kfree(res);
>  			data->res[i] = NULL;
>  			if (mapped)
> @@ -195,7 +195,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
>  
>  		rc = remove_memory(range.start, range_len(&range));
>  		if (rc == 0) {
> -			release_resource(data->res[i]);
> +			remove_resource(data->res[i]);
>  			kfree(data->res[i]);
>  			data->res[i] = NULL;
>  			success++;
> diff --git a/kernel/resource.c b/kernel/resource.c
> index ddbbacb9fb50..b1763b2fd7ef 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -1343,20 +1343,6 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
>  			continue;
>  		}
>  
> -		/*
> -		 * All memory regions added from memory-hotplug path have the
> -		 * flag IORESOURCE_SYSTEM_RAM. If the resource does not have
> -		 * this flag, we know that we are dealing with a resource coming
> -		 * from HMM/devm. HMM/devm use another mechanism to add/release
> -		 * a resource. This goes via devm_request_mem_region and
> -		 * devm_release_mem_region.
> -		 * HMM/devm take care to release their resources when they want,
> -		 * so if we are dealing with them, let us just back off here.
> -		 */
> -		if (!(res->flags & IORESOURCE_SYSRAM)) {
> -			break;
> -		}
> -
>  		if (!(res->flags & IORESOURCE_MEM))
>  			break;
>  

