Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F31472F11
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 15:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238184AbhLMOYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 09:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbhLMOYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 09:24:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42613C06173F
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 06:24:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09F78B81074
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 14:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA9C34601;
        Mon, 13 Dec 2021 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639405440;
        bh=lDhF3hqNE41H3vihjxOLfZclGTPUhjSwjl/L2c5ZyJg=;
        h=Subject:To:From:Date:From;
        b=BSbT4QJpfq1nkF+QF5NC3MaUMfnkKKNeHxbMenZi7M9rZu06cA+dGn0x/EriC1Ay5
         Q/ZDquQionSMERmk5V7pjq4ROSzmHewTJkRlVVK0DYkjbqFRd2TdelbZjY56Dvawyb
         vcGKb7XRLE9I0t/hD7d0fBodc8C/JyQnko6tbPhQ=
Subject: patch "usb: cdnsp: Fix issue in cdnsp_log_ep trace event" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 15:23:50 +0100
Message-ID: <1639405430180106@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix issue in cdnsp_log_ep trace event

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 50931ba27d1665c8b038cd1d16c5869301f32fd6 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Mon, 13 Dec 2021 06:06:09 +0100
Subject: usb: cdnsp: Fix issue in cdnsp_log_ep trace event

Patch fixes incorrect order of __entry->stream_id and __entry->state
parameters in TP_printk macro.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20211213050609.22640-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-trace.h b/drivers/usb/cdns3/cdnsp-trace.h
index 6a2571c6aa9e..5983dfb99653 100644
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
-- 
2.34.1


