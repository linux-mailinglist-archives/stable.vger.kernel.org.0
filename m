Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5979560FDD0
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236791AbiJ0Q70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236699AbiJ0Q7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF9A17F665
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE188B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D753C433C1;
        Thu, 27 Oct 2022 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889959;
        bh=e77SltMDh3N1oIHPnyPOIz17JKzpmxa4gY5v6TOWUt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=th0bCW61jVQly6873syH7GPiXnFPS1bXBu4poR8U+4hD4U69xVsZQVHwp7GDhNhQ3
         2ABfX5urU5oUutGIwaRknTMh1c5e4PbkQscQHIG39pOc6jAl5vyPSeEUgV/mykn3J6
         rd5kWPj5jouD7eIiknv7dtWDYtK4v4vfLBpnVDzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.0 23/94] media: venus: dec: Handle the case where find_format fails
Date:   Thu, 27 Oct 2022 18:54:25 +0200
Message-Id: <20221027165057.996118543@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
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
@@ -183,6 +183,8 @@ vdec_try_fmt_common(struct venus_inst *i
 		else
 			return NULL;
 		fmt = find_format(inst, pixmp->pixelformat, f->type);
+		if (!fmt)
+			return NULL;
 	}
 
 	pixmp->width = clamp(pixmp->width, frame_width_min(inst),


