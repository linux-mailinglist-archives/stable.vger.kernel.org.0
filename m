Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4E1681035
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbjA3OBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbjA3OBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC413B643
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4898ACE16A2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E80C433D2;
        Mon, 30 Jan 2023 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087241;
        bh=x+gOVXtRDYV5uej9F6oIqNv17uN1ek1roduVasw9TaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz1DCEuFUSPmd3W0l8Zl5IfomHE5SqKE8sVpEouDQLDLT/PHs+FhndFiWVJOB23HM
         useSxtkRSdw87AfA5F6OS3dZ/FhAPtv1ZX1KtAcgvxDlYGxoSf4ujiReeZ5ScCreOY
         oavysqhgZVsc5G4uwF7TmbO5MiEn7SB+3ZSTvEiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Curtis Malainey <cujomalainey@chromium.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/313] ASoC: SOF: Add FW state to debugfs
Date:   Mon, 30 Jan 2023 14:49:39 +0100
Message-Id: <20230130134343.368975414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Curtis Malainey <cujomalainey@chromium.org>

[ Upstream commit 9a9134fd56f6ba614ff7b2b3b0bac0bf1d0dc0c9 ]

Allow system health detection mechanisms to check the FW state, this
will allow them to check if the FW is in its "crashed" state going
forward to help automatically diagnose driver state.

Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20221220125629.8469-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/debug.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/debug.c b/sound/soc/sof/debug.c
index d9a3ce7b69e1..ade0507328af 100644
--- a/sound/soc/sof/debug.c
+++ b/sound/soc/sof/debug.c
@@ -353,7 +353,9 @@ int snd_sof_dbg_init(struct snd_sof_dev *sdev)
 			return err;
 	}
 
-	return 0;
+	return snd_sof_debugfs_buf_item(sdev, &sdev->fw_state,
+					sizeof(sdev->fw_state),
+					"fw_state", 0444);
 }
 EXPORT_SYMBOL_GPL(snd_sof_dbg_init);
 
-- 
2.39.0



