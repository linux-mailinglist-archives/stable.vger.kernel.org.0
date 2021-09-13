Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC540956C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346387AbhIMOlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346533AbhIMOjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DC116113E;
        Mon, 13 Sep 2021 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541324;
        bh=gTZ+FGzDPLRC11wr1V9rfXhxQuTN4Zfm2wOT3/awIoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gq5taA2cjsTHVq0238oAOmZMxp+EYGXlUsF0khHzsjYceoVX3LHmiX3gKnEsizcJl
         FMy+qNDc66spqYIOMB6A5I56iuKnW1u4aE4pbWbSUOkJJEcmrAK1ah/PajhGgWHD+9
         0hSqe882vgEb7RObtZ5fc7HBVs2HKgMEsbGLBIa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 253/334] ASoC: wm_adsp: Put debugfs_remove_recursive back in
Date:   Mon, 13 Sep 2021 15:15:07 +0200
Message-Id: <20210913131121.960933717@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e6d0b92ac00b53121a35b2a1ce8d393dc9179fdf ]

This patch reverts commit acbf58e53041 ("ASoC: wm_adsp: Let
soc_cleanup_component_debugfs remove debugfs"), and adds an
alternate solution to the issue. That patch removes the call to
debugfs_remove_recursive, which cleans up the DSPs debugfs. The
intention was to avoid an unbinding issue on an out of tree
driver/platform.

The issue with the patch is it means the driver no longer cleans up
its own debugfs, instead relying on ASoC to remove recurive on the
parent debugfs node. This is conceptually rather unclean, but also it
would prevent DSPs being added/removed independently of ASoC and soon
we are going to be upstreaming some non-audio parts with these DSPs,
which will require this.

Finally, it seems the issue on the platform is a result of the
wm_adsp2_cleanup_debugfs getting called twice. This is very likely a
problem on the platform side and will be resolved there. But in the mean
time make the code a little more robust to such issues, and again
conceptually a bit nicer, but clearing the debugfs_root variable in the
DSP structure when the debugfs is removed.

Fixes: acbf58e53041 ("ASoC: wm_adsp: Let soc_cleanup_component_debugfs remove debugfs"
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210824101552.1119-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index fe15cbc7bcaf..a4d4cbf716a1 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -747,6 +747,8 @@ static void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
 static void wm_adsp2_cleanup_debugfs(struct wm_adsp *dsp)
 {
 	wm_adsp_debugfs_clear(dsp);
+	debugfs_remove_recursive(dsp->debugfs_root);
+	dsp->debugfs_root = NULL;
 }
 #else
 static inline void wm_adsp2_init_debugfs(struct wm_adsp *dsp,
-- 
2.30.2



