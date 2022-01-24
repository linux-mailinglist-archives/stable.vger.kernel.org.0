Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972C2498D96
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349246AbiAXTds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:33:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58788 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347311AbiAXTbi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:31:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B54A6135E;
        Mon, 24 Jan 2022 19:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6F0C340E5;
        Mon, 24 Jan 2022 19:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052697;
        bh=TGICEL1JlDSz94eSHY5GVl52jJkWdxOLFeLR5apU6e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t6U/uDtz5uE99KUdLS76zZ+lC7quTTOSYqIMsvfWb0sOq0Dkczp/4PJ4/dBfh1FKj
         rRumuJGDDPAzCkbkXYxIg+gbpJleh08ddu9cn+xeT4aeG576+d7cvf25sdXJMS1Uib
         7LLcN5e5KDg2wQ7CG/JgCYbCbj7GB6ILdrQMwifE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 146/320] ASoC: samsung: idma: Check of ioremap return value
Date:   Mon, 24 Jan 2022 19:42:10 +0100
Message-Id: <20220124183958.606307191@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index 65497cd477a50..47f6f5d70853d 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -363,6 +363,8 @@ static int preallocate_idma_buffer(struct snd_pcm *pcm, int stream)
 	buf->addr = idma.lp_tx_addr;
 	buf->bytes = idma_hardware.buffer_bytes_max;
 	buf->area = (unsigned char * __force)ioremap(buf->addr, buf->bytes);
+	if (!buf->area)
+		return -ENOMEM;
 
 	return 0;
 }
-- 
2.34.1



