Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8486C594C
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 23:09:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCVWJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 18:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCVWJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 18:09:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012B720561
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 15:09:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YK+L8z1dYpffTHIHh9L648lY6lpPdszPNqb9vWCGKL4jlZgi3gsJj57xtWUTly2ItoNbADA0l5E6bEopk48HRnU29QKh/2GnXZjtfJg4loSvCQ7y105Z6RStFkd8UjgVJhU+n8mDytRwHUpU92j5MvLfNkcMQnd4D8VEcfFo8Qte/hAudJvwLP8A5I+YziD4Ep+8a2+kmtstPq/0dmvYy2KFCNkWL6EidcLhXirucYr0jSFwKx7kfEsq4nydU1KW5I7hFS72g8jCbs2FLbYZFo+Et5FGD9khDWgxL4gNMPiCMn45rROe9jjFoggExGXKP3zdriVE/LmNlhJPGGpWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NzitKwWUly/kaTnukWUNhW+H0+QtiYtoYNe6tD8n2Ow=;
 b=ngY9zIsWy7CIdZK45yWSDJVgJ5VhzwDU8ZbRJFQlFHgi6EYNSXlum1FEPPyKWwql1n06ptpjuwILCgYp2zZMorpd7Y/xVN5LnBbUbvcoM1noi0V8iICaprt0jIAQVlxhUsrtT4IDP+z5O3mKFbOmUz4eQU+hMvlN7LPYlvkDP907mITXy2nFM6OFRokc7A59TgWq+e3qpLmmjRQBoIJjSaiSwMDxFu8Pt8HWt9XNnZCKwNdeaZzi3pkfuA0U+6NFQ9xpi0JVkAbGJbBa+q1sF63pIH2FTXAeh1k0fphfGnvvZt6GEmkWJXke+EEvwSTmaHlMxLntSLkjScXzJt3wSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NzitKwWUly/kaTnukWUNhW+H0+QtiYtoYNe6tD8n2Ow=;
 b=YEsMryF19PHaxJ/NYzISpcpkY0r4ArwT7RaXS1eI+6ftaBGZzMZbERj/s0tDg/Ap5caI1spEpsd8tNrzGcg9QBr6fTbOSUJHF1F3ugnyH15KKryEWtyQZKBk92IDe6i7wMKd6ivG+FvY83lWhzWILNCXVM/bfhUG3xHHubGYQtI=
Received: from MW2PR16CA0045.namprd16.prod.outlook.com (2603:10b6:907:1::22)
 by SJ0PR12MB6879.namprd12.prod.outlook.com (2603:10b6:a03:484::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 22:08:59 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::75) by MW2PR16CA0045.outlook.office365.com
 (2603:10b6:907:1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 22:08:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 22:08:59 +0000
Received: from AUS-LX-MLIMONCI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 17:08:57 -0500
From:   Mario Limonciello <mario.limonciello@amd.com>
To:     <stable@vger.kernel.org>
CC:     Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.2.y/6.1.y 0/1] Fixed stable backport for USB4 CM issue
Date:   Wed, 22 Mar 2023 17:08:40 -0500
Message-ID: <20230322220841.898-1-mario.limonciello@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|SJ0PR12MB6879:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d4aad8-2c42-4954-adc9-08db2b22099b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4j6O1fd7sCT+byB0imOfk+z9rmHCrmdF0e5rBdXmwXk/cVwDq6L90DeTCtH0UbKvTJkwRJBNlmi3vVedvVIICpilJe7wCoAwbdeRFK4yzKn7Yy8+9eAKo2ZqdqB0bf6UN9ZUpMyVnayuB/Td9srsCJmOQ0Un4iXiRvModFrUu9f8dAeicNgFuLjgpwgkh4WmcmzQxWIuPjFgwMEa7saXpNRnwJDNH1U9Xp+E0nuyz6Myw0UHI4Z7/0n8s1ymwgIyJJl6WmqgBYArxgSznSSA1AHojx3zfWQirvNvuEjdIH5TQM+2rXOZSW9y14bGkAjMzdZIErsm5pImpVFJr9bY3Lj7q5Q+wFn20UTqw6Sfxr5aTOLIlTJy6i8LAi1kSB3wW/fHQHdzqQVqjfhYocQXcbG9rIh/FKJQBcYHuEOQcZzHzELDXguJkAiTlqmAx1VC8sY0IKpw7D2zPpOZdbP8G3TH6RlPKL72WyMPibTNF+PuFQW7HUWQWlUU4+zEpxjGAAgCf/BFejNieDYYLpWLaXoMgtzDNCJSwn2d2SjdmgHNIgaT31Sl4rKcT741PzBNhhD7Ttuh6q/uVTc/nYGgifGSFyAgL0Ru7tRkwFarxNMubJJdmQ754PU76uzc/+IEfO9pFEoe4ZcRE2CX7PEzadG3mzmYeTq1ak9/TClK0nFjbMyggKl1t8N71lYZGVRRE83rSiGjP6EV1ISvzxCzUqdSlg23rXt+ZKgo0C1Szf4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(356005)(478600001)(81166007)(2616005)(316002)(82310400005)(16526019)(186003)(2906002)(6916009)(70206006)(82740400003)(8676002)(70586007)(26005)(4326008)(86362001)(36756003)(1076003)(7696005)(44832011)(6666004)(40480700001)(41300700001)(5660300002)(47076005)(36860700001)(4744005)(336012)(40460700003)(426003)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 22:08:59.1574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d4aad8-2c42-4954-adc9-08db2b22099b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6879
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

This commit that landed in 6.3 was marked to got to stable, but it failed
to apply to both 6.2.y and 6.1.y.

cbd6c1b17d3b ("drm/amd/display: Fix DP MST sinks removal issue")

The code is needed for some timing issues with USB4 CM teardown.

It failed to apply because the code it fixed was moved to a new file in
6.3.  The code is otherwise unchanged in the old file, so this has been
manually fixed up.

Please apply for both 6.2.y and 6.1.y.

Thanks!

Cruise Hung (1):
  drm/amd/display: Fix DP MST sinks removal issue

 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.34.1

