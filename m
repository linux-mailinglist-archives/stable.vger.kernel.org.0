Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5410C6DEFB1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjDLIxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjDLIxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B418783D8
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1DCB6306D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B74C433D2;
        Wed, 12 Apr 2023 08:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288922;
        bh=4JGRkfaABeW2vM6Pg0ybjR4+395wKaZDSbKQnDp9WZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ei4ZDDKLPpFNmqgVO0Hv/KLdTVxzcMrek86mo0ucV3xHxAiQgIg6lMlNVR/SY7tKe
         29AaeiSNSwK5XOAzft+eAQsk31y/m7gHEKr+VHUGpUQrYis9oJXvv97NtO2IQoPmKN
         acripTdfDRdUh+BKiuViEOsPKtLwSUOKPzLv3O1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, RD Babiera <rdbabiera@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 068/164] usb: typec: altmodes/displayport: Fix configure initial pin assignment
Date:   Wed, 12 Apr 2023 10:33:10 +0200
Message-Id: <20230412082839.667630426@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: RD Babiera <rdbabiera@google.com>

commit eddebe39602efe631b83ff8d03f26eba12cfd760 upstream.

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
---
 drivers/usb/typec/altmodes/displayport.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/altmodes/displayport.c
+++ b/drivers/usb/typec/altmodes/displayport.c
@@ -112,8 +112,12 @@ static int dp_altmode_configure(struct d
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


