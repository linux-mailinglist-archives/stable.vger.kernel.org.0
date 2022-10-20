Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0D605457
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJTAEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 20:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiJTAEe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 20:04:34 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863202ADC
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 17:04:24 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f193so17748348pgc.0
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 17:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JFEAuRVxYze/rS1o+HmtzgS2VnFodVUCCckeeNQBPJo=;
        b=Qaz4H1KwKV2rEH1XylJDVh+Jyd+kjjCT40sHv0yltr24IPXS3A7bCxHahuIbL/aKxK
         HQymcu6lvjyUm4M3opQtknDcwkb3CpXipIAuZsVPTT02+205ImH7Ygnwl0k1o1zk3Lfe
         PIFtNfZeI46Af+097eiyWVE6XVf79YgCLePDI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFEAuRVxYze/rS1o+HmtzgS2VnFodVUCCckeeNQBPJo=;
        b=nHveuwpT4s3UhZ3rnNXZYgL4nDc6kINaW0P1HNMgByKUfu9azEz6xvDb+9odq8Xec7
         /6gYQGXsqH0M1GFL0Sr3+1z3uq5sDOQanwlzpVfkPqjDen3FxjhEJCj+fHxTQYqUgbL6
         NwgDhDcqQZGewACSLFKG7Do8+/HaoU1KHbX8lLtwFX97ywIzLYaY8kaAhxf13kdHdAo+
         zOaxWU/k0bv+OsFClkzJrm81idosMl5WtudCczIzEbDc89zf0MbDz5Hu1UQ39SRtpHaT
         v0Te/yIEFabBQrfOP8M9WLqS+EvzMpNL1kx6bnPgPpQjYcRV0GF55bVCdDXQZeupgJqk
         Lhqg==
X-Gm-Message-State: ACrzQf0xgV+wMkr8rpeXc/Da89/AWWk4RYzl06EZ+q9HupHb/7hsSiiy
        cS8OcL3/qIwZKWDsSGxCa38cKw==
X-Google-Smtp-Source: AMsMyM4/WuzkNI/KO9rd2JcSdJmmamHNIYsZ7bctseAbBQ/6EBWhOKRYCFsmPMPJl382wA/rvveujQ==
X-Received: by 2002:a63:4426:0:b0:464:4e1d:80e3 with SMTP id r38-20020a634426000000b004644e1d80e3mr9460506pga.106.1666224263585;
        Wed, 19 Oct 2022 17:04:23 -0700 (PDT)
Received: from localhost ([2620:15c:9d:2:57b7:1f0e:44d1:f252])
        by smtp.gmail.com with UTF8SMTPSA id b11-20020a17090a6acb00b00200a85fa777sm541885pjm.1.2022.10.19.17.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Oct 2022 17:04:23 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     =?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>
Cc:     dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Helen Koike <helen.koike@collabora.com>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] drm/rockchip: dsi: Force synchronous probe
Date:   Wed, 19 Oct 2022 17:03:49 -0700
Message-Id: <20221019170255.2.I6b985b0ca372b7e35c6d9ea970b24bcb262d4fc1@changeid>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
In-Reply-To: <20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid>
References: <20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We can't safely probe a dual-DSI display asynchronously
(driver_async_probe='*' or driver_async_probe='dw-mipi-dsi-rockchip'
cmdline), because dw_mipi_dsi_rockchip_find_second() pokes one DSI
device's drvdata from the other device without any locking.

Request synchronous probe, at least until this driver learns some
appropriate locking for dual-DSI initialization.

Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
index d222c6811207..528ddce144e5 100644
--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1689,5 +1689,11 @@ struct platform_driver dw_mipi_dsi_rockchip_driver = {
 		.of_match_table = dw_mipi_dsi_rockchip_dt_ids,
 		.pm	= &dw_mipi_dsi_rockchip_pm_ops,
 		.name	= "dw-mipi-dsi-rockchip",
+		/*
+		 * For dual-DSI display, one DSI pokes at the other DSI's
+		 * drvdata in dw_mipi_dsi_rockchip_find_second(). This is not
+		 * safe for asynchronous probe.
+		 */
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
-- 
2.38.0.413.g74048e4d9e-goog

