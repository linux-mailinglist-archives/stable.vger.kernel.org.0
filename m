Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D506F4F3AA2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381636AbiDELqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354175AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D67D50E33;
        Tue,  5 Apr 2022 02:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC2E3B81B18;
        Tue,  5 Apr 2022 09:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E114C385A1;
        Tue,  5 Apr 2022 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152674;
        bh=fiVzT95+a5QkHnGpoPHbZ5qYYyO35JuD9pBA12LY8Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ja+btqe8+szqE05D2GTRsAPPAK5AxIlHm9WXmJQIOHcuO0XlqQDIZOUNXidReh1E
         UlGcJ6aa9NfniU8/SHFjVor/qXKeKKTqQMeeJNN9oHfjmzmuHySlVFCWmIHRo6xMUo
         BX1iy10PA4OXphR+G54UG0asd1/7x4hAlhotUVV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.15 861/913] platform/chrome: cros_ec_typec: Check for EC device
Date:   Tue,  5 Apr 2022 09:32:03 +0200
Message-Id: <20220405070405.634759278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -1106,7 +1106,13 @@ static int cros_typec_probe(struct platf
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


