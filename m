Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23A84F338B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245517AbiDEI4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241110AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C17A1573E;
        Tue,  5 Apr 2022 01:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD4BB609D0;
        Tue,  5 Apr 2022 08:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1645C385A2;
        Tue,  5 Apr 2022 08:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147261;
        bh=ju9FU22MfB+ePx543AKTfSg4v7Ler6NNa/m0AdVhx4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sMW2+tBuPz7ujereR4yeCmG8LAzXf39iH5kBqRy5OcCU8ex3F9VBjIYleyq5hS0A
         1bHadjhHZZ35BTzWrT/1Mw4jUaWT3XvOr1N0dqZjD/ID2ZWm4wFP+6ydCJ9E0kUEwX
         WKJix49uwd3T7qXsIsUpPwAqE7Q2M6rkO/HcvIYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alyssa Ross <hi@alyssa.is>,
        Tzung-Bi Shih <tzungbi@google.com>,
        Prashant Malani <pmalani@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.17 1061/1126] platform/chrome: cros_ec_typec: Check for EC device
Date:   Tue,  5 Apr 2022 09:30:08 +0200
Message-Id: <20220405070438.604049387@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1075,7 +1075,13 @@ static int cros_typec_probe(struct platf
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


