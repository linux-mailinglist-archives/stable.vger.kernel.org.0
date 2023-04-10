Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE66DC4EC
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDJJNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 05:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjDJJNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 05:13:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A473C23
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 02:13:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3DD1619D6
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 09:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF5DC433EF;
        Mon, 10 Apr 2023 09:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681118016;
        bh=pdljobIJ/PeFITdllCBvxUtR8U1+Q+hhJLtiGjOLavI=;
        h=Subject:To:Cc:From:Date:From;
        b=AYbppaaZvdmAXnJ8vMdcL3OiUfDc3cFA/EFdedvlFdCT0VDkGqBxE/Ss4wGA2KmY7
         Lem26xMZD6xU4V9Ks7FNxcpxKR/08jrUrJEabT0O20/qQ17nNtvjTMmnl24vNuY7Qi
         UsO/07PVFdF0VbTn3SP10FGmA/dIM0J8rqxkO5zU=
Subject: FAILED: patch "[PATCH] usb: typec: altmodes/displayport: Fix configure initial pin" failed to apply to 4.19-stable tree
To:     rdbabiera@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Apr 2023 11:13:32 +0200
Message-ID: <2023041032-pasty-shifty-db8c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x eddebe39602efe631b83ff8d03f26eba12cfd760
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041032-pasty-shifty-db8c@gregkh' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

eddebe39602e ("usb: typec: altmodes/displayport: Fix configure initial pin assignment")
09fed4d64d3f ("usb: typec: altmodes/displayport: Fall back to multi-func pins")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eddebe39602efe631b83ff8d03f26eba12cfd760 Mon Sep 17 00:00:00 2001
From: RD Babiera <rdbabiera@google.com>
Date: Wed, 29 Mar 2023 21:51:59 +0000
Subject: [PATCH] usb: typec: altmodes/displayport: Fix configure initial pin
 assignment

While determining the initial pin assignment to be sent in the configure
message, using the DP_PIN_ASSIGN_DP_ONLY_MASK mask causes the DFP_U to
send both Pin Assignment C and E when both are supported by the DFP_U and
UFP_U. The spec (Table 5-7 DFP_U Pin Assignment Selection Mandates,
VESA DisplayPort Alt Mode Standard v2.0) indicates that the DFP_U never
selects Pin Assignment E when Pin Assignment C is offered.

Update the DP_PIN_ASSIGN_DP_ONLY_MASK conditional to intially select only
Pin Assignment C if it is available.

Fixes: 0e3bb7d6894d ("usb: typec: Add driver for DisplayPort alternate mode")
Cc: stable@vger.kernel.org
Signed-off-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230329215159.2046932-1-rdbabiera@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/altmodes/displayport.c b/drivers/usb/typec/altmodes/displayport.c
index 662cd043b50e..8f3e884222ad 100644
--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -112,8 +112,12 @@ static int dp_altmode_configure(struct dp_altmode *dp, u8 con)
 		if (dp->data.status & DP_STATUS_PREFER_MULTI_FUNC &&
 		    pin_assign & DP_PIN_ASSIGN_MULTI_FUNC_MASK)
 			pin_assign &= DP_PIN_ASSIGN_MULTI_FUNC_MASK;
-		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK)
+		else if (pin_assign & DP_PIN_ASSIGN_DP_ONLY_MASK) {
 			pin_assign &= DP_PIN_ASSIGN_DP_ONLY_MASK;
+			/* Default to pin assign C if available */
+			if (pin_assign & BIT(DP_PIN_ASSIGN_C))
+				pin_assign = BIT(DP_PIN_ASSIGN_C);
+		}
 
 		if (!pin_assign)
 			return -EINVAL;

