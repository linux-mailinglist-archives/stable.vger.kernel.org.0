Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED340579F12
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243188AbiGSNKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243411AbiGSNJZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0272D8967B;
        Tue, 19 Jul 2022 05:28:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4264860DE0;
        Tue, 19 Jul 2022 12:28:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138CDC341C6;
        Tue, 19 Jul 2022 12:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233682;
        bh=2LOjYje2bLXGWMOvXmaOsvyq6QYDfSUX/nqUmPJDAgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbIP5h3PjSDL56nkO+6HmzX7F/06DyLZeDIRWFJJ+bmDsI29fE/9Hhg1UdgEfhlqb
         PtaU1a5Cjkwl9gFF7PkFwSbZgmpdfoPTXEi5ucXsRgoU/pGoChU2bN3MGQCtX4s5HK
         uBwNj7dYMrtShQvml1RIVINAhPhR5oArJZWDcVN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 205/231] ASoC: madera: Fix event generation for OUT1 demux
Date:   Tue, 19 Jul 2022 13:54:50 +0200
Message-Id: <20220719114731.206510208@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e3cabbef3db8269207a6b8808f510137669f8deb ]

madera_out1_demux_put returns the value of
snd_soc_dapm_mux_update_power, which returns a 1 if a path was found for
the kcontrol. This is obviously different to the expected return a 1 if
the control was updated value. This results in spurious notifications to
user-space. Update the handling to only return a 1 when the value is
changed.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20220623105120.1981154-4-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/madera.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/madera.c b/sound/soc/codecs/madera.c
index 272041c6236a..8095a87117cf 100644
--- a/sound/soc/codecs/madera.c
+++ b/sound/soc/codecs/madera.c
@@ -618,7 +618,13 @@ int madera_out1_demux_put(struct snd_kcontrol *kcontrol,
 end:
 	snd_soc_dapm_mutex_unlock(dapm);
 
-	return snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	ret = snd_soc_dapm_mux_update_power(dapm, kcontrol, mux, e, NULL);
+	if (ret < 0) {
+		dev_err(madera->dev, "Failed to update demux power state: %d\n", ret);
+		return ret;
+	}
+
+	return change;
 }
 EXPORT_SYMBOL_GPL(madera_out1_demux_put);
 
-- 
2.35.1



