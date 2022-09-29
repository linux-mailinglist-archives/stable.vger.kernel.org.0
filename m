Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D75EFC35
	for <lists+stable@lfdr.de>; Thu, 29 Sep 2022 19:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiI2Rsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 13:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiI2Rsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 13:48:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10890127576
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 10:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jniwYJql96CHuO/dxBHnVTE8NZ6cuAMmUUuNcnEzGai3EVU1KXkJpAWvFNrfiykLaksU7xcUkXVbsjGWsW9UUI6wDTxY/4t21bAcWYSaGuWPxjiks79EVYmi7PraF6hcqBdmBQ1IqoG2IH0Kme4hxz9EU9OaEqganPWumAmjJ8cehzcOUBgNBI1MojYFEcoRP9TTAnngbXUi5pUvgccYWbCcqlePxbS8Cxl7pO5/WNBJobPwSKmjeB9j3KRlxX3IvZWSez9VUFS/Pdj5Q8mg16PVeQqaFykKk+GdJwk+1lrr4Ev2rGrxk4WvqzbKgPS+sNdR0UhYX6AZY9Ytn+GODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NZ49kMbkx9+7MvDNXJLfcwMJ8RO/oZuHo9ve8U1phQ=;
 b=d5tMrAqHAD2Zz1YetlsHnmwhpb+Y5r74fSEOJFAgTNwIM9x9dEJQS0eRFJXI5CLr+wD1SIATEwQEdOBjcyyvk6dzEPZ3jaHZ88+N2am+Hb3CKUvBrrezPvJsyc4DnZ8U5Cy64vnBJbFH1Pc3Eo7Q4JGhT1NlY3vXrQMAh+iftVMe5fEFYNoVlwBP0kRzJOg8lhl3omRv9G1O9we3I+zORrsmFZg/G2qrK5zzrkxlrVK7DWiIXl8jdu1Q+kF1RiKFqyyc0IWsex64kGu4lYfEPXl7yL4+/C6QqCL5BxNgcKlqBa/OmdlvUe3PTLmfW9NNKCreLNz3leWTWuYy7Iy0Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NZ49kMbkx9+7MvDNXJLfcwMJ8RO/oZuHo9ve8U1phQ=;
 b=RDR1H9TAKcnuXEqsgBmYKn/aD9ElFV31mn/WigKIfXCNdv+HXnK4SLjUZByMQvel8hqmyW6crCXpUVLzAxGiYSdaFUTDoYXujQjs/ZvC4TCLi3+MtqVQUd5kUfHaBjmQxSkb45kzRbNTJk6b8JTfOZv8bb3XNR+C2OH12XJei93A/R99vZJd1WZyu7FDnGz7YiMaL5EwGc4xN9UI8zFP9DJa+h2mSGY5XG/qpeqOecX70xeQpEhloKZ1OfzkqupsyOnlUNhtMqYJXBZiZEu8G4SgXtK+MJ9QjKwbbatmngo9REnd5blIrLhSVqsK033eKxkw1stgvsZurC4UTN/Njg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4917.namprd12.prod.outlook.com (2603:10b6:a03:1d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.22; Thu, 29 Sep
 2022 17:48:36 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 17:48:36 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: [PATCH] drm/i915/gvt: Add missing vfio_unregister_group_dev() call
Date:   Thu, 29 Sep 2022 14:48:35 -0300
Message-Id: <0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:208:239::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BY5PR12MB4917:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d28af9-3c15-4a81-2b7a-08daa242d5c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ELWvopIyPN8DfwltgwiAtdmPuXK+EqlTl7rKl4+6ird4van3WOxekZbat54gbLFslVRln8amq5am9LkwuI+sx07uXMTTqnr7UPJzMbR4FGRlgYCansZ0EofXUL5jRtnJp2UQTtkHYLhzyl9rQtPOEDlYNlSjCawwPFYkQGiX26mi5+EojX4x2j8f5PXN9YeRNBXOUBfxx+6WcQhkDKncvq6rd3M6eeLvBDjzEffwjW0LWvWrSZ38uec+iX7fh6CNNxB2KFQogtf4B6ZGHnPVv/8d6fnO/Br3OaeYuDK1l75NAGJvmo+Sk5Ciw5kJ3KOFd9CJ/0SByO1C03n+6AM+eZIroZzgPnuuIlNXbV4gc5WooIchnKV+P4aO5tuq3NM6YQ9UPHZdh42wdO9FDoSR6RemiTQ59qXFIuk2+QcoA4aQIA6jWCDmnfn6xMMef1PEi5S94oiSZWJ3JDn88Zck6xNXMQ/5Y1zmYeg1TLUw4M5GUxfoAkNNhYaCURxi5YqqGKxsCbjvfaNGl9cGvEMxb+5T0OJcr8+1/SUXa9DjOZTDjZg4oDDDamlEfB/UZDalHsRxRgmc7AyXxF5/KHtHSpL/SyCZKknwqBj3qJFc7zVXPUiAwYNihNes177AsDNBdCCScN5+Z56kxwZqrlj3wbQw2G8SLVwK1fBTrkqZeaq9XP5WU4pdeltf53RxOPXzdKSCwxraSCNC4QgjUydaGbGQNGn3hcytAjx9ogLCQVVGVWcqP0+Lk2eupgEdb85Z9JTAyHBp9BeC/ZNR2to0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(6506007)(26005)(186003)(2616005)(6512007)(66476007)(66556008)(66946007)(8676002)(6486002)(36756003)(5660300002)(4326008)(478600001)(38100700002)(7416002)(41300700001)(921005)(86362001)(8936002)(2906002)(110136005)(54906003)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FAqrU4fV0dy6fFhF9xj1YrhoouzBknw2+vQ4KxdgKwbwVmvxVsDp6+vKlkN8?=
 =?us-ascii?Q?r5LMdJnjIpY/TaKGUb7gXOxCMJ/3U9lMN84OIvTQdxscAgMPxDHYYj+tXwdh?=
 =?us-ascii?Q?kHcNVsmZBGeAsBV0H5IkImMtNaAW2/zBOPA9WsyeNRy1Y3bhqcCnN3qbh18H?=
 =?us-ascii?Q?STYUrfwmbN/rH4HXRPITi0dttCsjvcKRs0vj2OvPVsv3epfVdyVLrGUJu4KE?=
 =?us-ascii?Q?jNnoY3KQxnS5qBV4Ph6k3tm1njV2FrrDN3Gl4SxfTYXCL7APpYaRGhbtZ0zA?=
 =?us-ascii?Q?yPN47EO+DK52fPrTFNGi8zkbmu2tLY05AXCTncC6fD87ceWJruKaIGQ6+G5v?=
 =?us-ascii?Q?qqq3dIaxM3z8hsm3gI7MXfu8QApLTQShe563zHyPJzWNs9GXZCLCsjeOTBmJ?=
 =?us-ascii?Q?usc/Dg8hIkRYP2Os8Z2C8dF3Gsx+Zq4ssQXM4GCVaKzoNI83iCJItZ5bbWzV?=
 =?us-ascii?Q?19IEUsLaKoR+KxDNYdS/Jhfb3W5ESe/HIBGqDMQXSmGdf43fPRYJPv8HhLyY?=
 =?us-ascii?Q?/MKOjeF44QsRQo/yK4GaaeopvNYdtKEsGEYc6IVEVA+Xg7EUuu7UH2jnJ/SP?=
 =?us-ascii?Q?dUDzjenl6tRTH0O6p50N6qtsFFwt3yHP/HoCidCRpAs+aBYmxKcMepXxcWzc?=
 =?us-ascii?Q?lSJzQ6wYZfy8Tbaxa2LBvswLFgJEWosn3TrbE5qry1C58cj+vjVL7gAkh0Ll?=
 =?us-ascii?Q?3yX2ftnFCjIgLKJYYNK4Y40KKZdjEe6kHUoCQ/XyMKJO+I3ZixvAUPt3oxQV?=
 =?us-ascii?Q?UJcYZzqvRAVdR4VEiAnCjRSHrBAT9qFgST8h02ccmOpo12BT6UGN0I+NRvkq?=
 =?us-ascii?Q?2M4pIDzeRhHYjtWUgBeUykq9rDt7HJ7yvc+8rLBpj/IOEiAzuAywOwheBgEi?=
 =?us-ascii?Q?vp0XVKqpxgFSoobRR95aXF9mndZaP0EeKy8bSQyDm06PPClIAtJ9ZjwJ5BgZ?=
 =?us-ascii?Q?1hARrC2ezAOb7rW0oDj/VAdGCbcI19eKI6qOvu10CRNcaDE53nIU+Z4l5Kk8?=
 =?us-ascii?Q?vtC9L8+9DV1kqvtoP0dnvtADEiVK4DZEI3OcSa8ZDbMIRdjBIgEOuzbzK4zX?=
 =?us-ascii?Q?yVXdI0Y2T1umQSInx36T43cCGmHqGGTg0XZP5EHXTraS27z7hZkRUteuz0ej?=
 =?us-ascii?Q?K+fBK3muv0BZGHREq9kd0VTLYv2o0Sr4wLWmpSe3ZqhDYYPrzZc1CB7PFCdU?=
 =?us-ascii?Q?myQk5PAiryisCFB0VKrwwYnHfOn6Onqz3ZoRXZkgh7PZf1ti+Lp7nJMO/9i2?=
 =?us-ascii?Q?/wgLOcvm1AcUDuwx8kFpe0pOGJLVP23WPt/7Msg48kq3OIYoHHv2dbe9A8cw?=
 =?us-ascii?Q?FHv+b7BGjMPy0U1atnPj8IY6e2bC1+8cCiiQTNekxTKTmlDkynIDI/CFfbEl?=
 =?us-ascii?Q?IylXgj8rUe/wrOvDjwodI61Iv0YG1wN5aWwXSlL5kDrml6Qe5wMyTicGdoxt?=
 =?us-ascii?Q?QwP4LG+RyLyYPvhy9Iu9hEJ9MAnHjQtC7Ll4f5w+rI8ymapTFwCDw+Py8MoV?=
 =?us-ascii?Q?iopOgpf+rWmRDSR6YcBp/sJtAWKW+3RmNdKRoFHO0el7SA1w53+4Ps0Dmdhj?=
 =?us-ascii?Q?63NX5nfiShGZE4TvwzM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d28af9-3c15-4a81-2b7a-08daa242d5c8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 17:48:36.6440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/A6oL0+MT/1ztscqHivnhcw43uJBeAPXgTRVzaYRA0/pPILcQdwrFy/fj9yCsMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4917
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When converting to directly create the vfio_device the mdev driver has to
put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
vfio_unregister_group_dev() in the remove.

This was missed for gvt, add it.

Cc: stable@vger.kernel.org
Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
Reported-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
 1 file changed, 1 insertion(+)

Should go through Alex's tree.

diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
index 41bba40feef8f4..9003145adb5a93 100644
--- a/drivers/gpu/drm/i915/gvt/kvmgt.c
+++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
@@ -1615,6 +1615,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
 	if (WARN_ON_ONCE(vgpu->attached))
 		return;
 
+	vfio_unregister_group_dev(&vgpu->vfio_device);
 	vfio_put_device(&vgpu->vfio_device);
 }
 

base-commit: c72e0034e6d4c36322d958b997d11d2627c6056c
-- 
2.37.3

