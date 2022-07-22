Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D98E57EA14
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 00:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiGVW4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 18:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiGVW4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 18:56:41 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20613.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::613])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B633718F
        for <stable@vger.kernel.org>; Fri, 22 Jul 2022 15:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNO7b2w8hASVKC1gMDaux7fFLJ6vLEXHXh394GwV/ZVZjt0yf9mxytgC6oH+AGyh4iCUqu2DZNo9EjX8vEtDLFqQ5HVa325Fu/gi5q13QAnMJlBr9pcZ+VwWZDYSOd6cAx7FjEdJkCgpmqajGfvGg/MZ1Li6b6dfj75QsE3p2nrw/L+mzSGw7QTszHPC/TpuZsEdbwVorXrMzF/EsV5A7OyvgDtRHwdIx7UC9BMqReXQ9TNpOPc2dPqnhFimf0LP9BliMiEVkSD6sYnz8slUlfdM3759d2FL4Gpm71U6NlbnXZwSfPu7/va0d+8NxLuuhyeI2fhNF3Anlyf8H3qQKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2xbsDJs9eqDgGxC7QELu3xmbw0CVXdtRNthZu1GUJLk=;
 b=Yv8FG+Rwt2hnhZBO0GEV8axN5UVhrKlIiWVYiqTrqaQ4gHOvpk/Q2fiqixc9mE2MfJLGub/bV/TZNsv1qfxqClkJFXpaCVbgWGQ29y60FQoG2bLbC5T3sgXWtvyzpxwc5O1xle5mnScSq1uemXXI7hmUiOKmFJxunwTFsxe3svWeyL/BQ/zT8Fw9Au4l8qHqZOD+9pU8xpL3joRLZN33AwqQO7lxiKC+3WFZAmnSpbdOFjrJqCDEw9Ww3QANsZpxVTxs8RpQhbGAzh77cofRCd8YBhkXvEG+lRVGWbbvqjyavt6p8yI5uzodrZ9GiqLm+xJWZ2wYrbjzIpTtpH57qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xbsDJs9eqDgGxC7QELu3xmbw0CVXdtRNthZu1GUJLk=;
 b=D8qWWM0nCXirL4U3mQExEtOK3nPJGpb4mXyW2iA1arCv9yCgkO1pvdTxZF+2YGji2JH1vGXQzU8266hc1p7kdLHuS5Gu03HyzZCQdt64BPYpM1GH7qao1wXeXwHZHJ9RgiZMJl+Iveto+9cORZ+LRLRYe8ZaspYqf15RCilKeKHPC4WRG3TVwmvUS8gXyEE/n0t226hJeKHMTY/CNczqAW0igubPEg/OdOCrPrNHo+shzIIiGfM0ieinv5DJMpDF0Cb1HlLwNL3tNpKyd1w/eVfxiggUnaxtlt6APZqSlMOAXN6AC1DFFNav6Hs0PZ125mH8k1t+IU5JhzBrbzKPpg==
Received: from DM6PR08CA0010.namprd08.prod.outlook.com (2603:10b6:5:80::23) by
 BYAPR12MB3207.namprd12.prod.outlook.com (2603:10b6:a03:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Fri, 22 Jul
 2022 22:56:37 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::5a) by DM6PR08CA0010.outlook.office365.com
 (2603:10b6:5:80::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Fri, 22 Jul 2022 22:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 22:56:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Jul
 2022 22:56:36 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 22 Jul
 2022 15:56:35 -0700
Received: from rcampbell-dev.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Fri, 22 Jul 2022 15:56:35 -0700
From:   Ralph Campbell <rcampbell@nvidia.com>
To:     <linux-mm@kvack.org>
CC:     Felix Kuehling <felix.kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ralph Campbell <rcampbell@nvidia.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm/hmm: fault non-owner device private entries
Date:   Fri, 22 Jul 2022 15:56:32 -0700
Message-ID: <20220722225632.4101276-1-rcampbell@nvidia.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ca7c0eb-4a2c-4797-94ac-08da6c356e82
X-MS-TrafficTypeDiagnostic: BYAPR12MB3207:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1RXeqVgMXNvMnzY6trCN30ajg4VBDjREQ2s773FVgCWUdIYTJ6iCb03Nc9ifQ1CiX+VAF+/GtepeTOHueQzx+jZIZpZsyPR9wkMJDSSdzDEuxK6q4Q5BUrtT6jaC2BYKmhc97U/ITyqgDmNe4buX+5kG9+gzhyO/PlIeEPsUi0/50kawQlfLWWoJRUNyEneh5TuBljPoT4Upmoe23PBGvzOTXr26fPGN0nCPTU+c2hIdaIg15Iz7Nkm/8kNrjtOwV/O6av0O1rLe//qrjJxoDrZH/NT+SXMoR0SY7lwdd25sihyr2V9LyOK/UkUr3E3I7RYHaFTaof5Buaisd5FtOVytV1BB7QIsgKzUh8jaXQvmQ6M3GctALXaoqy9VJ3qlRgZHVxg+Zz4Wtod136EIiLcVLJ9SXrQOmxmJTYCz5EznR+VysmjNYpReq8Zp8MkSOTcx3xPQd/0Ygcznez8B74ZDwnG8Z2ADb1twWBjF6MatnURMa5iZpPZZDWxu86WJPISdXs+fq/PHObZMrOvlO+fRrAHFk7qi+2HgHBpAmDIsByZjHy10+7BJOigBlTYkCuC7lTh9nk9fuVkoYSMjJsWL2f0jVFwK/ObJg7Bw37q0z/x/231eG5W50kNcHEZ3zwDQdO2sdndCGsGN3g8XOMjDhRCFal+WhdDR3zTYb+eURlKa8XlAUZAYMpnopwg92mP6K+/0ILSc0AfjSwSsZ4lDAd22Oz+tkUMQeFaqubcsfAtjuiXStisRm2sHhKsleduxjeYBoYOWWRUJQ11Y8Xs4J2t7orzlwcxYM2gm3NLycu3/0N2k9M6GCZBJFffa2o9xtsz4MWTqzz7Z9VakA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(136003)(396003)(36840700001)(40470700004)(46966006)(426003)(356005)(336012)(54906003)(2616005)(47076005)(4744005)(26005)(70586007)(4326008)(186003)(36860700001)(5660300002)(7696005)(81166007)(41300700001)(82740400003)(1076003)(8936002)(82310400005)(2906002)(40460700003)(8676002)(40480700001)(36756003)(70206006)(316002)(6666004)(86362001)(478600001)(6916009)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 22:56:36.8370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca7c0eb-4a2c-4797-94ac-08da6c356e82
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3207
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If hmm_range_fault() is called with the HMM_PFN_REQ_FAULT flag and a
device private PTE is found, the hmm_range::dev_private_owner page is
used to determine if the device private page should not be faulted in.
However, if the device private page is not owned by the caller,
hmm_range_fault() returns an error instead of calling migrate_to_ram()
to fault in the page.

Cc: stable@vger.kernel.org
Fixes: 76612d6ce4cc ("mm/hmm: reorganize how !pte_present is handled in hmm_vma_handle_pte()")
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reported-by: Felix Kuehling <felix.kuehling@amd.com>
---
 mm/hmm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index 3fd3242c5e50..7db2b29bdc85 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -273,6 +273,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (!non_swap_entry(entry))
 			goto fault;
 
+		if (is_device_private_entry(entry))
+			goto fault;
+
 		if (is_device_exclusive_entry(entry))
 			goto fault;
 
-- 
2.35.3

