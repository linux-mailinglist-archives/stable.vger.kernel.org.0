Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4A262218
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 23:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729741AbgIHVsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 17:48:43 -0400
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:56954
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbgIHVsh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 17:48:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpD5HnSkO5rIr567Xm+1wo9OR0Y7eDFonLBDz6n4SmhsCjglTE1gnRGKFwQd/NtBU9QvbXm57aAa1V/PEb9WSHMKNQrcASSOpI0YLehtR/9qOexX8QVF8Q5u7cTv3MMdxgS6dF4KAa5YvKu0Tu28bmuxU9gELROoLszLGU7Rxeell2NhOEBVlhV3wgDhM68VBsXZp4FaFUbLx91gjrC+sOK32E3vyf8r86w5TA3hnqXxv5KTNwgsrxX0BO/jVEF3HLYDSOyuyDb++RfThfJGWyDHxJqkjvqMejAdu/QS7u8HWf7TaFw5opPVJ75HSHT+nLHtfGQe5aBhF3z5Srpikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ggWot059eRVohE/cNcVAQIToD+p+Gj+HvAbFM8efco=;
 b=ZZqP8HHIR+QBpieBpVO8D0vDIJw2n7+2O6xDnqosIMNKOSSQKr42NrDFdne7ky0kgbP+ibd4rpmnSIrobOx4tTFgCwZNXFtUIgIYvDYEyC6jCwq/OEx84ioZl2Y3TBfFqDIfuJPpYXxYRZUq+aspz/qSB7JZ0iKcCi3oLShCwBf32xgm+AdrPlY8E2mv869mgf0Zdf/t87AUN7LusNf5IW9MC+9I0U4smBpgHcQNgnrLSJ6M2SAUjxqBo+J06VJxU+yQseywMxAyadRf1zZP7QnNDrxAfUz+VfvAIp126nz0WmIyBtlHHcKKyuMT29MEAKd+nmlYyeLvWdM75s43pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ggWot059eRVohE/cNcVAQIToD+p+Gj+HvAbFM8efco=;
 b=2mQ79EHCcAEWCC/MafsfEiV89HyMTC94RzNHhorXBf106U99unQKlMmAOerCCInHL1h3RRHt3Eh4eoeefOkNJZAsg6Ms3if7vhJh8T5nEBD9Lxq7zRCgXVkMj7+dFTVcQDFqiSUEZS8mDF77m7a0SoU8l2E8pztF5vDcQ7riYKU=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB2946.namprd12.prod.outlook.com (2603:10b6:408:9d::13)
 by BN7PR12MB2593.namprd12.prod.outlook.com (2603:10b6:408:25::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 8 Sep
 2020 21:48:34 +0000
Received: from BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6]) by BN8PR12MB2946.namprd12.prod.outlook.com
 ([fe80::a92d:18c0:971b:48e6%6]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 21:48:34 +0000
From:   Kim Phillips <kim.phillips@amd.com>
To:     Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kim.phillips@amd.com
Cc:     Stephane Eranian <eranian@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Stephane Eranian <stephane.eranian@google.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 3/7] arch/x86/amd/ibs: Fix re-arming IBS Fetch
Date:   Tue,  8 Sep 2020 16:47:36 -0500
Message-Id: <20200908214740.18097-4-kim.phillips@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908214740.18097-1-kim.phillips@amd.com>
References: <20200908214740.18097-1-kim.phillips@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0067.namprd07.prod.outlook.com
 (2603:10b6:5:74::44) To BN8PR12MB2946.namprd12.prod.outlook.com
 (2603:10b6:408:9d::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fritz.amd.com (165.204.77.11) by DM6PR07CA0067.namprd07.prod.outlook.com (2603:10b6:5:74::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Tue, 8 Sep 2020 21:48:31 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5ddc8a2a-bc16-4e59-ebef-08d85440ef35
X-MS-TrafficTypeDiagnostic: BN7PR12MB2593:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN7PR12MB259373535565EE758CF1A6EB87290@BN7PR12MB2593.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOJHb3DUFPhZJPOP7oV79gpKna7XPKQsZ2WWcanvoaL+yl6lgfzakhLOUJoPxhqOZvgCR6NLysF2CEwkqV/92iAZKFwllIzg2uKFO2f7nGwdJl4rsntK0M6HwPXJr6x1nH+F+v45elrzY9lJ5IiOWrCBJPn9Qswh6/KfwB7Dxj9vfreStaigAY9OOr3PEWuAttN2UJk038it9M5wy5VKmfbMlqcfgt5CIt5T4lg/k5EJnbGVLHccoNpe0AGQwLNFNQ5sIpqlAihSbu6eEHKyg64/KcsEISAncQh6ewhqSXAuTLG0RsOJh2mfH1bXX0O/JfE9/mYyGT4YBIdzrob1abX72WnE2XqmbS14PSBM26FWGVW004GbBojjKTd0y9xL0OhirebcioIjPK24zPtGWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB2946.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(7696005)(52116002)(83380400001)(6486002)(44832011)(956004)(2616005)(86362001)(7416002)(478600001)(66476007)(66556008)(66946007)(186003)(26005)(8936002)(2906002)(4326008)(16526019)(8676002)(966005)(316002)(36756003)(5660300002)(54906003)(110136005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: VUwDx0+kv0VTum36LMRktHL5c/bRJU7HgQLqVPsaHLLG63hABB+83adwptTlz0AAPCoCeqG42LL5TFu4SsmsEnxsC0GU6L0KqC7HifVFKqGXO7D/EuZUjuSPHay2C3EhPAUwLhTvqila4DGX406h6wKj/rg/vBA4Vr55bfvtS3sqWwv3wJLfGFI5k7MhWIBj8Qwzoc6fPPP+D479HsFmyKCEzGapZygpgD/ZSgAtuPMCSdellsmZA/+3hxpRX2g7btdK7JMsyMZXKzmlrvpOKQNusQiqgmknZDBJWNQqXg2Hl8EMpKywoqjZ7FE0ydR3nkBZ0kzwbVdakLEcQJ49/zYUzwU1dU3woYqky16HFxtGzDDdQOQdhfP1kWwMJ0skzxZEB3Zas36VYTHuGR3olioAuHCPcBEQmXMS8Vpewg77PgnGn6nE/CFQebfkK/3NGawvs58UBFoQ4EoML6KR9hv7n0Mlk8tBEnV6hmZAtDZnMCZtNi4Nu87VCFImb/AEMWD1nFaJBjAkNYc1ssCPxYQpN+bQ0OggLLU8hCaV1LnNPryHVtsIb+G87XLBf9VYI41h6kKqfuk+oQB1giOa7198qq0eumyJrbNc3nsCNF0esGggdCPK6QV2BGPisX0mqBoXaThUcLFszM0v5ScYaw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddc8a2a-bc16-4e59-ebef-08d85440ef35
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB2946.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 21:48:34.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skdl5Emanwriwljim5HtfiXewesnYw8yt1o6DsqdvU1056Ei1mEYPzDbK4JiDeBc69P0LL5Yap51bVLFL6BKVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2593
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stephane Eranian found a bug in that IBS' current Fetch counter was not
being reset when the driver would write the new value to clear it along
with the enable bit set, and found that adding an MSR write that would
first disable IBS Fetch would make IBS Fetch reset its current count.

Indeed, the PPR for AMD Family 17h Model 31h B0 55803 Rev 0.54 - Sep 12,
2019 states "The periodic fetch counter is set to IbsFetchCnt [...] when
IbsFetchEn is changed from 0 to 1."

Explicitly set IbsFetchEn to 0 and then to 1 when re-enabling IBS Fetch,
so the driver properly resets the internal counter to 0 and IBS
Fetch starts counting again.

A family 15h machine tested does not have this problem, and the extra
wrmsr is also not needed on Family 19h, so only do the extra wrmsr on
families 16h through 18h.

Reported-by: Stephane Eranian <stephane.eranian@google.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Cc: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: x86 <x86@kernel.org>
Cc: stable@vger.kernel.org
---
v2: constrained the extra wrmsr to Families 16h through 18h, inclusive.

 arch/x86/events/amd/ibs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 26c36357c4c9..3eb9a55e998c 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -363,7 +363,14 @@ perf_ibs_event_update(struct perf_ibs *perf_ibs, struct perf_event *event,
 static inline void perf_ibs_enable_event(struct perf_ibs *perf_ibs,
 					 struct hw_perf_event *hwc, u64 config)
 {
-	wrmsrl(hwc->config_base, hwc->config | config | perf_ibs->enable_mask);
+	u64 _config = (hwc->config | config) & ~perf_ibs->enable_mask;
+
+	/* On Fam17h, the periodic fetch counter is set when IbsFetchEn is changed from 0 to 1 */
+	if (perf_ibs == &perf_ibs_fetch && boot_cpu_data.x86 >= 0x16 && boot_cpu_data.x86 <= 0x18)
+		wrmsrl(hwc->config_base, _config);
+
+ 	_config |= perf_ibs->enable_mask;
+	wrmsrl(hwc->config_base, _config);
 }
 
 /*
-- 
2.27.0

