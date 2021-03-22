Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C12A334415C
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbhCVMdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231459AbhCVMcJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 174F161992;
        Mon, 22 Mar 2021 12:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416319;
        bh=oXE1iUftqQGBVpvJSf3ey9Cgm92izoSfFtkaZ/CNuuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6Z5Tq/o1y48hHrAGxi0Th7fOx0J4mW7QlLepj3seSqwROe2yA00azkJ7+ARoe8bu
         T4VCJ6JirIAkkrsdMDgQt0LdDux4g91stYPXkPhOL++mwBnRXPUHbYn7rypx0KMWEC
         6MLYc7JvJgwH7da00nz2HloQqq5T5iLFm6CX1TaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.11 034/120] ASoC: qcom: sdm845: Fix array out of range on rx slim channels
Date:   Mon, 22 Mar 2021 13:26:57 +0100
Message-Id: <20210322121930.799909440@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit 4800fe6ea1022eb240215b1743d2541adad8efc7 upstream.

WCD934x has only 13 RX SLIM ports however we are setting it as 16
in set_channel_map, this will lead to array out of bounds error!

Orignally caught by enabling USBAN array out of bounds check:

Fixes: 5caf64c633a3 ("ASoC: qcom: sdm845: add support to DB845c and Lenovo Yoga")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210309142129.14182-3-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/sdm845.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -27,7 +27,7 @@
 #define SPK_TDM_RX_MASK         0x03
 #define NUM_TDM_SLOTS           8
 #define SLIM_MAX_TX_PORTS 16
-#define SLIM_MAX_RX_PORTS 16
+#define SLIM_MAX_RX_PORTS 13
 #define WCD934X_DEFAULT_MCLK_RATE	9600000
 
 struct sdm845_snd_data {


