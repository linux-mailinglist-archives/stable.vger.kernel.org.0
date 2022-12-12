Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 731FD64A0A8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiLLN22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiLLN2J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:28:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D624D97
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:28:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE94A61053
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D248C433D2;
        Mon, 12 Dec 2022 13:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670851686;
        bh=c+zOY0RhwOXblJOFhBONr4D0iyGGCwCyf/TPmyisYKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgyccGQDS6/17LhMzkgatfk2ElgqMHella/cT+pgBJBeFnvZP4GwpKGJ0Tea6RgX5
         ajToSJ7Fi0lQJFpitIvQib37f8jpXimS7qTfcx0PMMYJc7HcqELMkyBI7Xi1OEy/Qb
         B0AOBVj1QRJEFu/Iwa9hqF/ykgugbZEAYOrUIoEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zack Rusin <zackr@vmware.com>,
        Nicholas Hunt <nhunt@vmware.com>,
        Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 5.15 049/123] drm/vmwgfx: Dont use screen objects when SEV is active
Date:   Mon, 12 Dec 2022 14:16:55 +0100
Message-Id: <20221212130928.983378153@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
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

From: Zack Rusin <zackr@vmware.com>

commit 6e90293618ed476d6b11f82ce724efbb9e9a071b upstream.

When SEV is enabled gmr's and mob's are explicitly disabled because
the encrypted system memory can not be used by the hypervisor.

The driver was disabling GMR's but the presentation code, which depends
on GMR's, wasn't honoring it which lead to black screen on hosts
with SEV enabled.

Make sure screen objects presentation is not used when guest memory
regions have been disabled to fix presentation on SEV enabled hosts.

Fixes: 3b0d6458c705 ("drm/vmwgfx: Refuse DMA operation when SEV encryption is active")
Cc: <stable@vger.kernel.org> # v5.7+
Signed-off-by: Zack Rusin <zackr@vmware.com>
Reported-by: Nicholas Hunt <nhunt@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221201175341.491884-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_scrn.c
@@ -953,6 +953,10 @@ int vmw_kms_sou_init_display(struct vmw_
 	struct drm_device *dev = &dev_priv->drm;
 	int i, ret;
 
+	/* Screen objects won't work if GMR's aren't available */
+	if (!dev_priv->has_gmr)
+		return -ENOSYS;
+
 	if (!(dev_priv->capabilities & SVGA_CAP_SCREEN_OBJECT_2)) {
 		return -ENOSYS;
 	}


