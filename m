Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA41599FA7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350087AbiHSPvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350234AbiHSPuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:50:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643FF105219;
        Fri, 19 Aug 2022 08:47:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F255616B5;
        Fri, 19 Aug 2022 15:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C06BC433D6;
        Fri, 19 Aug 2022 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924077;
        bh=eH8DaH1rOHUDuA9B08awRUYCR1/DUe2jXgaguD0AhxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0lPmnkSBQPz+kfQ4fbMvsUetRVe38Uqnoz0ChAf17KGOlpS6Qxw0QizA6YbWwvfW
         IV9LqvFraEQdk0qDAAIwEn3R4hY6Sez3bdVEEwjkmnXAdre0SRnZeuy8TQWemJJyJY
         5zte+PoTrGtPvSTPmfORA09VtEOuyHxux4x14LYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 5.10 046/545] drm/nouveau/acpi: Dont print error when we get -EINPROGRESS from pm_runtime
Date:   Fri, 19 Aug 2022 17:36:56 +0200
Message-Id: <20220819153831.277673694@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 53c26181950ddc3c8ace3c0939c89e9c4d8deeb9 upstream.

Since this isn't actually a failure.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: David Airlie <airlied@linux.ie>
Fixes: 79e765ad665d ("drm/nouveau/drm/nouveau: Prevent handling ACPI HPD events too early")
Cc: <stable@vger.kernel.org> # v4.19+
Link: https://patchwork.freedesktop.org/patch/msgid/20220714174234.949259-2-lyude@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_display.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_display.c
+++ b/drivers/gpu/drm/nouveau/nouveau_display.c
@@ -543,7 +543,7 @@ nouveau_display_acpi_ntfy(struct notifie
 				 * it's own hotplug events.
 				 */
 				pm_runtime_put_autosuspend(drm->dev->dev);
-			} else if (ret == 0) {
+			} else if (ret == 0 || ret == -EINPROGRESS) {
 				/* We've started resuming the GPU already, so
 				 * it will handle scheduling a full reprobe
 				 * itself


