Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594DD61105F
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 14:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJ1ME4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 08:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiJ1MEw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 08:04:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D96E21B9D4
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 05:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 756CA62809
        for <stable@vger.kernel.org>; Fri, 28 Oct 2022 12:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B719C433C1;
        Fri, 28 Oct 2022 12:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666958684;
        bh=dB+hDIDqyTXkhgxJzKHaYP0HMFYnopuQiVsFovqBxCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwuSs7+rt87Yopc/baG/J0pCNA0nQjwA1fzPuFoXsJDFtqWypBr09bhb1JHN4Sf0u
         CRn75UqQqiAsAL0XeX3abACnf+mFDPUr/9baT0SwpJ8SmwwkyGMpw0jPtT2GF1K5LK
         thPc7ed98zIooos3qHA2uZXPVPi5ye1IMAi8vWxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.10 14/73] media: venus: dec: Handle the case where find_format fails
Date:   Fri, 28 Oct 2022 14:03:11 +0200
Message-Id: <20221028120232.986942929@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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


