Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2972D676FC6
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjAVPZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjAVPZG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:25:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C69622785
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:25:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23D72B80B1D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78987C433EF;
        Sun, 22 Jan 2023 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401101;
        bh=4yE50Cdx3y7ucv06WlRzHCzL9aALG3n4N+k7exwjdQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uk6BQxorqTDZb81yT9qiqDlmSWP1A4Als2AmmagnquGqlEZMwHaPSJA5BwmcJ9DrB
         Zw/x+T1C41XL362csDn52nIUCI9X45F8kfVBpomB/NodJkRMFy66xx9dIcUu5OQJSY
         YgISn/QWfMaSsnqV8j7oU4xOP8dJXvauKUy37jQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Prashant Malani <pmalani@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 6.1 111/193] usb: typec: altmodes/displayport: Fix pin assignment calculation
Date:   Sun, 22 Jan 2023 16:04:00 +0100
Message-Id: <20230122150251.398298639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
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
@@ -426,9 +426,9 @@ static const char * const pin_assignment
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


