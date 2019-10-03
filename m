Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F740CA8F6
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403899AbfJCQfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404058AbfJCQfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:35:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D879B222C9;
        Thu,  3 Oct 2019 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120516;
        bh=gfjxtCDC8qvqtkS70sKSq48huJP48vRLnJ9jhAFOzAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=denW1LXjqEaMznfWyGiLAmndqGn/cMczGjElxfuVYWRxp0c0YzgsIU0ClKKkSocgQ
         Y1N7twCyDRstUN9481AiE6atjLWUic7xNBhRwJATeQPunUMyg1wLGYqMY3B04JKFdu
         NibYB78hSIU5Nyxg34U4EukOAVtRlYzD/VsAQIlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 252/313] ASoC: Intel: Skylake: Use correct function to access iomem space
Date:   Thu,  3 Oct 2019 17:53:50 +0200
Message-Id: <20191003154557.858082634@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>

commit 17d29ff98fd4b70e9ccdac5e95e18a087e2737ef upstream.

For copying from __iomem, we should use __ioread32_copy.

reported by sparse:
sound/soc/intel/skylake/skl-debug.c:437:34: warning: incorrect type in argument 1 (different address spaces)
sound/soc/intel/skylake/skl-debug.c:437:34:    expected void [noderef] <asn:2> *to
sound/soc/intel/skylake/skl-debug.c:437:34:    got unsigned char *
sound/soc/intel/skylake/skl-debug.c:437:51: warning: incorrect type in argument 2 (different address spaces)
sound/soc/intel/skylake/skl-debug.c:437:51:    expected void const *from
sound/soc/intel/skylake/skl-debug.c:437:51:    got void [noderef] <asn:2> *[assigned] fw_reg_addr

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@intel.com>
Link: https://lore.kernel.org/r/20190827141712.21015-2-amadeuszx.slawinski@linux.intel.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/intel/skylake/skl-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/skylake/skl-debug.c
+++ b/sound/soc/intel/skylake/skl-debug.c
@@ -188,7 +188,7 @@ static ssize_t fw_softreg_read(struct fi
 	memset(d->fw_read_buff, 0, FW_REG_BUF);
 
 	if (w0_stat_sz > 0)
-		__iowrite32_copy(d->fw_read_buff, fw_reg_addr, w0_stat_sz >> 2);
+		__ioread32_copy(d->fw_read_buff, fw_reg_addr, w0_stat_sz >> 2);
 
 	for (offset = 0; offset < FW_REG_SIZE; offset += 16) {
 		ret += snprintf(tmp + ret, FW_REG_BUF - ret, "%#.4x: ", offset);


