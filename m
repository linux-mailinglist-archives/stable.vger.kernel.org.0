Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58BE68FAF9
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 00:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBHXOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 18:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBHXOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 18:14:02 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EC1E0;
        Wed,  8 Feb 2023 15:14:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AloJvUN2rmZ2TjmHmz4jIj+G7c3MdRF/yLns3bkyn/YlYC1FjrakebDr7Miuy6lYoS8CtypjrlZGEutzK7yHfS5ENjnQavNyLGnwsBEotOsv9XlCF/9BM9UcyR/ylhMDFBjqBEPsFLBYVHSr8TFF4gBRYTJvsGqJ4Pi8y2yDv1COxcw9+5sJwy+FDKtzOa9Pv8TONSbKUf7/MANjt7NFlazvDOXt/WUfAxwgPcZE8tmN0I4Lc5BJC5RMfLieGRnuppJoyvLPSLJa7Adz/pysBhK21R7B833K4A8NdKzC86LFXDh3knDVHaGSiOjyFLWSU7zdzbl6DQ6uSMaW1bvKLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wanm6gqz3T/QKUeTXEPIezLl9hZZel+mfl4DucLj4og=;
 b=Tdl+qEJ6Vh1zaUyVbJRE67u1egsy2/BX2JNTE4Li1nQs2/kmbLtZjn6e9X5gDo+fTUs6A5usxN+XTALPQPWYKUVsA9T+Dn4APV4fJIwp0VmksxAR8lOB2VxtZF8PISXgNxBLAqpW/gRcTRdZxhx1iagiZxah8mb8aQmeAp9rxuxoFhLy3Kj2kRLdAYam0HcAL1elmqvykyPU+lqVcDoCF8Kuha+Gro/AAEsNGBS7Pogci1aHNegIWm1f5uy+3tByLlPFmHEwIGK5R+IoscnzdfzhnSMeziu5uajfBN3YMXdan2B+V02n9qoZl0In2KBrZTL1i0qATf+qjtYnWrAA7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wanm6gqz3T/QKUeTXEPIezLl9hZZel+mfl4DucLj4og=;
 b=v9A7AEucJVV0pUClQcqf+IVUlvBFYJexHcqRAYpf0yn2YgWwkhPloSBmuW21MvQvZJ6ZAOrn/+fgy8adIpRRkuXeh+gLFPjOeY7Y+7/BAmhWKV4cOD+mPGms7OITp9p9sOreNeB3sxFJrxBsWZohe1EmDCmZ7kgv7mzoO0Ndi8Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ0PR01MB7432.prod.exchangelabs.com (2603:10b6:a03:3d3::16) by
 CH0PR01MB6956.prod.exchangelabs.com (2603:10b6:610:109::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Wed, 8 Feb 2023 23:13:58 +0000
Received: from SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5]) by SJ0PR01MB7432.prod.exchangelabs.com
 ([fe80::5208:e5ea:6ab3:19b5%9]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 23:13:58 +0000
From:   Darren Hart <darren@os.amperecomputing.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     stable@vger.kernel.org, linux-efi@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] arm64: efi: Force the use of SetVirtualAddressMap() on Altra Max machines
Date:   Wed,  8 Feb 2023 15:12:00 -0800
Message-Id: <a968c446bde75bf019580366854349bf94e6c961.1675897882.git.darren@os.amperecomputing.com>
X-Mailer: git-send-email 2.34.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CP5P284CA0132.BRAP284.PROD.OUTLOOK.COM
 (2603:10d6:103:229::10) To SJ0PR01MB7432.prod.exchangelabs.com
 (2603:10b6:a03:3d3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR01MB7432:EE_|CH0PR01MB6956:EE_
X-MS-Office365-Filtering-Correlation-Id: ade786ff-5493-44e1-0980-08db0a2a2842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2BKLG/ItOYKeU9J4fX+6u1lYEhGnvWvZNwzV0r1MbgUI92oCcxQgM7XgnJ2Rh10OsQ3vriPTAztem1A+ccNi7ISJpaKOSxdyjxysk2OEl/hmVCOgvgm5qL6Y43J/IPsjl3XkkT6jX+Pcqp6v9Y1nycHQi2VcCFnn4zS0Qo0C+vNi3HE7+HPtiUSXObOacykK2vHUoS25ep082ROs7E8woIOt/EPst4Z5XcXd/7s8JBBx7w3Z+U/J99Gy2HFctpgo27G4bdt+JLSzCmXW5wFuD46jG91xVW9dS7DQo4FOTsLNwI6AgZT5cZ+air1IwcV/ArO6jtrt6OHkbcaAyKwg+P8wvy2N68uTFOBtv6OpCFbPoQ66koHUGgWtcA9yJ0GIjDc2H9sbzer5d30GMhSrYkJ1Bf55F7pSozfnml+y5GO+d3q4XbEMEXChFcWtG40fByQhiYx/M7wd30wrYEFkATAulRBBiyZF3v++cKqLhLWw0KeWehHixPsfzLx2DvAWJCZ1cd12ixRjc0ZDVKL3WBKE8zmwgJp4dX8+NpIbNalT96oReEJwaKv8p4gTb9yyy2NHtAK6xBNP5F0JFHaYxPINCh7I87dSA/PkXmJcnRuhUgYHPwCbybBH78CT9ecXSs4Oat8rFKs9uEwxvFTEhuaDKE2ee4aB0KtDgYlm+7V+B4rAcTYmRrggf023Nc9Un0KQYDpl6SKsrcQorhiqfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR01MB7432.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(39850400004)(346002)(136003)(451199018)(86362001)(8936002)(66556008)(41300700001)(66946007)(66476007)(5660300002)(6916009)(4326008)(8676002)(2906002)(38100700002)(38350700002)(6486002)(52116002)(478600001)(6666004)(316002)(2616005)(54906003)(6512007)(26005)(186003)(83380400001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h/5Px6G5SBBnddFV3MyLH9+KSQ1w4C4QeIGsN9R3h+KxJ1+fusFXAHcPvKRU?=
 =?us-ascii?Q?4JofM2C2KaSycodaSbK4MB5NPn1gUSnSSis7ByWh13H7fwj7/PPaTFTEb9mi?=
 =?us-ascii?Q?xoohW/XmzLvgAjEMQhVoVlfISyTnlO0YPSk5g+SaOwBuxgRXHgyo+bxZvrnz?=
 =?us-ascii?Q?jCbda0FITG76if+3JGLsp5hyi/0km2xyjrXkVLCqq++OzdXUJUWrlaxY8A4t?=
 =?us-ascii?Q?5HTVtPkUbA22d+1veE0v3blkHoJ5kV9YZixaU/P3lCq48NEke6o+F4JbgLcm?=
 =?us-ascii?Q?HU0Vk5UuP8rA+Som5zO1TdY65oRZcEVXCC2mJIeIUfVqin1YucgPuffr0+V0?=
 =?us-ascii?Q?XwxEKuwyhF55nhf2saKPw0EWDe+hLk3cKsmfMKzScFJ6BOXvVzJXDH4bhBSo?=
 =?us-ascii?Q?OAKVdvwJA0YnMoAFt3tnNlczldqPh3Tu2WqP+nmYG4S0NChb7aKXvbd+Jkpk?=
 =?us-ascii?Q?weIK4A5fFJA75NaiE3zt3GPN31ODnNBfRkJVI57vHUltxKxUzMLmJaOotZIv?=
 =?us-ascii?Q?rppyICwfzYsYiobcGNOsE8hdkbrpDspPwrybQnB/gf/qabiLCBU5QmUmPUKI?=
 =?us-ascii?Q?GFROhmdVakiBYvqDkgWrVUVOGHLosrPsKWJ7gpl5J3B7nWrSrEBZcwgnA4oW?=
 =?us-ascii?Q?DeUVTAC36NQKUZZ4fFvY8yvQZjeKAqqSX7QJr1MTtMNzioi9H3Msc02/ZlsU?=
 =?us-ascii?Q?AezgYofjpOy0W+ZG0EVe2XAQqkCXOoOhereGvlln4gBUbbbyfuMThZMKbjSC?=
 =?us-ascii?Q?BHqj40y9MWOoKF4V22Cp7v2To8G3hq+1vGieeFmxR8sllcFm3TdlOaGK4kxC?=
 =?us-ascii?Q?liAWTRanOORjVwxMQHFaoLAiDbX9OjXGALfI8uz44b9debw+lKXTjNSksZBL?=
 =?us-ascii?Q?EJKIAaoHlFLwj1GbZeOg9iU3BbLXl65SMnplOq2QblYvjzvcEdL7hko2cjlf?=
 =?us-ascii?Q?M2MQhf53v2MnEk2ghP2BzjXDUg9IDmqA07e/3tPmkpjikN+CZoRRMjWd5Xb/?=
 =?us-ascii?Q?QBxsSx2dFZoafm+GhDnIZl6KwOVHJdduKK0lW1adgU/9k40GEa6WLC0DdDBN?=
 =?us-ascii?Q?nztxk0o4gmIL/ryTiRqdxZ7yoBytTvWJ6rbKHtn5cRKo4zmNH+QtR9VnRMCv?=
 =?us-ascii?Q?AWO+m0gzQ/6zr717PyW4phmhkDzfaOFyU0C9QZRqt+ZLtXB0igXsEi/s2Nsb?=
 =?us-ascii?Q?12KypYl7WN9SpVVf850Qd17YlcvIDFbdQVf6HRj/RUdj0Me+81K8WANTl6Bu?=
 =?us-ascii?Q?ap9CVbHaqP/UokSm96oIWjfcOZFkwQbbcuMl4Cvtv8GuaMTxlXR/sNGclnr8?=
 =?us-ascii?Q?6V7wk21/ALAtdsWu7KkJ5dQTwgP9FjHknROKtNo5p+PDLotLOP68RxaOzgAh?=
 =?us-ascii?Q?9YtY/CvaZDyGIHNZKCNS8H7fFi0ppp9uH7LwZQLhOnrVUu4YfWq2mkUF0FD6?=
 =?us-ascii?Q?mUKTDCoSolGtu8pMXLJlFHQ/B4ljhT/K2gRqMLikFVVkIh5CjGSxz3Nr5EIh?=
 =?us-ascii?Q?eocJpzcbty7oZmTFJmwEPAepYSFNHhmauEQI9OQoNVfpXLnvzgm92OaHgN83?=
 =?us-ascii?Q?T24vAnei7EE/oR6TW5Fd+Qbup4UgJZfzxTJDDHrJyxM04FYsxMJsDTZUjo6n?=
 =?us-ascii?Q?kPUntoRuHYoR2DkoCOLiARE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade786ff-5493-44e1-0980-08db0a2a2842
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR01MB7432.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 23:13:58.5736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+xdH2Ahj4WtZqDtm2CgyNLaFYwT8kokxxsHsfsEXYFyBILQ4MGuWw5qLL2XcBiUfOUsUk2tQmXzklzQFnO0TyBBsOlQBscCOT3KeNvE3d+jOL7BkGcAmLhu9HCr8n/z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6956
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap()
on Altra machines") identifies the Altra family via the family field in
the type#1 SMBIOS record. Altra Max machines are similarly affected but
not detected with the strict strcmp test.

Rather than risk greedy matching with strncmp, add a second test for
Altra Max. Do not refactor to handle multiple tests as these should be
the only two needed.

Fixes: 550b33cfd445 ("arm64: efi: Force the use of SetVirtualAddressMap() on Altra machines")
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: <linux-efi@vger.kernel.org>
Cc: Alexandru Elisei <alexandru.elisei@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Darren Hart <darren@os.amperecomputing.com>
---
 drivers/firmware/efi/libstub/arm64.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/libstub/arm64.c
index ff2d18c42ee7..97f4423059c7 100644
--- a/drivers/firmware/efi/libstub/arm64.c
+++ b/drivers/firmware/efi/libstub/arm64.c
@@ -19,10 +19,10 @@ static bool system_needs_vamap(void)
 	const u8 *type1_family = efi_get_smbios_string(1, family);
 
 	/*
-	 * Ampere Altra machines crash in SetTime() if SetVirtualAddressMap()
-	 * has not been called prior.
+	 * Ampere Altra and Altra Max machines crash in SetTime() if
+	 * SetVirtualAddressMap() has not been called prior.
 	 */
-	if (!type1_family || strcmp(type1_family, "Altra"))
+	if (!type1_family || (strcmp(type1_family, "Altra") && strcmp(type1_family, "Altra Max")))
 		return false;
 
 	efi_warn("Working around broken SetVirtualAddressMap()\n");
-- 
2.34.3

