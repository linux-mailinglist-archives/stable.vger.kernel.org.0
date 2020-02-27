Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85052171C85
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbgB0OMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388904AbgB0OMv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D357524691;
        Thu, 27 Feb 2020 14:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812770;
        bh=DSFBM7BNuOdb259OtWqXqz7MxqSG3Bzku8QvVO0rB9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BnQeGsi5htjETFa1XC3Hwnd+fb7R0HbLvy8K8j/AnKyRkw6NEoM6d3YTLp8o+FWq
         9WVHaFn0sbOCoe6vfcTxxi6U+0a3japMtXBEb68rxsNQtiFsLCxY8oaU+U4RQ/s/l7
         K46ke6wqw/3bcXxcKEGXyu+K4Ty5eZF6wqf4h7qU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Samuel Holland <samuel@sholland.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.5 010/150] ASoC: codec2codec: avoid invalid/double-free of pcm runtime
Date:   Thu, 27 Feb 2020 14:35:47 +0100
Message-Id: <20200227132234.226756912@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

commit b6570fdb96edf45bcf71884bd2644bd73d348d1a upstream.

The PCM runtime was freed during PMU in the case that the event hook
encountered an error. However, it is also unconditionally freed during
PMD. Avoid a double-free by dropping the call to kfree in the PMU hook.

Fixes: a72706ed8208 ("ASoC: codec2codec: remove ephemeral variables")
Cc: stable@vger.kernel.org
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20200213061147.29386-2-samuel@sholland.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -3888,9 +3888,6 @@ snd_soc_dai_link_event_pre_pmu(struct sn
 	runtime->rate = params_rate(params);
 
 out:
-	if (ret < 0)
-		kfree(runtime);
-
 	kfree(params);
 	return ret;
 }


