Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE79615848
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiKBCsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiKBCsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F5B657E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7BF4617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65157C433D6;
        Wed,  2 Nov 2022 02:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357324;
        bh=WP/pV6xu1M7sCh363mNPUyjMS0YmfI/xesU5Tbzhz5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piZMec+dmPzACl3Qm4dyrQEEKhjQ1luFOeJ99bqqYYslMy6S7nrdRfl/CTwd3QHbR
         aJ0/pGfwYfwDJNaR+UPkPzKOTxoLgSnnKtz3a/HS8tEvGhF9WTDH4+2VwMV5LhSsuX
         FDPQd4TOgNhKCNLOK54sbPMLTl3W9jVg9LJlTK44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 149/240] ASoC: codecs: tlv320adc3xxx: Wrap adc3xxx_i2c_remove() in __exit_p()
Date:   Wed,  2 Nov 2022 03:32:04 +0100
Message-Id: <20221102022114.745897628@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 4e8ff35878685291978b93543d6b9e9290be770a ]

If CONFIG_SND_SOC_TLV320ADC3XXX=y:

    `.exit.text' referenced in section `.data' of sound/soc/codecs/tlv320adc3xxx.o: defined in discarded section `.exit.text' of sound/soc/codecs/tlv320adc3xxx.o

Fix this by wrapping the adc3xxx_i2c_remove() pointer in __exit_p().

Fixes: e9a3b57efd28fe88 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/3225ba4cfe558d9380155e75385954dd21d4e7eb.1665909132.git.geert@linux-m68k.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index 748998e48af9..8a0965cd3e66 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -1450,7 +1450,7 @@ static struct i2c_driver adc3xxx_i2c_driver = {
 		   .of_match_table = tlv320adc3xxx_of_match,
 		  },
 	.probe_new = adc3xxx_i2c_probe,
-	.remove = adc3xxx_i2c_remove,
+	.remove = __exit_p(adc3xxx_i2c_remove),
 	.id_table = adc3xxx_i2c_id,
 };
 
-- 
2.35.1



