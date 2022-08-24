Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDCB59F1D8
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 05:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234686AbiHXDF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 23:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiHXDFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 23:05:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E062857C0;
        Tue, 23 Aug 2022 20:03:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/E+l+T6Q4YzJKTWUeeeofNAz8wQeEil8WUM19cgy7Z59WFbQEsc2YYIwbamIknnkwvQgRmj7H5jvDNLju2wvlnPXrnsF/mxb9hM+P8BdH0h7TA6/GISrKNo90rnVNLWmNnGY49a7v5uqx3ofhpBcCILeMKJBmkEfOH1YfBUVzbFFOd3ZDIYB9jdq/0V7L/zhtYDHMso2c0XXuC8wRsUB6FCwEjSjO6GyVuwGzovCVlOjg2wu5maK35tNuIUZkhitaFwIlfYV1nbm7feRts7ZaKKFIhqUi2MkLQtXNZnmp0Jsi8UUrr1y1iR17ViLAxeuA0YcFvu1UEdd/glJBMy3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=snVPulbAKBAi9Wd3KFPYZ5rYVHb8mY3ptG8l5yLntdE=;
 b=Vs5Pu9sDiwrhW3JeGDZv5wZj7aIHscwNUD+B1yFaENCF9lLTEC3xliYgbdEw40ocd/Be73XLialRLem8PKYa/nY5si97kPAUWG5lAlOExL+0WI6cFUXemGWY6vHwK7H90tsiF5FzdoPKH66I3EQ+aLwWDdQ1R0zgmXxdS26+57vRJ2/KSAKX+6PPHerOj5KgfUvo4B2qYLgKNHJdmUxbnMz+R9Cirqvcw7/r1ZQIxC4egBZ5cUiU7GQTIEOpJNADHgvSD1Dt/Bs5TsVOYsmjX1bEkVVOnH/iATWxXbffjeuQ9MD+vpSswVlXQqgZhhUHQLFeo3L7tRM5vZAJF/EG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=snVPulbAKBAi9Wd3KFPYZ5rYVHb8mY3ptG8l5yLntdE=;
 b=N9r3BBevrOsLQ8P5gSvHSSuOS0fUYjYp8SiyuvUIpmAok3JdCAHK3STK6cCQpRn9ZefzOFMIMNU8AQYXALt+G2u/eq3zWc/7yrvaA9aQIlM++g8a/J4A3mcd+nTmyMN4dOlk+k2O6nkFSwb4l2ZN6pa3LTte5lKnLNbv3c4ZITIcXY3XSFjYL+tfpPprsdzmHwz+DTb0GSLEgBqeGT+pesKU9hW5wdorbxpiBTHfrXKpobjK36arsI+fOHS64rAhfKyM1eibU0BFnym4lpno7gtlFBzePNFpBJ47RBkLcxo00SFy03CDETS0jrm2+Pz5+Ix1v5aoSBkBkTpnNuWGjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.23; Wed, 24 Aug
 2022 03:03:50 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::7432:2749:aa27:722c%7]) with mapi id 15.20.5546.022; Wed, 24 Aug 2022
 03:03:50 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     Peter Xu <peterx@redhat.com>, Nadav Amit <nadav.amit@gmail.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: [PATCH v3 3/3] selftests/hmm-tests: Add test for dirty bits
Date:   Wed, 24 Aug 2022 13:03:39 +1000
Message-Id: <8e425a8ec191682fa2036260c575f065eeb56a53.1661309831.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
References: <3b01af093515ce2960ac39bb16ff77473150d179.1661309831.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0113.namprd05.prod.outlook.com
 (2603:10b6:a03:334::28) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f693d62-88fc-4a34-6fc3-08da857d451b
X-MS-TrafficTypeDiagnostic: LV2PR12MB5774:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bZmzRAFqR2cu83C/EuVCfmxhlHyqrLyPS3M/bUwnQHD7qdvSTkAEUdKNJpogGeDWjDfedcmOYikq5zwy6aMTRlXQoHIxRlwj7naji0D2vkFNFV0OtP585OWdzC7Q4cafdDfxd333+ZzmLxkgRM61z/RUouKMGRGXlqxo896/Ye6GQrz0jeSUC7RxJbEttijST2jzoL/tLNkYQM8N29TwKHbjLZdXxlJeONGptHdqhBxH4+tqHQ8TNlpc89l6hLqXri6cqJpvTn6QQpGqnFxIM94loQER7E8Ynus/a8uiuslJxyiKyE86q0cZ/8nK2JXVOCrXA6ahO/SyCMhcDZa3yblZfSSRdvLCMm/k2j3sl9rzydZHv4tKgtkLxLXxEtnoob1hzqNZkmoQfSbW6yxsbsQEGBhjejPerch6KmWZY994cUOBhhidVu8tmMrVUJ52rGl+GvD68qJ3qZhV0xAFTApW1pvmgodj3UXhXBR3+gz66Ig/fISAyEFoWoG+6HFR21DyXGzCA0sFbj1X2zsmVcZPJHQVN2IhgXM0JF7KZJBKC710Hs/Wbaq7JiB1jfuMXRVlFEd9uv5rK12jrPHr0Mk3rxhqawxF3/NFf6Sw96OwBSog6TSq7c9toF1jv/C7OJKufrXypKA3zvg/aPuOVztLLypxNxkB7Ed20WzQ9qI3DuJFH3BhdFWXk2p7fupBkkaYB6W2a3WhseK2p/Q2tz7vjz8USrZdJ8xEj1Qai1MON1X38ZvF1TjNlN+XRP3XQXOpN8yx5P6iYgYOZYmldA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(83380400001)(478600001)(66556008)(66476007)(66946007)(2616005)(4326008)(186003)(8676002)(36756003)(8936002)(41300700001)(6666004)(6512007)(2906002)(6486002)(6506007)(26005)(86362001)(7416002)(5660300002)(316002)(54906003)(38100700002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vi06MaBhg7VPeMAIg2aX3mngHgnPkB/9LTIrlWZfM2I61oFXUT5Qxwneylgt?=
 =?us-ascii?Q?vQOHI26GDs03DoRAxeYCQqfdV8oiN0elQAynVxAlhR0ZfP7Mq2gw5MskwJsx?=
 =?us-ascii?Q?/9hsDyO14zSv6tlfrjgfRbmNpZYNxz5BCtDr27mVkkpHpUkRBL/hNsQGXSnc?=
 =?us-ascii?Q?9qHxtyMnUJcPu4Di/g9corFfcjTKUAeEVeVcHQ5pNRd72CKt/Fh4tB0zDylG?=
 =?us-ascii?Q?uFLLOMzmNaq4rzS9nxWWBoHtEZqR+R7s5rEH1Xn52JR7rKO8nDj8b8+DpEUp?=
 =?us-ascii?Q?CYIiwMRsfi88Dsb6pcXnEeSxxOIc+ZAgDbIi9eJLFuAVCULlhGe+3GpFeKw/?=
 =?us-ascii?Q?2RE+0sB4s6R+miTqdNi7zIViI0TBccUVNdc7W9YOQyTpMaWzzMnJek4okLhm?=
 =?us-ascii?Q?SuiZyrv/Wr4hNKE5fdQE8/gVrZPAjPhXaxtV/ZMSc5BpGWu7SKs8tM0//KDk?=
 =?us-ascii?Q?kHnmEwXzf+nVEr43uRwlRsmA+FmnYw5UIPjEhu1a/YMn8ssWaAv4h2ryvQDo?=
 =?us-ascii?Q?uucv2MzNEyc5h/rx/P5CJ2sr2y1LZoV+V8k6epyDp+gj1Wo1ECL9s7Sk+T++?=
 =?us-ascii?Q?HsajAauEkhXofJ3AfE+ykgHeIczKKg2mUFkzn73Bny4VfAKPOCiA7N+MjTXq?=
 =?us-ascii?Q?w1/ev8YD8zvqx6+eFp6PeMjCQIprDUrvLc8h1ODdmXpmzfilLAz2AboHZwFl?=
 =?us-ascii?Q?U1Nw3bActgE8hWzinbZRmnDbiezJXniJlfooca5xpknf5ZZAGqBSUzsOgbUs?=
 =?us-ascii?Q?UdgfKr6nYtSBMiTQRCEGg2jnV8UnKqvbUTmbG/NigXER/TCsZuNmxByKxRi0?=
 =?us-ascii?Q?FetJ+ET0aBCregDzahMhBmxQASbVmP8SDW4FWjsR0ifkdNHeAjNBVIDBeawm?=
 =?us-ascii?Q?Ul4nAGr0Z2v55DnqdN1s9aP86POBepwVkcliVQD/N249QtPJuKZKm6kgJ0zV?=
 =?us-ascii?Q?5uGDt9O2+6hUPWxpNYJolnQEnhCqRUGrGe1uQIwTETsJXDOTBK9FV+G7r+Ik?=
 =?us-ascii?Q?W+B5IBCNxP8MlR4Iemk1Ybzc36ldSpNP1KLIHaSzMxvR0LviymXHU9gZrHbS?=
 =?us-ascii?Q?y0l9wEe4sT5NR++E1+nVpTAbdNYcUG2jX6jmt1wdZy7kWAQSeOQIGcwoY6HO?=
 =?us-ascii?Q?d5TQoHtuQH/3QW/YyphoMnjzSC9422rvoiNkhzMyw9VA9ZLyZXzbEkkTve0O?=
 =?us-ascii?Q?7zQ82tBo68szMjbfFVerbkRGHuDqwHIXzwYJY8Hi0bMPPSp6H+u13PBskjt1?=
 =?us-ascii?Q?r08mGDYO69T6JWflk++7pMsJKpwQB5rcDw9FzF/KI5131/99FwXuUcyVxGfv?=
 =?us-ascii?Q?j0LGJq5ukSrBfeVQRpbg3eKSf7DSpxV43yrXxIzR9Hjl0Zr2RwBRfCgJPCeL?=
 =?us-ascii?Q?ULMqpNy4baYvBIjF0tkE1AEFBP0ayVFKHXF5UlJjl6ekvx8n7Xkzz+s8HcfC?=
 =?us-ascii?Q?G2E2uHFJYEbh3es2czSnVunpFSxd369pdIejGa/LBa9weTRgaltTm7veA5Ky?=
 =?us-ascii?Q?rXgKyjFRmJ8sm8N+A1G6lLV4GeulZ+v0H7DKr0ZIYEfEYN2fpfh0p0sA1PsU?=
 =?us-ascii?Q?38ay9/KDVe+/bDzUixb9TFx5l7tnx+sKBrBUo5J5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f693d62-88fc-4a34-6fc3-08da857d451b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 03:03:50.4741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4qkStYyDB6rG+wwdhwWs4iDxmijQGEFtsaBY1wyFVB+h2S0kyyU7Z/4rJw97hh2qranG7Ql0XPPfljL+Ea2YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We were not correctly copying PTE dirty bits to pages during
migrate_vma_setup() calls. This could potentially lead to data loss, so
add a test for this.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 tools/testing/selftests/vm/hmm-tests.c | 124 ++++++++++++++++++++++++++-
 1 file changed, 124 insertions(+)

diff --git a/tools/testing/selftests/vm/hmm-tests.c b/tools/testing/selftests/vm/hmm-tests.c
index 529f53b..70fdb49 100644
--- a/tools/testing/selftests/vm/hmm-tests.c
+++ b/tools/testing/selftests/vm/hmm-tests.c
@@ -1200,6 +1200,130 @@ TEST_F(hmm, migrate_multiple)
 	}
 }
 
+static char cgroup[] = "/sys/fs/cgroup/hmm-test-XXXXXX";
+static int write_cgroup_param(char *cgroup_path, char *param, long value)
+{
+	int ret;
+	FILE *f;
+	char *filename;
+
+	if (asprintf(&filename, "%s/%s", cgroup_path, param) < 0)
+		return -1;
+
+	f = fopen(filename, "w");
+	if (!f) {
+		ret = -1;
+		goto out;
+	}
+
+	ret = fprintf(f, "%ld\n", value);
+	if (ret < 0)
+		goto out1;
+
+	ret = 0;
+
+out1:
+	fclose(f);
+out:
+	free(filename);
+
+	return ret;
+}
+
+static int setup_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	if (!mkdtemp(cgroup))
+		return -1;
+
+	ret = write_cgroup_param(cgroup, "cgroup.procs", pid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int destroy_cgroup(void)
+{
+	pid_t pid = getpid();
+	int ret;
+
+	ret = write_cgroup_param("/sys/fs/cgroup/cgroup.procs",
+				"cgroup.proc", pid);
+	if (ret)
+		return ret;
+
+	if (rmdir(cgroup))
+		return -1;
+
+	return 0;
+}
+
+/*
+ * Try and migrate a dirty page that has previously been swapped to disk. This
+ * checks that we don't loose dirty bits.
+ */
+TEST_F(hmm, migrate_dirty_page)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int tmp = 0;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	ASSERT_EQ(setup_cgroup(), 0);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = 0;
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Fault pages back in from swap as clean pages */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		tmp += ptr[i];
+
+	/* Dirty the pte */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/*
+	 * Attempt to migrate memory to device, which should fail because
+	 * hopefully some pages are backed by swap storage.
+	 */
+	ASSERT_TRUE(hmm_migrate_sys_to_dev(self->fd, buffer, npages));
+
+	ASSERT_FALSE(write_cgroup_param(cgroup, "memory.reclaim", 1UL<<30));
+
+	/* Check we still see the updated data after restoring from swap. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+	destroy_cgroup();
+}
+
 /*
  * Read anonymous memory multiple times.
  */
-- 
git-series 0.9.1
