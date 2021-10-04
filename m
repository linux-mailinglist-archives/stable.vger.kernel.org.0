Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D8420EE0
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236900AbhJDN3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237257AbhJDN1y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:27:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54A3B61C4F;
        Mon,  4 Oct 2021 13:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353138;
        bh=Rkr1HwoKGGxIRuA6VZPHJxUWKBvbfGer4rG/Un0/UcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npktbZnH70OPpUDWvYQxzKpnC0S8hC/ejHUjDEcgRIZV2I8lKSJk/Q2IdBxAB7Ixr
         ZZD/xT5o80xzsCCvWZSmkJ58KQUusOwe1qfG1IxvVG1OEss/VD322kqn/DcSg9XPeV
         4yL5DY65GxsYPQBva3w15AvIHfBtGkNircnBh+pM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yong Zhi <yong.zhi@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 011/172] ASoC: SOF: Fix DSP oops stack dump output contents
Date:   Mon,  4 Oct 2021 14:51:01 +0200
Message-Id: <20211004125045.331988033@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yong Zhi <yong.zhi@intel.com>

[ Upstream commit ac4dfccb96571ca03af7cac64b7a0b2952c97f3a ]

Fix @buf arg given to hex_dump_to_buffer() and stack address used
in dump error output.

Fixes: e657c18a01c8 ('ASoC: SOF: Add xtensa support')
Signed-off-by: Yong Zhi <yong.zhi@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@gmail.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20210915063230.29711-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/xtensa/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/xtensa/core.c b/sound/soc/sof/xtensa/core.c
index bbb9a2282ed9..f6e3411b33cf 100644
--- a/sound/soc/sof/xtensa/core.c
+++ b/sound/soc/sof/xtensa/core.c
@@ -122,9 +122,9 @@ static void xtensa_stack(struct snd_sof_dev *sdev, void *oops, u32 *stack,
 	 * 0x0049fbb0: 8000f2d0 0049fc00 6f6c6c61 00632e63
 	 */
 	for (i = 0; i < stack_words; i += 4) {
-		hex_dump_to_buffer(stack + i * 4, 16, 16, 4,
+		hex_dump_to_buffer(stack + i, 16, 16, 4,
 				   buf, sizeof(buf), false);
-		dev_err(sdev->dev, "0x%08x: %s\n", stack_ptr + i, buf);
+		dev_err(sdev->dev, "0x%08x: %s\n", stack_ptr + i * 4, buf);
 	}
 }
 
-- 
2.33.0



