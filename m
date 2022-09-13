Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8308D5B6FBE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiIMOR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbiIMORR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E923663F16;
        Tue, 13 Sep 2022 07:12:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F9AB80EF7;
        Tue, 13 Sep 2022 14:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF8CC433C1;
        Tue, 13 Sep 2022 14:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078270;
        bh=wHNCixadpIDzH5eeDro/KU1b/z9TVYQ7Rw5nLZwi2CE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlRbr1jRLtEX777Te4EzImD9MhKGY50drmURWmws+psdfQJIdqV5OCtRDZwDPX2Uz
         0GrKd0lxWRwq6bw9Xly9j/NFZoYvOO+Zbh6mNtfr4HpNNp6MQfILq8Mzk/Zz5DV1wO
         LSCNAzH/xfOz7+90Kw371GKYXm9vfhc64ly58RM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergey Matyukevich <sergey.matyukevich@syntacore.com>,
        Atish Patra <atishp@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 049/192] perf: RISC-V: fix access beyond allocated array
Date:   Tue, 13 Sep 2022 16:02:35 +0200
Message-Id: <20220913140412.381795215@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich@syntacore.com>

commit 20e0fbab16003ae23a9e86a64bcb93e3121587ca upstream.

SBI firmware should report total number of firmware and hardware counters
including unused ones or special ones. In this case the kernel doesn't need
to make any assumptions about gaps in reported counters, e.g. excluded timer
counter. That was fixed in OpenSBI v1.1 by commit 3f66465fb6bf ("lib: pmu:
allow to use the highest available counter"). This kernel patch has no effect
if SBI firmware behaves correctly. However it eliminates access beyond the
allocated pmu_ctr_list if the kernel is used with OpenSBI older than v1.1.

Fixes: e9991434596f ("RISC-V: Add perf platform driver based on SBI PMU extension")
Signed-off-by: Sergey Matyukevich <sergey.matyukevich@syntacore.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220830155306.301714-2-geomatsi@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/riscv_pmu_sbi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -467,7 +467,7 @@ static int pmu_sbi_get_ctrinfo(int nctr)
 	if (!pmu_ctr_list)
 		return -ENOMEM;
 
-	for (i = 0; i <= nctr; i++) {
+	for (i = 0; i < nctr; i++) {
 		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_GET_INFO, i, 0, 0, 0, 0, 0);
 		if (ret.error)
 			/* The logical counter ids are not expected to be contiguous */


