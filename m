Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 696A36CC38E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjC1OzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbjC1OzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:55:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37A9BD510
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5EA6181B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDDEC433EF;
        Tue, 28 Mar 2023 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015301;
        bh=JL7swysdZjFPmLwy5SPweFAjgwocKbKWkI3q0AwtqnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImKQB5fkEy7JUqU8YXxD6vx5A63l6kgzu7uJ1rv2f75sKy+X8N3xUf0lIT/cTluoX
         IkzA92eWIJJaNTw7V7bsIcdcsgSGg0Lp9mWq752FXrMBdqRvGIaDWoux/sNSHEw8eS
         E6j5ro5F9fh3HpbYyqqAvY910E9VsrjmNIDVUKIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Abel Vesa <abel.vesa@linaro.org>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Sai Prakash Ranjan <quic_saipraka@quicinc.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.2 232/240] soc: qcom: llcc: Fix slice configuration values for SC8280XP
Date:   Tue, 28 Mar 2023 16:43:15 +0200
Message-Id: <20230328142629.379087634@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Abel Vesa <abel.vesa@linaro.org>

commit 77bf4b3ed42e31d29b255fcd6530fb7a1e217e89 upstream.

The slice IDs for CVPFW, CPUSS1 and CPUWHT currently overflow the 32bit
LLCC config registers, which means it is writing beyond the upper limit
of the ATTR0_CFGn and ATTR1_CFGn range of registers. But the most obvious
impact is the fact that the mentioned slices do not get configured at all,
which will result in reduced performance. Fix that by using the slice ID
values taken from the latest LLCC SC table.

Fixes: ec69dfbdc426 ("soc: qcom: llcc: Add sc8180x and sc8280xp configurations")
Cc: stable@vger.kernel.org	# 5.19+
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Tested-by: Juerg Haefliger <juerg.haefliger@canonical.com>
Reviewed-by: Sai Prakash Ranjan <quic_saipraka@quicinc.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230306135527.509796-1-abel.vesa@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/llcc-qcom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -191,9 +191,9 @@ static const struct llcc_slice_config sc
 	{ LLCC_CVP,      28, 512,  3, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
 	{ LLCC_APTCM,    30, 1024, 3, 1, 0x0,   0x1, 1, 0, 0, 1, 0, 0 },
 	{ LLCC_WRCACHE,  31, 1024, 1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
-	{ LLCC_CVPFW,    32, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUSS1,   33, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
-	{ LLCC_CPUHWT,   36, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
+	{ LLCC_CVPFW,    17, 512,  1, 0, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUSS1,   3, 2048, 1, 1, 0xfff, 0x0, 0, 0, 0, 1, 0, 0 },
+	{ LLCC_CPUHWT,   5, 512,  1, 1, 0xfff, 0x0, 0, 0, 0, 0, 1, 0 },
 };
 
 static const struct llcc_slice_config sdm845_data[] =  {


