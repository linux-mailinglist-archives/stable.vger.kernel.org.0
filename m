Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49258521929
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243899AbiEJNmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbiEJNjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE5123677A;
        Tue, 10 May 2022 06:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30D3661824;
        Tue, 10 May 2022 13:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEB7C385CB;
        Tue, 10 May 2022 13:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189359;
        bh=/G7G98mOkb3wMCY7W2ZwgXvwNVhR/tDRGLVkEvO0kr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/7w+ZWlarW/Cg6f+IdiaIVMjzY+FWijTilmXUAehpMmmgL5ghmRenxiAXy50J6Qb
         z7atzJfQKlRfXijcZ2JRXULSSIZe3K8v35AtQRER3S1bBKwLfW9DIMl7sefQg5Lidy
         5K9dXPszDjWtDQClgg4niWgRgcVBbJEqIKpPHTDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jerome Brunet <jbrunet@baylibre.com>
Subject: [PATCH 5.15 025/135] ASoC: meson: Fix event generation for AUI ACODEC mux
Date:   Tue, 10 May 2022 15:06:47 +0200
Message-Id: <20220510130741.123163139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 2e3a0d1bfa95b54333f7add3e50e288769373873 upstream.

The AIU ACODEC has a custom put() operation which returns 0 when the value
of the mux changes, meaning that events are not generated for userspace.
Change to return 1 in this case, the function returns early in the case
where there is no change.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://lore.kernel.org/r/20220421123803.292063-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/aiu-acodec-ctrl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/meson/aiu-acodec-ctrl.c
+++ b/sound/soc/meson/aiu-acodec-ctrl.c
@@ -58,7 +58,7 @@ static int aiu_acodec_ctrl_mux_put_enum(
 
 	snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
 
-	return 0;
+	return 1;
 }
 
 static SOC_ENUM_SINGLE_DECL(aiu_acodec_ctrl_mux_enum, AIU_ACODEC_CTRL,


