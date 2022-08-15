Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDC6593B02
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbiHOUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345940AbiHOUBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:01:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCC77B1F4;
        Mon, 15 Aug 2022 11:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D41561227;
        Mon, 15 Aug 2022 18:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A22FC433C1;
        Mon, 15 Aug 2022 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589607;
        bh=qmAwL4dfCbVkHN98smibt7siZPH+IcCOgX81JiDmpik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8kM0y3Iqp9+BKVF0lcSIR2JcS8nGqVv0goczF6VeZy4x3ZlTcARhzCpHzBBNpoq+
         CTkCcSMIeDBL8c7wg6aG8DlcQAm5GzxGGQqb+fwDU1OkdJzFOt02W2cTQfygvI8roW
         gqITkQS//GvnD6yfZgM2tDOuLmm2Hyan2512SrQE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>
Subject: [PATCH 5.15 772/779] drm/meson: Fix refcount leak in meson_encoder_hdmi_init
Date:   Mon, 15 Aug 2022 20:06:56 +0200
Message-Id: <20220815180410.395878169@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

commit 7381076809586528e2a812a709e2758916318a99 upstream.

of_find_device_by_node() takes reference, we should use put_device()
to release it when not need anymore.
Add missing put_device() in error path to avoid refcount
leak.

Fixes: 0af5e0b41110 ("drm/meson: encoder_hdmi: switch to bridge DRM_BRIDGE_ATTACH_NO_CONNECTOR")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511054052.51981-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -438,8 +438,10 @@ int meson_encoder_hdmi_init(struct meson
 		cec_fill_conn_info_from_drm(&conn_info, meson_encoder_hdmi->connector);
 
 		notifier = cec_notifier_conn_register(&pdev->dev, NULL, &conn_info);
-		if (!notifier)
+		if (!notifier) {
+			put_device(&pdev->dev);
 			return -ENOMEM;
+		}
 
 		meson_encoder_hdmi->cec_notifier = notifier;
 	}


