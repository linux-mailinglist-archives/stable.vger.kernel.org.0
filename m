Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96AB60FE39
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbiJ0RDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236879AbiJ0RDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2D118F271
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC46623ED
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC53C433D6;
        Thu, 27 Oct 2022 17:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890198;
        bh=dB+hDIDqyTXkhgxJzKHaYP0HMFYnopuQiVsFovqBxCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHJ9Tk2wrvyYK8a37vAL+j5ZjOGHp9iynXZ3nTr3qHhD1zcq+d9rx5wvrAKLohHOU
         XZzM/SHuMg0j9uT5xwgr6xRZNZtheaGMeB9i1X3hTXLWRDKZeK7Gxvd+AOUHSF0DWs
         /9vvSDgmGeJs2lWoK70P6WqmgChH1u1EF16JDOCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 29/79] media: venus: dec: Handle the case where find_format fails
Date:   Thu, 27 Oct 2022 18:55:27 +0200
Message-Id: <20221027165055.919503221@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

commit 06a2da340f762addc5935bf851d95b14d4692db2 upstream.

Debugging the decoder on msm8916 I noticed the vdec probe was crashing if
the fmt pointer was NULL.

A similar fix from Colin Ian King found by Coverity was implemented for the
encoder. Implement the same fix on the decoder.

Fixes: 7472c1c69138 ("[media] media: venus: vdec: add video decoder files")
Cc: stable@vger.kernel.org  # v4.13+
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/vdec.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -158,6 +158,8 @@ vdec_try_fmt_common(struct venus_inst *i
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),


