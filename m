Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F59D5EA458
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238359AbiIZLpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238520AbiIZLnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:43:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EE57286A;
        Mon, 26 Sep 2022 03:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0E5B80925;
        Mon, 26 Sep 2022 10:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA312C433D6;
        Mon, 26 Sep 2022 10:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189165;
        bh=/8T1n28G2OkOlOq8doDkRAmA1DaEtWdSbd0oPGpyoF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF+tl5w4EllW3z2N/SWrsbggyjWUtj0BbnCMF1Cv9bg4H/7mcPN9+RUVjJu3hgcoT
         /vrAbTfZ4U+aln9yGKck50R+Rkk1aQql3Qd9Z5qgO91ByIUm4VKP34kCp7KsjoXfVi
         VuBhKd/hboYhYHqFMJGumXapOMH+297gOYacvIuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ilkka Koskinen <ilkka@os.amperecomputing.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.19 067/207] perf/arm-cmn: Add more bits to child node address offset field
Date:   Mon, 26 Sep 2022 12:10:56 +0200
Message-Id: <20220926100809.597544349@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilkka Koskinen <ilkka@os.amperecomputing.com>

commit 05d6f6d346fea2fa4580a0c2b6be207456bebb08 upstream.

CMN-600 uses bits [27:0] for child node address offset while bits [30:28]
are required to be zero.

For CMN-650, the child node address offset field has been increased
to include bits [29:0] while leaving only bit 30 set to zero.

Let's include the missing two bits and assume older implementations
comply with the spec and set bits [29:28] to 0.

Signed-off-by: Ilkka Koskinen <ilkka@os.amperecomputing.com>
Fixes: 60d1504070c2 ("perf/arm-cmn: Support new IP features")
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20220808195455.79277-1-ilkka@os.amperecomputing.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 80d8309652a4..b80a9b74662b 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -36,7 +36,7 @@
 #define CMN_CI_CHILD_COUNT		GENMASK_ULL(15, 0)
 #define CMN_CI_CHILD_PTR_OFFSET		GENMASK_ULL(31, 16)
 
-#define CMN_CHILD_NODE_ADDR		GENMASK(27, 0)
+#define CMN_CHILD_NODE_ADDR		GENMASK(29, 0)
 #define CMN_CHILD_NODE_EXTERNAL		BIT(31)
 
 #define CMN_MAX_DIMENSION		12
-- 
2.37.3



