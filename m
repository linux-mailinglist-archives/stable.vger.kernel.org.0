Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76CF4528E63
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbiEPTnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345932AbiEPTmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:42:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD5E83EF3D;
        Mon, 16 May 2022 12:40:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6150BB81613;
        Mon, 16 May 2022 19:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FF2C385AA;
        Mon, 16 May 2022 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730055;
        bh=DaFRiu8rRiStmkSXEE9NOoZkG8RjKP4bUTDrVSKhZ/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOhSY33bRXtnrhZXWkNzme1nTVmi/7IBlkiTAA5CIrUtP60ko8URt9AsP31UwPb8y
         cjEt0w3zuy5OyTKwy4/maCwGU2SeyO/QVlDxYOdioPnczFAKgJjTAtUKurKPLGO4Ls
         2QQRQ58P02l3P/W7/6jmpp7EIPtvuFTdU/Nt1aQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/32] ASoC: max98090: Generate notifications on changes for custom control
Date:   Mon, 16 May 2022 21:36:31 +0200
Message-Id: <20220516193615.285912243@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 13fcf676d9e102594effc686d98521ff5c90b925 ]

The max98090 driver has some custom controls which share a put() function
which returns 0 unconditionally, meaning that events are not generated
when the value changes. Fix that.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220420193454.2647908-2-broonie@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98090.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 6e5a4e757bf1..b9f15a260c78 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -436,7 +436,7 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 		mask << mc->shift,
 		sel << mc->shift);
 
-	return 0;
+	return *select != val;
 }
 
 static const char *max98090_perf_pwr_text[] =
-- 
2.35.1



