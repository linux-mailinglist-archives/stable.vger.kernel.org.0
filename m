Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870C768B538
	for <lists+stable@lfdr.de>; Mon,  6 Feb 2023 06:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbjBFFgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Feb 2023 00:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBFFgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Feb 2023 00:36:22 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9D313505;
        Sun,  5 Feb 2023 21:36:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLrDwKwN09Mhgo0TdHMTxk7bBiUxWHbcRaGzTigo2dW9IqkwSubuELVydvNx3dht7bBLN370UyHv4ADFVuDzYa7NngMZ0fYwFxBWy02FXg3hlevnbRJnvxh7QhClXh1oHZBvTwunvw4FaAFh2ZD6QvqZDZetgeDn3nqdSJuMG9WKfqKltCFd/MJXbEOoYld2kr1frl4H+kfuZK+EZhRwZt6X2Mw4C6NdRrMGTL9wBRvmPohFMFwI7BUoT3lHmNQiXHluZ0ARGlhxSJcF5zaOKf5J5YiVc7fvIH37EOxSGdVWN9YUQh12CY/f/YAT66Y3xsft671hnoPFY+DvCbj6pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WsM7JvlC/zMzDriuXrYOdZgXx1EBKJa57f/4bkCcKYU=;
 b=AXEZQoRQRYs3TUu61uAytURhqyiW5Xk/bh650GxIbda/hBpZvrfxDgDalsiPVWzM8Kt5KPCIg38H+odIlXMyocnqOJRWvPMw8J71/prhClfjaVOZ6cbfQ9gUyN601ilGI7vByZe+1N30K78MZt+qelG24MvzP3GKDT56+etEffXsvAm+6c/ykbVwlV0GFzWZvD98eFl9Czba/A5M45o25Tn2HqGaFdp/dn1taM/jxGk/VxQfnDIudZl3p55xg/A7u7j20r/XU7CSwi2tdtVzZwS6KUMTIDR8CmvkgYBspDovnRJv4QZykqwsfZbOtAC89gj+1Xq9dzCnKOBD2vsTKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=memverge.com; dmarc=pass action=none header.from=memverge.com;
 dkim=pass header.d=memverge.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=memverge.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WsM7JvlC/zMzDriuXrYOdZgXx1EBKJa57f/4bkCcKYU=;
 b=AigUQfNl4gIqFvNghFHlWPCfMy+hiJkp6DbMUJIyCHs8+We+4pB+QyF5PV+JPtPM2eUKSz2ZsHV0iR9mTwjkDEUQabuks1tw+Y9QfIuhVhGdh7WVxajAAGlH8RwbBF9O9LSkdq9hWVmb2nFbv+Unhijk0hdl7hYnsPOStMavwT8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=memverge.com;
Received: from BN6PR17MB3121.namprd17.prod.outlook.com (2603:10b6:405:7c::19)
 by SJ0PR17MB5005.namprd17.prod.outlook.com (2603:10b6:a03:303::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 05:36:17 +0000
Received: from BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660]) by BN6PR17MB3121.namprd17.prod.outlook.com
 ([fe80::d253:1eb3:9347:c660%4]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 05:36:17 +0000
Date:   Mon, 6 Feb 2023 00:36:11 -0500
From:   Gregory Price <gregory.price@memverge.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     linux-cxl@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/18] CXL RAM and the 'Soft Reserved' => 'System RAM'
 default
Message-ID: <Y+CRyz0eFKfERZLD@memverge.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To BN6PR17MB3121.namprd17.prod.outlook.com
 (2603:10b6:405:7c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR17MB3121:EE_|SJ0PR17MB5005:EE_
X-MS-Office365-Filtering-Correlation-Id: b506b5f1-6302-4654-f454-08db08041178
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyvZiPCCYJCBVxJbRcd05ZoW3Tg/FiwUnRvRR8QyTt36sI7QxRuZlhCerElC3wYVGf3xXqz+4g9kzPDyQdqK/9U4N1+eD9FH7Kd+fELUdEDLF6xeYW1iee+aZqjVToP2sWUtO7MZnx11UtG8I7fHzyruzneyPTbOFuD0WIPkWbtpkJCJkbV+XrRF5yAzHoNH4uxWp7svLPVT1mhYy++//X5yXtcBIR7itytMJZh3wYepRUW8mMgEcaQ3K/eQJ8OdmEVsnh62INNgMTo7tqXbfn8HBc5qgDjCvJnrbZnoY8HwSozmXvDoJoF/gaZ6umtv4DXQzdMyjh/U5N7bccYPYa3XzVNbYU6Q5WeZplyTrX5rl6jCrSqnTw4HPVaHGqhSUlpY7coLr2obZxemNlFc70c8zkXbBU9CdshKoXrpmDLDBAW6UCv0DDZYOz5lcsmUJXGcqlBFz2PT2MH0fNlP5WYYZgQUcA2zMPgkImbysqnodQjyDuNbC3eq5t6pAMAeS273hDaI8JYRdmh+H7CANg4g6mYKyiiiloZWpOMHOOKinz01mxhM8KFV1Q7HU7/JLayjH/KAU36tlG72lnJOV6nEOwdD0XYfga7kUb+/Xq0FJxffKpuJmGoJrLUE0tNn99KrRCkiVlBJJw/YfGEnbV0NGhPJEHwDgX2h6XNJyzZUPzo2r0Ix1zkgSJ6ielLW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR17MB3121.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39830400003)(346002)(376002)(136003)(451199018)(86362001)(36756003)(38100700002)(45080400002)(316002)(2906002)(54906003)(478600001)(6486002)(41300700001)(8936002)(44832011)(6506007)(66946007)(66556008)(5660300002)(8676002)(6916009)(4326008)(6666004)(83380400001)(66476007)(6512007)(186003)(26005)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9eK8MOciuyOi8aHJhj3+/yL1jQGM5LBsEpv61/kf+kKVFK4q0SPq3dTyArEh?=
 =?us-ascii?Q?svOQ6mrJENlX9G06jxgT4TUpE/QSizR7NOiNnB+C2CUyzTxLGt4GUQ+t67o6?=
 =?us-ascii?Q?8hZXGIJL3Hu28VMswRTx1adIJQjOH6okhsm1O8tYGiqhY7zFQHEj8jw6x2/d?=
 =?us-ascii?Q?VTF6LDWbPiFMjITrTMn3BvLJmphNnltyRjtjT3qkdo7FxX6eCf9S8Lor1kIQ?=
 =?us-ascii?Q?iQjYn8j1WzCPau/vl/TK64Fw1mKO/nYC6RWSZVI0bqaHY4wroRhwbnEeMiAb?=
 =?us-ascii?Q?ws+wFyQobNWqcl/Tjxo9LZUIvAaHl2JJJ/dpScSGE1BFaCR9igWDVKrnG1TM?=
 =?us-ascii?Q?dDJswNY3fR1ajMiKmLHjR5JT7tv3p5sd5xP/8KFq+m0X4yzqCON01akWJRiT?=
 =?us-ascii?Q?5xpI+waMuAJBkpDwUJeS8wX2WtCg/GYbrZ6ZoDpIU82Af7Tm8QutLLbZLdDb?=
 =?us-ascii?Q?PnjQoo73bSm6ZN8OaWyhBUN/tebrLK+gvy4ri7Sbfa0Km+5YsIJBf9YuPm3J?=
 =?us-ascii?Q?ji+6gKHkZSCnYwqZfQGyn3eV8fZ/zGtFtdVr5BdJdk75gGAInghr8wIkMUDZ?=
 =?us-ascii?Q?7cGE4eCxfSVKvAXyLJRGjG9D0LVILsPs7VW2kvlhLZi6EuJSSkz89HEb2Hws?=
 =?us-ascii?Q?9u/S2t0UQo7tXMMftIDcTqa3fL+dh/VwRfaY6eJKXFL2acbWbSjWsHWu2NeT?=
 =?us-ascii?Q?7nvGaRsoT8aw+BPCurhxSNaT9nzydrRWB/koXrmnBH34wvSNOLD9A/k1qL8n?=
 =?us-ascii?Q?2/BkZgw7W7GNm2cZcTbANTV+YnCEX6dhp8dX/OMwHLoFrON+KGDsbJ1qerqj?=
 =?us-ascii?Q?ZYGBM5wkOly8kPN1pnW9tbPT3S7Wej6Fm39vwfe/f1erG3GXVXfL9UkYBMW4?=
 =?us-ascii?Q?GvIzQRKrlPkZNpaZEjSh+De5K7y4yJOt46y6l2cgT0gpzMPdPwEdFqE5Fi3D?=
 =?us-ascii?Q?RifNeRkggr3k1egpR9MN052cbtzRhzoS3jPgAWjea9DwdEZh/zYQLVP5o9zy?=
 =?us-ascii?Q?03xk25l0gI09HNjvPbMdhh1jcJprC2GHrphrKup9dXgQiyDEgvfhP6D7D7Ym?=
 =?us-ascii?Q?42/qlUi+W0jKAwp+sPtuANl8LdZQWcwWvOv/CXNz5zbh7xbVBj4DtDO5ofJa?=
 =?us-ascii?Q?MzmFnNjrStHu6EF4IiJNhniL/bT/gGzwNNDgdYYIbLJpS262AAnB7JCAjayc?=
 =?us-ascii?Q?GMAhzML5GcHs7+tekYQfDnLr4zfcMl2y3F1LTkU8zznOh8EoY5H1HYq1+AbK?=
 =?us-ascii?Q?zW75L+FT0RJyaEvyDvlBBiMf6XXE1sA2A5USI6F9cqgtSzhDVIpkuDTMu/Y1?=
 =?us-ascii?Q?zlgb9aEcfOOsKFxTCzAAfeBAQ+FV74R6fw/ehMq4KJAIyMXcqUNmT/fCC8um?=
 =?us-ascii?Q?9eDlo/gWrvWGaKJNMtN+XW9qjzlXBn7XSBEFCqy3+xAQ/hjA/oUlpmjtjXAn?=
 =?us-ascii?Q?MgJmOsLdtGmeN8LOWGNhMSjNTB/e2VnmeuFpB6hn6hkpatVCArbQzVdo6npt?=
 =?us-ascii?Q?MEJjDuC6b6qalvrh3bZbcgzDIHVHcbkvjxiKFdfL52HB/kxq9E20SEC6G/YF?=
 =?us-ascii?Q?IjBkLF4fmJUi0y1nchtxz984Cnx6+gTv9NEToV1jgy68vjeogeHpFx578PQ5?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: memverge.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b506b5f1-6302-4654-f454-08db08041178
X-MS-Exchange-CrossTenant-AuthSource: BN6PR17MB3121.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 05:36:17.1275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5c90cb59-37e7-4c81-9c07-00473d5fb682
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bE+39649Ugpq5AeDhETZXQsOs6+AvlRR8Wv91kk7VyneJZnNmN5dDnke10py3e0LESxt0lK3A9zpkx1uEiL0NkOWk5RP2gA3fdUmdk8tiEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR17MB5005
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 05, 2023 at 05:02:29PM -0800, Dan Williams wrote:
> Summary:
> --------
> 
> CXL RAM support allows for the dynamic provisioning of new CXL RAM
> regions, and more routinely, assembling a region from an existing
> configuration established by platform-firmware. The latter is motivated
> by CXL memory RAS (Reliability, Availability and Serviceability)
> support, that requires associating device events with System Physical
> Address ranges and vice versa.
> 
> The 'Soft Reserved' policy rework arranges for performance
> differentiated memory like CXL attached DRAM, or high-bandwidth memory,
> to be designated for 'System RAM' by default, rather than the device-dax
> dedicated access mode. That current device-dax default is confusing and
> surprising for the Pareto of users that do not expect memory to be
> quarantined for dedicated access by default. Most users expect all
> 'System RAM'-capable memory to show up in FREE(1).

Leverage the same QEMU branch, machine, and configuration as my prior
tests, i'm now experiencing a kernel panic on boot.  Will debug a bit
in the morning, but here is the stack trace i'm seeing

Saw this in both 1 and 2 root port configurations

(note: I also have the region reset issue previously discussed on top of
your branch).  

QEMU configuration:

sudo /opt/qemu-cxl/bin/qemu-system-x86_64 \
-drive file=/var/lib/libvirt/images/cxl.qcow2,format=qcow2,index=0,media=disk,id=hd \
-m 2G,slots=4,maxmem=4G \
-smp 4 \
-machine type=q35,accel=kvm,cxl=on \
-enable-kvm \
-nographic \
-device pxb-cxl,id=cxl.0,bus=pcie.0,bus_nr=52 \
-device cxl-rp,id=rp0,bus=cxl.0,chassis=0,port=0,slot=0 \
-object memory-backend-file,id=mem0,mem-path=/tmp/mem0,size=1G,share=true \
-device cxl-type3,bus=rp0,volatile-memdev=mem0,id=cxl-mem0 \
-M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=1G

[   13.936817] Call Trace:
[   13.970691]  <TASK>
[   13.990690]  device_add+0x39d/0x9a0
[   14.024690]  ? kobject_set_name_vargs+0x6d/0x90
[   14.066690]  ? dev_set_name+0x4b/0x60
[   14.090691]  devm_cxl_add_port+0x29a/0x4d0
[   14.135946]  cxl_acpi_probe+0xd9/0x2f0
[   14.167691]  ? device_pm_check_callbacks+0x36/0x100
[   14.203691]  platform_probe+0x44/0x90
[   14.247691]  really_probe+0xde/0x380
[   14.277690]  ? pm_runtime_barrier+0x50/0x90
[   14.324693]  __driver_probe_device+0x78/0x170
[   14.356694]  driver_probe_device+0x1f/0x90
[   14.396692]  __driver_attach+0xce/0x1c0
[   14.435691]  ? __pfx___driver_attach+0x10/0x10
[   14.471692]  bus_for_each_dev+0x73/0xa0
[   14.508693]  bus_add_driver+0x1ae/0x200
[   14.551691]  driver_register+0x89/0xe0
[   14.587691]  ? __pfx_cxl_acpi_init+0x10/0x10
[   14.625690]  do_one_initcall+0x59/0x230
[   14.814691]  kernel_init_freeable+0x204/0x24e
[   14.846710]  ? __pfx_kernel_init+0x10/0x10
[   14.899692]  kernel_init+0x16/0x140
[   14.954691]  ret_from_fork+0x2c/0x50
[   14.986692]  </TASK>
[   15.023689] Modules linked in:
[   15.057693] CR2: 0000000000000060
[   15.105691] ---[ end trace 0000000000000000 ]---
[   15.162837] RIP: 0010:bus_add_device+0x5b/0x150
[   15.217693] Code: 49 8b 74 24 20 48 89 df e8 92 88 ff ff 89 c5 85 c0 75 3b 48 8b 53 50 48 85 d2 75 03 48 8b 13 49 8b 84 24 a8 00 00 00 48 89 0
[   15.427859] RSP: 0000:ffffbd2a40013bc0 EFLAGS: 00010246
[   15.475692] RAX: 0000000000000000 RBX: ffff955c419e1800 RCX: 0000000000000000
[   15.591691] RDX: ffff955c41921778 RSI: ffff955c419e1800 RDI: ffff955c419e1800
[   15.703693] RBP: 0000000000000000 R08: 0000000000000228 R09: ffff955c4119e550
[   15.802711] R10: ffff955c414bedc8 R11: 0000000000000000 R12: ffffffff9e259d60
[   15.907692] R13: ffffffff9d3cee40 R14: ffff955c419e1800 R15: ffff955c41f06010
[   15.983693] FS:  0000000000000000(0000) GS:ffff955cbdd00000(0000) knlGS:0000000000000000
[   16.126698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.206694] CR2: 0000000000000060 CR3: 0000000036010000 CR4: 00000000000006e0
[   16.347694] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
[   16.348686] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---
