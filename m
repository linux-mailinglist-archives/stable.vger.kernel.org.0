Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3693549633
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbiFMKTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242766AbiFMKSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:18:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5D620BDC;
        Mon, 13 Jun 2022 03:16:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A1DC614BA;
        Mon, 13 Jun 2022 10:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE79C34114;
        Mon, 13 Jun 2022 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115380;
        bh=ITYIFrUnHYpsV539xmrC608F3msk7H+aUAsKiM0u9Jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z917gircGH4MJFUMLm9EYW9A57O245WzE6FLUh79V7fZnKWPHtwdKN9jnMlCvUQUG
         vzVVCZF35hty84FuDsExDvawA5yBxrIVh95cw6Bi/VZ4ZtHTsVdd5Pmw254gbBS2Hf
         /eGEpKxedZkPRFHiPR6SCr5KagHOjtvhWlb/M0Dc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/167] ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe
Date:   Mon, 13 Jun 2022 12:08:47 +0200
Message-Id: <20220613094853.364404336@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094840.720778945@linuxfoundation.org>
References: <20220613094840.720778945@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 2be84f73785fa9ed6443e3c5b158730266f1c2ee ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.

Fixes: 08641c7c74dd ("ASoC: mxs: add device tree support for mxs-saif")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511133725.39039-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mxs/mxs-saif.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 5977a2011d9e..76e1059e7f15 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -748,6 +748,7 @@ static int mxs_saif_probe(struct platform_device *pdev)
 		saif->master_id = saif->id;
 	} else {
 		ret = of_alias_get_id(master, "saif");
+		of_node_put(master);
 		if (ret < 0)
 			return ret;
 		else
-- 
2.35.1



