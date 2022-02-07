Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064084ABA72
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383750AbiBGLXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354815AbiBGLM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:12:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC89C043188;
        Mon,  7 Feb 2022 03:12:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B462611AA;
        Mon,  7 Feb 2022 11:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC7DC004E1;
        Mon,  7 Feb 2022 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232344;
        bh=FE2h/zvvcUjsME01AwRtBtnb1+6moFaXnxKmjhwCs3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7/ngxnbVgbeCX6qVlzE8O9AH4ps0gtGp6nlrlGQs2YMcGT5zfFqnonfebWn1yj0U
         sMjsyBmaxFVW1riW6xZT2ClV7wFswN6mTp6z4951DdVyS5+G+NFYMOeMQznijVTlem
         +gsI/UCf2NbQCp50STInFUh3gLB3aGECndjVhu/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 4.14 15/69] usb: typec: tcpm: Do not disconnect while receiving VBUS off
Date:   Mon,  7 Feb 2022 12:05:37 +0100
Message-Id: <20220207103756.117211011@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Badhri Jagan Sridharan <badhri@google.com>

commit 90b8aa9f5b09edae6928c0561f933fec9f7a9987 upstream.

With some chargers, vbus might momentarily raise above VSAFE5V and fall
back to 0V before tcpm gets to read port->tcpc->get_vbus. This will
will report a VBUS off event causing TCPM to transition to
SNK_UNATTACHED where it should be waiting in either SNK_ATTACH_WAIT
or SNK_DEBOUNCED state. This patch makes TCPM avoid vbus off events
while in SNK_ATTACH_WAIT or SNK_DEBOUNCED state.

Stub from the spec:
    "4.5.2.2.4.2 Exiting from AttachWait.SNK State
    A Sink shall transition to Unattached.SNK when the state of both
    the CC1 and CC2 pins is SNK.Open for at least tPDDebounce.
    A DRP shall transition to Unattached.SRC when the state of both
    the CC1 and CC2 pins is SNK.Open for at least tPDDebounce."

[23.194131] CC1: 0 -> 0, CC2: 0 -> 5 [state SNK_UNATTACHED, polarity 0, connected]
[23.201777] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[23.209949] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 170 ms [rev3 NONE_AMS]
[23.300579] VBUS off
[23.300668] state change SNK_ATTACH_WAIT -> SNK_UNATTACHED [rev3 NONE_AMS]
[23.301014] VBUS VSAFE0V
[23.301111] Start toggling

Fixes: f0690a25a140b8 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20220122015520.332507-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/typec/tcpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/typec/tcpm.c
+++ b/drivers/staging/typec/tcpm.c
@@ -3103,7 +3103,8 @@ static void _tcpm_pd_vbus_off(struct tcp
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:


