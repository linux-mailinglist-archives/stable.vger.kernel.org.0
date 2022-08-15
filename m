Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2059462D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348773AbiHOWiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350928AbiHOWhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:37:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B29C2DE8;
        Mon, 15 Aug 2022 12:50:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E773B81154;
        Mon, 15 Aug 2022 19:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5254AC433D7;
        Mon, 15 Aug 2022 19:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593003;
        bh=tkqliisyWlw//YEyiwGGxb+HGB3tuKHQvqGhfE8nTOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8yHJUQ4ZNrSQrP6BCP9wS6eQM3e1EuMZT1FzTMSQLLWHgFiTYuPlhGEd7sHFQ98u
         uzMbsxU62Npbbk5X3hRgWpuhoqUC/JkOsdE8GzCeVcXW7rGd0lxNfMmEnkt3WGDH+U
         pYDWASujksCo7oC/3uO8PmrC8H6/7WijkfMBSk/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0878/1095] ASoC: SOF: ipc3-topology: Prevent double freeing of ipc_control_data via load_bytes
Date:   Mon, 15 Aug 2022 20:04:37 +0200
Message-Id: <20220815180505.688938280@linuxfoundation.org>
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

[ Upstream commit d5bd47f3ca124058a8e87eae4508afeda2132611 ]

We have sanity checks for byte controls and if any of the fail the locally
allocated scontrol->ipc_control_data is freed up, but not set to NULL.

On a rollback path of the error the higher level code will also try to free
the scontrol->ipc_control_data which will eventually going to lead to
memory corruption as double freeing memory is not a good thing.

Fixes: b5cee8feb1d4 ("ASoC: SOF: topology: Make control parsing IPC agnostic")
Reported-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220712130103.31514-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index 80fb82ece38d..74c230fbcf68 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1629,6 +1629,7 @@ static int sof_ipc3_control_load_bytes(struct snd_sof_dev *sdev, struct snd_sof_
 	return 0;
 err:
 	kfree(scontrol->ipc_control_data);
+	scontrol->ipc_control_data = NULL;
 	return ret;
 }
 
-- 
2.35.1



