Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DF94C4C0
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 03:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731066AbfFTBFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 21:05:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731067AbfFTBFB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 21:05:01 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5K12Epn011335
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 18:05:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=UeowdcOCFMUQPPPGTQqUXffwP9NuXJLQNLadx7jDkj0=;
 b=Y5GuKHYy5DU6I1d0lRR/STm3Eaxlumnyd5W/41HrCXDLFZjkvcjF21h2lWZfKTZEMVBH
 zvIhOC07JNtIXutoqVP2x84E4t65gHgNVc3UOIFKMyNs33xeK9sGHoG5C2ubxo/TYIx1
 jJDFit2rMxTAQnKyxBesKOVkx8mBkj3BrcA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2t7rex1par-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 18:05:00 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 19 Jun 2019 18:04:58 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id ED22C62E2FFC; Wed, 19 Jun 2019 18:04:56 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <linux-kernel@vger.kernel.org>
CC:     <kernel-team@fb.com>, <acme@redhat.com>, <davidca@fb.com>,
        <jolsa@kernel.org>, <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>, <stable@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH] perf: assign proper ff->ph in perf_event__synthesize_features()
Date:   Wed, 19 Jun 2019 18:04:53 -0700
Message-ID: <20190620010453.4118689-1-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-19_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=642 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906200005
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bpf/btf  write_* functions need ff->ph->env.

With this missing, pipe-mode (perf record -o -)  would crash like:

Program terminated with signal SIGSEGV, Segmentation fault.

This patch assign proper ph value to ff.

Cc: stable@vger.kernel.org #v5.1+
Fixes: 606f972b1361 ("perf bpf: Save bpf_prog_info information as headers to perf.data")
Reported-by: David Carrillo Cisneros <davidca@fb.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 tools/perf/util/header.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 06ddb6618ef3..5f1aa0284e1b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3684,6 +3684,7 @@ int perf_event__synthesize_features(struct perf_tool *tool,
 		return -ENOMEM;
 
 	ff.size = sz - sz_hdr;
+	ff.ph = &session->header;
 
 	for_each_set_bit(feat, header->adds_features, HEADER_FEAT_BITS) {
 		if (!feat_ops[feat].synthesize) {
-- 
2.17.1

