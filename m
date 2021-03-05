Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D585032EA28
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232812AbhCEMgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232286AbhCEMg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:36:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D6C664FF0;
        Fri,  5 Mar 2021 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947788;
        bh=2bo71qpCCT+TnORrIQ17DkEIX86OvWsxQeV8oXRVmtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zqtmVWVo6pC2FWKXUXCLp3y1mjJrVJw7iQaMX1JGXVCPxYFS0l0s30zN0cXn85LBl
         EdECpIgCHuv5Tm8kwMpUlVWIJv0TuIZ/ok7fveSFZtlKTxQOSNgrF3qCDDYlcLgcmY
         GH54R2rABxFZTsOKKzJzjZ7zAbDSOZDklFK8zAcc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6d31bf169a8265204b8d@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.19 12/52] media: mceusb: sanity check for prescaler value
Date:   Fri,  5 Mar 2021 13:21:43 +0100
Message-Id: <20210305120854.269375710@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120853.659441428@linuxfoundation.org>
References: <20210305120853.659441428@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit 9dec0f48a75e0dadca498002d25ef4e143e60194 upstream.

prescaler larger than 8 would mean the carrier is at most 152Hz,
which does not make sense for IR carriers.

Reported-by: syzbot+6d31bf169a8265204b8d@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -685,11 +685,18 @@ static void mceusb_dev_printdata(struct
 				data[0], data[1]);
 			break;
 		case MCE_RSP_EQIRCFS:
+			if (!data[0] && !data[1]) {
+				dev_dbg(dev, "%s: no carrier", inout);
+				break;
+			}
+			// prescaler should make sense
+			if (data[0] > 8)
+				break;
 			period = DIV_ROUND_CLOSEST((1U << data[0] * 2) *
 						   (data[1] + 1), 10);
 			if (!period)
 				break;
-			carrier = (1000 * 1000) / period;
+			carrier = USEC_PER_SEC / period;
 			dev_dbg(dev, "%s carrier of %u Hz (period %uus)",
 				 inout, carrier, period);
 			break;


