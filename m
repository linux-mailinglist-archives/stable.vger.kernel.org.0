Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B52B4A41EA
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343950AbiAaLHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:07:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52000 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358897AbiAaLFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:05:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E6FB82A4D;
        Mon, 31 Jan 2022 11:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BC1C340E8;
        Mon, 31 Jan 2022 11:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627105;
        bh=OUhEJvXOgBhzU0u44Xd5EN8/jjiRO3tNqHcCjxWqQWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDXdrTsZUAOC81xYn7YHII6954FFocynvZ7Bt8w0badzGoh6hMhrxjUx3jqev8Zio
         PhXb9xD6+uSgWjVYC6Jp8qIm3kPFNJnZS6sYcVH6aelz6UHrGps9mShXzrWn1sCvKF
         QbjKHr7+U4mWnchpu4hlseX9Ag0D0y+uuW4vdqhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.10 033/100] usb: typec: tcpm: Do not disconnect while receiving VBUS off
Date:   Mon, 31 Jan 2022 11:55:54 +0100
Message-Id: <20220131105221.560972591@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 drivers/usb/typec/tcpm/tcpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -4164,7 +4164,8 @@ static void _tcpm_pd_vbus_off(struct tcp
 	case SNK_TRYWAIT_DEBOUNCE:
 		break;
 	case SNK_ATTACH_WAIT:
-		tcpm_set_state(port, SNK_UNATTACHED, 0);
+	case SNK_DEBOUNCED:
+		/* Do nothing, as TCPM is still waiting for vbus to reaach VSAFE5V to connect */
 		break;
 
 	case SNK_NEGOTIATE_CAPABILITIES:


