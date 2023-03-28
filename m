Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322B16CC374
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbjC1OyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbjC1OyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AAB8DBC9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5ACB617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031CDC433D2;
        Tue, 28 Mar 2023 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015238;
        bh=nYN8+71foBTiqgYHHhcWxzxib4C6f8/REBE4g+lz67w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zct/yuzcgPp0OoNopvBqfQK+gJh+XPGYtH04iyiZhUdcdEs5QEhhFagXuz6EeX7vB
         KsFYlbpKWLOXnUL0j4VgK0TWIXPmVFTL036V5vEQPFk901XOvMzq6yEKfu2WbO/3ZE
         HnYsjwhgf1zIF7oAjyQdOIKH3pRrwJw2r6qT5i/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matheus Castello <matheus.castello@toradex.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.2 217/240] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found
Date:   Tue, 28 Mar 2023 16:43:00 +0200
Message-Id: <20230328142628.753042927@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matheus Castello <matheus.castello@toradex.com>

commit 1a70ca89d59c7c8af006d29b965a95ede0abb0da upstream.

Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
with what all the other DRM bridge drivers are doing and this is
required since the bridge might not be there when the driver is probed
and this should not be a fatal failure.

Cc: <stable@vger.kernel.org>
Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Matheus Castello <matheus.castello@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230322143821.109744-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -659,8 +659,8 @@ static int lt8912_parse_dt(struct lt8912
 
 	lt->hdmi_port = of_drm_find_bridge(port_node);
 	if (!lt->hdmi_port) {
-		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
-		ret = -ENODEV;
+		ret = -EPROBE_DEFER;
+		dev_err_probe(lt->dev, ret, "%s: Failed to get hdmi port\n", __func__);
 		goto err_free_host_node;
 	}
 


