Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8025D111C03
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfLCWj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbfLCWj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF960207DD;
        Tue,  3 Dec 2019 22:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412768;
        bh=L8aTFcBkYlwSH4hb0/HZBFxZiMJsBbKPtEM+pulKXFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfJR9JHSXM4BwDgKjuCAT19m9w5uS9qjVVHtQSWbYZoG8mOnUQuCtuw6oJyQFS5JN
         fZK1eG99na4FYVIXYpsOGcVAG+jSZgQNQpKvC5ndn9ksgc7bi11bB06RciL8zGxUIP
         /3I3ntE7yccvqKPV475h+gc0pMiTryFrIpqDDvdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 010/135] soundwire: intel: fix intel_register_dai PDI offsets and numbers
Date:   Tue,  3 Dec 2019 23:34:10 +0100
Message-Id: <20191203213007.585191169@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit cf9249626f72878b6d205a4965093cba5cce98df ]

There are two issues, likely copy/paste:

1. Use cdns->pcm.num_in instead of stream_num_in for consistency with
the rest of the code. This was not detected earlier since platforms did
not have input-only PDIs.

2. use the correct offset for bi-dir PDM, based on IN and OUT
PDIs. Again this was not detected since PDM was not supported earlier.

Reported-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20190916192348.467-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index ec25a71d08873..db9c138adb1ff 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -765,7 +765,7 @@ static int intel_register_dai(struct sdw_intel *sdw)
 	/* Create PCM DAIs */
 	stream = &cdns->pcm;
 
-	ret = intel_create_dai(cdns, dais, INTEL_PDI_IN, stream->num_in,
+	ret = intel_create_dai(cdns, dais, INTEL_PDI_IN, cdns->pcm.num_in,
 			       off, stream->num_ch_in, true);
 	if (ret)
 		return ret;
@@ -796,7 +796,7 @@ static int intel_register_dai(struct sdw_intel *sdw)
 	if (ret)
 		return ret;
 
-	off += cdns->pdm.num_bd;
+	off += cdns->pdm.num_out;
 	ret = intel_create_dai(cdns, dais, INTEL_PDI_BD, cdns->pdm.num_bd,
 			       off, stream->num_ch_bd, false);
 	if (ret)
-- 
2.20.1



