Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BED5F8E81
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiJIU7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiJIU5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:57:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23053206F;
        Sun,  9 Oct 2022 13:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A18AB80DCF;
        Sun,  9 Oct 2022 20:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E7CC433D6;
        Sun,  9 Oct 2022 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348840;
        bh=mJaAX5aQnkjIe12CCLao8bgMgMSX4vYZAqRvmLN19Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbluvfSstBzJ0c+sXODeSNm46MnaUKfDEkF42d2Tr7NgL0ik5VcL+xSBLMSpH87jF
         6oFvj+lCAZP2+4sTJ/0y1RI9idf3EUoo+WEhyzaqq4IhP7F1xdWOcG/VxLfw2SEWR2
         2jV64KjwSaYjKdaRARQXVoSsc8kaDrokZm/WmVrIjRqSR2R7OdgRXiiQzPzxFpbgQu
         jweN6T/4Dnn6MmJ9GhiHzptXInE0JCfG/dJbRkKbiv1hyuxybQCKWS9FQH7rfcflEE
         7J8s4++xBC6iAkVxSM/62goYTEREpV/pFPjFmgdhbKlR024yxbhzH3yl99XvAT96fs
         CvGVLK8UfcZ7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Qin <chao.qin@intel.com>, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/10] powercap: intel_rapl: fix UBSAN shift-out-of-bounds issue
Date:   Sun,  9 Oct 2022 16:53:44 -0400
Message-Id: <20221009205350.1203176-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205350.1203176-1-sashal@kernel.org>
References: <20221009205350.1203176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Qin <chao.qin@intel.com>

[ Upstream commit 2d93540014387d1c73b9ccc4d7895320df66d01b ]

When value < time_unit, the parameter of ilog2() will be zero and
the return value is -1. u64(-1) is too large for shift exponent
and then will trigger shift-out-of-bounds:

shift exponent 18446744073709551615 is too large for 32-bit type 'int'
Call Trace:
 rapl_compute_time_window_core
 rapl_write_data_raw
 set_time_window
 store_constraint_time_window_us

Signed-off-by: Chao Qin <chao.qin@intel.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 70d6d52bc1e2..64a86990671a 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -938,6 +938,9 @@ static u64 rapl_compute_time_window_core(struct rapl_package *rp, u64 value,
 		y = value & 0x1f;
 		value = (1 << y) * (4 + f) * rp->time_unit / 4;
 	} else {
+		if (value < rp->time_unit)
+			return 0;
+
 		do_div(value, rp->time_unit);
 		y = ilog2(value);
 		f = div64_u64(4 * (value - (1 << y)), 1 << y);
-- 
2.35.1

