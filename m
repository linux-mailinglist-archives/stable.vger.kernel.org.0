Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473DB498F26
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiAXTu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348804AbiAXTkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:40:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F65C0613E6;
        Mon, 24 Jan 2022 11:19:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4B39B81249;
        Mon, 24 Jan 2022 19:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B2FC340E7;
        Mon, 24 Jan 2022 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051976;
        bh=QMWYLrt8iQbcEWQT/CMGJk+AiXwb31DZVl21V+GXoQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J39H91+yz2I/u6FG6PevGIiCQToQ/jszeZI3NnbPUnBPbMarO7e4Qe/N4QIx3h05n
         PLgyKc3QTlh/ogSa2iZ/EzjtHqK83XQsQdzzBKdWMGr9MukrjQREnGccKmMvTrkV13
         WPweaFB1RuxTvVl0AvB+Pb1ncZ5XnNkgBwE6L4G4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/239] ASoC: samsung: idma: Check of ioremap return value
Date:   Mon, 24 Jan 2022 19:42:33 +0100
Message-Id: <20220124183946.761209146@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 3ecb46755eb85456b459a1a9f952c52986bce8ec ]

Because of the potential failure of the ioremap(), the buf->area could
be NULL.
Therefore, we need to check it and return -ENOMEM in order to transfer
the error.

Fixes: f09aecd50f39 ("ASoC: SAMSUNG: Add I2S0 internal dma driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Link: https://lore.kernel.org/r/20211228034026.1659385-1-jiasheng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/samsung/idma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index b1f09b942410d..e397f5e10e33e 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -369,6 +369,8 @@ static int preallocate_idma_buffer(struct snd_pcm *pcm, int stream)
 	buf->addr = idma.lp_tx_addr;
 	buf->bytes = idma_hardware.buffer_bytes_max;
 	buf->area = (unsigned char * __force)ioremap(buf->addr, buf->bytes);
+	if (!buf->area)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.34.1



