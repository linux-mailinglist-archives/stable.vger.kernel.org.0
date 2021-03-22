Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126CB344209
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhCVMiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230325AbhCVMgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:36:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDD3661931;
        Mon, 22 Mar 2021 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416572;
        bh=yTayAIBKuIJn+gV5lv0TS3Hk7EPo/GlQvUqJXS22suA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZedSgFFW30N8C3Y/7txioztRtX+JNCDE8BdmRL4pou2azOC48Hn8WRkZWxzuI0Zn
         Gk06TYvrDPewIP80jUXhkLIQZlPc3YNyJOMTqnHEpFfZ3mS53JqBoefmpV+vwBJR3T
         9Ttp0amNswfbg023wPVFjVqJ6rg12Y5YRD+06u/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 030/157] ASoC: codecs: wcd934x: add a sanity check in set channel map
Date:   Mon, 22 Mar 2021 13:26:27 +0100
Message-Id: <20210322121934.718868730@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 3bb4852d598f0275ed5996a059df55be7318ac2f upstream.

set channel map can be passed with a channel maps, however if
the number of channels that are passed are more than the actual
supported channels then we would be accessing array out of bounds.

So add a sanity check to validate these numbers!

Fixes: a61f3b4f476e ("ASoC: wcd934x: add support to wcd9340/wcd9341 codec")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210309142129.14182-4-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd934x.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/soc/codecs/wcd934x.c
+++ b/sound/soc/codecs/wcd934x.c
@@ -1873,6 +1873,12 @@ static int wcd934x_set_channel_map(struc
 
 	wcd = snd_soc_component_get_drvdata(dai->component);
 
+	if (tx_num > WCD934X_TX_MAX || rx_num > WCD934X_RX_MAX) {
+		dev_err(wcd->dev, "Invalid tx %d or rx %d channel count\n",
+			tx_num, rx_num);
+		return -EINVAL;
+	}
+
 	if (!tx_slot || !rx_slot) {
 		dev_err(wcd->dev, "Invalid tx_slot=%p, rx_slot=%p\n",
 			tx_slot, rx_slot);


