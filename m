Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0324B4F3361
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiDEJ4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343908AbiDEJP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:15:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E40972EC;
        Tue,  5 Apr 2022 02:01:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B7104CE1C6A;
        Tue,  5 Apr 2022 09:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D308FC385A1;
        Tue,  5 Apr 2022 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149289;
        bh=FXIASGTXlwyPFhZKczifYvKVHhbnTeDqSdZKl1fpCmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZjf5NHAM09fk5dIFv4z3KXWQUfH7AQVbr/SIVaTYj5Bnqvj61zdaY7X/ytbnT8ir
         EI+9dpSLKFbuI5MgIfy5A1oMM3PVtvytFQcMKmND8wcXHiF6z5eFGG9AURAk7Mjpii
         eQ5s460lbOxXGKrvXDlSRsZVjT7nAH0b5iEDLTXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0661/1017] pinctrl: renesas: checker: Fix miscalculation of number of states
Date:   Tue,  5 Apr 2022 09:26:14 +0200
Message-Id: <20220405070413.903578909@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit de9b861018d46af27a5edff8b6baef35c0c0ad4f ]

The checker failed to validate all enum IDs in the description of a
register with fixed-width register fields, due to a miscalculation of
the number of described states: each register field of n bits can have
"1 << n" possible states, not "1".

Increase SH_PFC_MAX_ENUMS accordingly, now more enum IDs are checked
(SH-Mobile AG5 has more than 4000 enum IDs defined).

Fixes: 12d057bad683b1c6 ("pinctrl: sh-pfc: checker: Add check for enum ID conflicts")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/6d8a6a05564f38f9d20464c1c17f96e52740cf6a.1645460429.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/renesas/core.c b/drivers/pinctrl/renesas/core.c
index 0d4ea2e22a53..12d41ac017b5 100644
--- a/drivers/pinctrl/renesas/core.c
+++ b/drivers/pinctrl/renesas/core.c
@@ -741,7 +741,7 @@ static int sh_pfc_suspend_init(struct sh_pfc *pfc) { return 0; }
 
 #ifdef DEBUG
 #define SH_PFC_MAX_REGS		300
-#define SH_PFC_MAX_ENUMS	3000
+#define SH_PFC_MAX_ENUMS	5000
 
 static unsigned int sh_pfc_errors __initdata;
 static unsigned int sh_pfc_warnings __initdata;
@@ -865,7 +865,8 @@ static void __init sh_pfc_check_cfg_reg(const char *drvname,
 			 GENMASK(cfg_reg->reg_width - 1, 0));
 
 	if (cfg_reg->field_width) {
-		n = cfg_reg->reg_width / cfg_reg->field_width;
+		fw = cfg_reg->field_width;
+		n = (cfg_reg->reg_width / fw) << fw;
 		/* Skip field checks (done at build time) */
 		goto check_enum_ids;
 	}
-- 
2.34.1



