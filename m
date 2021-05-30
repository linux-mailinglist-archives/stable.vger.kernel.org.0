Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEFB3951F2
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 18:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhE3Q1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 12:27:20 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:49278 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229683AbhE3Q1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 12:27:19 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14UGPEmD026430;
        Sun, 30 May 2021 16:25:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-0064b401.pphosted.com with ESMTP id 38v7a6g549-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 30 May 2021 16:25:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyvVllXyNYEdnBMJsW61Du8WjbDEZ48DtIqjwD/ICGUO7YPdyLO9rM+utBdl1HPmjhtvuja0zn0OcKSjcZYrlQ7Kao10NudVv0Z/yfkI+t5dHgHh93blPBZSyXqMHe66vxdEqhKg4UC8CQlHSNy+BSJRmZq/iXh6QZub2MZ4i04jm/P0yItt6AjIqVxCqRem8/9gSj+D4tCVJ+2pHDVEej+x0gCnYES3ckEwT9cAfXsOZZqrMZxl6lodhc4eZETOTvpprVccnclesPKygVBuM6lZj9ic0ErcHIsZogOg4MuBms29AIii5hkAuc5QLv1OW0v2HiCwgIrly08ewWWuag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kaOpTkHzVeXIczbMbpVHlmh6G96LVX4fznmbFAyf/U=;
 b=FBMO2o8iF16Ee0iZUZ0FuRK4s+eVCKIe+Ym75nDZtjiPRFJ1B1YFN3jQZzehHRh49bPXjsoJqQOC5B8fBxSWLfOJVmk6GeQOJ9YMhdAHjdWtjMfffFiCHbxYmB5rIs10X+3HYyF6MvmVYMqUpI+eCNyffLOE40Ma/Up/CaOJezzCvjYc4vKMRDFrdhXeWeXXSg+sf7fKuYbZxITt7d/h4QMLMSEnhnNNMfnHQagoqOSYE4lXkkYv8KpOpH3zjf6NqXfjW00B24zIjxE28EBa0NduMujiEHDrGc+CfJI1qI0AF5hoVRuCMGftv0vFMSC8eXSqhvP3tvMivrgVEQD2AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kaOpTkHzVeXIczbMbpVHlmh6G96LVX4fznmbFAyf/U=;
 b=kOtzHrV7gMjqGY+eveul6KDJXlREKhOI56Gd56GDKXIiZ4jpJ1M1QmkZ2OxtcAIgygKA0EWqgSVQpp5Jj9+bHGcIOCFrcTRgc2t6vRCxXmaHq/04Xwwz3gl+O6aiBh4xKzFUsxsQvQC7WSAWIiFn3CobZnfmBNTvKuAlbqQpb8s=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by DM6PR11MB2633.namprd11.prod.outlook.com (2603:10b6:5:c0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Sun, 30 May
 2021 16:25:14 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::1caa:f0c2:b584:4aea%4]) with mapi id 15.20.4173.030; Sun, 30 May 2021
 16:25:14 +0000
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Garrett <mjg@redhat.com>,
        Michael D Labriola <michael.d.labriola@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Renninger <trenn@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable@vger.kernel.org
Subject: [PATCH 3/3] x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions
Date:   Sun, 30 May 2021 12:24:47 -0400
Message-Id: <20210530162447.996461-4-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530162447.996461-1-paul.gortmaker@windriver.com>
References: <20210530162447.996461-1-paul.gortmaker@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [128.224.252.2]
X-ClientProxiedBy: YT1PR01CA0011.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::24)
 To DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yow-cube1.wrs.com (128.224.252.2) by YT1PR01CA0011.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Sun, 30 May 2021 16:25:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72177895-a052-4dc2-72ba-08d923878143
X-MS-TrafficTypeDiagnostic: DM6PR11MB2633:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB26332142639DAEB70707F68483209@DM6PR11MB2633.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LRiY4XuowNM75f0QlN2b+4hRa01Vn06J4T+Mi20YLVy19ejH+Qb1U+1kes/TVKpMd5uFvtRwZ/gjPU529XwcEnV2sdpz4cs6NCs4asAPQMcxX+sg66o4ycMeuHo4hF/pEJ6876pV+Mcn/sbVwcnI8ZzQhLt9P7PoxPtnOf9kR8hpn7HWbn0hVUMiQXJwAwrWv9E75mWuuEojEg/3SwZ/tjGPFU6OvvTZMgMizjg6YoF48VU2/dH+kE66N0QwTl4v6L9F0NPYQJw7/vYGBBobjpuLQ4Lhg1N1Z5xIXK5ybiqcWbRwJ7qn2U6sEgraSnXuR+xOQnlJ38kLU5bIZJjuV2MnQ3O2eXSXbcBOjiyxN7iNPBVJLm2UYauNQnprFnGafXxXmw8XEPbDgWkOIj7BhyWA2g0kp4f5qPmCqXvI5r0p7ni3R9Cqw5ly5fvh/b33tmLvYq8OyHgbU4tVAAQ4WMLcY40iaNDZrWWB40xJ9jMRWYl8P1Prn8NY8qts+OhFVfce4yvFY1wbZzIowUIGq+oym9pbUfRtmRpfIdBEHX4l/7xEBSAsk9Jb2+lW4YR8JXX2MuYph6z37fEEjBhS3v4kYq76rJc/KywRtDyJElQg54Pc/LyxiG8mVUo9iafkfv290C/hWRWkEc9dOEBVzedoDOWJGDnn6n72CT3AWdsIxZ6km8W/NG9t767LW/F1oUUeboftq4HWeygzGnhRUMP4ZJDapR2jrZRvPsaYeF3hdxQln1bhyk4z9B9bh4+oAPXIXALRSbgDHKhXQlORJkTgR6brr1ahi1MJ+OTjplv/9cswIBCl0uGHrHZzg/vWirUJ3PIeD2AFsIDtTTKFPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39830400003)(396003)(4326008)(8936002)(7416002)(8676002)(6486002)(6666004)(478600001)(83380400001)(956004)(44832011)(2906002)(2616005)(1076003)(66946007)(66556008)(66476007)(16526019)(38350700002)(38100700002)(5660300002)(316002)(36756003)(966005)(54906003)(186003)(86362001)(6512007)(52116002)(6506007)(26005)(460985005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tYDv4UOkt3jC5pimaV1KcVDflvOFC43+Wl0y6iddEUJxBeHWWMhV5dft5Pvh?=
 =?us-ascii?Q?TjithT7uZa62zJx/zWZSOVFhVWSNh1GyAWoQ17kVNMXZx1a8EGF+23g7QnXv?=
 =?us-ascii?Q?Ihm5KM1VS9rhFCF0Xkn5p1qIwVZdAI1mKvWWfLWeMU6h7A3ru600puonXO5Z?=
 =?us-ascii?Q?aABNE+OyYFDEJKKyzjiAVSxtzA1S6fHULiKwTf5gsBiNH3EMmPFyPfLOcvmf?=
 =?us-ascii?Q?NQPFLIPM74pewOFOVGv34SiBwBVH2F3YA56vfbyWmH0eRIfq9Ac+b5CXTb5g?=
 =?us-ascii?Q?bEe3mDFh+QPOCOyVjgP5DnlzyhJHoCoADvIqbKMCRW9QlNgypzhsH6CJqbOA?=
 =?us-ascii?Q?2op1Qds7I/4uYZaqdr4RLj4EhBuQFA3nhYuZ4vhpVxpCOWjy0XMBL23EG0W8?=
 =?us-ascii?Q?9ITgC0SJalJuiMlLNIsVkggFqZd4yKoRsc0HXdHpiPnviREvMXhbGUazY6ti?=
 =?us-ascii?Q?ScQoY+HiaM6BP1k8TjcxUv3kqTMsKyZcUzsWEcFTnQrK25Aku7zK5yBdLrul?=
 =?us-ascii?Q?5ZS/FO8+i8CQaIiOrMK9FqeUysZatXPzTIMtCNluRHAO9tNJpuZnIdorDdIN?=
 =?us-ascii?Q?icPOTCSSVIOChR1ZeKFzqS5zrKYPEf9rzMkGJJBMo+FPy49HkC6Y7fb0o3ih?=
 =?us-ascii?Q?NzN+mgBcDkSxLMKZUVlPeZtblYsI6Kt8ToKuNaSV9wJbqEFaJnoho/MhVECs?=
 =?us-ascii?Q?sipF449LNKIa7ka9VwfS0nXydsHNYE8lAr8lze6AF76+SfI7qG1AR3WFl17K?=
 =?us-ascii?Q?bnu8n0L/+skE6ESgJWdQz4v69AHX/moJD7xmw1zcO7Rercj4ALyQmLYDSzpV?=
 =?us-ascii?Q?gWQmAyKtJ2OrMb9+6OorGwL+NP6ayAEuG9CHV4aGRPNr/Nr/cn+NgeWqT3Z2?=
 =?us-ascii?Q?RYVeOHeoD1DAg2ad6HXS4Zw5reb1wtA0akTl1okW8kwcyzkWwbmPIuu+gvh4?=
 =?us-ascii?Q?+kcW8C3sugStDyn54Fmhl+PBKdxnfVDVTgEV7zfMes22vTg1yoPWzwy5eeyI?=
 =?us-ascii?Q?gRbOy+8rL5y+fOVZQ5YueBuLzeGFL3j9UVONxqtJimCkANz/eCY7fcUgzIY0?=
 =?us-ascii?Q?wazbgKjhXWuMSF6yX5OK11dOcCuVBedayPW22vv4HooNr1sydYWMzmHvr+n/?=
 =?us-ascii?Q?03ADVwH7qE7E+8EEgufIWANTAyhPALkU60kCq3TWjTgmN+IdlJ/1RjL9/0FW?=
 =?us-ascii?Q?wfsTOiQN4KkZCEHWyF+WIY8lmo1ASlSQYWPl41dp7sK2YiksKT5vymkI0dFL?=
 =?us-ascii?Q?K1EzjMQJY8AgbYbdPPHFQoUvjC4w7IIssLeYCwuJVFhASePD+vS/rxM2VM0O?=
 =?us-ascii?Q?S6YAR/P68U4QgH7pqKj60t3L?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72177895-a052-4dc2-72ba-08d923878143
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2021 16:25:14.7228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jKjvcretveBCPdSA13fyK/hTAfH6xtvzy528NmFL8Zm4l2nM/X1K5Babo/fECQJeg0sj38p1c4A0gfEut5bNBKMXJgcyz+H5nb5qC156hCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2633
X-Proofpoint-ORIG-GUID: Jda7Mxq5y6wpjj86zY7eMIJ0j8MGYfds
X-Proofpoint-GUID: Jda7Mxq5y6wpjj86zY7eMIJ0j8MGYfds
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-30_09:2021-05-27,2021-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 clxscore=1011 mlxscore=0 adultscore=0
 impostorscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105300128
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When this platform was relatively new in November 2011, with early BIOS
revisions, a reboot quirk was added in commit 6be30bb7d750 ("x86/reboot:
Blacklist Dell OptiPlex 990 known to require PCI reboot")

However, this quirk (and several others) are open-ended to all BIOS
versions and left no automatic expiry if/when the system BIOS fixed the
issue, meaning that nobody is likely to come along and re-test.

What is really problematic with using PCI reboot as this quirk does, is
that it causes this platform to do a full power down, wait one second,
and then power back on.  This is less than ideal if one is using it for
boot testing and/or bisecting kernels when legacy rotating hard disks
are installed.

It was only by chance that I saw the quirk in dmesg - and then disabled
it to find that it wasn't required anymore (BIOS A24), and a default
reboot would work fine without the "harshness" of power cycling the
machine (and disks) down and up like the PCI reboot does.

Doing a bit more research, it seems that the "newest" BIOS for which
the issue was reported[1] was version A06, however Dell[2] seemed to
suggest only up to and including version A05, with the A06 having a
large number of fixes[3] listed.

As is typical with a new platform, the initial BIOS updates come
frequently and then taper off (and in this case, with a revival for CPU
CVEs); a search for O990-A<ver>.exe reveals the following dates:

        A02     16 Mar 2011
        A03     11 May 2011
        A06     14 Sep 2011
        A07     24 Oct 2011
        A10     08 Dec 2011
        A14     06 Sep 2012
        A16     15 Oct 2012
        A18     30 Sep 2013
        A19     23 Sep 2015
        A20     02 Jun 2017
        A23     07 Mar 2018
        A24     21 Aug 2018

While I'm not going to flash and test each of the above,  it would seem
likely that the issue was contained within A0x BIOS versions, given the
dates above and the dates of issue reports[4] from distros.  So rather
than just throw out the quirk entirely, I've limited the scope to just
those early BIOS versions, in case people are still running systems from
2011 with the original as-shipped early A0x BIOS versions.

[1] https://lore.kernel.org/lkml/1320373471-3942-1-git-send-email-trenn@suse.de/
[2] https://www.dell.com/support/kbdoc/en-ca/000131908/linux-based-operating-systems-stall-upon-reboot-on-optiplex-390-790-990-systems
[3] https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=85j10
[4] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/768039

Fixes: 6be30bb7d750 ("x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot")
Cc: stable@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/reboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ebfb91108232..0a40df66a40d 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -388,10 +388,11 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 	},
 	{	/* Handle problems with rebooting on the OptiPlex 990. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell OptiPlex 990 BIOS A0x",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A0"),
 		},
 	},
 	{	/* Handle problems with rebooting on Dell 300's */
-- 
2.25.1

