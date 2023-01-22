Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F600676E2D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjAVPHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjAVPHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:07:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208211DBBA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:07:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE326B80B16
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E392C433D2;
        Sun, 22 Jan 2023 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400066;
        bh=cc/v7m/mpHXzegOwvt3tpMdwtYJkp+XIpTEfmBwT9aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ul6P+Too4+1LmoSXL7UxeBrv07rbJt9Fa5dnkHiAai2/zMacl5uhS3XZ18oUqT79u
         7OGgD9AicUdKQ2e/jFD9jSrAxJhS9YiwwIHxyza7mrqp+Y99qHujx9g/3D3D7QRoUC
         SLNywjPKHUY0UAiauDQubMmgODddbEkmrtzzu7AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 4.19 26/37] usb: typec: altmodes/displayport: Fix pin assignment calculation
Date:   Sun, 22 Jan 2023 16:04:23 +0100
Message-Id: <20230122150220.641775235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>

commit 9682b41e52cc9f42f5c33caf410464392adaef04 upstream.

Commit c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin
assignment for UFP receptacles") fixed the pin assignment calculation
to take into account whether the peripheral was a plug or a receptacle.

But the "pin_assignments" sysfs logic was not updated. Address this by
using the macros introduced in the aforementioned commit in the sysfs
logic too.

Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct pin assignment for UFP receptacles")
Cc: stable@vger.kernel.org
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Benson Leung <bleung@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230111020546.3384569-2-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/altmodes/displayport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -418,9 +418,9 @@ static const char * const pin_assignment
 static u8 get_current_pin_assignments(struct dp_altmode *dp)
 {
 	if (DP_CONF_CURRENTLY(dp->data.conf) == DP_CONF_DFP_D)
-		return DP_CAP_UFP_D_PIN_ASSIGN(dp->alt->vdo);
+		return DP_CAP_PIN_ASSIGN_DFP_D(dp->alt->vdo);
 	else
-		return DP_CAP_DFP_D_PIN_ASSIGN(dp->alt->vdo);
+		return DP_CAP_PIN_ASSIGN_UFP_D(dp->alt->vdo);
 }
 
 static ssize_t


