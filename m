Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C0C29B920
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802214AbgJ0PqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798482AbgJ0P2T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:28:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0766F22264;
        Tue, 27 Oct 2020 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812497;
        bh=C1bDi8BgLPkkrY9rtuzXJh2TJj+LMbpNGbh8Mc5qV50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WsZ2INrdEVptprx90caZd8+Q5dcoHb2gskKFGMa+jUyFn5hKI59f5//eov+XfW5OK
         CnKVvtHd4P0CakH6HSBMUl6wmR8iBqazD8aB/ZXGPEA/+/1qo/z5wTGjoZ+WBKlQ93
         djqsBcFtOWxv/Esbv7F8oHYrorME0nT5K393XjUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 230/757] soundwire: intel: fix NULL/ERR_PTR confusion
Date:   Tue, 27 Oct 2020 14:48:00 +0100
Message-Id: <20201027135501.399131170@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 06dcb4e443643db93b286f861133785ca46f5a19 ]

snd_soc_dai_get_sdw_stream() can only return the pointer to stream or
an ERR_PTR value, NULL is not a possible value.

Fixes: 09553140c8d7b ('soundwire: intel: implement get_sdw_stream() operations')
Reported-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20200903204739.31206-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index a283670659a92..10ff166977f8f 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1011,7 +1011,7 @@ static void *intel_get_sdw_stream(struct snd_soc_dai *dai,
 		dma = dai->capture_dma_data;
 
 	if (!dma)
-		return NULL;
+		return ERR_PTR(-EINVAL);
 
 	return dma->stream;
 }
-- 
2.25.1



