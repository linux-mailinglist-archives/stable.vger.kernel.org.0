Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367F02B0B35
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 18:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgKLRWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 12:22:21 -0500
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:39585
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbgKLRWV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Nov 2020 12:22:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1Py1y/jfgXa3S60KKAaGXHNQvBOl8bVsyESYq7ePSdx9MuzcyZaybs5CgmmbDJnc2W5aHhcBafvh4RPnFBwS0Hwtwn7/rclPBIKlUYNEQ+FkVwgiZ7o1NwFu0x0UL34WOGT9sYA4q8EbT0f8BYTUJT8cw3TKJ71CdjXmhK13GxqCppeHAastAQQJHmadJxKK57xXGAGFrJlsP+URAXSdjbhUxKEOZ8E/GyBUyBCWpS3r5Ve5i7gXljynXwJcvVPg1/WknWVxJw7ci6hTsesDPQR8DP4/EMDNPUmObuy+sCyLTi2GZKb8R1wXz5Q5wjPmlUvNyzih2lPS/9He1+XcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fKMGXrhIRr+ODnG4flsSTD3LedKbgNbM3QMnfXX+ig=;
 b=Xj4DXk32RfymCDitG1/p0imzZ2NFnu0Hjvlw1jMNNDl5Aim5KRFcnTsL/ChdwFOV+FASBR4VCqBTnXERzEQtRvpH2lcJN1Ufnp7goYzzI5NttoRJ04Ofpw5ACal2uhkp7poKRGC0A9cB7C/+rLbdFmrmOaM9YdjiiI/6a04z60wGi4jpeNAF0jnb+otsdAWlNwp5xjrr4sl2acF6qsD2/cSsXwTIBfQXNJmrk88xrbmKeQLIPhaUY+YBGYWIue8sT9AM6N21SNFHU9Jw999uCbV3o7WJ5p4f4qlf/UpXfvcp6Q30LT0WVhSiTdcA2BN4Bay/NiPQKsvzoS5Sswrw7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fKMGXrhIRr+ODnG4flsSTD3LedKbgNbM3QMnfXX+ig=;
 b=j3vY3jSMNg2052I0kJrdjudY0PwgRR/kkLMh9fRLgiMcoFLSVxJg2CRWVFE3aQZoMTNnhSt2VOGpNeZ/PO7/XqoTc06fih1ev1iZ3w8KL1rd4FDR2//k+ZHKFi7GxITKdvQkf2Ql+eMRayjPf6GcwlSwTTBbjruvgoErjAQLU7s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10)
 by DM5PR12MB1548.namprd12.prod.outlook.com (2603:10b6:4:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Thu, 12 Nov 2020 17:22:18 +0000
Received: from DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::31b8:2b7f:39bb:23af]) by DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::31b8:2b7f:39bb:23af%6]) with mapi id 15.20.3541.025; Thu, 12 Nov 2020
 17:22:17 +0000
From:   Naveen Krishna Chatradhi <nchatrad@amd.com>
To:     linux-hwmon@vger.kernel.org
Cc:     naveenkrishna.ch@gmail.com,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Date:   Thu, 12 Nov 2020 22:51:59 +0530
Message-Id: <20201112172159.8781-1-nchatrad@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR0101CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::22) To DM6PR12MB4388.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from milan-ETHANOL-X.amd.com (165.204.156.251) by MAXPR0101CA0012.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 17:22:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0841b62b-08a9-495e-4e23-08d8872f8153
X-MS-TrafficTypeDiagnostic: DM5PR12MB1548:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB15489114D413DA448DB43C31E8E70@DM5PR12MB1548.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E2VJXYFgGkZiNSKcp6ihxqL+Y09GtFS6kdKs7jh7tqPx9AFj2IUmhOpgIl3yKahfBc5s+eZKEZGNmPKV1cg7hn+yky5uDSe1d2KkWV/WntiJBQ+xx0VO1JASpIsUm0s3UDjebSe8G4FwDfATJUk/K3gV8WAVZGER2ojxKzl51iiPTFdoHC2VHGYYkFXZt9+pk6hZway2N7JEMVyVfy0zOGUeaCvEmp2iUZ+5WuyntORdOafX8Y7/zRIR3eAzxgRAblzFobWj+69YgnkO4T5yK3qKDkA21Qpaej1g9jS3CbD6azisxisJpIS0Fx18mN6Ae00blLXerPEVJcxsa7DM5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4388.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(39860400002)(396003)(6486002)(36756003)(5660300002)(26005)(66556008)(8936002)(16526019)(7696005)(66476007)(186003)(1076003)(6666004)(956004)(2906002)(66946007)(2616005)(8676002)(4744005)(6916009)(478600001)(52116002)(83380400001)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LhI6hmFo+4E3/2qqRvvzyfMx7rqhjUaAzyYbLqgQVx4KkMs0q1/N0VOZLSKB7kM6j3vm3phCD/J8gGoYdk6zqo0JGWS9H/sXA26H/w8mvXmhSiZNqdgqekYG/lbj1QK2CZeqv9YqMeSf1Pusnv1sMHFN5ikQ6zWqPFPIND1ugxalaDGlMcBhOSFI/vnnn7emwDH5wg8S6jOJx9MqigjozvS92lw+rTlnZ+yZqgfY8Bc2aqzvYhF2MELeVjSaYnW30QNFKsb8HmUYZZNKsbN8PEEaHKcRAtez90UreW4ljGNa7hQUfxe4LM2xdznkzQXpkiGHwxS/dyVpcifZ6u72ts5w9OQvqEy9GLJwDYF7s9paBANtCRTj5IAAE9FTtnQDutnthhHgDtrHi2SbBzH62tkJSQIKi4O2QWvDyxGeUKbm1I22AOcxMD7q0k8JFcQ9X5rP1s/ELQzX0Zsq2vPoB+OskgaMda3qq4VHwr1aaZDmsay7/mWHedgkJKe/WueJ0LgmU/0/QSAKGD1bWmzuV2fFkQmgOnf1yZh6Yztf2+Dz3m8cNlTVNYNUi4Bmn6sGfVUxVYWxO6UEOkzI42+YC1vgT9LrMVpS1LEGnhnjrre/eXYg1Y9PIq6VYW5+EDynTqaHOVovyYdnzpifUbPTJA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0841b62b-08a9-495e-4e23-08d8872f8153
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4388.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 17:22:17.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+OggccBXPtNblU+jg8NULgUTHhJmwhUvCcr9ZESrTZouVjj8LGoGBafuG/aR7ZXpBNKQd1oY5e+kvsq3vQ0oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1548
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch limits the visibility to owner and groups only for the
energy counters exposed through the hwmon based amd_energy driver.

Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Naveen Krishna Chatradhi <nchatrad@amd.com>
---
 drivers/hwmon/amd_energy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/amd_energy.c b/drivers/hwmon/amd_energy.c
index d06597303d5a..3197cda7bcd9 100644
--- a/drivers/hwmon/amd_energy.c
+++ b/drivers/hwmon/amd_energy.c
@@ -171,7 +171,7 @@ static umode_t amd_energy_is_visible(const void *_data,
 				     enum hwmon_sensor_types type,
 				     u32 attr, int channel)
 {
-	return 0444;
+	return 0440;
 }
 
 static int energy_accumulator(void *p)
-- 
2.17.1

