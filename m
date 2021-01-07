Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F82ED29C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbhAGOel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:34:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:48220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729759AbhAGOeN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:34:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 501182339D;
        Thu,  7 Jan 2021 14:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610030012;
        bh=gfaR36mNm4g5wMocpec7JhcyAr99jWZmVBNXJoNagGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dSTxHdW+w4ViIz5zf++QTHK0vF51ZIskHFBP7xA7j7kBeA1mZjBgEdEUybbfl2yJ8
         pkXyU1jDC9PkiHug7Jn6+5IfMaD53ER5TvXsKXCeiiKBQviEGwMpI5Rik25POOEe1j
         8sYhwHPjteUqUdkDQLxOGrFt2ts+uJCCAPq6wvv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Vear <edwardvear@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 07/20] Bluetooth: Fix attempting to set RPA timeout when unsupported
Date:   Thu,  7 Jan 2021 15:34:02 +0100
Message-Id: <20210107143053.441330544@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Vear <edwardvear@gmail.com>

commit a31489d2a368d2f9225ed6a6f595c63bc7d10de8 upstream.

During controller initialization, an LE Set RPA Timeout command is sent
to the controller if supported. However, the value checked to determine
if the command is supported is incorrect. Page 1921 of the Bluetooth
Core Spec v5.2 shows that bit 2 of octet 35 of the Supported_Commands
field corresponds to the LE Set RPA Timeout command, but currently
bit 6 of octet 35 is checked. This patch checks the correct value
instead.

This issue led to the error seen in the following btmon output during
initialization of an adapter (rtl8761b) and prevented initialization
from completing.

< HCI Command: LE Set Resolvable Private Address Timeout (0x08|0x002e) plen 2
        Timeout: 900 seconds
> HCI Event: Command Complete (0x0e) plen 4
      LE Set Resolvable Private Address Timeout (0x08|0x002e) ncmd 2
        Status: Unsupported Remote Feature / Unsupported LMP Feature (0x1a)
= Close Index: 00:E0:4C:6B:E5:03

The error did not appear when running with this patch.

Signed-off-by: Edward Vear <edwardvear@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Johan Hedberg <johan.hedberg@intel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bluetooth/hci_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -763,7 +763,7 @@ static int hci_init3_req(struct hci_requ
 			hci_req_add(req, HCI_OP_LE_CLEAR_RESOLV_LIST, 0, NULL);
 		}
 
-		if (hdev->commands[35] & 0x40) {
+		if (hdev->commands[35] & 0x04) {
 			__le16 rpa_timeout = cpu_to_le16(hdev->rpa_timeout);
 
 			/* Set RPA timeout */


