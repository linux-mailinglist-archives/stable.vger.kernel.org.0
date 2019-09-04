Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73A8A8EBB
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733033AbfIDR7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388271AbfIDR7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:59:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC80822CEA;
        Wed,  4 Sep 2019 17:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619983;
        bh=tB8hZZLTRyVlHXribobIoKvzLcGtcR5wqsf4cKX4VkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJa9tTYqVl+3TcMOg7O+LTQbbnlrjCAecoJj4jPCFTTfxcInnH5k+Z76qsBjckV79
         iF6g5ujQd8Xa9VOzi/YQWVq+F3XCEYuTE0EZCSkVeVUur8Y3XNUdMCI1wXeoU9zX7U
         XboodobdYZk6X3mGjJgBG9tpLls/N76uaDOLi6yA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 04/83] ASoC: dapm: Fix handling of custom_stop_condition on DAPM graph walks
Date:   Wed,  4 Sep 2019 19:52:56 +0200
Message-Id: <20190904175304.059475061@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
References: <20190904175303.488266791@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index ab647f1fe11bd..08bfc91c686f0 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1104,8 +1104,8 @@ static __always_inline int is_connected_ep(struct snd_soc_dapm_widget *widget,
 		list_add_tail(&widget->work_list, list);
 
 	if (custom_stop_condition && custom_stop_condition(widget, dir)) {
-		widget->endpoints[dir] = 1;
-		return widget->endpoints[dir];
+		list = NULL;
+		custom_stop_condition = NULL;
 	}
 
 	if ((widget->is_ep & SND_SOC_DAPM_DIR_TO_EP(dir)) && widget->connected) {
@@ -1142,8 +1142,8 @@ static __always_inline int is_connected_ep(struct snd_soc_dapm_widget *widget,
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



