Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F871B6C06
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 05:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgDXDlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 23:41:35 -0400
Received: from mail-eopbgr690136.outbound.protection.outlook.com ([40.107.69.136]:28483
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbgDXDle (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Apr 2020 23:41:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gufJJuqGp+hZzcn3zGeYhKQjOaVS/2X0PDQxZe2GfjmexFc3m8jpxT5BcXrDSJIpcoValpkKGAoa8WOXqYkuaVgulMQjfWG6OKiTcMP7Nyr6I5oTP45a7SmambKjQXs6DPvJ+0XxPlderXZ4cAva/akY6zUVKzsD05+TJ2e9RPuwHdo1WQzuhSv0hSjJdNPfj+SG9O41p7MZlfIrNtVdJ2i0tO/v/HIQQNN5PgyzilSSVaT7vm/kfl1HPSmO6NZITViChfsvWQRiuIaO+kP41cM6RTiThlCHvB2mbCmdmk2Yz9iJ9rSql/dkCCEAFK+NQsKJzVtO66ZoRIf95jEwSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4+x0rFTlMEwx/m/YZNj5dLTyDjpQWSM9I7tw2XEP+I=;
 b=TcH7WofYzEwdwV/K7DaHxylUkP2eZGTPdCFquY3V8V+yjsdut+OVT6Wg9I6T3g8rmY0gBRoQZ21pQoeProncyMBzRTX7zp5WkrwvKiKv8BFUSy3pVedYp7DRRoxkoel07WqoHFDNdeiowIF6a3L2AstNcm4bCEW/GPu4mKqmST9GRCY5mfl67l7olL8Emq9tWQfcuiJXbdlfLUQVVZD/mXNm3SYYCxdJCIrcFTsOpzo9SsHuCdUZCjGaApVixBX1bGlFb0Ibws6wnPnPljGdUglJeHUk03e1J3aKFdd9ODj1RtD+Hoi5jCagGiGznEmDGKNyKFZ2S1dQPqt4n1hy2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4+x0rFTlMEwx/m/YZNj5dLTyDjpQWSM9I7tw2XEP+I=;
 b=c7tcPnl+awPjrfMiHxeWO4baeTfrfO6k7Qoguu711miDb316+fZVJG3eyTiZzUjzC5VQZ/Aqx2syHZkbsgGT3IGsZgbjH2jfSVqqUiBk9eKGWl/baJAR++bEIKilj3gxaeBky/tzH0MJNJzlDgg3H4hyMXktFc5TOooKTm2TMgQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
Received: from BN6PR21MB0161.namprd21.prod.outlook.com (2603:10b6:404:94::7)
 by BN6PR21MB0740.namprd21.prod.outlook.com (2603:10b6:404:93::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.2; Fri, 24 Apr
 2020 03:41:31 +0000
Received: from BN6PR21MB0161.namprd21.prod.outlook.com
 ([fe80::171:e82f:b9f2:3a68]) by BN6PR21MB0161.namprd21.prod.outlook.com
 ([fe80::171:e82f:b9f2:3a68%13]) with mapi id 15.20.2958.010; Fri, 24 Apr 2020
 03:41:31 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     linux-pm@vger.kernel.org, rjw@rjwysocki.net, len.brown@intel.com,
        pavel@ucw.cz, bvanassche@acm.org, mikelley@microsoft.com,
        longli@microsoft.com
Cc:     linux-kernel@vger.kernel.org, ming.lei@redhat.com,
        wei.liu@kernel.org, sthemmin@microsoft.com, haiyangz@microsoft.com,
        kys@microsoft.com, Dexuan Cui <decui@microsoft.com>,
        stable@vger.kernel.org
Subject: [PATCH] PM: hibernate: Freeze kernel threads in software_resume()
Date:   Thu, 23 Apr 2020 20:40:16 -0700
Message-Id: <20200424034016.42046-1-decui@microsoft.com>
X-Mailer: git-send-email 2.17.1
Reply-To: decui@microsoft.com
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:300:4b::20) To BN6PR21MB0161.namprd21.prod.outlook.com
 (2603:10b6:404:94::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from decui-u1804.corp.microsoft.com (2001:4898:80e8:9:d9f1:f6e4:3d4b:68b4) by MWHPR02CA0010.namprd02.prod.outlook.com (2603:10b6:300:4b::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 03:41:27 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2001:4898:80e8:9:d9f1:f6e4:3d4b:68b4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8411dd9e-86cd-4acb-82f0-08d7e8015f8d
X-MS-TrafficTypeDiagnostic: BN6PR21MB0740:|BN6PR21MB0740:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR21MB0740AC41EA2537272FBC5C96BFD00@BN6PR21MB0740.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR21MB0161.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(316002)(66476007)(186003)(966005)(16526019)(6666004)(6486002)(7696005)(6636002)(86362001)(1076003)(82950400001)(10290500003)(82960400001)(5660300002)(2616005)(478600001)(3450700001)(66946007)(8676002)(52116002)(66556008)(8936002)(4326008)(2906002)(36756003)(81156014)(30253002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xBFbPlApz8WJGl7u+xkp8F/H1jXu9xg5dmlqr7tXPElA6lreqFRghjRuOioyueiaJxDhR2OtAdVuTtwx59ufq9jnBBVF30cN96omR8EKrdvbYMGqsDUYjP+J5nUBQqE1DTPNeCw86WczYN055nSTL9JzkBz0IilZGDYggqnoSnhNsa5O8e95ttrrcKXHv7/au4nF2XxYwAnwmnG8ChhchLoQx2J9OEVkYZyM98UH5+GT3TbilaK1sgV9hdEa4V2NJGZybp32BITpNQvSh/gdXLxnSrq1IebjsZmWOiKoPpZbGa1JfpWNpq4GJFJ8e6ln4GlO0T4tr+juCg03i8FUPquRsWl1US/bamR3E2IUygupBjFWGxaM9KV4ZyAb3eFzPrakHwbnK9Dy8aNM4LsxRoKVEPIXvnW7IM03jLI99LH+hUY/9E6zNUC6YsBTYmZNqozFuUoUgZVu9RPUiS3LjifA7khBPBP8AkuJIbx9ua1xaf8nwf8QuuXXuh1etop+9aN6XcJfrXRJsowco0t5MMBUo8bBlBcsp6Jr5TVk0AU3ZYzIAe8csdI9jqTo8QMa
X-MS-Exchange-AntiSpam-MessageData: B7XKrctR7hm9XbLgAhwUsJZyvNXYFnzw0c17uGIvAbmEjLL7pv1ElhbRbmRPtYv9UOlUGVkl/tDOA56qeMpmuTINZ+AvHzlSDi9Gk8G3B2xIBHReVTtQSItcBhBFzAelRATVDNr9TJBE8VbIdgjFn2d6H8hV5NvySy9zvRqCnjQHtbSDug8Dx13U9gXyH+3nQO9Xfuqw7fRM2Uk7ceDjN6+lNNgfqPhwmv7m8lL9k+XKUmeboQhsyNrNcGFf4x6Tsst02RRH58ZfM7eWlITl6zlfi5mCb2RyogqVeh9NZws0JuTVcdJWosKvubMAA1EUZF//KA11KkCpXxt35tGA2BowACu8aAilWIz4eAIPYp1AL77MYp7SGDPQS+MaMNR67UrZMW8pG3edkD7qx6se0CG7UXigp0A7gQO+/o5olr1mY3zbfuzDvugAULWpZrZ1c0nKybP/pgCVaF59cO11dZjVuidfyEVyQVJbgGtlKoZo2jV9ap964ijAL9wonelSO9NfmEMW6fBSVp2NIbfloQ1uWjdAE21zRwAda3TYP/KHKz46EuYJ0SzvE25Waqdv+GIV9+C9BG7jRrCQy4Qo1d7jy8dVMZwbOWFVCPIAeusMFqjVHJFriNYDrSvB8Y4xxoSNy5Sp4ozdol5VJhO33CUKqYD74dCYvW+lvA4mBh875OiRdF1wNoJL1reneWnxRwfwNHv0TOl0cBpuwszVGWEPsCJOJf7aFEVbkwhM4hBqZr4kwI6KABnwji9Qvrq1GLJwNeR6752qZbflYxxD0MPXTeWxjYLl/ZREaE92P/2lFgtZXLDhiK6EfxV64jrBGj9uCMoGiTEwcxUK/eGgXnkagTdvgTSGff3t3jZlojk=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8411dd9e-86cd-4acb-82f0-08d7e8015f8d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 03:41:31.1076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z71R9MWpgbIOxfcjPEDz14zEDIv3lSwokxMBZddM7XdeiO3KZkbnQmjwVO6P2ivOFNtbU9XZ3wHqUrbwc4524w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0740
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the kernel threads are not frozen in software_resume(), so
between dpm_suspend_start(PMSG_QUIESCE) and resume_target_kernel(),
system_freezable_power_efficient_wq can still try to submit SCSI
commands and this can cause a panic since the low level SCSI driver
(e.g. hv_storvsc) has quiesced the SCSI adapter and can not accept
any SCSI commands: https://lkml.org/lkml/2020/4/10/47

At first I posted a fix (https://lkml.org/lkml/2020/4/21/1318) trying
to resolve the issue from hv_storvsc, but with the help of
Bart Van Assche, I realized it's better to fix software_resume(),
since this looks like a generic issue, not only pertaining to SCSI.

Cc: Bart Van Assche <bvanassche@acm.org>
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 kernel/power/hibernate.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 86aba8706b16..30bd28d1d418 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -898,6 +898,13 @@ static int software_resume(void)
 	error = freeze_processes();
 	if (error)
 		goto Close_Finish;
+
+	error = freeze_kernel_threads();
+	if (error) {
+		thaw_processes();
+		goto Close_Finish;
+	}
+
 	error = load_image_and_restore();
 	thaw_processes();
  Finish:
-- 
2.19.1

