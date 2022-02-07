Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599A94ABC8D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386832AbiBGLhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384635AbiBGL3a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3586CC02B5E8;
        Mon,  7 Feb 2022 03:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9ED9B811A6;
        Mon,  7 Feb 2022 11:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15284C004E1;
        Mon,  7 Feb 2022 11:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233264;
        bh=G53Ov27bx25K4bYLcs+JBgsqz22eleL4UIUrJ3J1pmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gbZY4oNOQnU/lNERKTOyZazLtMML9qlLGYS4FsB4liIPLvvFiRhASabY2s5NDMc6F
         C6vaStQpXGDD6xtSMudmyKM+vYB2SMGPo25qLe3N39KVOwd6le0xUYlKeDUYjCzvaY
         H5fU8lV3poNovXUdxBiW86ZUk3lH2v6owomuhNBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anitha Chrisanthus <anitha.chrisanthus@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.15 068/110] drm/kmb: Fix for build errors with Warray-bounds
Date:   Mon,  7 Feb 2022 12:06:41 +0100
Message-Id: <20220207103804.581728460@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Anitha Chrisanthus <anitha.chrisanthus@intel.com>

commit 43f2517955875be5d96b641fba33d73097fe3cd9 upstream.

This fixes the following build error

drivers/gpu/drm/kmb/kmb_plane.c: In function 'kmb_plane_atomic_disable':
drivers/gpu/drm/kmb/kmb_plane.c:165:34: error: array subscript 3 is above array bounds of 'struct layer_status[2]' [-Werror=array-bounds]
  165 |                 kmb->plane_status[plane_id].ctrl =
  LCD_CTRL_GL2_ENABLE;
  |                 ~~~~~~~~~~~~~~~~~^~~~~~~~~~
  In file included from drivers/gpu/drm/kmb/kmb_plane.c:17:
  drivers/gpu/drm/kmb/kmb_drv.h:61:41: note: while referencing 'plane_status'
  61 |         struct layer_status  plane_status[KMB_MAX_PLANES];
  |                                         ^~~~~~~~~~~~
  drivers/gpu/drm/kmb/kmb_plane.c:162:34: error: array subscript 2 is above array bounds of 'struct layer_status[2]' [-Werror=array-bounds]
  162 |  kmb->plane_status[plane_id].ctrl =  LCD_CTRL_GL1_ENABLE;
  |                 ~~~~~~~~~~~~~~~~~^~~~~~~~~~
  In file included from
  drivers/gpu/drm/kmb/kmb_plane.c:17:
  drivers/gpu/drm/kmb/kmb_drv.h:61:41: note: while referencing 'plane_status'
  61 |         struct layer_status  plane_status[KMB_MAX_PLANES];
  |
  ^~~~~~~~~~~~

Fixes: 7f7b96a8a0a1 ("drm/kmb: Add support for KeemBay Display")
Signed-off-by: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220127194227.2213608-1-anitha.chrisanthus@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/kmb/kmb_plane.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/gpu/drm/kmb/kmb_plane.c
+++ b/drivers/gpu/drm/kmb/kmb_plane.c
@@ -158,12 +158,6 @@ static void kmb_plane_atomic_disable(str
 	case LAYER_1:
 		kmb->plane_status[plane_id].ctrl = LCD_CTRL_VL2_ENABLE;
 		break;
-	case LAYER_2:
-		kmb->plane_status[plane_id].ctrl = LCD_CTRL_GL1_ENABLE;
-		break;
-	case LAYER_3:
-		kmb->plane_status[plane_id].ctrl = LCD_CTRL_GL2_ENABLE;
-		break;
 	}
 
 	kmb->plane_status[plane_id].disable = true;


