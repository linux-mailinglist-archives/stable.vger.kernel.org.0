Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D882507D31
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 01:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbiDSXjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 19:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiDSXjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 19:39:39 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93F213CE0;
        Tue, 19 Apr 2022 16:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJ2599NIlixEjY3G2siDUvFyatK4d7xcqJS+j0p6gCy1PamHcNJSIqO/JCIs6+gwiHz/IRw6K8/14f9g5zbbb+q8vumwsMquNph42zSTLlgX631ytIvbbzmLy/S5aE8n95lrAOBwA0vL5EOFcNQQd6V1kFdCNrtTfKCuTPgehjCfMNuTPH10vOnuoZ5cOrjAD3WncmHSBC+gLd7kmR2NeyJopWFH6s8NUHynZeZr5hzpfnsRTsrGgKcBrMqbWWI2vs01kEW62oPqzH2pDKDI3S3QWIwzIdPxifPPskFSu5vnUhg73/+g4PeIlaT9gBtpTz3IbSvbhHk9hhzX6q+FhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t7OgoFQC09eTiC3iazuKUSOwePNgA64hcxixrP+eDAg=;
 b=cIXOA80CnyykgtWcpz86AjHb2ZOUUpuNaK9OJ4l8oK5zA455m3YtscqzcuaS4x0RQDGdt/ltUsGOilNEB3HGJD/MgeNovVIP0ABj9nWUj8/XRWWwMvvlKLEbLPPPGtjw+hjtFRqpF0SWs4Az/B6MgnENHO03zmNzS3tRv4wXyvW/Sq9WenpxaEzM6zfezAr3NZfRWTgWsvXyxFXGfCdn50/Q48DzQRoglGVAzdxBuXFU/tpeX5GJIqpdZXG6sVmCZ9nsPesFk3dFlvY69Bztrt+OjGubUGjoOWQjfJmYwYa2qSgs1GJzMyJanj21uwTGxK/Bu7cPqBnLwsMMSLmRwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t7OgoFQC09eTiC3iazuKUSOwePNgA64hcxixrP+eDAg=;
 b=DM7Te/suwHRAdx7z/t+BcxSSk9NBNL5M23QZyoYqEtqfYdFKVcjgwSZkv0AcxxOSy4m4JcuOnfPsQ+Brr82xDapJ7jLQ5uOWtaX8z0sK6Yn3ZcI2vW/dwAJkQ51GZ72CmrKO9nM/m7cejJ6qFCmbMdwkF1TXRe1qZ5OlFUnIkpNgS9l/3CDxdhVkyEpKff67AXkP+Bdl2+xDR0Hm/jyjnskeo+RbbUI8UWIL+XplYf4t4+TQdM+2kHWNvJYg5WWbRjGNg7KHe1htU3nrcA6jYYeCJjSvQR6vKF7Z05PqJ5qfX9WkA4IUrok3sy5/Ja6K4pUjNSMYixuj5tMtIa+dXw==
Received: from BN9PR03CA0854.namprd03.prod.outlook.com (2603:10b6:408:13d::19)
 by CY4PR12MB1846.namprd12.prod.outlook.com (2603:10b6:903:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Tue, 19 Apr
 2022 23:36:51 +0000
Received: from BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::a5) by BN9PR03CA0854.outlook.office365.com
 (2603:10b6:408:13d::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Tue, 19 Apr 2022 23:36:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT050.mail.protection.outlook.com (10.13.177.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Tue, 19 Apr 2022 23:36:50 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 19 Apr 2022 23:36:49 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 19 Apr 2022 16:36:49 -0700
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22 via Frontend
 Transport; Tue, 19 Apr 2022 16:36:48 -0700
Date:   Tue, 19 Apr 2022 16:36:47 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <jean-philippe@linaro.org>, <jacob.jun.pan@linux.intel.com>,
        <baolu.lu@linux.intel.com>, <fenghua.yu@intel.com>,
        <rikard.falkeborn@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] iommu/arm-smmu-v3: Fix size calculation in
 arm_smmu_mm_invalidate_range()
Message-ID: <Yl9Hj7JlsZZYsB65@Asurada-Nvidia>
References: <20220419210158.21320-1-nicolinc@nvidia.com>
 <20220419231034.GP64706@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220419231034.GP64706@ziepe.ca>
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 951f3f85-a8dd-411b-e1f1-08da225d7aaa
X-MS-TrafficTypeDiagnostic: CY4PR12MB1846:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB18468C7F99AD13271F1BFB7CABF29@CY4PR12MB1846.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2EzUEeeVI8K2qNjeQL4IDmrWNfqgdHdUZ4o+eVUtlhicjeGcMUf82fMYyrnCVxZ68ttoZR30oX/BRLC9J4hORHsizrGxyMnCIhb8ryil2apCNEE3sBGyzfw/wmKao2ebkGAkXBKLS3Tb7QuySS1F0WCqDaJUeQuQU3sOVZ9GS/4iD6ZXAtuceOGeUmunNsxZHtxVZD5ZmZmcj1HTsi+Hegk9XN8PK7njIvx6mzvzl5nZIMx7IRPVHD4fK4UNjD+POanu1y5OJ6sgR9GqDjyLsbj4qrBImBdBFOr/lc8t1To0t6u49YjIrd8eEGAjzaPBwcPOLlrvcz99pYwZKXOD8zpe8wYdOaYl/GzjhvLTfXaU7C7+Aj/DmCAYZcONdj8357/780WmzJqA40ItOtnYZtSBOblinTYzYQL4364qV8iPNF2HRhyfe0Xdq02goUbbxTzDJSPAwveiuOphNQk3lUz+KmIEcPS4cJoErYRXy7Dd/K8wxCS2kOw5BRAXTK3guYPh2mdKr3DgIV23no0KQlEIas2WX5B7ff2PjRaHzLf8/xwc4m8HDBl8EaFcMaCznV5jic1qqJz58ShiUv8UxdWiUdvpUQ0j+Gqno85Q54z3eIj9xaBhjv6inoMd64cRx2XdfRJNUYFyNKlKQSc2pO7X5fuzH/o+LAXDU9WtEhvSf0nQvbFrLvVxXf5WD5wuS9ViXZpFlzKVyHLMwq38UQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(47076005)(40460700003)(70586007)(70206006)(86362001)(33716001)(55016003)(426003)(26005)(4744005)(186003)(316002)(356005)(36860700001)(54906003)(8676002)(5660300002)(6916009)(7416002)(4326008)(508600001)(8936002)(81166007)(82310400005)(9686003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 23:36:50.9950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 951f3f85-a8dd-411b-e1f1-08da225d7aaa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT050.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1846
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 08:10:34PM -0300, Jason Gunthorpe wrote:

> > -     size_t size = end - start + 1;
> > +     size_t size;
> > +
> > +     /*
> > +      * The mm_types defines vm_end as the first byte after the end address,
> > +      * different from IOMMU subsystem using the last address of an address
> > +      * range. So do a simple translation here by calculating size correctly.
> > +      */
> > +     size = end - start;
> 
> I would skip the comment though

It's a bit of highlight here to help us remember in the future,
per Robin's comments at my previous patch.

Thanks!
Nic
