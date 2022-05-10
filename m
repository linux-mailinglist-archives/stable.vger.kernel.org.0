Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A60C521DC7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 17:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbiEJPPZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 11:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345218AbiEJPPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 11:15:01 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3931126C4E9
        for <stable@vger.kernel.org>; Tue, 10 May 2022 07:49:37 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ADpKFj032009
        for <stable@vger.kernel.org>; Tue, 10 May 2022 14:49:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=a705WuCHBSfmV5gMooV1L+YU3ys1QNPVQxCEwyN/UFU=;
 b=sTjxu55adKzrmbO3tzPzD/Vs8jalq62oPR5pd5MLiAonkEXGiJoW3+sdqLGvrDy5pn/8
 Vs2D4qZhvKDvvsrl2pxUiQl4lagHUkRLOaZNBQoueRKyxKfsGjLkSzxq71Y6ctCqdeyr
 Vzh7l1xdDv/AqCdTaKoTle831RvggHWkpm7Jsjoo2Q98EC/iMhVS4wQK4xmGN+/CzfXj
 Iityf7yPlaOSObS3GrIMwgpxrW7zyC4HesFEYMfR9AY7vFDhPROvmnbRM81YbTVuXtzs
 w+ikkb33OtBXPKvrWdHWLtnGyiTaOK+SepH27sD+/Ha9tDezSJtm693v6fgrZWCHrZYY Jw== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fync6xnwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 10 May 2022 14:49:36 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24AEdJpN012532
        for <stable@vger.kernel.org>; Tue, 10 May 2022 14:49:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3fyrkk04ar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 10 May 2022 14:49:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24AEZvwg51708412
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 14:35:57 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48D7C5204F;
        Tue, 10 May 2022 14:49:31 +0000 (GMT)
Received: from MBP-von-Wenjia.fritz.box.com (unknown [9.211.95.243])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 998575204E;
        Tue, 10 May 2022 14:49:29 +0000 (GMT)
From:   Wenjia Zhang <wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     Sven Schnelle <svens@linux.ibm.com>, stable@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [test] s390/stp: clock_delta should be signed
Date:   Tue, 10 May 2022 16:49:26 +0200
Message-Id: <20220510144926.53413-1-wenjia@linux.ibm.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GRzUggIjlSKsMAPXXCRjhhVBXN6aZOId
X-Proofpoint-ORIG-GUID: GRzUggIjlSKsMAPXXCRjhhVBXN6aZOId
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 mlxlogscore=748 phishscore=0 mlxscore=0 malwarescore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

clock_delta is declared as unsigned long in various places. However,
the clock sync delta can be negative. This would add a huge positive
offset in clock_sync_global where clock_delta is added to clk.eitod
which is a 72 bit integer. Declare it as signed long to fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/cio.h | 2 +-
 arch/s390/kernel/time.c     | 8 ++++----
 drivers/s390/cio/chsc.c     | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index 1effac6a0152..1c4f585dd39b 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -369,7 +369,7 @@ void cio_gp_dma_destroy(struct gen_pool *gp_dma, struct device *dma_dev);
 struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages);
 
 /* Function from drivers/s390/cio/chsc.c */
-int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta);
+int chsc_sstpc(void *page, unsigned int op, u16 ctrl, long *clock_delta);
 int chsc_sstpi(void *page, void *result, size_t size);
 int chsc_stzi(void *page, void *result, size_t size);
 int chsc_sgib(u32 origin);
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 2506bfdc91c7..6b7b6d5e3632 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -364,7 +364,7 @@ static inline int check_sync_clock(void)
  * Apply clock delta to the global data structures.
  * This is called once on the CPU that performed the clock sync.
  */
-static void clock_sync_global(unsigned long delta)
+static void clock_sync_global(long delta)
 {
 	unsigned long now, adj;
 	struct ptff_qto qto;
@@ -400,7 +400,7 @@ static void clock_sync_global(unsigned long delta)
  * Apply clock delta to the per-CPU data structures of this CPU.
  * This is called for each online CPU after the call to clock_sync_global.
  */
-static void clock_sync_local(unsigned long delta)
+static void clock_sync_local(long delta)
 {
 	/* Add the delta to the clock comparator. */
 	if (S390_lowcore.clock_comparator != clock_comparator_max) {
@@ -424,7 +424,7 @@ static void __init time_init_wq(void)
 struct clock_sync_data {
 	atomic_t cpus;
 	int in_sync;
-	unsigned long clock_delta;
+	long clock_delta;
 };
 
 /*
@@ -544,7 +544,7 @@ static int stpinfo_valid(void)
 static int stp_sync_clock(void *data)
 {
 	struct clock_sync_data *sync = data;
-	u64 clock_delta, flags;
+	long clock_delta, flags;
 	static int first;
 	int rc;
 
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index 297fb399363c..620a917cd3a1 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1255,7 +1255,7 @@ chsc_determine_css_characteristics(void)
 EXPORT_SYMBOL_GPL(css_general_characteristics);
 EXPORT_SYMBOL_GPL(css_chsc_characteristics);
 
-int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta)
+int chsc_sstpc(void *page, unsigned int op, u16 ctrl, long *clock_delta)
 {
 	struct {
 		struct chsc_header request;
@@ -1266,7 +1266,7 @@ int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta)
 		unsigned int rsvd2[5];
 		struct chsc_header response;
 		unsigned int rsvd3[3];
-		u64 clock_delta;
+		s64 clock_delta;
 		unsigned int rsvd4[2];
 	} *rr;
 	int rc;
-- 
2.35.2

