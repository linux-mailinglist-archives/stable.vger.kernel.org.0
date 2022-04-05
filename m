Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23A84F42DD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383439AbiDEMZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240067AbiDEKwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:52:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EEFA94DA;
        Tue,  5 Apr 2022 03:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B706181D;
        Tue,  5 Apr 2022 10:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B31FC385A6;
        Tue,  5 Apr 2022 10:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154490;
        bh=cCG4DXsmOt2RjegLmBychxHXXVtElDKPMsn2x6Ymw+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kVOMOsfeVIisInkqW2ceLoPlxI+H3OmsTPcMStcOmFRphrxPs6N7ckrqoFQHbI5ax
         pH5Kd4xVGc5bKCRuNT+7efH99G7QVmz9KhO1hjk2y6pBRzNgsz0epTnJRmTm6l5tf+
         4jSr9iZ6s/1YpE1Gn/4Lr8kaIYU6AILCZB0oVQY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.10 570/599] platform/chrome: cros_ec_typec: Check for EC device
Date:   Tue,  5 Apr 2022 09:34:24 +0200
Message-Id: <20220405070315.805023283@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

From: Prashant Malani <pmalani@chromium.org>

commit ffebd90532728086007038986900426544e3df4e upstream.

The Type C ACPI device on older Chromebooks is not generated correctly
(since their EC firmware doesn't support the new commands required). In
such cases, the crafted ACPI device doesn't have an EC parent, and it is
therefore not useful (it shouldn't be generated in the first place since
the EC firmware doesn't support any of the Type C commands).

To handle devices which use these older firmware revisions, check for
the parent EC device handle, and fail the probe if it's not found.

Fixes: fdc6b21e2444 ("platform/chrome: Add Type C connector class driver")
Reported-by: Alyssa Ross <hi@alyssa.is>
Reviewed-by: Tzung-Bi Shih <tzungbi@google.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Alyssa Ross <hi@alyssa.is>
Tested-by: Alyssa Ross <hi@alyssa.is>
Link: https://lore.kernel.org/r/20220126190219.3095419-1-pmalani@chromium.org
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec_typec.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/chrome/cros_ec_typec.c
+++ b/drivers/platform/chrome/cros_ec_typec.c
@@ -712,7 +712,13 @@ static int cros_typec_probe(struct platf
 		return -ENOMEM;
 
 	typec->dev = dev;
+
 	typec->ec = dev_get_drvdata(pdev->dev.parent);
+	if (!typec->ec) {
+		dev_err(dev, "couldn't find parent EC device\n");
+		return -ENODEV;
+	}
+
 	platform_set_drvdata(pdev, typec);
 
 	ret = cros_typec_get_cmd_version(typec);


