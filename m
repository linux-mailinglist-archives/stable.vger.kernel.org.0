Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3CD9E2E
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437889AbfJPV4t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:56:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395434AbfJPV4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:56:48 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C14BE218DE;
        Wed, 16 Oct 2019 21:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263008;
        bh=XE/YkTvqc1UUzp6Bz2d0CnVwHgwtQ36P/CX2TSzYC8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SK7A3K+9AVjizb0rEPRH6qgFZa3gJK1ZoQMRCvV+ZdTyLdBOw3x94zf6W0IQyWQmi
         iWXbNgrW37NyuI3W6T0BqweLWked5PQ+MQtZKw9o3gqD0PRin7qHZkGEXuPCHFPJ1t
         YDUzpL7vRkISrYGu2qNXrLw/ZyGYyuQrlY824F6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Schmidt <jan@centricular.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 4.19 10/81] xhci: Check all endpoints for LPM timeout
Date:   Wed, 16 Oct 2019 14:50:21 -0700
Message-Id: <20191016214815.170211026@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214805.727399379@linuxfoundation.org>
References: <20191016214805.727399379@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Schmidt <jan@centricular.com>

commit d500c63f80f2ea08ee300e57da5f2af1c13875f5 upstream.

If an endpoint is encountered that returns USB3_LPM_DEVICE_INITIATED, keep
checking further endpoints, as there might be periodic endpoints later
that return USB3_LPM_DISABLED due to shorter service intervals.

Without this, the code can set too high a maximum-exit-latency and
prevent the use of multiple USB3 cameras that should be able to work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jan Schmidt <jan@centricular.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-4-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4631,12 +4631,12 @@ static int xhci_update_timeout_for_endpo
 	alt_timeout = xhci_call_host_update_timeout_for_endpoint(xhci, udev,
 		desc, state, timeout);
 
-	/* If we found we can't enable hub-initiated LPM, or
+	/* If we found we can't enable hub-initiated LPM, and
 	 * the U1 or U2 exit latency was too high to allow
-	 * device-initiated LPM as well, just stop searching.
+	 * device-initiated LPM as well, then we will disable LPM
+	 * for this device, so stop searching any further.
 	 */
-	if (alt_timeout == USB3_LPM_DISABLED ||
-			alt_timeout == USB3_LPM_DEVICE_INITIATED) {
+	if (alt_timeout == USB3_LPM_DISABLED) {
 		*timeout = alt_timeout;
 		return -E2BIG;
 	}


