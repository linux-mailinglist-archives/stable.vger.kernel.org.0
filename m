Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0015A6A7
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 23:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfF1V73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 17:59:29 -0400
Received: from mail-eopbgr800045.outbound.protection.outlook.com ([40.107.80.45]:55968
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726537AbfF1V73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jun 2019 17:59:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNws9qrzj9SfSTMUPblXo4+WxKzyxDlQTpUdCQrEFps=;
 b=MKGjpsS62GpQAKrRakQfXyrGEHAxNGK/0iJS0Z3yfMr5JLjBr1XVjYO8ZiPBv0Y4eGfM3GfFQMj4a2U5RMFDmpHXgvBjUpg5Z4/9WjhYy2UKEjbDCZ9TjCRPSFcGPO5IZIix3rlcFDd7eD0Zsv7n/1o9OW6XHA5MB/45FIZ06Sc=
Received: from CY4PR12MB1798.namprd12.prod.outlook.com (10.175.59.9) by
 CY4PR12MB1285.namprd12.prod.outlook.com (10.168.167.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Fri, 28 Jun 2019 21:59:20 +0000
Received: from CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44]) by CY4PR12MB1798.namprd12.prod.outlook.com
 ([fe80::38d5:5f22:2510:9e44%9]) with mapi id 15.20.2008.019; Fri, 28 Jun 2019
 21:59:20 +0000
From:   "Phillips, Kim" <kim.phillips@amd.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Phillips, Kim" <kim.phillips@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Martin Liska <mliska@suse.cz>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH 1/2 RESEND3] perf/x86/amd/uncore: Do not set ThreadMask and
 SliceMask for non-L3 PMCs
Thread-Topic: [PATCH 1/2 RESEND3] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Thread-Index: AQHVLfy8rktZfr6s2kKTZOiVCdKwUA==
Date:   Fri, 28 Jun 2019 21:59:20 +0000
Message-ID: <20190628215906.4276-1-kim.phillips@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SN1PR12CA0053.namprd12.prod.outlook.com
 (2603:10b6:802:20::24) To CY4PR12MB1798.namprd12.prod.outlook.com
 (2603:10b6:903:11a::9)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kim.phillips@amd.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [165.204.77.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f50765d-2ed2-4e71-7792-08d6fc13df2f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CY4PR12MB1285;
x-ms-traffictypediagnostic: CY4PR12MB1285:
x-microsoft-antispam-prvs: <CY4PR12MB128509CA9A88D17B08DF949487FC0@CY4PR12MB1285.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(199004)(189003)(2906002)(110136005)(486006)(71190400001)(8936002)(186003)(71200400001)(25786009)(68736007)(7736002)(3846002)(45080400002)(81166006)(81156014)(6116002)(305945005)(5660300002)(7416002)(66476007)(64756008)(66556008)(99286004)(86362001)(8676002)(50226002)(1076003)(26005)(14454004)(316002)(36756003)(478600001)(66446008)(66946007)(14444005)(6512007)(256004)(73956011)(102836004)(4326008)(476003)(66066001)(386003)(6436002)(6506007)(52116002)(6486002)(2616005)(53936002)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR12MB1285;H:CY4PR12MB1798.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EFsiWkUcenNiXTGVvEudfCWi49hiezQFClxjAbhdj7rIg39NbziV5aj+aNm8Q719xP28N/ghKKgjnOmRnsnAQfpjF5m0jY/ovikaGLQ26Y35JPh7XYaSjzy74XkCuB354SGDpwMuWSxcKixDMJMhWEd3f2PGWQmE/OVcTGEHDZtVo6YlFrzgSAxSfOEgT6/hux9RB6dM5aRkHCUeDWeQ0ZiWGzfnEYMHUczqPMOGGtV1NmJ3eICDSp9NrttlYarPCUfT/5kao2MaScFPsqMYwMECNmIKVVibBjvzR/rXTKMnQFMtlDZxOzUSu2I+x/PYft9Luiya7yzJx0lSWF8weUp+R87YHrHQIp+XKdYlX4FY1KCgLcK1OLIUWDJi2C+19mfTN0xFpt7aZPcc5PKsuRQww7I7MIp6zjRvRdr1FQA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <574048C5DD2DF841A1EE743DC603461E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f50765d-2ed2-4e71-7792-08d6fc13df2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 21:59:20.1034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kphillips@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1285
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

Commit d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask
for L3 Cache perf events") enables L3 PMC events for all threads and
slices by writing 1s in ChL3PmcCfg (L3 PMC PERF_CTL) register fields.

Those bitfields overlap with high order event select bits in the Data
Fabric PMC control register, however.

So when a user requests raw Data Fabric events (-e amd_df/event=3D0xYYY/),
the two highest order bits get inadvertently set, changing the counter
select to events that don't exist, and for which no counts are read.

This patch changes the logic to write the L3 masks only when dealing
with L3 PMC counters.

AMD Family 16h and below Northbridge (NB) counters were not affected.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Cc: <stable@vger.kernel.org> # v4.19+
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Martin Liska <mliska@suse.cz>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Gary Hook <Gary.Hook@amd.com>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: x86@kernel.org
Fixes: d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask for=
 L3 Cache perf events")
---
RESEND3: file sent with header:

	Content-Type: text/plain; charset=3D"us-ascii"

to work around a bug in the Microsoft Outlook SMTP servers.

 arch/x86/events/amd/uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index 85e6984c560b..c2c4ae5fbbfc 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -206,7 +206,7 @@ static int amd_uncore_event_init(struct perf_event *eve=
nt)
 	 * SliceMask and ThreadMask need to be set for certain L3 events in
 	 * Family 17h. For other events, the two fields do not affect the count.
 	 */
-	if (l3_mask)
+	if (l3_mask && is_llc_event(event))
 		hwc->config |=3D (AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK);
=20
 	if (event->cpu < 0)
--=20
2.22.0

