Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBCB383B86
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 19:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243077AbhEQRoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 13:44:25 -0400
Received: from mail-mw2nam12on2042.outbound.protection.outlook.com ([40.107.244.42]:28256
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239397AbhEQRoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 13:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N/FZ9Iebe7im6s5Jpueae24SPgx6sLA/JfW+zaA5yAhjkUhvWQKNXk2U0oGKXif1v1GUyoKndW/Mco+4pXkf4rLMkfPnuqq1hR4D+zQ8F8w14+QYFuhWnDU2+k/TrWwyXo7fhVt2CcdgF/heGZBjtmXX0tDF/bywWfA7XhJonPPi2/C1kPAp4EG9og4Z1mTLfgsqz5jb8Wgzl/TwUxFPLBBJiHJ7QeKlyzKO9rg47KkRh1b0NJ7sQCM4WfrHV+kjHyHT8hLjZhUln4rJS6IY7t0YoukivCcOLjMiAaRGRzC4gGGLYBcdtKfMLu3fWRjwG31seGfUniY5MK/bbDPUlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZwQfBM999Vu6CYDZXgscS/dLTuF8XYAMpAaviyyIRQ=;
 b=HJianIUVjBGWteGGnWGBaA+mnWpXkyGVlqCuNMPdPU9ooOQ3HyyYJ168cguyxzsCZKnTMrb0ubqCugdvxLK7wAbVyqyS8CPfLikcZ/aTmFYBcX8GRbJtwu2EIQQpELCQNStHVKHL9xU22NsivZUg0hAC/O130DycFGzkhKrxFk9u8upIqh6bxFYa1/48AMBpKxRAaP3cjJ/jQeNdjDv7OzRA2RyYAy5sRq7mIzfTRvIdId/yIyFr670yP6gT1cHkKwwI5fd1aBs8UldVoxHLu3pleVK5jLlNiIJQaji6+X555Gc6Te8Y18BWIButjRX4QTNq9pqm+H03o2/1RLAGSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OZwQfBM999Vu6CYDZXgscS/dLTuF8XYAMpAaviyyIRQ=;
 b=MxYPpyLPxgZBiE8to5ogp00RRVG6MTwzktUU5J11zuFDZsv1oBOeCTEoBYnW1Moxye+ljDS3wRFUXDgMIDvK5ywhuOFUdYJT0ZZ+s79u4Y79+1h/24PVm0a3CrlIb1cOLdK7EsaRG8NBHvfjR7stwrymVNctLzZSRTrvt6/cuD8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1835.namprd12.prod.outlook.com (2603:10b6:3:10c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Mon, 17 May 2021 17:42:54 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4129.031; Mon, 17 May
 2021 17:42:54 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
Subject: [PATCH v2 2/2] x86/sev-es: Invalidate the GHCB after completing VMGEXIT
Date:   Mon, 17 May 2021 12:42:33 -0500
Message-Id: <5a8130462e4f0057ee1184509cd056eedd78742b.1621273353.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com>
References: <8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR16CA0059.namprd16.prod.outlook.com
 (2603:10b6:805:ca::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN6PR16CA0059.namprd16.prod.outlook.com (2603:10b6:805:ca::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Mon, 17 May 2021 17:42:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96fd550a-31b5-48d9-d709-08d9195b3317
X-MS-TrafficTypeDiagnostic: DM5PR12MB1835:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18350D6494F84A5EE7D55A2CEC2D9@DM5PR12MB1835.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FtN6xhIDGb5FNM1927DnwNxJveueoh4wZ+L8I/fKjMmeqYw1ZBE2PUtvKOI2Wldsz0Ar6WgIRJrTWgMVI6mNmoEaHEZ5rI2DAFiZqnD2VNihFt1pevVv+AFzAiSMRHVcB3Ii9/9mkpQKkQFNAzYmHxmcmUsDki9wpEcSD42Bgd9RJXNmYiQqVPLB8v6y9CHbit+UMmdiuacUOmWyqQYkAW0bwK7lKumcD9kXphvUZzjEKdj/GyLDblxmFTzmTVqQXzJvEX8Re1dXblYu6qajW6zytbj7pv5IaQi+ODS8t7r44bh9EzHkU38Pb7LAEdIcka68A2K4vw902cKOM+zIonvfzj4oWQ85umM01L2JnM8C65PSWDZTu4tS5+3gFG5SEIdmaiIx2b3oB8palZExmQOZIU0ioniCwXOFQU1RfR9NQJUMw06fN1t0zj+9Xs7OpKVLSiSF+RdLAonhUZGKW03Y7iKjhCLrZL2iCM/wI1ToA/jPegDKUCmIyeBKSBAY8oNPPHIKXezH4ONwVBd9e7zrS25ueKKq0mcZKc+arFoncmyglt+uBN4rTPQIGBwJcnM7tEX2yFIbByDNbrmsY03xov3d5AzFVrOiShZaYfEI7Flpmydc8pK9wTgsPDte/+NCU7Rk+UEKH/Bhz0bS8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(5660300002)(316002)(186003)(2616005)(956004)(6666004)(478600001)(16526019)(54906003)(86362001)(4326008)(7696005)(38100700002)(7416002)(38350700002)(8676002)(83380400001)(8936002)(6486002)(26005)(36756003)(2906002)(66556008)(52116002)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wRtw/7+/vaIWXzKLrjCdLZWUg5CPT6KrcvVBwHBrDEWVVIrFxju4goZHQ5MT?=
 =?us-ascii?Q?I7jz9n5tHaikJtV5hbiBP1lTxwa73S+SYFtiD7YE2+RwljZ65v1aVOwSrpXw?=
 =?us-ascii?Q?ISq+kkiAwPbqIiwc9094wH1u9aA/tiFe7qRPQkXvqSMM7q64gQG6xHw3R+5J?=
 =?us-ascii?Q?cFnhIf5zJ+zpX1nPv5WlHP96fySQOY3e4fO7GV1QMXUaqy7p4xTBuOb4mLZJ?=
 =?us-ascii?Q?OPQnQU2MofF2AVPaKSFEaqHeMnjrteEcj+tGvEFHxdmfwmwx759KOwoBaTAp?=
 =?us-ascii?Q?zUsb5VhHvNpGz2eSP4lDIatAv8MI3yUqGPoAJWbHUVdWUPGJbrfxk4E8Rgu4?=
 =?us-ascii?Q?6sJsbyQKod7a3z0zp5+a87A/43Hdx3o92CS+FC6sg6GASuU5iK5VamtpswAF?=
 =?us-ascii?Q?J3N6tgRkWKxonW7j6g6+6VZ5EHsW+T0dXxQve0KMlAXREppBzJTwb3I0V4Nz?=
 =?us-ascii?Q?0BF+b/Sh8GtOEI32tpx1RoJqlXm0IVD+aOOU9CdT6gmyzuaR9qg+Kxa6+4Jv?=
 =?us-ascii?Q?9BQp+7oQM3y6BZJWvwhuTbx7WIYPQr6kXrynvuya6XdnOLenI8PrIhw8DPB/?=
 =?us-ascii?Q?McuX0QSON/xKM4NxPNKfeOpX0OhTZ0EYhzHNS9aozPKIkikc3jF73LN9nstF?=
 =?us-ascii?Q?tAkDTHvV3RrSfu/1HyGiwUVjNEFYkfubNnPohL30h5kEVyLoHUlVQWaNq4s1?=
 =?us-ascii?Q?pUNrxFyw3RcpkqWgnid/UMH3To6RwGkNoOpmk+rdfGNaSi86cFMp8CDiT/VL?=
 =?us-ascii?Q?xRZBnFMbaK46/PTjVEx0axfScPec2tFQCAnZf/90WkzhnVc77NTO2NvXwSMg?=
 =?us-ascii?Q?VVdMouFHSAA5plRFmBwH1vx17i2P4PiF7dpUYgQxRtBPSbl7neq5b3YY+PYt?=
 =?us-ascii?Q?fV+O/Y1KtF8TmG8+h+B+NiK5eMervuswRu5P6Xd65wtMBRCZOzvFrgyIvZG5?=
 =?us-ascii?Q?Ne7/dyiL83rynL9oAXOPbWysJUXW1aO2cZvGOhVagSJtELoz0xrRDOxRdZTI?=
 =?us-ascii?Q?oR1299MVOmvDFVhAw3g0ClPS0YjqyuHNw5f4TWoJ2hcAkGO9c54bv+gUCJHw?=
 =?us-ascii?Q?0+nhFOwHdqIyi2+roxoAGQtMRLrHYa+2NYQ9mZr7jJsDNZEj+tF5DoPuO0uZ?=
 =?us-ascii?Q?BuxFY1TcNY19IFi/iYJthKNL36Ps8buyhTcQl77e2iBhdEOWqpO5S7M69rNl?=
 =?us-ascii?Q?YPNL6lopkANh1tVZnekeTPk8fknW4w4FIEK61Iub2Dzwdsz0AxS6rZsRX00w?=
 =?us-ascii?Q?SnK8fwhcuSs1z1wPn+OvKu930VABzbxwl014pb7JLQtgv/Eibsp+rnQEfgWu?=
 =?us-ascii?Q?Vkf726SLBMp+xZTkICdrmIss?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96fd550a-31b5-48d9-d709-08d9195b3317
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:42:54.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zq5X+1UtdIqhphNE+NiMxxkYCpb8m2IFe9GxIPVAgvZquxJF8e8V/0IfUHWoJgyjwFy6YvBNOZIvQa5qtaKgcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1835
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the VMGEXIT instruction can be issued from userspace, invalidate
the GHCB after performing VMGEXIT processing in the kernel.

Invalidation is only required after userspace is available, so call
vc_ghcb_invalidate() from sev_es_put_ghcb(). Update vc_ghcb_invalidate()
to additionally clear the GHCB exit code, so that a value of 0 is always
present outside VMGEXIT processing in the kernel.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/sev-shared.c | 1 +
 arch/x86/kernel/sev.c        | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
index 6ec8b3bfd76e..9f90f460a28c 100644
--- a/arch/x86/kernel/sev-shared.c
+++ b/arch/x86/kernel/sev-shared.c
@@ -63,6 +63,7 @@ static bool sev_es_negotiate_protocol(void)
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
+	ghcb->save.sw_exit_code = 0;
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 45e212675811..4fa111becc93 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -457,6 +457,11 @@ static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
 		data->backup_ghcb_active = false;
 		state->ghcb = NULL;
 	} else {
+		/*
+		 * Invalidate the GHCB so a VMGEXIT instruction issued
+		 * from userspace won't appear to be valid.
+		 */
+		vc_ghcb_invalidate(ghcb);
 		data->ghcb_active = false;
 	}
 }
-- 
2.31.0

