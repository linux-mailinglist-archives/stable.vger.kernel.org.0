Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF17A61F388
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 13:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiKGMms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 07:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbiKGMmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 07:42:47 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2070.outbound.protection.outlook.com [40.107.92.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504261B9C1;
        Mon,  7 Nov 2022 04:42:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QS1ElGTqlrEg1Q+nDsTzcvPoct4C1nrMG9qyZdgosE+P8HcnzfChBnxK+gZTMuNc8ccneBe3QvmJF/DTNGjV7epzwgy+pd5rA1dk7NuAVBw29by+TtUyEk/9CXZveb4CW3mf5UXTe/IS3RltjaGQFx9yW9ISUIiCKbsba0SXlNcY3rcTdp7LHYRYXRsEJ8+HP/iWWMC9V+OiRXlZ1NRYf+2YW8Vsstei2phzeXmteNB6KnmSROfMIJQS9EJd3LSsBy4g4E+DYPBnXtxgNMWwcIsJR5K+HhmG5VhH4VZRX1A9NPPKG/+x261P47UxjE2XBHOF3OT4nC5Q25qW64zAew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I1djnWP+YLdl5ZAr84eyFvFmtgcor4LgWZeqpKGewWU=;
 b=HKYCe08BqWbTiAQ+pNFW0rO/49+SPy3nyj06b2S36OJmaC8y34DwY5ScLl78EMaihdd9LLUdQo+PAiKnsaZbzKeqSbx0g3CXswyfd16/Lpt6yG/M9mDJoPwwVI9GJXVjtHf/o1fK5Cbofg1ZdUCodHFEUo8gCvRWYYiir526AiJsyd3AqpyA3Xdjif4zm8MiZq3CR8ItgcgGsKZYjo8me+ZN7lDOoB+DfH+AlPRcQTNKnqXpzq5r9I+7n8cr4QryK1s+L9ugAXoCrHLWRTsUzWH2V+ntSh5TeMJenTZkWUh9B2pn2cii3CwryPamqNeiAHVProeWl8trLutJ6Mccog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1djnWP+YLdl5ZAr84eyFvFmtgcor4LgWZeqpKGewWU=;
 b=IGa6KksDndXnEl4cv65ITa3LQbaKA8Co6Ij0z/EHSyAbwv4CtgGIntmyejSk3tw+Tp6Uo8DfSPYlRQuq6FeLRHiQwMLx6QSD3eY8HV/Ti8hTdUfe90K0maElEDw0SonelOuO8Tc1gNIPxMy+vTUUkah+Z24Cco6I2outFtz7iXIMcsBOGogdBrjbBfy58cC/nqIqm40GPjoEfuBWjIVe/ymGQKnYWCZoR/vBCGG7zeFTvOqrjqKzylAhnxhRyub1iNprT+gvcjnyoEsq7xpjbNRAgLFIvkgzFw7eNWQVTPca0ldpeQGGrtQ/1Cv24OLo2tOTK/eAS1HzeirZHGOB3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7131.namprd12.prod.outlook.com (2603:10b6:806:2a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 12:42:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 12:42:44 +0000
Date:   Mon, 7 Nov 2022 08:42:43 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     dvyukov@google.com, willy@infradead.org, akinobu.mita@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Message-ID: <Y2j9Q/yMmqgPPUoO@nvidia.com>
References: <CACT4Y+Zc21Aj+5KjeTEsvOysJGHRYDSKgu_+_xN1LUYfG_H0sg@mail.gmail.com>
 <20221107033109.59709-1-zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107033109.59709-1-zhengqi.arch@bytedance.com>
X-ClientProxiedBy: BL0PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:207:3c::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7131:EE_
X-MS-Office365-Filtering-Correlation-Id: 228dba4f-4354-4fbc-de88-08dac0bd912a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aNSfkMMrnZGHvS11H1FLT0HVRw5AgXJi7evQhvCfkGFzJNrmjrwxQ9feJ7vtHka41PnXfsgpEd4K2opOlGzYmsnLj08Ni9rfgOxrSxx6YiwT4PuMZENg5DNpLU7sOlVvAwqFiFZRbA4eYgSrnNGyOZsoQJTsVptR02nPBRU7Rs33zXW1ba4nQQ0BckaiO99+gWWlpWUMyfTqAIF3rhIj0R9jRyTZLI5kNVFwNVUvxV/lF64N5T0jLwLXu2kPN26OnwR1AIjSe6ZydkIa3Kz1VyahxtIFRI9xGP4fX7sd0gxjWVnP+LNvCWBBoF9kyLjW4k6p3vIP/Nkx5TklNQ6iaoRM7Id49sSeH5H8F2pyzwJ/dcV1oMe9yl5GrbHfETc4IABddJnhmjTAFVcPWz8bYxlGIufNtgLLhSa4PWTgKKbGvYOtRx3jMGA59y1yWgZMzhTQP7qxBlKeRqz6XT18/UNwwDT+C0IfkCInUP4gBr55/YvzkdrNPN/N9kwZP96f9b9H33x+j3RGV/aNDiagZ2R3RD8DYn7DH0qcUEi/EEe9i7tp5Y9EYUzFGxaZe4C25TQ8GEiN+kQOC3Iva62DN/uT03GIY1zM8CYAS8vVncUBP7+yOR527b9Ap00r2lsqQWdcq55UTkVngIKRdEvdNY/zE2oDsoboB/CtIgQzYXhlRZo5bAlHJd17PvSuga154cGyXCHGgVVahmvn7JXiTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(36756003)(86362001)(66476007)(186003)(66556008)(66946007)(316002)(6916009)(8676002)(2616005)(83380400001)(4326008)(41300700001)(6512007)(6506007)(26005)(478600001)(6486002)(38100700002)(5660300002)(4744005)(8936002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hay6GTfL00OxAGzM7EHNT3MeAx+NmoQfAFXTF4fPtgQS3DCYkSbyKGdlo5cK?=
 =?us-ascii?Q?g/kBkZyCvXk8UCVXldJbVoDg+ZUllw+NeoQmxK5eu59LnLGwQLfzoQQX1F6i?=
 =?us-ascii?Q?ltsQVnyFDCx4SdTn2VnaTy0Lw0m89GiG80F8JAs/jWaHQwKHJLQpu4Bx8JRS?=
 =?us-ascii?Q?MQF6LvSxPjHeW57DBegJQcIs+S1ZtaETS5GTxNS+d1IIIzUgUvbUZYVAkhs0?=
 =?us-ascii?Q?2XqZmRRJ+sLDJgkPzvQ8iAcFhZqWScPn1n9AOUeYhWn7tfhcqbYDcgPW/DRC?=
 =?us-ascii?Q?BTkhvFEDi3PYx5Lk8oyU7qoG0Z0k8FMqgrPS+2WiA7NZmBPLIoNbjnYW6//N?=
 =?us-ascii?Q?ktz47f0NyDIQWkRQB1pCO5u9yaA/V7vS/Jiic0o/UUh4qsklp5Tu4f4dmsuZ?=
 =?us-ascii?Q?IBOMnDTRjFjB07MCk+2GFZ6PGKiGORdZc6DUhc4qaP8MwilkryP96aW5LcDR?=
 =?us-ascii?Q?+yh+KN7oySBQvcr/ZdU8LJelkc89EJm2n9UyOoacmXMcJxaxcGPDQFA2TDE0?=
 =?us-ascii?Q?++HkI02tdjdcFzv7grr5Bm4WHJDOmWx3ufxDISYc1Ey3VMbxmH9/bmwK0P6m?=
 =?us-ascii?Q?vHzdGlGRzQcvVit/9eVgdOjgB7P3CnXaX97SFjfPsi9HUtvrz6QrCZ8tWYS1?=
 =?us-ascii?Q?FXGOJGx0jxeWfSdJGSeBIsuu/Bk+1d3CbCURcUSbA6hjkTmZRP1CHLyNy2lX?=
 =?us-ascii?Q?crekpV4jE42FqDJvJWXFGzWLyWvVe8Bt7QeF2HZ1X2++2r1ZdZmvmwhGbomU?=
 =?us-ascii?Q?Om2BVJ6zgxUeBPTjsKlQkXQlkG16Mjb3mGVBvas6DHu8vaeqnckvxKiYXYla?=
 =?us-ascii?Q?tix433txluPlSH8PS6FsYC3rgGTkexPm/oypvn+D1JMlsMhbUQ08wGeB3RX9?=
 =?us-ascii?Q?n0v5cymF6QeqLmMWW0F8bomXk3sYp6/rhW+ME7VmR/NRsBGct+CI5eiE5UyY?=
 =?us-ascii?Q?gXn1W6zux3HAPoGjqBg5gfoyvvDo+nZL8DAvw/nh77cw7+3TPu3nRXiXmTxv?=
 =?us-ascii?Q?FxeMC0bTCKJsni65KkDHGEe+W1vHZw3E/AVDWLE39YPlBES9/pFtdNRzBjr2?=
 =?us-ascii?Q?NDz2PWY0roK6QxIzhfSOwkyVjMK2ZMPySmm18TGXYyJxAUi1E3lgncc5wIrp?=
 =?us-ascii?Q?djIGmLZXa96/KXtbQWCgDhUAWCP6dUdPjc8/8pEvaYvfalK4fC1pgp5ywlF9?=
 =?us-ascii?Q?6YEM/XbmI/qRprB0+lccocmv+J7tlzhaZXUElMDpB3RqrCz43fS0vTt+DJQy?=
 =?us-ascii?Q?Luq9RUz0uuMXP+eMVipluAlIIO9XX0uHboK7miwzi4a81juHxti/AFSFibaf?=
 =?us-ascii?Q?eH9NIHN9w/uvdUPw/nxk9aFkn/aV+TY3mLZ2qo9kRvy+fqlo2x6YVU33YMIu?=
 =?us-ascii?Q?GnkOnVVnzF0EUxWxEFtqWpvpIK8x+K5C2WqtUP/HCa5PaxNVVNK0G8zZp/Ms?=
 =?us-ascii?Q?znocwVTWoOg7I1sxgT6zgkeX/XPOdTlxBnShhHK8XdmR7ajkhmd6gt0EbW6V?=
 =?us-ascii?Q?p5ZkYjtTzIn39MO4whVsK8s2R+8h7omPlGyOiMmwkPJW6OdMlqkiFVtDZAYz?=
 =?us-ascii?Q?YcmU8Mke5my+Rwdrw9c=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228dba4f-4354-4fbc-de88-08dac0bd912a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 12:42:44.4922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kV2g1/uJ17WaYw6bd4tcY5uURIJ+cJjSsjxRJxKUQ1Xwv/CVXI9rR1KU5TULk+oR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 11:31:09AM +0800, Qi Zheng wrote:

> @@ -31,9 +33,9 @@ bool __should_failslab(struct kmem_cache *s, gfp_t gfpflags)
>  		return false;
>  
>  	if (gfpflags & __GFP_NOWARN)
> -		failslab.attr.no_warn = true;
> +		flags |= FAULT_NOWARN;

You should add a comment here about why this is required, to avoid
deadlocking printk

Jason
