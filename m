Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B206357D1
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbiKWJog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiKWJoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:44:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28D1D5A0D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF5461B7C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12319C433C1;
        Wed, 23 Nov 2022 09:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196535;
        bh=Fm12baPjYoNch4H1j/diuKG6XzVUOnv//UMdldRP9EE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJL1E5lFPpFcS+5fgxMK6EO3Djckf0UVm2LtC3EYu5KvgsZwjgathccAQduWZtCS+
         mnV9lq3fBeE23jJIc5NwWV8HtO8b4cXNrR9Qf7HwmIaZe0aQlG/zU+spoqlxxURjAI
         DfKWcZFxjUhLHLIhYWUYFaFKVBv1u1t0kMK3Nwpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Zhe <yuzhe@nfschina.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/314] cxl/pmem: Use size_add() against integer overflow
Date:   Wed, 23 Nov 2022 09:48:23 +0100
Message-Id: <20221123084628.131829259@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Zhe <yuzhe@nfschina.com>

[ Upstream commit 4f1aa35f1fb7d51b125487c835982af792697ecb ]

"struct_size() + n" may cause a integer overflow,
use size_add() to handle it.

Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
Link: https://lore.kernel.org/r/20220927070247.23148-1-yuzhe@nfschina.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index faade12279f0..e0646097a3d4 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -151,7 +151,7 @@ static int cxl_pmem_set_config_data(struct cxl_dev_state *cxlds,
 		return -EINVAL;
 
 	/* 4-byte status follows the input data in the payload */
-	if (struct_size(cmd, in_buf, cmd->in_length) + 4 > buf_len)
+	if (size_add(struct_size(cmd, in_buf, cmd->in_length), 4) > buf_len)
 		return -EINVAL;
 
 	set_lsa =
-- 
2.35.1



