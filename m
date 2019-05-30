Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53A2F545
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfE3DLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728664AbfE3DLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:45 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F68524504;
        Thu, 30 May 2019 03:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185905;
        bh=OP34NqQ4nCzrgrEOVghTv1qjubuhWWBEwB2RnRZva84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1zkshmHoex4BjW4gjDvfFdCWf+jxVrqgxshNWpOTFJ1EJ1nP0byJaw7CJgsmmdB1
         uF99QcI424OP/M/qUPNVtK20unDIgDkmfbpfLpoC3/eGM0PO58wsYBh5PHZW126xZI
         E084OOmutFTP//O3/KSenhiPgyX124hkWsJWEznM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wen.yang99@zte.com.cn>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, alsa-devel@alsa-project.org,
        Sasha Levin <sashal@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.1 276/405] ASoC: wcd9335: fix a leaked reference by adding missing of_node_put
Date:   Wed, 29 May 2019 20:04:34 -0700
Message-Id: <20190530030554.859752508@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 64b92de9603f22b5455da925ee57268ef7fb4e80 ]

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./sound/soc/codecs/wcd9335.c:5193:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 5183, but without a correspon    ding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com> (commit_signer:1/11=9%,authored:1/11=9%)
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd9335.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/wcd9335.c b/sound/soc/codecs/wcd9335.c
index 981f88a5f6154..a04a7cedd99de 100644
--- a/sound/soc/codecs/wcd9335.c
+++ b/sound/soc/codecs/wcd9335.c
@@ -5188,6 +5188,7 @@ static int wcd9335_slim_status(struct slim_device *sdev,
 
 	wcd->slim = sdev;
 	wcd->slim_ifc_dev = of_slim_get_device(sdev->ctrl, ifc_dev_np);
+	of_node_put(ifc_dev_np);
 	if (!wcd->slim_ifc_dev) {
 		dev_err(dev, "Unable to get SLIM Interface device\n");
 		return -EINVAL;
-- 
2.20.1



