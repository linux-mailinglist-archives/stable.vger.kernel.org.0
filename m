Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4150383203
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240616AbhEQOnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240866AbhEQOlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CA8613AF;
        Mon, 17 May 2021 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261161;
        bh=XsYnRwTNZcPyBxGlG/1oCN2uPgUhDI/zC/nuPTGhFV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQg7iNfnltEO+vYzHEqjvBao+Q2BX0oTw4/gDY2AbVjd8ymIADlFOS4zLVDfNQI9+
         sQyR/sYn+KDFkknFUSLFIlH45eQl9Kzg1MJDIUyxdF779z5jNMbLjfNvUU062ErAM5
         n43NWNflgWkkA4foL0zDhbrbi5Zg6rJAb3wtUg7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.12 316/363] usb: typec: tcpm: Fix wrong handling in GET_SINK_CAP
Date:   Mon, 17 May 2021 16:03:02 +0200
Message-Id: <20210517140313.289180358@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 2e2b8d15adc2f6ab2d4aa0550e241b9742a436a0 upstream.

After receiving Sink Capabilities Message in GET_SINK_CAP AMS, it is
incorrect to call tcpm_pd_handle_state because the Message is expected
and the current state is not Ready states. The result of this incorrect
operation ends in Soft Reset which is definitely wrong. Simply
forwarding to Ready States is enough to finish the AMS.

Fixes: 8dea75e11380 ("usb: typec: tcpm: Protocol Error handling")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210503171849.2605302-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2387,7 +2387,7 @@ static void tcpm_pd_data_request(struct
 		port->nr_sink_caps = cnt;
 		port->sink_cap_done = true;
 		if (port->ams == GET_SINK_CAPABILITIES)
-			tcpm_pd_handle_state(port, ready_state(port), NONE_AMS, 0);
+			tcpm_set_state(port, ready_state(port), 0);
 		/* Unexpected Sink Capabilities */
 		else
 			tcpm_pd_handle_msg(port,


