Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AAC4FD9C6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351508AbiDLHUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351730AbiDLHMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 747FE167E5;
        Mon, 11 Apr 2022 23:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 269DAB81B35;
        Tue, 12 Apr 2022 06:52:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B8CC385A8;
        Tue, 12 Apr 2022 06:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746319;
        bh=YMs7DdWMitcpwA45VOAPxYqNjZD+cfm5Xmc4BAEvph4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDp87CfHFB6D11iTbw8sURPvItkdAVKJ1SgzKBNw56zwjH/g8lIO/latXsC+OvdaL
         iiTroFfZGSUKC6HLr1E25xy9BAwFZ6gpY3fpV3mp+8AhKrhw/+ZEAm8DRq6XltZ+4k
         nTAGTh6DDZ/0pP5Teg/eTWBqiHfbYG6E/UvdrhOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.15 241/277] drm/panel: ili9341: fix optional regulator handling
Date:   Tue, 12 Apr 2022 08:30:44 +0200
Message-Id: <20220412062949.018964139@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Daniel Mack <daniel@zonque.org>

commit d14eb80e27795b7b20060f7b151cdfe39722a813 upstream.

If the optional regulator lookup fails, reset the pointer to NULL.
Other functions such as mipi_dbi_poweron_reset_conditional() only do
a NULL pointer check and will otherwise dereference the error pointer.

Fixes: 5a04227326b04c15 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Daniel Mack <daniel@zonque.org>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317225537.826302-1-daniel@zonque.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -612,8 +612,10 @@ static int ili9341_dbi_probe(struct spi_
 	int ret;
 
 	vcc = devm_regulator_get_optional(dev, "vcc");
-	if (IS_ERR(vcc))
+	if (IS_ERR(vcc)) {
 		dev_err(dev, "get optional vcc failed\n");
+		vcc = NULL;
+	}
 
 	dbidev = devm_drm_dev_alloc(dev, &ili9341_dbi_driver,
 				    struct mipi_dbi_dev, drm);


