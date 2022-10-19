Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E76603D47
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJSJAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232138AbiJSI7A (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E429D8768D;
        Wed, 19 Oct 2022 01:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D82F61806;
        Wed, 19 Oct 2022 08:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78188C433D6;
        Wed, 19 Oct 2022 08:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169168;
        bh=K0yeZ7/w3WHo2Xyl6Af/+8v2ksebm86re6HjFd/ClSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzkOxZYPdj8VTU5ClK4hzY7C8Wr7XZtTtXGo0KUYY7FvcOsG1UgonxfF5S/6oznrM
         eteF9y6wbtaZQReMoQyi9Lo/E7eFXErh7PTzAFaT7Asep4m9jnPKkroi8MjOE1EAJU
         nUR+wIp2xCBvakaAZ5QIu50LfpZx/40P7rGdpu2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 6.0 180/862] drm/nouveau/kms/nv140-: Disable interlacing
Date:   Wed, 19 Oct 2022 10:24:27 +0200
Message-Id: <20221019083257.911104683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -504,7 +504,8 @@ nouveau_connector_set_encoder(struct drm
 			connector->interlace_allowed =
 				nv_encoder->caps.dp_interlace;
 		else
-			connector->interlace_allowed = true;
+			connector->interlace_allowed =
+				drm->client.device.info.family < NV_DEVICE_INFO_V0_VOLTA;
 		connector->doublescan_allowed = true;
 	} else
 	if (nv_encoder->dcb->type == DCB_OUTPUT_LVDS ||


