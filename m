Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D2829D320
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 22:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgJ1VlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 17:41:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16766 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727309AbgJ1VlF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:41:05 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09S0QRD8019776
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 17:28:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=kfzmbO32XIWIQv7ky/UlidEbiXsVDoIt2XZLJ7ZnmjM=;
 b=rhXmCNeA7fU12WMlZe39Gah/EsTtSpAxkIoZRICaj38Y+ruBTVH/Zo6/55EcTKeiDPW9
 YkryRGLNLINmhmUWqrwXnGVnmH5AObMT688HKhUtVDOEFywUg8eG7TMtGQHHb6KW5Zdk
 hI64sj+VlnYEQkzJ3wwW37pd1FF4ySY4ZDM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34d4b6pr1h-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 17:28:44 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 27 Oct 2020 17:28:33 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id BFD1562E564A; Tue, 27 Oct 2020 17:28:28 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux@vger.kernel.org>
CC:     Song Liu <songliubraving@fb.com>, stable <stable@vger.kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Date:   Tue, 27 Oct 2020 17:27:51 -0700
Message-ID: <20201028002751.3566140-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-27_17:2020-10-26,2020-10-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 mlxlogscore=998 clxscore=1011 malwarescore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 adultscore=0
 suspectscore=1 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Making perf with gcc-9.1.1 generates the following warning:

  CC       ui/browsers/hists.o
ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
truncated writing between 1 and 11 bytes into a region of size \
between 2 and 12 [-Werror=3Dformat-truncation=3D]

 3078 |       "Max event group index to sort is %d (index from 0 to %d)",
      |                                                             ^~
ui/browsers/hists.c:3078:7: note: directive argument in the range [-21474=
83648, 8]
 3078 |       "Max event group index to sort is %d (index from 0 to %d)",
      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/stdio.h:937,
                 from ui/browsers/hists.c:5:

IOW, the string in line 3078 might be too long for buf[] of 64 bytes.

Fix this by increasing the size of buf[] to 128.

Fixes: dbddf1747441  ("perf report/top TUI: Support hotkeys to let user s=
elect any event for sorting")
Cc: stable <stable@vger.kernel.org> # v5.7+
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hist=
s.c
index a07626f072087..b0e1880cf992b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2963,7 +2963,7 @@ static int perf_evsel__hists_browse(struct evsel *e=
vsel, int nr_events,
 	struct popup_action actions[MAX_OPTIONS];
 	int nr_options =3D 0;
 	int key =3D -1;
-	char buf[64];
+	char buf[128];
 	int delay_secs =3D hbt ? hbt->refresh : 0;
=20
 #define HIST_BROWSER_HELP_COMMON					\
--=20
2.24.1

