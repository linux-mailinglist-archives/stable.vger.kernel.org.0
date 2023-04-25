Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A37B6EDBFD
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 08:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbjDYG7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 02:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbjDYG7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 02:59:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C24DAF32;
        Mon, 24 Apr 2023 23:59:11 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33P6bE38015911;
        Tue, 25 Apr 2023 06:58:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=OPwUhBfzRGsSut0j+vtqrGyiw75bGittZrZ7jEDKHnM=;
 b=DETIV78NIACDm/1VNMPlmMgaSxE0CYr+sZADc7urtN9t8GfNKXcbzgod2Gb4ahz7Eroy
 WxC85aVR2wvvulHPAPExynURxwGwQVvZ6N82qEQgICVXmBgNjwH0vlA3ZC8pITbAnbBh
 ynMbK7/vcbkTo4sbAmn0ITz+a7NSqNo/mP9qx9f7Aq4Q7OYVWv5OlRIQSwptPgITBYoX
 HmrC1h7k+5X7uPzVcgNAdzyPQFBveYYYBgTf1Fp5Db3r/PjDQYSjFBuNAya+nu543VNJ
 Z049Pk3x0lixnUuT1p4T3hYdoMeEZc0OPrwLMYRKAW+pGo0RAhNkJI7dUqMpmXCPGGGM 4g== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q68b8ug73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 06:58:47 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33ONa64n025920;
        Tue, 25 Apr 2023 06:58:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47771jc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 06:58:35 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33P6wXH129426206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 06:58:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B1402004E;
        Tue, 25 Apr 2023 06:58:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9800420040;
        Tue, 25 Apr 2023 06:58:30 +0000 (GMT)
Received: from li-bd3f974c-2712-11b2-a85c-df1cec4d728e.ibm.com.com (unknown [9.43.101.201])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 25 Apr 2023 06:58:30 +0000 (GMT)
From:   Hari Bathini <hbathini@linux.ibm.com>
To:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, bpf@vger.kernel.org
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, stable@vger.kernel.org
Subject: [PATCH v2] powerpc/bpf: populate extable entries only during the last pass
Date:   Tue, 25 Apr 2023 12:28:29 +0530
Message-Id: <20230425065829.18189-1-hbathini@linux.ibm.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IpL3BK40ps8ThY9uvWjjXDMg6YDdrrR7
X-Proofpoint-ORIG-GUID: IpL3BK40ps8ThY9uvWjjXDMg6YDdrrR7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_03,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit 85e031154c7c ("powerpc/bpf: Perform complete extra passes
to update addresses"), two additional passes are performed to avoid
space and CPU time wastage on powerpc. But these extra passes led to
WARN_ON_ONCE() hits in bpf_add_extable_entry() as extable entries are
populated again, during the extra pass, without resetting the index.
Fix it by resetting entry index before repopulating extable entries,
if and when there is an additional pass.

Fixes: 85e031154c7c ("powerpc/bpf: Perform complete extra passes to update addresses")
Cc: stable@vger.kernel.org
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
---
 arch/powerpc/net/bpf_jit_comp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index e93aefcfb83f..37043dfc1add 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -101,6 +101,8 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *fp)
 		bpf_hdr = jit_data->header;
 		proglen = jit_data->proglen;
 		extra_pass = true;
+		/* During extra pass, ensure index is reset before repopulating extable entries */
+		cgctx.exentry_idx = 0;
 		goto skip_init_ctx;
 	}
 
-- 
2.40.0

