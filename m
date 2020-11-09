Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD122AB328
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 10:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgKIJHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 04:07:52 -0500
Received: from mail-mw2nam12on2080.outbound.protection.outlook.com ([40.107.244.80]:52704
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729846AbgKIJHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 04:07:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BU77U6L64dI0n6DlEOfpzdclXtVJVRxvRdWRVoA3QIPZw287ZTdkqUwC0nbSea7lo6T1KTT2iNj2uSDsVZ22nBAbKrZ+3gqzEeWu1oq0y1zD1lRX+HfciLVqeEdzECD312Btd2QqMMy71DstACaorz2aN3EoZ94wguPQMm8ICNf4T7uhISsr9fqsDeBqj2wjjfuU02soVxpMsuziJJ/FYWVxcGSiht1Qk6wKuZgsgr6XWpSEKnjlyIHuLyuVwWoUmcJiuEg0D1KFka31K4DTTpt+a47vreL3Owfij12B0K3cfAwNFlcoKMJrBcL8u7rcdkBbYHY7Gxy60gvqdLhNhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fKMGXrhIRr+ODnG4flsSTD3LedKbgNbM3QMnfXX+ig=;
 b=dg4Si/wfMbCg1n4+yR4COf/l7uHenxSpfaSi8VvhjqoptJNgaMqz6tkWnkZz2fGK8/WOwbNu1N5NUhLANpgtgGP1O6oOwP1sOjrJBG2oOUrvX+6NCxZH87rGI1shetfrRIHx3roHDuYpRRWfpjG8mrgF/uKf25dyv6qUWoq0P5da61HMMdAeGLcBVdNRxY48+1gS/28NjnAy9+ljQ6xbihRSrCBKpzMzJCFKNmdZNws3jpShYeu+0Ph9SM0BxthND8AFoxxI9zchIq1sh/RCxXum/qdzHy4ZOc5LFzqR+d1XqzyAbU3o0iYeWAhQ9p+Qj8PETE9+8vPC9t5c/rC1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/fKMGXrhIRr+ODnG4flsSTD3LedKbgNbM3QMnfXX+ig=;
 b=LXCUuHvsT2VHdGKkBuY6vvwJ9/Q5W6xFCGrtZuLsYt110NP9x4sWITiC4TkeSiljzxKxrvZuV6bFVKgIXMGRcrRvtWotH/POnw2yVHgTBRSEm/twhcBpUSMAJZKtZCUpoilm0ZDk38leo/tF0C6HxWP+YpA2/EiLDlfFXtk4208=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB4390.namprd12.prod.outlook.com (2603:10b6:208:26e::21)
 by BL0PR12MB4660.namprd12.prod.outlook.com (2603:10b6:207:34::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.23; Mon, 9 Nov
 2020 09:07:50 +0000
Received: from MN2PR12MB4390.namprd12.prod.outlook.com
 ([fe80::8de5:25b7:db87:bb70]) by MN2PR12MB4390.namprd12.prod.outlook.com
 ([fe80::8de5:25b7:db87:bb70%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 09:07:50 +0000
From:   Naveen Krishna Chatradhi <nchatrad@amd.com>
To:     security@kernel.org
Cc:     naveenkrishna.ch@gmail.com,
        Naveen Krishna Chatradhi <nchatrad@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Date:   Mon,  9 Nov 2020 14:37:32 +0530
Message-Id: <20201109090732.9680-1-nchatrad@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MA1PR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::12) To MN2PR12MB4390.namprd12.prod.outlook.com
 (2603:10b6:208:26e::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from milan-ETHANOL-X.amd.com (165.204.156.251) by MA1PR01CA0096.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 09:07:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 01420493-111d-4b6c-a8df-08d8848eee9b
X-MS-TrafficTypeDiagnostic: BL0PR12MB4660:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB46604B2D3DABD3A56CB2BAF7E8EA0@BL0PR12MB4660.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hM0T19nh0e4U1O9Hts6Dxaew6sVDOODP1ZtWoxy5+FqoGsK5U6nqyhDcSHL2wonJjoyxODZlQf/phjqUwFnDBHlEbwYxkPtDl1i5EaBOknV5rxgbEdKytBnTtGi37ADEoQn5ZF3Cif49uEX37ft0+9McoV+EPEeK/DYMjyg4plWp+dmA+CCGxS1TNjWUmoAUd+72gFiJqr0pWur+iimbd5vcgNTKkVg8luJ+xWQ+zeOK/9+k158+abf5T8Lu5KUoL1ILgspS/KUsJDdfRgjH6IoWvs1UVB/qvnMsUfVPXJK1BBb43oI/ULspK6+yYZHNBNp6aQBqkSZTiWlUc+oTVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4390.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(8676002)(4744005)(16526019)(6666004)(186003)(36756003)(4326008)(956004)(2616005)(6916009)(66476007)(66556008)(66946007)(26005)(6486002)(8936002)(478600001)(316002)(2906002)(7696005)(52116002)(83380400001)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WJDfXrw99sUbdzyAlP/iHe62QDhxUTS9MQlk3hRaIt4MOaiXXQwucXBqIKvCRuH2akLo9rXC9vzms2hXH3015S28qI5SwTVqfhQhy52EcrtAXPbzIVnw0Doc1FfyMLPSI+dUofnisMr4yWZgZ3V5QvR6cyAfx1l6k7dPN5UpLnycF1DBoTRPrcmAz3/K6xz1rlpd5VcbWPFHtAl0j2ONeN8/iQ2z/SgqSNGuwbRlK3coaWGIAPM3Dn54YljANifziadL0SfpW047Kq1dZ7q8GiAs9b2xZH5Hs9ZaEoJ0+QprFjiQSY6fLHAG2enR9sr3KJEGP/10bEM0gDEEt0JHhoQY+l/08l/Q6MELYL9fWAsjDN4yuMapXSdKfpvKQ2q1Cs3ULdzK7F0cR8sq8ItJVTmyKColT3uxjzTXbu1RAlZVAaKaTH64Pi67eH3rgyhmNEh3MIH7Z2TFmhcSJleHYPlMO2VGJ7kbgLbx3dueIaqAx4qHfu7QryO8yR9GmQCScTzZWzMQYsOrPdnVWzLLD5qYAsAFL6/QRwM+aeXoEmz8V8qGLIejA79050SaF0r/I/DP1EOvkE+OS6+hMUV5nHSdRZM7eOs1m0GYP059PY/mSRtDLbCk2bC9oZP77FBt0LabVK6s47Aoj8Aqb8oHpA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01420493-111d-4b6c-a8df-08d8848eee9b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4390.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 09:07:50.0856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ek4E6Q3cz9tQ4bouT0F9rtaq5CFrtdfOiCxnY7GNn3F6fkv403WL/mH3CsR5w/TBb+4WCYFdqPlF/kIW1/tH1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4660
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

