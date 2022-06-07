Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BF6541682
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376898AbiFGUxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377475AbiFGUuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:50:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE1E1F98F3;
        Tue,  7 Jun 2022 11:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA03B8233E;
        Tue,  7 Jun 2022 18:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060D8C385A2;
        Tue,  7 Jun 2022 18:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627215;
        bh=hmOnrUcH7670N2tE92uyQ8lRAcXD4hwB3zS1oR7mbno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d54W5v/0dUDE45h1pPQRyFEFqBMxZFtPTy1FkgVvgOBp/RZDeH1nNp3OErckRDWra
         2xwSbg1M2ISy1LpkfuUMKFSSv9om3E9PGPsQ4BSZgyDERWEfGgJv2LbToV31P+lMvi
         r5N1RXbPyUsZyjgYU6+X0xoT5wog5kKon4E7+o1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.17 660/772] s390/stp: clock_delta should be signed
Date:   Tue,  7 Jun 2022 19:04:12 +0200
Message-Id: <20220607165008.509115168@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 5ace65ebb5ce9fe1cc8fdbdd97079fb566ef0ea4 upstream.

clock_delta is declared as unsigned long in various places. However,
the clock sync delta can be negative. This would add a huge positive
offset in clock_sync_global where clock_delta is added to clk.eitod
which is a 72 bit integer. Declare it as signed long to fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/cio.h |    2 +-
 arch/s390/kernel/time.c     |    8 ++++----
 drivers/s390/cio/chsc.c     |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -369,7 +369,7 @@ void cio_gp_dma_destroy(struct gen_pool
 struct gen_pool *cio_gp_dma_create(struct device *dma_dev, int nr_pages);
 
 /* Function from drivers/s390/cio/chsc.c */
-int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta);
+int chsc_sstpc(void *page, unsigned int op, u16 ctrl, long *clock_delta);
 int chsc_sstpi(void *page, void *result, size_t size);
 int chsc_stzi(void *page, void *result, size_t size);
 int chsc_sgib(u32 origin);
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
@@ -400,7 +400,7 @@ static void clock_sync_global(unsigned l
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
 
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1255,7 +1255,7 @@ exit:
 EXPORT_SYMBOL_GPL(css_general_characteristics);
 EXPORT_SYMBOL_GPL(css_chsc_characteristics);
 
-int chsc_sstpc(void *page, unsigned int op, u16 ctrl, u64 *clock_delta)
+int chsc_sstpc(void *page, unsigned int op, u16 ctrl, long *clock_delta)
 {
 	struct {
 		struct chsc_header request;
@@ -1266,7 +1266,7 @@ int chsc_sstpc(void *page, unsigned int
 		unsigned int rsvd2[5];
 		struct chsc_header response;
 		unsigned int rsvd3[3];
-		u64 clock_delta;
+		s64 clock_delta;
 		unsigned int rsvd4[2];
 	} *rr;
 	int rc;


