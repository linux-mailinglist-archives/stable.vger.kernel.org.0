Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22DC660A3CB
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiJXMAY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232543AbiJXL7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6073E7C1E8;
        Mon, 24 Oct 2022 04:48:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF9A36128E;
        Mon, 24 Oct 2022 11:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAD6C433C1;
        Mon, 24 Oct 2022 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612078;
        bh=PXpipTnBrRLPqsNN64DZFWvxTM737PnWfsW5sg9ZY+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LN8WMaNCCi7KFXAY/V1XaiaHhofeOI8JAxLDenexJp5QR4qZzXCr/1RC8zChm3otJ
         uyIZDcy8MkHosRqwD1UuVZCB2rCt0YwjaUJxzFnGdUPVs3Ivx4hcgHKnrVw4zNHG1E
         ms7U0rFsvMIawf+Yowi8cfl/MKHKD6b8lR2Mf5IY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andrew Chernyakov <acherniakov@astralinux.ru>
Subject: [PATCH 4.14 034/210] rpmsg: qcom: glink: replace strncpy() with strscpy_pad()
Date:   Mon, 24 Oct 2022 13:29:11 +0200
Message-Id: <20221024112958.072393418@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 766279a8f85df32345dbda03b102ca1ee3d5ddea upstream.

The use of strncpy() is considered deprecated for NUL-terminated
strings[1]. Replace strncpy() with strscpy_pad(), to keep existing
pad-behavior of strncpy, similarly to commit 08de420a8014 ("rpmsg:
glink: Replace strncpy() with strscpy_pad()").  This fixes W=1 warning:

  In function ‘qcom_glink_rx_close’,
    inlined from ‘qcom_glink_work’ at ../drivers/rpmsg/qcom_glink_native.c:1638:4:
  drivers/rpmsg/qcom_glink_native.c:1549:17: warning: ‘strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]
   1549 |                 strncpy(chinfo.name, channel->name, sizeof(chinfo.name));

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220519073330.7187-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Andrew Chernyakov <acherniakov@astralinux.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rpmsg/qcom_glink_native.c |    2 +-
 drivers/rpmsg/qcom_smd.c          |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1447,7 +1447,7 @@ static void qcom_glink_rx_close(struct q
 	cancel_work_sync(&channel->intent_work);
 
 	if (channel->rpdev) {
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1000,7 +1000,7 @@ static int qcom_smd_create_device(struct
 
 	/* Assign public information to the rpmsg_device */
 	rpdev = &qsdev->rpdev;
-	strncpy(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
+	strscpy_pad(rpdev->id.name, channel->name, RPMSG_NAME_SIZE);
 	rpdev->src = RPMSG_ADDR_ANY;
 	rpdev->dst = RPMSG_ADDR_ANY;
 
@@ -1230,7 +1230,7 @@ static void qcom_channel_state_worker(st
 
 		spin_unlock_irqrestore(&edge->channels_lock, flags);
 
-		strncpy(chinfo.name, channel->name, sizeof(chinfo.name));
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
 		chinfo.src = RPMSG_ADDR_ANY;
 		chinfo.dst = RPMSG_ADDR_ANY;
 		rpmsg_unregister_device(&edge->dev, &chinfo);


