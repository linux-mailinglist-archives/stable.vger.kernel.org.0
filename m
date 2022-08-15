Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB4759451B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349278AbiHOWa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350741AbiHOW1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A4A4198F;
        Mon, 15 Aug 2022 12:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63375B81136;
        Mon, 15 Aug 2022 19:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB13DC433C1;
        Mon, 15 Aug 2022 19:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592733;
        bh=GQzVVrODmWCT239cap0EveCqiYT9gKfYsgEnP5+XKRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VTSNDZEdi/cBywZKYptSxsJ2GiWXT/3yL3v1Go8Qx+4AtjAxJdddOkQfM0F/hEwqE
         JQlPzWpSxLrHnoN9FM7PbfUOmnW1fsYCDSZ42MlBC20s6qx40zflEPdIYiDHE/iFIz
         xEXlv97ScDQRJhbdjMMfYbemyb1Vu1D5l78J8axs=
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
Subject: [PATCH 5.18 0837/1095] ASoC: SOF: make ctx_store and ctx_restore as optional
Date:   Mon, 15 Aug 2022 20:03:56 +0200
Message-Id: <20220815180503.967711887@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index c856f0d84e49..f369242dd975 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -364,8 +364,8 @@ struct snd_sof_ipc_msg {
 
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



