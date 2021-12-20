Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D966A47AE3A
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbhLTO7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:59:09 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47664 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239689AbhLTO5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:57:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86BB8611CB;
        Mon, 20 Dec 2021 14:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70804C36AE7;
        Mon, 20 Dec 2021 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012226;
        bh=2nV3J5yWVeAUdb7Eg+cOE7s/75omNPi40C8ot2AEPH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUSUyMxY7o+pc6HBexapaS+U+fKTURfyuUjs598rsuU9PKeYIBURjO1n9z3tb+0/S
         6b1ilqHpCnDVZ2c20zDRPbT5ewW8Ds90+kUGES/T5+huCusM7DjgX+vSb+cV8kA2U9
         aTIrAIIOyIl+OM3zVtYafPpH18/Ob++n3RXV4k7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Chen <peter.chen@kernel.org>,
        Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.15 125/177] usb: cdnsp: Fix issue in cdnsp_log_ep trace event
Date:   Mon, 20 Dec 2021 15:34:35 +0100
Message-Id: <20211220143044.289703285@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 50931ba27d1665c8b038cd1d16c5869301f32fd6 upstream.

Patch fixes incorrect order of __entry->stream_id and __entry->state
parameters in TP_printk macro.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211213050609.22640-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-trace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-trace.h
+++ b/drivers/usb/cdns3/cdnsp-trace.h
@@ -57,9 +57,9 @@ DECLARE_EVENT_CLASS(cdnsp_log_ep,
 		__entry->first_prime_det = pep->stream_info.first_prime_det;
 		__entry->drbls_count = pep->stream_info.drbls_count;
 	),
-	TP_printk("%s: SID: %08x ep state: %x stream: enabled: %d num  %d "
+	TP_printk("%s: SID: %08x, ep state: %x, stream: enabled: %d num %d "
 		  "tds %d, first prime: %d drbls %d",
-		  __get_str(name), __entry->state, __entry->stream_id,
+		  __get_str(name), __entry->stream_id, __entry->state,
 		  __entry->enabled, __entry->num_streams, __entry->td_count,
 		  __entry->first_prime_det, __entry->drbls_count)
 );


