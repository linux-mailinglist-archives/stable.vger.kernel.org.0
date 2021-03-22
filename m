Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD367344169
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCVMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230138AbhCVMcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 630EB619A3;
        Mon, 22 Mar 2021 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416345;
        bh=oZ4IFlk/9bq4DKYKDhxL1X/+NmZqzXw5WYT/pnqiE+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e72P5NaPHMw4WNsWnqe5Z0r6y7ID6Ihj1tqraCbHwGYDlgZ3CzPX0x3ud8Z/ClxGD
         HnNQyOxpmrp3yQlY/FluBzuQ5OYd0JKAKdcxkswSrceXOzWYXU7gk6BPCyVgf1/lv9
         S/lIdej3brUaShsmKgKFsCn2qFozee4uPZV5KYYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivasa Rao Mandadapu <srivasam@codeaurora.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 036/120] ASoC: qcom: lpass-cpu: Fix lpass dai ids parse
Date:   Mon, 22 Mar 2021 13:26:59 +0100
Message-Id: <20210322121930.863072727@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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


