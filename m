Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108EC49AA1C
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384432AbiAYDc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1322224AbiAYDV2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:21:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51BFC0811B5;
        Mon, 24 Jan 2022 12:33:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15DF61538;
        Mon, 24 Jan 2022 20:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F1C340E5;
        Mon, 24 Jan 2022 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056390;
        bh=IRR7woKXRTUuwAj7dh3xDIZETJ6KdYf3GLSVPriOUYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kth9V8Rx4iETZtmNfQXxmvb4mQ6pedK055RSkpVYrd5gp+Ir2KbAPADCSDgeDCHlW
         /pqZBh3oUfF7ljeMVokFVNiFsoRVzV+6APoEs0+WQKIgIt3ns25SxpYCJpbl/a2Q8B
         zOXLuxXZ+t/yDmY9L+XJ0SWwiLD2p/+DerbQl2n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 435/846] ASoC: samsung: idma: Check of ioremap return value
Date:   Mon, 24 Jan 2022 19:39:12 +0100
Message-Id: <20220124184115.992572282@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 66bcc2f97544b..c3f1b054e2389 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -360,6 +360,8 @@ static int preallocate_idma_buffer(struct snd_pcm *pcm, int stream)
 	buf->addr = idma.lp_tx_addr;
 	buf->bytes = idma_hardware.buffer_bytes_max;
 	buf->area = (unsigned char * __force)ioremap(buf->addr, buf->bytes);
+	if (!buf->area)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.34.1



