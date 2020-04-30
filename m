Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A831BFD63
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgD3OMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727968AbgD3NvO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D05124955;
        Thu, 30 Apr 2020 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254674;
        bh=92fzWmuJDPXuqoNMnvf0B2lwUjxV7b8HmUcTNgIuHfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OL23cxiB9BTifK7GTvB4VRsgqnSsVc4YlnpEPJG9Q0/5SVjNKVBGWtqx7TlevgM90
         J71otWULTqzoh6Thx5HcXmai3RmqFqhR4CYT7dzPj8BC7OWq6WF4sPZ6lzsAmXuurU
         K28PXnuBst1JJqIyCyXlMpg/jGMhvATlttOvFvp4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.6 26/79] ASoC: topology: Fix endianness issue
Date:   Thu, 30 Apr 2020 09:49:50 -0400
Message-Id: <20200430135043.19851-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 26d87881590fd55ccdd8f829498d7b3033f81990 ]

As done in already existing cases, we should use le32_to_cpu macro while
accessing hdr->magic. Found with sparse.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20200415162435.31859-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index e6a17ab433eea..009d65a6fb43a 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2652,7 +2652,7 @@ static int soc_valid_header(struct soc_tplg *tplg,
 	}
 
 	/* big endian firmware objects not supported atm */
-	if (hdr->magic == SOC_TPLG_MAGIC_BIG_ENDIAN) {
+	if (le32_to_cpu(hdr->magic) == SOC_TPLG_MAGIC_BIG_ENDIAN) {
 		dev_err(tplg->dev,
 			"ASoC: pass %d big endian not supported header got %x at offset 0x%lx size 0x%zx.\n",
 			tplg->pass, hdr->magic,
-- 
2.20.1

