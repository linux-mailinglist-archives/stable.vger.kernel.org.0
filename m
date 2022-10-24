Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E86EB60BD0A
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiJXWEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiJXWEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5D050531;
        Mon, 24 Oct 2022 13:18:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ACD861286;
        Mon, 24 Oct 2022 12:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B234BC433C1;
        Mon, 24 Oct 2022 12:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615222;
        bh=hkN++V+EZziRXwAqDFEpFocfj0LhpT6OEj3yMchgpAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUpGFyFBXnr//HfjdXtjxnr/hMQ71oLMyU+KLkObn8hki+NUGdV7uA6iMv8+Lkpqq
         epsL+5rLwIdggGDl/8eb/iIJ45Jz+FUHTlf/hAEvwrJOz5bXGHpOZmOig2px421gC3
         WI4mb7wWqfFw63NMsbskx3dTQnmxDtlyk4sy/8Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 128/530] drm/nouveau/kms/nv140-: Disable interlacing
Date:   Mon, 24 Oct 2022 13:27:52 +0200
Message-Id: <20221024113050.860144557@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 8ba9249396bef37cb68be9e8dee7847f1737db9d upstream.

As it turns out: while Nvidia does actually have interlacing knobs on their
GPU still pretty much no current GPUs since Volta actually support it.
Trying interlacing on these GPUs will result in NVDisplay being quite
unhappy like so:

nouveau 0000:1f:00.0: disp: chid 0 stat 00004802 reason 4 [INVALID_ARG] mthd 2008 data 00000001 code 00080000
nouveau 0000:1f:00.0: disp: chid 0 stat 10005080 reason 5 [INVALID_STATE] mthd 0200 data 00000001 code 00000001

So let's fix this by following the same behavior Nvidia's driver does and
disable interlacing entirely.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220816180436.156310-1-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -503,7 +503,8 @@ nouveau_connector_set_encoder(struct drm
 			connector->interlace_allowed =
 				nv_encoder->caps.dp_interlace;
 		else
-			connector->interlace_allowed = true;
+			connector->interlace_allowed =
+				drm->client.device.info.family < NV_DEVICE_INFO_V0_VOLTA;
 		connector->doublescan_allowed = true;
 	} else
 	if (nv_encoder->dcb->type == DCB_OUTPUT_LVDS ||


