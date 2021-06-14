Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D98F3A61FD
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234128AbhFNKyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234480AbhFNKwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91CC361474;
        Mon, 14 Jun 2021 10:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623667157;
        bh=em3TqvbmWiyZKlweTdDiS4zUd7yZKvdBMVRuYwXX6lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRFQIFZ1P37iTibeFyudBCjt50YLthEOKdog5UYV40b8mAPeeEi9efdXzvT0wzFeL
         6ZtAwIL2zVS57fDjOGaSaKAgBl8PBIUHJB7OvGDqtCNSyg1deLgZ9hKw/GZGU3ycRb
         1zaqjkEklV6rFO2ENIUxUDbHgjVYeo9STu1JZt4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Kyle Tso <kyletso@google.com>
Subject: [PATCH 5.4 48/84] usb: pd: Set PD_T_SINK_WAIT_CAP to 310ms
Date:   Mon, 14 Jun 2021 12:27:26 +0200
Message-Id: <20210614102648.003268407@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
References: <20210614102646.341387537@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kyle Tso <kyletso@google.com>

commit 6490fa565534fa83593278267785a694fd378a2b upstream.

Current timer PD_T_SINK_WAIT_CAP is set to 240ms which will violate the
SinkWaitCapTimer (tTypeCSinkWaitCap 310 - 620 ms) defined in the PD
Spec if the port is faster enough when running the state machine. Set it
to the lower bound 310ms to ensure the timeout is in Spec.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210528081613.730661-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/usb/pd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/usb/pd.h
+++ b/include/linux/usb/pd.h
@@ -425,7 +425,7 @@ static inline unsigned int rdo_max_power
 #define PD_T_SENDER_RESPONSE	60	/* 24 - 30 ms, relaxed */
 #define PD_T_SOURCE_ACTIVITY	45
 #define PD_T_SINK_ACTIVITY	135
-#define PD_T_SINK_WAIT_CAP	240
+#define PD_T_SINK_WAIT_CAP	310	/* 310 - 620 ms */
 #define PD_T_PS_TRANSITION	500
 #define PD_T_SRC_TRANSITION	35
 #define PD_T_DRP_SNK		40


