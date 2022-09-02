Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAD85AB07A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiIBMyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238173AbiIBMyB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C0F1AF24;
        Fri,  2 Sep 2022 05:38:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5365B6215D;
        Fri,  2 Sep 2022 12:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F58C433C1;
        Fri,  2 Sep 2022 12:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122293;
        bh=fnNNfiYZWirMDFmJg7FtUoSBfRmd7MQx/c6xnOQizJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WY38d2dYYo+0UPb5qzqFyO3gJJ1CnIIN2c1I6ny4FWo6RK5BWwQdQ/FdPGSpku2Sh
         1X8NEqMIdQs0CuRRIqPaQ7yJo9mLC22os9sQoBGg2vGiIC2gi7WZc53masmafbUTCx
         JHxU4KsEWZrrrWJYzzoElQ5oYk6TlaCebRydId4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Leung <Martin.Leung@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Charlene Liu <Charlene.Liu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 58/72] drm/amd/display: avoid doing vm_init multiple time
Date:   Fri,  2 Sep 2022 14:19:34 +0200
Message-Id: <20220902121406.668444371@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 5544a7b5a07480192eb5fd3536462faed2c21528 ]

[why]
this is to ensure that driver will not reprogram hvm_prefetch_req again if
it is done.

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
index c5e200d09038f..5752271f22dfe 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubbub.c
@@ -67,9 +67,15 @@ static uint32_t convert_and_clamp(
 void dcn21_dchvm_init(struct hubbub *hubbub)
 {
 	struct dcn20_hubbub *hubbub1 = TO_DCN20_HUBBUB(hubbub);
-	uint32_t riommu_active;
+	uint32_t riommu_active, prefetch_done;
 	int i;
 
+	REG_GET(DCHVM_RIOMMU_STAT0, HOSTVM_PREFETCH_DONE, &prefetch_done);
+
+	if (prefetch_done) {
+		hubbub->riommu_active = true;
+		return;
+	}
 	//Init DCHVM block
 	REG_UPDATE(DCHVM_CTRL0, HOSTVM_INIT_REQ, 1);
 
-- 
2.35.1



