Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC754420595
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 07:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbhJDFek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 01:34:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232358AbhJDFej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 01:34:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1944keAi029444
        for <stable@vger.kernel.org>; Sun, 3 Oct 2021 22:32:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=ZUciwl852Lqkpzfl9IQj/1VtOOCjVLQ1V25CpGOStg8=;
 b=mNAkkDiRSat9OXzXDx4Au+H55XKv2EQXNbeNNJkFMURGVCcAt6EqY1dIs1xTlXVop9Vz
 er49znYGVhLF4Z5qOrbOdYZz9WzhFOwJq9GI5Joz1p2nnqK7VwLwh/lho3Oy+aGTVQM4
 rcnvluOfF7n9+wJcr5VJiE2NBf3DHnwc5PM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3bftvkr8dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 22:32:51 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Sun, 3 Oct 2021 22:32:50 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 5EF6615554668; Sun,  3 Oct 2021 22:32:43 -0700 (PDT)
From:   Song Liu <songliubraving@fb.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <kernel-team@fb.com>, <acme@kernel.org>, <peterz@infradead.org>,
        <mingo@redhat.com>, Song Liu <songliubraving@fb.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] perf-script: check session->header.env.arch before using it
Date:   Sun, 3 Oct 2021 22:32:38 -0700
Message-ID: <20211004053238.514936-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: DmVD5Dx7G-_Wlj208zDSF1USTLJUY3RC
X-Proofpoint-GUID: DmVD5Dx7G-_Wlj208zDSF1USTLJUY3RC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-04_01,2021-10-01_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 adultscore=0
 mlxlogscore=985 spamscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110040038
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When perf.data is not written cleanly, we would like to process existing
data as much as possible (please see f_header.data.size =3D=3D 0 conditio=
n
in perf_session__read_header). However, perf.data with partial data may
crash perf. Specifically, we see crash in perf-script for NULL
session->header.env.arch.

Fix this by checking session->header.env.arch before using it to determin=
e
native_arch. Also split the if condition so it is easier to read.

Cc: stable@vger.kernel.org
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/perf/builtin-script.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 6211d0b84b7a6..7821f6740ac1d 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -4039,12 +4039,17 @@ int cmd_script(int argc, const char **argv)
 		goto out_delete;
=20
 	uname(&uts);
-	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
-	    !strcmp(uts.machine, session->header.env.arch) ||
-	    (!strcmp(uts.machine, "x86_64") &&
-	     !strcmp(session->header.env.arch, "i386")))
+	if (data.is_pipe)  /* assume pipe_mode indicates native_arch */
 		native_arch =3D true;
=20
+	if (session->header.env.arch) {
+		if (!strcmp(uts.machine, session->header.env.arch))
+			native_arch =3D true;
+		else if (!strcmp(uts.machine, "x86_64") &&
+			 !strcmp(session->header.env.arch, "i386"))
+			native_arch =3D true;
+	}
+
 	script.session =3D session;
 	script__setup_sample_type(&script);
=20
--=20
2.30.2

