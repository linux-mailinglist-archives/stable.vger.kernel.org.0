Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 749F68C989
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHNCja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727447AbfHNCL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:11:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD4920989;
        Wed, 14 Aug 2019 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748686;
        bh=/G3q73kkYaUElnRdVDFR827OJ9BjbjlHh9kCYd76l50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W6c0kZUFp7a7VpMbxCC6X0mpodJLO2ZZWX7AFu8tneCk6OFv8O8+sgff6PFeYCtlu
         8+sbLPjdU2MVXgGYs1c4xBZT7tpamCw9BX8a5dB1UFhDEYxXUNOItNuNT4F4NfbC4J
         k/BEAYNEDWP+vif1oSqepggY41N5unxIYUQMJ0eM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 022/123] ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks
Date:   Tue, 13 Aug 2019 22:09:06 -0400
Message-Id: <20190814021047.14828-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 8dd26dff00c0636b1d8621acaeef3f6f3a39dd77 ]

DPCM uses snd_soc_dapm_dai_get_connected_widgets to build a
list of the widgets connected to a specific front end DAI so it
can search through this list for available back end DAIs. The
custom_stop_condition was added to is_connected_ep to facilitate this
list not containing more widgets than is necessary. Doing so both
speeds up the DPCM handling as less widgets need to be searched and
avoids issues with CODEC to CODEC links as these would be confused
with back end DAIs if they appeared in the list of available widgets.

custom_stop_condition was implemented by aborting the graph walk
when the condition is triggered, however there is an issue with this
approach. Whilst walking the graph is_connected_ep should update the
endpoints cache on each widget, if the walk is aborted the number
of attached end points is unknown for that sub-graph. When the stop
condition triggered, the original patch ignored the triggering widget
and returned zero connected end points; a later patch updated this
to set the triggering widget's cache to 1 and return that. Both of
these approaches result in inaccurate values being stored in various
end point caches as the values propagate back through the graph,
which can result in later issues with widgets powering/not powering
unexpectedly.

As the original goal was to reduce the size of the widget list passed
to the DPCM code, the simplest solution is to limit the functionality
of the custom_stop_condition to the widget list. This means the rest
of the graph will still be processed resulting in correct end point
caches, but only widgets up to the stop condition will be added to the
returned widget list.

Fixes: 6742064aef7f ("ASoC: dapm: support user-defined stop condition in dai_get_connected_widgets")
Fixes: 5fdd022c2026 ("ASoC: dpcm: play nice with CODEC<->CODEC links")
Fixes: 09464974eaa8 ("ASoC: dapm: Fix to return correct path list in is_connected_ep.")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20190718084333.15598-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-dapm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c91df5a9c8406..835ce1ff188d9 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1156,8 +1156,8 @@ static __always_inline int is_connected_ep(struct snd_soc_dapm_widget *widget,
 		list_add_tail(&widget->work_list, list);
 
 	if (custom_stop_condition && custom_stop_condition(widget, dir)) {
-		widget->endpoints[dir] = 1;
-		return widget->endpoints[dir];
+		list = NULL;
+		custom_stop_condition = NULL;
 	}
 
 	if ((widget->is_ep & SND_SOC_DAPM_DIR_TO_EP(dir)) && widget->connected) {
@@ -1194,8 +1194,8 @@ static __always_inline int is_connected_ep(struct snd_soc_dapm_widget *widget,
  *
  * Optionally, can be supplied with a function acting as a stopping condition.
  * This function takes the dapm widget currently being examined and the walk
- * direction as an arguments, it should return true if the walk should be
- * stopped and false otherwise.
+ * direction as an arguments, it should return true if widgets from that point
+ * in the graph onwards should not be added to the widget list.
  */
 static int is_connected_output_ep(struct snd_soc_dapm_widget *widget,
 	struct list_head *list,
-- 
2.20.1

