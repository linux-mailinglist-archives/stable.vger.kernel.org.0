Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040D3594D3D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343940AbiHPAmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350398AbiHPAlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:41:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AB541907C0;
        Mon, 15 Aug 2022 13:39:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFB8CB8113E;
        Mon, 15 Aug 2022 20:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2AEDC433C1;
        Mon, 15 Aug 2022 20:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595983;
        bh=Ay0XAbYlO976TQxwn64944NrmDGhtHDV+JN61Q9XLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpgeFDMjgWMqZnc657umcn3V1VxQ6zAk58jlANqYtMFr6hbV9L7fuTBEvnH58sffs
         VujEG0wZy8Q/spO81WoNxijPoEA3AA7jAM5V67xX+kMkt7s0kqSF2xOiNRVAKoqQtS
         1TeKJXHqMCOBr6hPsdV71vCklnd8Qew+dbrI/wHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0903/1157] ASoC: SOF: make ctx_store and ctx_restore as optional
Date:   Mon, 15 Aug 2022 20:04:19 +0200
Message-Id: <20220815180515.594813939@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 03f69725749f453b9a4d454a92805f8eb5f095c2 ]

Commit 657774acd00f ("ASoC: SOF: Make sof_suspend/resume IPC agnostic")
did not marked ctx_store and ctx_restore as Optional.

Fixes: 657774acd00f ("ASoC: SOF: Make sof_suspend/resume IPC agnostic")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220610083549.16773-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-priv.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index f0f3d72c0da7..f11f575fd1da 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -378,8 +378,8 @@ struct sof_ipc_fw_tracing_ops {
 
 /**
  * struct sof_ipc_pm_ops - IPC-specific PM ops
- * @ctx_save:		Function pointer for context save
- * @ctx_restore:	Function pointer for context restore
+ * @ctx_save:		Optional function pointer for context save
+ * @ctx_restore:	Optional function pointer for context restore
  */
 struct sof_ipc_pm_ops {
 	int (*ctx_save)(struct snd_sof_dev *sdev);
-- 
2.35.1



