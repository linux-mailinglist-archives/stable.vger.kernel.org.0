Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501F1354080
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240012AbhDEJSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239928AbhDEJSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:18:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1EE56128B;
        Mon,  5 Apr 2021 09:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614285;
        bh=1FlLlzjcLm0GeT7D8m4KQAXu/GrkAdfaWvVzN3j0/p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm49azLg8U4EqGZHLCiT03oo9iFV0WCac51KyFRtj/+USH9RfB68noE+n0hze6d1r
         Olwcw35hHTih7gnPaA/mFCZs51r9cip3TWDsjhz1kGmxkD8wFwAMEzYBzepHBKECR3
         CxW44Xnf41kA5O++sO9i7kaeU0Wa194qli/9FpuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atul Gopinathan <atulgopinathan@gmail.com>
Subject: [PATCH 5.11 145/152] staging: rtl8192e: Fix incorrect source in memcpy()
Date:   Mon,  5 Apr 2021 10:54:54 +0200
Message-Id: <20210405085038.926261539@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

commit 72ad25fbbb78930f892b191637359ab5b94b3190 upstream.

The variable "info_element" is of the following type:

	struct rtllib_info_element *info_element

defined in drivers/staging/rtl8192e/rtllib.h:

	struct rtllib_info_element {
		u8 id;
		u8 len;
		u8 data[];
	} __packed;

The "len" field defines the size of the "data[]" array. The code is
supposed to check if "info_element->len" is greater than 4 and later
equal to 6. If this is satisfied then, the last two bytes (the 4th and
5th element of u8 "data[]" array) are copied into "network->CcxRmState".

Right now the code uses "memcpy()" with the source as "&info_element[4]"
which would copy in wrong and unintended information. The struct
"rtllib_info_element" has a size of 2 bytes for "id" and "len",
therefore indexing will be done in interval of 2 bytes. So,
"info_element[4]" would point to data which is beyond the memory
allocated for this pointer (that is, at x+8, while "info_element" has
been allocated only from x to x+7 (2 + 6 => 8 bytes)).

This patch rectifies this error by using "&info_element->data[4]" which
correctly copies the last two bytes of "data[]".

NOTE: The faulty line of code came from the following commit:

commit ecdfa44610fa ("Staging: add Realtek 8192 PCI wireless driver")

The above commit created the file `rtl8192e/ieee80211/ieee80211_rx.c`
which had the faulty line of code. This file has been deleted (or
possibly renamed) with the contents copied in to a new file
`rtl8192e/rtllib_rx.c` along with additional code in the commit
94a799425eee (tagged in Fixes).

Fixes: 94a799425eee ("From: wlanfae <wlanfae@realtek.com> [PATCH 1/8] rtl8192e: Import new version of driver from realtek")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210323113413.29179-1-atulgopinathan@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtllib_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1968,7 +1968,7 @@ static void rtllib_parse_mife_generic(st
 	    info_element->data[2] == 0x96 &&
 	    info_element->data[3] == 0x01) {
 		if (info_element->len == 6) {
-			memcpy(network->CcxRmState, &info_element[4], 2);
+			memcpy(network->CcxRmState, &info_element->data[4], 2);
 			if (network->CcxRmState[0] != 0)
 				network->bCcxRmEnable = true;
 			else


