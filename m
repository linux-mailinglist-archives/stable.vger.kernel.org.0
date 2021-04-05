Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02016353CFD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbhDEI5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233338AbhDEI5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91BB061393;
        Mon,  5 Apr 2021 08:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613063;
        bh=vgIbxfGf4Yc0CYaS0CQPR7umn24F1+8lruYE4uj8dAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJm58rbqKDA8/ceBgcvyRWMgSReDHm58NzeM3bUc5lmEVK1UNFGsWagKP9xAgvIqj
         PpG/9uZSx2gbpywvj3BbcoYF5qMtItgWc0g1A1QsWOphZC+X09g4+3sxtDYSXjmexe
         E3Ng2uh2y/0lE8ot/xk7AQhzqRQNF1OEjrOaF3JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atul Gopinathan <atulgopinathan@gmail.com>
Subject: [PATCH 4.9 33/35] staging: rtl8192e: Change state information from u16 to u8
Date:   Mon,  5 Apr 2021 10:54:08 +0200
Message-Id: <20210405085019.920670231@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Atul Gopinathan <atulgopinathan@gmail.com>

commit e78836ae76d20f38eed8c8c67f21db97529949da upstream.

The "u16 CcxRmState[2];" array field in struct "rtllib_network" has 4
bytes in total while the operations performed on this array through-out
the code base are only 2 bytes.

The "CcxRmState" field is fed only 2 bytes of data using memcpy():

(In rtllib_rx.c:1972)
	memcpy(network->CcxRmState, &info_element->data[4], 2)

With "info_element->data[]" being a u8 array, if 2 bytes are written
into "CcxRmState" (whose one element is u16 size), then the 2 u8
elements from "data[]" gets squashed and written into the first element
("CcxRmState[0]") while the second element ("CcxRmState[1]") is never
fed with any data.

Same in file rtllib_rx.c:2522:
	 memcpy(dst->CcxRmState, src->CcxRmState, 2);

The above line duplicates "src" data to "dst" but only writes 2 bytes
(and not 4, which is the actual size). Again, only 1st element gets the
value while the 2nd element remains uninitialized.

This later makes operations done with CcxRmState unpredictable in the
following lines as the 1st element is having a squashed number while the
2nd element is having an uninitialized random number.

rtllib_rx.c:1973:    if (network->CcxRmState[0] != 0)
rtllib_rx.c:1977:    network->MBssidMask = network->CcxRmState[1] & 0x07;

network->MBssidMask is also of type u8 and not u16.

Fix this by changing the type of "CcxRmState" from u16 to u8 so that the
data written into this array and read from it make sense and are not
random values.

NOTE: The wrong initialization of "CcxRmState" can be seen in the
following commit:

commit ecdfa44610fa ("Staging: add Realtek 8192 PCI wireless driver")

The above commit created a file `rtl8192e/ieee80211.h` which used to
have the faulty line. The file has been deleted (or possibly renamed)
with the contents copied in to a new file `rtl8192e/rtllib.h` along with
additional code in the commit 94a799425eee (tagged in Fixes).

Fixes: 94a799425eee ("From: wlanfae <wlanfae@realtek.com> [PATCH 1/8] rtl8192e: Import new version of driver from realtek")
Cc: stable@vger.kernel.org
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
Link: https://lore.kernel.org/r/20210323113413.29179-2-atulgopinathan@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtllib.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -1160,7 +1160,7 @@ struct rtllib_network {
 	bool	bWithAironetIE;
 	bool	bCkipSupported;
 	bool	bCcxRmEnable;
-	u16	CcxRmState[2];
+	u8	CcxRmState[2];
 	bool	bMBssidValid;
 	u8	MBssidMask;
 	u8	MBssid[ETH_ALEN];


