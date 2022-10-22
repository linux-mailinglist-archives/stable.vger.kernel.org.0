Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A2460865F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiJVHss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231415AbiJVHsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F436844D3;
        Sat, 22 Oct 2022 00:45:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41FA4B82E17;
        Sat, 22 Oct 2022 07:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4B7C43144;
        Sat, 22 Oct 2022 07:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424563;
        bh=hkN++V+EZziRXwAqDFEpFocfj0LhpT6OEj3yMchgpAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVnPlWlZJC1VhSe9LrNFVAsfNDn82o+8H63b2IqCNk2ZAUtNeAoAKMMEnCFy9EXn8
         cpFY6sKymhV4iP6cAv76AeLZHk2U8DISLfW4+xiI0glTCxbGM5f5Yw3df7/uLUMNag
         EFgyQPoVTo3G/5Qu4lDOo4XSiB3W6d8fzcrvT72Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.19 165/717] drm/nouveau/kms/nv140-: Disable interlacing
Date:   Sat, 22 Oct 2022 09:20:44 +0200
Message-Id: <20221022072444.681003556@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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


