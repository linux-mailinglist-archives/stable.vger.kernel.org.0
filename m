Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F74C594553
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346361AbiHOWsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351471AbiHOWnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:43:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95D5133A4A;
        Mon, 15 Aug 2022 12:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519A760FB5;
        Mon, 15 Aug 2022 19:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29629C433D6;
        Mon, 15 Aug 2022 19:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593153;
        bh=okJrlgzBj1K0AXC4N2+ssJGxbgJwbYicAEw9OP6fVVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1mzi740kLq5+FT0fiDCe+WHSWil3lrWwKZbrkGcGT61kcUhBzrfiZo6G+JQlbLFW
         H1zB4BCFAhQylhho5rKZRSzyVaP0ywIsyvidsQW4QSntaUTwpdRS2zHKd7/M4nXx6L
         qw3pm0RQcosM41P3NEJxpmPdKrbar+avuo0pW2VU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0222/1157] arm64: dts: qcom: sc7180: Remove ipa_fw_mem node on trogdor
Date:   Mon, 15 Aug 2022 19:52:58 +0200
Message-Id: <20220815180448.463546438@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit e60414644cf3a703e10ed4429c15263095945ffe ]

We don't use this carveout on trogdor boards, and having it defined in
the sc7180 SoC file causes an overlap message to be printed at boot.

 OF: reserved mem: OVERLAP DETECTED!
 memory@86000000 (0x0000000086000000--0x000000008ec00000) overlaps with memory@8b700000 (0x000000008b700000--0x000000008b710000)

Delete the node in the trogdor dtsi file to fix the overlap problem and
remove the error message.

Cc: Alex Elder <elder@linaro.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Fixes: 310b266655a3 ("arm64: dts: qcom: sc7180: define ipa_fw_mem node")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220517193307.3034602-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index e55dbaa6dc12..a071b8f5d7dc 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -43,6 +43,7 @@ charger-crit {
  */
 
 /delete-node/ &hyp_mem;
+/delete-node/ &ipa_fw_mem;
 /delete-node/ &xbl_mem;
 /delete-node/ &aop_mem;
 /delete-node/ &sec_apps_mem;
-- 
2.35.1



