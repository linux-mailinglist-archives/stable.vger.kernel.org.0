Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D8C540FB5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354757AbiFGTLo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355041AbiFGTKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:10:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155BF2AC47;
        Tue,  7 Jun 2022 11:06:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3853EB82348;
        Tue,  7 Jun 2022 18:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B998C36AFE;
        Tue,  7 Jun 2022 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625210;
        bh=bEMjmt/fs8kRVG7tWEi/Vb+6ioSU5XDC+V8l26sZGkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfmDPShatAto70AOAajWCtNr7RjoDvwbZhi5+Xc82tefPtvB6OHb8flYz1IHbJeWq
         H7SkRgt+JNw/MgMp804ivbppJnxp1VovpTui9RBBtcikd0r7UQmWyMYCJCFVC00IAU
         79SwX4tFiSgq8YAvvxK3upG96PQT3+cchs2a5oBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 604/667] mmc: core: Allows to override the timeout value for ioctl() path
Date:   Tue,  7 Jun 2022 19:04:29 +0200
Message-Id: <20220607164952.792744222@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

commit 23e09be254f95a5b75cd87f91a4014f3b46dda3f upstream.

Occasionally, user-land applications initiate longer timeout values for certain commands
through ioctl() system call. But so far we are still using a fixed timeout of 10 seconds
in mmc_poll_for_busy() on the ioctl() path, even if a custom timeout is specified in the
userspace application. This patch allows custom timeout values to override this default
timeout values on the ioctl path.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Acked-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20220423221623.1074556-3-huobean@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -609,11 +609,11 @@ static int __mmc_blk_ioctl_cmd(struct mm
 
 	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
-		 * Ensure RPMB/R1B command has completed by polling CMD13
-		 * "Send Status".
+		 * Ensure RPMB/R1B command has completed by polling CMD13 "Send Status". Here we
+		 * allow to override the default timeout value if a custom timeout is specified.
 		 */
-		err = mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, false,
-					MMC_BUSY_IO);
+		err = mmc_poll_for_busy(card, idata->ic.cmd_timeout_ms ? : MMC_BLK_TIMEOUT_MS,
+					false, MMC_BUSY_IO);
 	}
 
 	return err;


