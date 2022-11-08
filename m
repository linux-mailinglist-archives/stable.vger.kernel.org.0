Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550ED620FC6
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbiKHMFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbiKHME6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:04:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06552F390;
        Tue,  8 Nov 2022 04:04:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WdO5BAj0va9QkUb7l2Lo+2w/iucZVv9ckHc6l8QvPiddnImjehtftnPLFa8+AZUVP14MhVcfDVAf4igyDCVe2BJUZO7MgvsujoE+Oi3RKWDEoBC/wjOXvYkCVVm0Y857sL8SeWcfSKA1m/4cJy8Qg2DpufLEgtcenCFRU/Fgw1WiJxn85JYqGUdrdGs+cICtXORZFX8/JKcTZw3sJzvooLMgeSJKIwj/ddzfI8f9jTly91bDGC0ptr8F5nMcWZyWQ6XzwAmVOSurMfxwTfg2qZDlNBY5r09YRXXTqjr1qq47l6pTcsRkj/KIrwy0+q2FC0OLqENdw0DRiK9VHouOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2PMGZK/njyRDQKGypAy8V+KF6bpuuqtyj/im05XQ0yk=;
 b=Jbil0Jw7drFWdok9rz8B67g7JvKe5FaXbZBqQ6/wVYRWM9J8D/yw9rgnFLNMqkG93CkXXscZ2y8YnwmtpzdCogWRPgubcGiLH/pTAVRQ5FFMMnZwE7PaRtUsIivgTL6VP1m3lzlK7iXe7OUQUh/4RELiL7xrQOjUil/eofHHEXNdUeRRUgnfDGX2iW6s29Gwos3yce+jWG1oBSS+oaISCuz8y2GHUedwxtgGFlTvtiMsD8/1mGcQcCV3whZJvdiFj43urorp9dRcJSPOaU3uqpIZB6S6XVNY3mcU4+BxCAX6QwTEHJnglOeNhw2PRvBW6IfWpnwH9lh67DgmEOg5lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2PMGZK/njyRDQKGypAy8V+KF6bpuuqtyj/im05XQ0yk=;
 b=kh8G5juZLAeQ3D+kws3+++w9sdMAUIqwxiNpMiejWPKJ9IlSj0juh8ddzlyqq4gAUmEwxlo8Skyweio4iBQXv3I2sOg3jDCRCvcggN1Y3k8vtcqONH7/tSZ3wE7jSpSbMeH49PJbcclf4B00KVm5p/lIz89m6la2CGHv/hccYh4FIBA9WNCUI05Y78cLjEw//eSbCpwgR8ozM4dNkU6MC5laG7AQH1W/IDZ8Nvbb4Cv2NpzZdf1QpHmH2B/Td/eLQXoaaMbMQejLZfFP3fIY2Zw0j3VPcCzoCgPi0k8xf6DIuWKSd0cWtLCh/K4ZsuQGQ+2cylT/Q2NfDFeBUXIX1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6942.namprd12.prod.outlook.com (2603:10b6:a03:449::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 12:04:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 12:04:53 +0000
Date:   Tue, 8 Nov 2022 08:04:51 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Qi Zheng <zhengqi.arch@bytedance.com>, dvyukov@google.com,
        willy@infradead.org, akinobu.mita@gmail.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: fix unexpected changes to
 {failslab|fail_page_alloc}.attr
Message-ID: <Y2pF4x4gsKjaHJaE@nvidia.com>
References: <Y2kxrerISWIxQsFO@nvidia.com>
 <20221108035232.87180-1-zhengqi.arch@bytedance.com>
 <65863340-b32f-a2fe-67ae-f1079b19eee4@huawei.com>
 <70dfbac1-4c84-9567-30be-1e2594157e62@bytedance.com>
 <e644e4bf-f1e0-3e22-7773-62f38f9b8963@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e644e4bf-f1e0-3e22-7773-62f38f9b8963@huawei.com>
X-ClientProxiedBy: MN2PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:208:237::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: 44dde958-c91e-4137-aafd-08dac18171c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wvdj4wBghDDivHIviKwerWH+GGJpeiqyLqDVEDRptK/dk8uRAMbyuVyejLMP2opcG5dfvjtQ5vA5Qh4O2qa32BC63JLO+/777QpGpCcIjHXUYjVu3RbwvPgTT32GCZiqEeZTRvFEKq7NWZzCcXXNO68mbux6heFQlAKb1bvoj3f4XTxVn/Do3zigCkQe3Qg6y1sLUWFSSk2Uf52H7Q5W6uaFrxt2rqO1ePB265iBDkvRj8MQkIdLGlfwuEBoTEyU5qRlEvgVTv7mFLgaxjMqWF8rqixdLPyy8Pw7l7oh5hXPkFVByYNHxSH/VU00m5H5aNxVMKsLsQgsiBDOJInBjE9UjIVBuZfv0HKVZ/NKd85/vWUPu8+IBsQXuh+okcIMA0akfj9RDidmColwSJTcZ2ofhW2HleLjyTsH4M8nmUNNdOEc80yU0q2mC8A07uAgBYI6tunCIMzZpUF4NmfgeRlDSYRU2PYCnxNeZXgVPf15gjmORAdeH5UmQN/5w2Hhw/Ew9TOpQh2Gr2MJ5pDlaC2n4T9M1z5sK2NcB4cpz3gICs8gqBxIV9E2oyW23Rji2oZwvYVpeyMGQCd/cezheVPdqRcgGvSEdo8NhRhyKae2cTnVqOxDIFEhVBZX9ku9uj/mlXHO5oirfwO04BliqRedDK5CE19GpQdj9yGHUj2OJo4SMR7Ra/i562inL5TnSeOZHIFzwp/mowUcF3o80w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199015)(6916009)(4326008)(66476007)(66556008)(66946007)(8676002)(316002)(4744005)(8936002)(7416002)(41300700001)(5660300002)(478600001)(6486002)(2906002)(186003)(6512007)(26005)(36756003)(2616005)(6506007)(83380400001)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?keFrh7IbCkuetA82Z5JcnAuo41zAsEReVd8L8PbcqSbMWcmC6Gn511opEEQ8?=
 =?us-ascii?Q?YjY0wjbj4pALz+4alP4Ao4wf9aalRh5Rae6OAQVFvgOntr0o1gDz9qz7KYF1?=
 =?us-ascii?Q?iMavhzeHESAnOtuSN5TqSuFGN2CqpqRSpc+58vXgX/KGaRmRvgJo3uOykLf2?=
 =?us-ascii?Q?Gcl6WOcgGcfbfmyqL+0vwbmRmwf0oTrYTVtIDmEwmqu5j1+77zHLuKBNyUZ6?=
 =?us-ascii?Q?FXPLAIVFTb2yEDFsPPYMXTfvSs+0UJGaIJftV0GMLQWdm0pnmtDjhQTcLJY2?=
 =?us-ascii?Q?Q5fTDVUv1EeWuO7oquCZ/LXPUHPOOZeWf1QXHP86aZxkVHoBJ8mRO10iXptz?=
 =?us-ascii?Q?wMUyxCSJHgk7wCg8ZDOxKkxx0iwaeVNCHdo3e8gz6fZ0oLXpShKEVIVHALBJ?=
 =?us-ascii?Q?GULZ9xl9ME4gBsB7glNR3wsuJaK2frHh6UsGHPYZLI2qMUQivCEagsjcaO3w?=
 =?us-ascii?Q?i8njGF+0jbLqh38YxPizRj4R5j5WBlpU1CLPcpJgWQsjPQ19J6X8uRyYIWh5?=
 =?us-ascii?Q?t8LD4IfZCRa9VLkGeDG8EAkqK8J9F8HmUMksVDjGJyJiusdLywbBXZ/dJq0T?=
 =?us-ascii?Q?Rl5/OzTWMrpotb4OiTI925jS9NwP3LM9lRZh2fnshyO0xDtEP4Vx+mzxlQkr?=
 =?us-ascii?Q?t/kvwK07OB4iNLFtjwWiNXRHdelOHRJuxQLkrzTdjb5PPs/UZR3Hvhvk6dwH?=
 =?us-ascii?Q?z1mjWue12VuPgQ/BF8FOiYxQjwkJNLBpRZ471wecLKnNPvwAvgNQ9bfntyao?=
 =?us-ascii?Q?pPj5h0pByz9/RU+wXpmQV9TVnG7g//hSBargwOqVzEw2foFP6H79GLcohdZd?=
 =?us-ascii?Q?Hbf2XfjDr6OFEdQ2nRP2rEs0hIenWPxhUNV7mjzfzvKBWoqrDhKVnOEOgpx/?=
 =?us-ascii?Q?0PRe5ih90Gc3U8W2A7hnfha6gW+gOFnr47t7WYWzSj3Lb6i6xWSRUpETf0K7?=
 =?us-ascii?Q?y3dx6sE7BBRhtyQLr9jowShyahKthQRz/YNeexV/6JyTPuWzDuP9J8c8Hkdt?=
 =?us-ascii?Q?TwI24jVNn/bVBXSp7DaoYghNDgRJANFzWeJqT/3Ol2CaOs8T5G1eTO/JGjYM?=
 =?us-ascii?Q?bRZQR3TXwNTRT9wcBiBW5gTrV4C8tpSXnbM7DJW/c3PJGyHp7E6EXLeGJf1y?=
 =?us-ascii?Q?yB1SkR8Epfu/nKArkw4BQnw+0KNyISQWgk1socIdzTXr1m8OGFxIHoHVyJBV?=
 =?us-ascii?Q?SyQXxonwQOC/hkACfbl4LRC6BDPxEa7z9yKukKaMXYsx1Ud+Wj39p57TIV84?=
 =?us-ascii?Q?Fi5P3nsp09oCKogWt47k32iNmJFwaipofMl/2KiiF4reD7bsOc/qwzUtVxwz?=
 =?us-ascii?Q?fpGxx04u0ntYsl469YbbL937wqZw4lxYJLCvmm2Ad9bLMsNerYARSfvLYGa0?=
 =?us-ascii?Q?4fe1IA8mQBqknaOHOcH+QBk1VAOB3BHfSH/qLtXaGAnfgxnlBXqtdtWp426J?=
 =?us-ascii?Q?xgXO0HajK/ULvTJJ3wBjwB+k+omDxZOt0AR0oykbiC9HFU+R57GfKITO9htQ?=
 =?us-ascii?Q?Y1UEIRPTqahbRhJzfqDcHg+aUS6Xy8vOVPk5eheMzKCOAzeYkK1mKGtMF8N3?=
 =?us-ascii?Q?WEo1V+UQevjCBqukSyA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44dde958-c91e-4137-aafd-08dac18171c2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 12:04:53.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOtOhtuRWEoFWGB/Ui8BToz2ZOoZjdQvacKMxjzwC3gha8dt1cFL1K5FqRvpNV5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6942
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 08, 2022 at 05:32:52PM +0800, Wei Yongjun wrote:
> > So you want to set/clear this no_warn attr through the procfs or sysfs
> > interface, so that you can easily disable/enable the slab/page fault
> > warning message from the user mode. Right?
> 
> Yes, just like:
> 
> echo 1 > /sys/kernel/debug/failslab/no_warn  #disable message
> echo 0 > /sys/kernel/debug/failslab/no_warn  #enable message

You can already do that:

 echo 0 > /sys/kernel/debug/failslab/verbose  #disable message

Jason
