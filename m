Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15157593CF3
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243259AbiHOUUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243999AbiHOUSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DE145F43;
        Mon, 15 Aug 2022 12:00:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5B56B810C5;
        Mon, 15 Aug 2022 19:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3E9C433D6;
        Mon, 15 Aug 2022 19:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590031;
        bh=CBb0Nq4prmkpogVj+AXr6e4xJHBujYPfz49hr0sMgxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQweulclZqzj9c9h3EUo78X+qrr6vsFVAxhMY1ERm/lp3+XC0RlfszWzS8b6vK4Oi
         PUOVNLZcs1u2y7ieqNiYdujJqPjGK25oqZk8tw4H83jGxtL6BT8iZXtBWumVLQWmlc
         3mpC7S9HKWPv51sSgxCxi4wuIWDIDJ6Od9gUmDG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.18 0098/1095] soundwire: qcom: Check device status before reading devid
Date:   Mon, 15 Aug 2022 19:51:37 +0200
Message-Id: <20220815180433.612111006@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

commit aa1262ca66957183ea1fb32a067e145b995f3744 upstream.

As per hardware datasheet its recommended that we check the device
status before reading devid assigned by auto-enumeration.

Without this patch we see SoundWire devices with invalid enumeration
addresses on the bus.

Cc: stable@vger.kernel.org
Fixes: a6e6581942ca ("soundwire: qcom: add auto enumeration support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220706095644.5852-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/qcom.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -471,6 +471,10 @@ static int qcom_swrm_enumerate(struct sd
 	char *buf1 = (char *)&val1, *buf2 = (char *)&val2;
 
 	for (i = 1; i <= SDW_MAX_DEVICES; i++) {
+		/* do not continue if the status is Not Present  */
+		if (!ctrl->status[i])
+			continue;
+
 		/*SCP_Devid5 - Devid 4*/
 		ctrl->reg_read(ctrl, SWRM_ENUMERATOR_SLAVE_DEV_ID_1(i), &val1);
 


