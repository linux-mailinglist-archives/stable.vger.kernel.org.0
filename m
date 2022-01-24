Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55984499AA0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573611AbiAXVpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50960 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456450AbiAXVjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1676B8123A;
        Mon, 24 Jan 2022 21:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB36C340E4;
        Mon, 24 Jan 2022 21:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060348;
        bh=eN+mCr4skE+vq5zxPwBpW4c7azPJ/28oHfu3vTochZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRYQvcnZc45NxvW9bQD1ZoWvYAgN9DVLIzW86aRiLjuRZC55NTzxmLpkROXHLNyVB
         SPevsSnXmUIVAUv1bAnPZYHfqktXrXGcR9qAFLwbUB0rC86/L4vF04aQDsnT/GJr+Q
         wsP2Cuk42bjgoY3UssCjoq0egu/EQe+G0vsZV55o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 0919/1039] Bluetooth: hci_sync: Fix not setting adv set duration
Date:   Mon, 24 Jan 2022 19:45:08 +0100
Message-Id: <20220124184156.191792917@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit f16a491c65d9eb19398b25aefc10c2d3313d17b3 upstream.

10bbffa3e88e attempted to fix the use of rotation duration as
advertising duration but it didn't change the if condition which still
uses the duration instead of the timeout.

Fixes: 10bbffa3e88e ("Bluetooth: Fix using advertising instance duration as timeout")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/hci_request.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1935,7 +1935,7 @@ int __hci_req_enable_ext_advertising(str
 	/* Set duration per instance since controller is responsible for
 	 * scheduling it.
 	 */
-	if (adv_instance && adv_instance->duration) {
+	if (adv_instance && adv_instance->timeout) {
 		u16 duration = adv_instance->timeout * MSEC_PER_SEC;
 
 		/* Time = N * 10 ms */


