Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97466667665
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbjALObX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:31:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237137AbjALOab (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:30:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C4658FAA
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:22:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C59C8B81E6D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B0EC433F1;
        Thu, 12 Jan 2023 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533338;
        bh=hFbmR7gR+7jajMcgCu5cDRzh/eQ8Iz8PMcJQW5e1N3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFiwT0M06SPpPKfHUT5RReued8IOWbsKDcq/ZT1zAyflq7fh64FkRxXaWAsmsCbWm
         d8BWfmtnajUwqAZRiaXKOS3dj1c2R337OCrQgks5ps1Dhr4AYmzGNdzNSq8AkQOuqL
         tUkKuAq0UhLmP+pkXMy9Xsq3tB4mj+hmqVFXW9Nk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mukesh Ojha <quic_mojha@quicinc.com>,
        Luca Weiss <luca.weiss@fairphone.com>,
        Caleb Connolly <caleb.connolly@linaro.org>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/783] remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove
Date:   Thu, 12 Jan 2023 14:52:43 +0100
Message-Id: <20230112135544.970179672@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit 9a70551996e699fda262e8d54bbd41739d7aad6d ]

Leaving wakeup enabled during probe fail (-EPROBE_DEFER) or remove makes
the subsequent probe fail.

[    3.749454] remoteproc remoteproc0: releasing 3000000.remoteproc
[    3.752949] qcom_q6v5_pas: probe of 3000000.remoteproc failed with error -17
[    3.878935] remoteproc remoteproc0: releasing 4080000.remoteproc
[    3.887602] qcom_q6v5_pas: probe of 4080000.remoteproc failed with error -17
[    4.319552] remoteproc remoteproc0: releasing 8300000.remoteproc
[    4.332716] qcom_q6v5_pas: probe of 8300000.remoteproc failed with error -17

Fix this by disabling wakeup in both cases so the driver can properly
probe on the next try.

Fixes: a781e5aa5911 ("remoteproc: core: Prevent system suspend during remoteproc recovery")
Fixes: dc86c129b4fb ("remoteproc: qcom: pas: Mark devices as wakeup capable")
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221118090816.100012-1-luca.weiss@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_pas.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_pas.c b/drivers/remoteproc/qcom_q6v5_pas.c
index 0678b417707e..99b206b00456 100644
--- a/drivers/remoteproc/qcom_q6v5_pas.c
+++ b/drivers/remoteproc/qcom_q6v5_pas.c
@@ -472,6 +472,7 @@ static int adsp_probe(struct platform_device *pdev)
 detach_active_pds:
 	adsp_pds_detach(adsp, adsp->active_pds, adsp->active_pd_count);
 free_rproc:
+	device_init_wakeup(adsp->dev, false);
 	rproc_free(rproc);
 
 	return ret;
@@ -487,6 +488,7 @@ static int adsp_remove(struct platform_device *pdev)
 	qcom_remove_sysmon_subdev(adsp->sysmon);
 	qcom_remove_smd_subdev(adsp->rproc, &adsp->smd_subdev);
 	qcom_remove_ssr_subdev(adsp->rproc, &adsp->ssr_subdev);
+	device_init_wakeup(adsp->dev, false);
 	rproc_free(adsp->rproc);
 
 	return 0;
-- 
2.35.1



