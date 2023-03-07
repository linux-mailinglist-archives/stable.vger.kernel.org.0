Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716116AEA36
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbjCGRbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCGRba (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:31:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DA5A1000
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:26:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D64B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1198C433D2;
        Tue,  7 Mar 2023 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210007;
        bh=AG4/g8xeWWzOeT3qTMzdZ7kJpzDrPTaP8g3RF5mV5Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXBWot62cteXQKPi+LxGVzwtyB37Oqo8CXHfUDQ1zHMMhRXInxvDvlRY1noy8EMGf
         uj4WDWmK3XXLXMSUIArxZ84gpkA9LoQrXhJeQwYszZHhFqqop8Ij26ydz8rRsIe5aV
         GDIoYvEQz8CPl8C/My8ss92XHAjCjKx8qXs38ABk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0403/1001] ASoC: topology: Properly access value coming from topology file
Date:   Tue,  7 Mar 2023 17:52:55 +0100
Message-Id: <20230307170038.813631751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit c5d184c92df2b631fb81fe2ce6e96bfc5ba720e5 ]

When accessing values coming from topology, le32_to_cpu should be used.
One of recent commits missed that.

Fixes: 86e2d14b6d1a ("ASoC: topology: Add header payload_size verification")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230127231111.937721-2-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index a79a2fb260b87..d68c48555a7e3 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2408,7 +2408,7 @@ static int soc_valid_header(struct soc_tplg *tplg,
 		return -EINVAL;
 	}
 
-	if (soc_tplg_get_hdr_offset(tplg) + hdr->payload_size >= tplg->fw->size) {
+	if (soc_tplg_get_hdr_offset(tplg) + le32_to_cpu(hdr->payload_size) >= tplg->fw->size) {
 		dev_err(tplg->dev,
 			"ASoC: invalid header of type %d at offset %ld payload_size %d\n",
 			le32_to_cpu(hdr->type), soc_tplg_get_hdr_offset(tplg),
-- 
2.39.2



