Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D991F55DBAA
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243640AbiF1CVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243550AbiF1CUa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD7024970;
        Mon, 27 Jun 2022 19:20:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC739B81C0A;
        Tue, 28 Jun 2022 02:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78541C385A2;
        Tue, 28 Jun 2022 02:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382801;
        bh=0FpoLL75cAtPyL6H/nENDZXIYSx/j5PXTuH45FL799Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5SE5oasbh0sRNQb2yW61HN8rBWcLWMHvEpQ4hzV77Wz9ds2L25kKY/V7ZnREqAsq
         ProjuVWqlIyxHX3TQZ8KnoDUDfPfegDEpHHgFnzeD35+E9ykTyfEtP4CtiJeVA9iZm
         7b3EQeHvjztkGLPrdMz2vfTGMnmYshFZh/V2YNiFJ5KJ1RtzJUipQxOK8Ea3X/DMsJ
         9Ubf3LGivBsyqPqFZCoQS+EY3FfdeI/Lhjo6vubKA32GZ5bPHYaYbrItWSPqIcvMTP
         2phPYRt14yrPfGJWJ7WY3VSIacK5fOesYP+AKWcHLbh/ufjKxfOfxwCgqt6u+eaba5
         W3FzlXo5u/jUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antoniu Miclaus <antoniu.miclaus@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, lars@metafoo.de,
        Michael.Hennerich@analog.com, jic23@kernel.org,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 28/53] iio: freq: admv1014: Fix warning about dubious x & !y and improve readability
Date:   Mon, 27 Jun 2022 22:18:14 -0400
Message-Id: <20220628021839.594423-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit 6f6bd7591945c679b7f595119ea997b19f5794db ]

The warning comes from __BF_FIELD_CHECK()
specifically

BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
		 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
		 _pfx "value too large for the field"); \

The code was using !(enum value) which is not particularly easy to follow
so replace that with explicit matching and use of ? 0 : 1; or ? 1 : 0;
to improve readability.

Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://lore.kernel.org/r/20220511090006.90502-1-antoniu.miclaus@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/frequency/admv1014.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/frequency/admv1014.c b/drivers/iio/frequency/admv1014.c
index a7994f8e6b9b..1aac5665b5de 100644
--- a/drivers/iio/frequency/admv1014.c
+++ b/drivers/iio/frequency/admv1014.c
@@ -700,8 +700,10 @@ static int admv1014_init(struct admv1014_state *st)
 			 ADMV1014_DET_EN_MSK;
 
 	enable_reg = FIELD_PREP(ADMV1014_P1DB_COMPENSATION_MSK, st->p1db_comp ? 3 : 0) |
-		     FIELD_PREP(ADMV1014_IF_AMP_PD_MSK, !(st->input_mode)) |
-		     FIELD_PREP(ADMV1014_BB_AMP_PD_MSK, st->input_mode) |
+		     FIELD_PREP(ADMV1014_IF_AMP_PD_MSK,
+				(st->input_mode == ADMV1014_IF_MODE) ? 0 : 1) |
+		     FIELD_PREP(ADMV1014_BB_AMP_PD_MSK,
+				(st->input_mode == ADMV1014_IF_MODE) ? 1 : 0) |
 		     FIELD_PREP(ADMV1014_DET_EN_MSK, st->det_en);
 
 	return __admv1014_spi_update_bits(st, ADMV1014_REG_ENABLE, enable_reg_msk, enable_reg);
-- 
2.35.1

