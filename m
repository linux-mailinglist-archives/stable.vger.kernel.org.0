Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 514E95F2A3B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiJCHdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbiJCHcf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:32:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451E24DF38;
        Mon,  3 Oct 2022 00:21:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38E6DB80E90;
        Mon,  3 Oct 2022 07:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D040C433C1;
        Mon,  3 Oct 2022 07:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781558;
        bh=bLvLAYpSrTFfe7GvDq+4us9MRoQncBYlB1SEYr38dPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZwIlliDb0ifwulFXDOeGPWCQMZv1aZVh/HGeUdNFU8ixPucTf8tyGozsN2FWGJjz
         xQJSKen1tLHiuKB/ARyWuTww4ANUqWm4YALgTRcI0L2CguHCPZ2UBu0dHpK8sopqiL
         dRP/lQZjs6XaR7WOka8A8AgCTAJoWO9/0c4Znr6M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Brian Norris <briannorris@chromium.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 36/83] media: rkvdec: Disable H.264 error detection
Date:   Mon,  3 Oct 2022 09:11:01 +0200
Message-Id: <20221003070722.901877992@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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

From: Nicolas Dufresne <nicolas.dufresne@collabora.com>

commit 3a99c4474112f49a5459933d8758614002ca0ddc upstream.

Quite often, the HW get stuck in error condition if a stream error
was detected. As documented, the HW should stop immediately and self
reset. There is likely a problem or a miss-understanding of the self
reset mechanism, as unless we make a long pause, the next command
will then report an error even if there is no error in it.

Disabling error detection fixes the issue, and let the decoder continue
after an error. This patch is safe for backport into older kernels.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Tested-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/rkvdec/rkvdec-h264.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/rkvdec/rkvdec-h264.c
+++ b/drivers/staging/media/rkvdec/rkvdec-h264.c
@@ -1124,8 +1124,8 @@ static int rkvdec_h264_run(struct rkvdec
 
 	schedule_delayed_work(&rkvdec->watchdog_work, msecs_to_jiffies(2000));
 
-	writel(0xffffffff, rkvdec->regs + RKVDEC_REG_STRMD_ERR_EN);
-	writel(0xffffffff, rkvdec->regs + RKVDEC_REG_H264_ERR_E);
+	writel(0, rkvdec->regs + RKVDEC_REG_STRMD_ERR_EN);
+	writel(0, rkvdec->regs + RKVDEC_REG_H264_ERR_E);
 	writel(1, rkvdec->regs + RKVDEC_REG_PREF_LUMA_CACHE_COMMAND);
 	writel(1, rkvdec->regs + RKVDEC_REG_PREF_CHR_CACHE_COMMAND);
 


