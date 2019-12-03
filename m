Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB699111F47
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728972AbfLCWqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:36762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729251AbfLCWqv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:46:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D98D2084B;
        Tue,  3 Dec 2019 22:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413211;
        bh=Tyhi2JPw7jneTFeLl7BLrdgROznfz5UAxCjic14lyyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lkMzGuGfMqOrmyMhQIcTISTmK4Ls3qjdZzSSx/hIS3SJe0LVzxTF9wGdhJdYC4aa
         K+Ad7lGtfgzQ70riuftSwUp6v4pHASUI8Yn/merpnleGwQ0g3sOfQp/4sM6hm8K+nq
         aKyQM+oAVmusVs3F9Qh6K5ODSHXCZGpAs/y8e84c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaojun Sang <xsang@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/321] ASoC: compress: fix unsigned integer overflow check
Date:   Tue,  3 Dec 2019 23:31:10 +0100
Message-Id: <20191203223427.350424112@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojun Sang <xsang@codeaurora.org>

[ Upstream commit d3645b055399538415586ebaacaedebc1e5899b0 ]

Parameter fragments and fragment_size are type of u32. U32_MAX is
the correct check.

Signed-off-by: Xiaojun Sang <xsang@codeaurora.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20191021095432.5639-1-srinivas.kandagatla@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/compress_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/compress_offload.c b/sound/core/compress_offload.c
index 516ec35873256..509038d6bccdb 100644
--- a/sound/core/compress_offload.c
+++ b/sound/core/compress_offload.c
@@ -529,7 +529,7 @@ static int snd_compress_check_input(struct snd_compr_params *params)
 {
 	/* first let's check the buffer parameter's */
 	if (params->buffer.fragment_size == 0 ||
-	    params->buffer.fragments > INT_MAX / params->buffer.fragment_size ||
+	    params->buffer.fragments > U32_MAX / params->buffer.fragment_size ||
 	    params->buffer.fragments == 0)
 		return -EINVAL;
 
-- 
2.20.1



