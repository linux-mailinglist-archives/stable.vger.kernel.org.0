Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA65344219
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231767AbhCVMip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:38:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231928AbhCVMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DB8619B4;
        Mon, 22 Mar 2021 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416599;
        bh=oZ4IFlk/9bq4DKYKDhxL1X/+NmZqzXw5WYT/pnqiE+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7dGi1eD9884SVqggSpDGaUCf09mB9SAonXtx8skP8f6uDj1iaOM9wWXlELQIvsBF
         Cwv8J9EPSqjm9omqeF/hyN25KLrkUNYZ7k0pfCn70Tz2DJF5v/tIixLkednTYC5dWq
         ITqeinMjs4ruhbzxf5EBTSTQtd11JwkFk8D41xos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 031/157] ASoC: qcom: lpass-cpu: Fix lpass dai ids parse
Date:   Mon, 22 Mar 2021 13:26:28 +0100
Message-Id: <20210322121934.750450699@linuxfoundation.org>
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

From: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>

commit 9922f50f7178496e709d3d064920b5031f0d9061 upstream.

The max boundary check while parsing dai ids makes
sound card registration fail after common up dai ids.

Fixes: cd3484f7f138 ("ASoC: qcom: Fix broken support to MI2S TERTIARY and QUATERNARY")

Signed-off-by: Srinivasa Rao Mandadapu <srivasam@codeaurora.org>
Link: https://lore.kernel.org/r/20210311154557.24978-1-srivasam@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass-cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/lpass-cpu.c
+++ b/sound/soc/qcom/lpass-cpu.c
@@ -737,7 +737,7 @@ static void of_lpass_cpu_parse_dai_data(
 
 	for_each_child_of_node(dev->of_node, node) {
 		ret = of_property_read_u32(node, "reg", &id);
-		if (ret || id < 0 || id >= data->variant->num_dai) {
+		if (ret || id < 0) {
 			dev_err(dev, "valid dai id not found: %d\n", ret);
 			continue;
 		}


