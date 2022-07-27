Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F5A58311B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbiG0Rqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243097AbiG0Rpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:45:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619348C3F3;
        Wed, 27 Jul 2022 09:53:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26BA4B821B9;
        Wed, 27 Jul 2022 16:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DD4C433D6;
        Wed, 27 Jul 2022 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940806;
        bh=8IAcbXVWHUwLLmGTrw55Bqlu6XMog/ZOQW9uxG73sIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/g36wBlPZUUt0vzvEUuuY4p6tHtM2hcSpnUXPNG19p7KO7CjFxwKBaO/zX7ziVAQ
         M6qyEXErAX8d1nWfbE7G5oI8k7V9sbrxSbPlT6y3o/FZGsSCXZvI+0wWmPAs+gjBoc
         LpGkBBpuOarA6Zd73cQU6TcCqwGmB3CTGGHXfxsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        =?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.18 155/158] ASoC: SOF: pm: add explicit behavior for ACPI S1 and S2
Date:   Wed, 27 Jul 2022 18:13:39 +0200
Message-Id: <20220727161027.542365103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit a933084558c61cac8c902d2474b39444d87fba46 upstream.

The existing code only deals with S0 and S3, let's start adding S1 and S2.

No functional change.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20220616201818.130802-2-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pm.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/pm.c
+++ b/sound/soc/sof/pm.c
@@ -327,8 +327,18 @@ int snd_sof_prepare(struct device *dev)
 		return 0;
 
 #if defined(CONFIG_ACPI)
-	if (acpi_target_system_state() == ACPI_STATE_S0)
+	switch (acpi_target_system_state()) {
+	case ACPI_STATE_S0:
 		sdev->system_suspend_target = SOF_SUSPEND_S0IX;
+		break;
+	case ACPI_STATE_S1:
+	case ACPI_STATE_S2:
+	case ACPI_STATE_S3:
+		sdev->system_suspend_target = SOF_SUSPEND_S3;
+		break;
+	default:
+		break;
+	}
 #endif
 
 	return 0;


