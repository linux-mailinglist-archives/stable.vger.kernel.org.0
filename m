Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A019137FCC
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgAKKXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:23:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgAKKXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:23:12 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37AC205F4;
        Sat, 11 Jan 2020 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738191;
        bh=FEufkkPCT+mRnvVJNE8hRSNOHE541zr3+4MMIWro1SQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lezhUescQhf32hIZ4H1HNolgeuAZlFPDeNuz+wyBgLuQ3cBMN27viPXMcMAkzjugt
         B0XJzh3t24wrOcqz88TRwA6j8hI7QE2bVmgqddOtw0IXX1HM7srP28V2CDicGC0asX
         DRQFrJRNQEdF/HVYIGYEcqXHkOKy7PFzq4Xze8tk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Karol Trzcinski <karolx.trzcinski@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/165] ASoC: SOF: loader: snd_sof_fw_parse_ext_data log warning on unknown header
Date:   Sat, 11 Jan 2020 10:49:26 +0100
Message-Id: <20200111094925.334535356@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karol Trzcinski <karolx.trzcinski@linux.intel.com>

[ Upstream commit 8edc95667646a75f0fc97e08ecb180581fdff300 ]

Added warning log when found some unknown FW boot ext header,
to improve debuggability.

Signed-off-by: Karol Trzcinski <karolx.trzcinski@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20191210004854.16845-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/loader.c b/sound/soc/sof/loader.c
index 9a9a381a908d..a041adf0669d 100644
--- a/sound/soc/sof/loader.c
+++ b/sound/soc/sof/loader.c
@@ -66,6 +66,8 @@ int snd_sof_fw_parse_ext_data(struct snd_sof_dev *sdev, u32 bar, u32 offset)
 			ret = get_ext_windows(sdev, ext_hdr);
 			break;
 		default:
+			dev_warn(sdev->dev, "warning: unknown ext header type %d size 0x%x\n",
+				 ext_hdr->type, ext_hdr->hdr.size);
 			break;
 		}
 
-- 
2.20.1



