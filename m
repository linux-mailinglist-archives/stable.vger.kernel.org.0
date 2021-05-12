Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247DD37BCB4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhELMmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:42:52 -0400
Received: from mail-dm6nam11on2060.outbound.protection.outlook.com ([40.107.223.60]:51040
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232854AbhELMmc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 08:42:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bImzQQWJKg8fuSkam3uwIrirHc+q3qAnzWUrKUH/e2gdDGYabCbJambRnTcftElpEmzYgMVh2Rlks7Ec7pZKYS2fjGKd+uAC76n8hqh5SYIabvRE7R2uF/+rBx9VCdhVkZnidCPzo/tGwrYyQlY7+iy8WzgDhpBbJaEBp/fnepsBB4c2WxjefO1PBwSAelXQOFRWMhNOnaoY04gHhrFnvI8S58HA2tUENswqoWcIQ4Xf4Q1wlPLn5nC5fALcsRLkQNzUJmyGcHIjuvwMnCtGweBQsWHrWY/Aw+CbkacEgXae4EAQpx17TY1YHVAjWfndynOs8j6ZlZqNI/lX52bdHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Us1s3Snv0o5Y5bXHJDkGXcrCTOdKWws6PSmPL0Lirc=;
 b=HCp3ZPTqNshWp0jLrfCdaBPbY/ClRj7eK/ed9JU+6GXVe8VmyKlKe1ibMMBU8XlhngxYpiToDI5cxiD6n6m3d23ac7OQcYXHnwE5rwdvcuON0eTa11dtdDINK/ZeLsRLgiGKq7XFj2V9r4CmDwEksvq+0TkjWaxtgyuH9T6U+2i5lVW1Gh/H7qsGwoHcrVgjKTq4XSWKqO2hhwpmUmPk6tTX45QzeKYDSz+/yLva2a2sq6SEDilouM46elpG4pwK/MY7BHD8K2O/6FB7UanrzfSLv2XL0JqvB1JjbD1HKhXpZnpbzhCxpG30Czv9FxSfFn02baaIHQOwdrwx/JsDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Us1s3Snv0o5Y5bXHJDkGXcrCTOdKWws6PSmPL0Lirc=;
 b=XX1+IJIMXGiSeOsckgKCqLjRsu0dOdwNiTccPxKburh2cQE6vdm2K5QVlZKK0cRAMzHQ2dEEQkp5QPoOC8zdZF+Im06Buj6Y+6ZBKxlSKK/ugrqVIh4oOQrB4li0v8bQMe7pBGAi0l4f+p5K3JL7klOU1Ti1xTSD64oXFmxH83YiPhrdiO8wSWjRp0X49JtMg0CzU9kq0x9j0RQuaENsFf9MROcbETyv4EtCEcMB47a+Dn1S/tC3dY2erKx7LwkwzH9mZ2Ne0p//TDCHoS6YFFhkNcK9tRl5o8h/tOQDHSlV3PPEywzyh/jmjtJMTUAy9lQ6Xki9R1l55DkRSM5B+g==
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1337.namprd12.prod.outlook.com (2603:10b6:3:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Wed, 12 May
 2021 12:41:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4129.026; Wed, 12 May 2021
 12:41:22 +0000
Date:   Wed, 12 May 2021 09:41:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        pasic@linux.vnet.ibm.com, jjherne@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Tony Krowiak <akrowiak@stny.rr.com>
Subject: Re: [PATCH v2] s390/vfio-ap: fix memory leak in mdev remove callback
Message-ID: <20210512124120.GV1002214@nvidia.com>
References: <20210510214837.359717-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510214837.359717-1-akrowiak@linux.ibm.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0134.namprd03.prod.outlook.com (2603:10b6:208:32e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 12:41:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lgoAy-005pQA-F0; Wed, 12 May 2021 09:41:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d61d14e1-70e2-4569-7049-08d915433f46
X-MS-TrafficTypeDiagnostic: DM5PR12MB1337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13377548AF929AC9E62819DAC2529@DM5PR12MB1337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hUbTCtYt/4qrIXzseIsecSk/mf15Xxu+BbFf1fUXJVmghpNwl9Pg9KqJpP4Rz3JWE//iUPnPlqr5/7Ab/PnE0tiQ9IcsD1FseWgCHIcNZbzlqaXPH5fy5wcoXZ0geu/vGs5AB0MOmQMWqSD69/ek2FTpaL2cmJjn6CGm8BmUJ3d6K2mUm/ZIYdQwOwhAdiVDbcnLySoFFptAaTmbybZaHvgYx0a2EuXHVIrK49KPdBFksSaonlQienmQ6pOyq4cpNouJlofYJyy+a93/+dUtynGHntSkuWQ8poR69lVQ4zErFUEV97Nk9GWjaKSTgPLNtIqpbTb2dK/AEuSJ9cbkI0Sc5dQecZg5yG1sDRs92STETXj8d+fkZR4Y4HcNFMk0hUfDLU6KKk7mrO27CjTtSyChwupn8Vp+hRb4Hjvrz18xyo+kkeIvMeRgCAzauX3ugr1EjeHssbPUhr/ottFaVkSngBjEKKSuRdZcLfgEMvHF21kMeNG/M5sSwvKl0DaloiLoFmh7BMTQSQM4ed/6Vp7S1QSCXtVEMsF1pZOKuvPHUfVGQz1WqIcxa435MFuuX9nTFEs+vlimQ5h8fR1S4c/3CULOuEYAhCrJLcThpQo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(426003)(7416002)(9746002)(66476007)(66556008)(83380400001)(2616005)(26005)(66946007)(5660300002)(4326008)(478600001)(36756003)(6916009)(186003)(38100700002)(9786002)(33656002)(86362001)(2906002)(8936002)(8676002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kwhU6m07z88eFJptwyKY7jZaIctk9Gg1tLSwqCNa087tx4r6iW9gJhHkALCb?=
 =?us-ascii?Q?Md28b7lrMyAspk3XdHt6qIIqwyZgygrfgXQfy3N27o+N935OZSwC9NSXgfZX?=
 =?us-ascii?Q?CajOUCGZAHKFGlZ65xHei3IeGBFE+VGF5OudaKDZhXHQqsD4kQL/7dV+8bhb?=
 =?us-ascii?Q?bF9U3EGadohELpSZh25MvDPSpIGhWF9+1cidbTSd2jjEWuz7T+smwip+1ztx?=
 =?us-ascii?Q?h3O7vu2GOhUENQEjV9T44jnaXRQ5IljNPY8HGDmVewxsLDWkC/XcfJtWq9T3?=
 =?us-ascii?Q?92uglzTCUL5gRQGce4b2qLhx6gpEvSoAdURdls76XfOLfUS4+4h7PgANyhiZ?=
 =?us-ascii?Q?cJ7R+KlLYrLKwb1eDDKQQ+KPXGtRX5EZeVsJH7ULL0gRXYPQM3mR1mc8/c7R?=
 =?us-ascii?Q?IdH4G13eDLChQHWJ8YTr2SYfyWK5lpr47O/rwCIvp5DH5qt07PYQ3zJySl5x?=
 =?us-ascii?Q?Ick+vQoIRfZyhroZbZBElEq6xGpLEHIl/rtQFXA9FYrq/y09l8IDNElGD1xl?=
 =?us-ascii?Q?XWwzqIrxOfWfsWtuUlkv73D398xLTgHc/2AdXRLV0c6PJLYN6+sPh7IPssDD?=
 =?us-ascii?Q?a08k/CK7oFy4pc19cDqyk7K2LLn+9r5QbJBINwKqAcw3f8+8LlnZN28LdvWF?=
 =?us-ascii?Q?GFuj8/GMepYobR7TKXbVOVLcC9ggP/q5E5sd6zjlVWdko1z2JYF329Cc3iyJ?=
 =?us-ascii?Q?epXzpQl6Oi2j4gSh0VY5t2ftn22FhCvPonimr/7SgHBie6um/6jdylhz/zvU?=
 =?us-ascii?Q?7kUoYl7xkUuc6nEWIKxxWgMnoJXYESEh+TrWWZ7PWidfg3a6cScYBsos57FI?=
 =?us-ascii?Q?Qw+DInY9RbC7GOBBj7BSXVNi5armUtv48VK111QaoWQc4ipoW59iz/lkMa7d?=
 =?us-ascii?Q?kb5FqHVWzD6fLd3DTlppCG62YAb++oYzrZ3DHJTNgFwTPuA5ZHldnGzCmq5t?=
 =?us-ascii?Q?2Nt1UXBe5QTEBcpN8BuMde+X2vRxJvNagTnFz12a6L8T8Gg1izOLr7YbaUZZ?=
 =?us-ascii?Q?FiU9jUWndYTu9KH0SMl/gI8cL/AQOwJ/xyoCARc81Ns8LHyP3LiyaBsPxAOg?=
 =?us-ascii?Q?HlK7+kykkA6Ekc4GLSz+tKpFf4/Fpdbr78vkdsyB0JtnD58AVOgLTnngZoxJ?=
 =?us-ascii?Q?xysI177+cbt97b2e5YQXujLT1MpBGWGSsdOvpJUawSxjtFlOTHZFbK8MNJl0?=
 =?us-ascii?Q?lFETB+paXc1BXu0g4g37UQn+iYKUEC9ftD0Us/qkqlcNNtZbAvDi0WYaQTbu?=
 =?us-ascii?Q?QSnne8a+ihQmUX9clfDs4K6Z0DgkWQCOimeqym4n0GSP6VJF4eiNMUOkLWVp?=
 =?us-ascii?Q?yR9LvSIGCfnOD78hrmskzo/G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61d14e1-70e2-4569-7049-08d915433f46
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 12:41:21.9608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PAg8QDvzjMvSLm94ydqH+LTJt1CIpMwZ6iRegsT88GGLmD+WXmKmWt9rBHE/bBIx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1337
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 05:48:37PM -0400, Tony Krowiak wrote:
> The mdev remove callback for the vfio_ap device driver bails out with
> -EBUSY if the mdev is in use by a KVM guest. The intended purpose was
> to prevent the mdev from being removed while in use; however, returning a
> non-zero rc does not prevent removal. This could result in a memory leak
> of the resources allocated when the mdev was created. In addition, the
> KVM guest will still have access to the AP devices assigned to the mdev
> even though the mdev no longer exists.
> 
> To prevent this scenario, cleanup will be done - including unplugging the
> AP adapters, domains and control domains - regardless of whether the mdev
> is in use by a KVM guest or not.
> 
> Fixes: 258287c994de ("s390: vfio-ap: implement mediated device open callback")
> Cc: stable@vger.kernel.org
> Signed-off-by: Tony Krowiak <akrowiak@stny.rr.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)

Can you please ensure this goes to a -rc branch or through Alex's
tree?

Thanks,
Jason
