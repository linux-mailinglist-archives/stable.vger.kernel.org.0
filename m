Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E8732EA97
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhCEMjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:39:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhCEMi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:38:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3774664FF0;
        Fri,  5 Mar 2021 12:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947937;
        bh=ten8VZA0HMjTVB4OJBxb18K57bDdXHdD+HdxiunCSFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7uIw1N5eZSzNip37Nug+Fuqq4AfZy3Q8rpYLU1N0dKHh3bUZR0OD4B3sTkssRY1x
         VoSkUYYhCbdfV5+BGut2AzO85HKaveHdy0xMCUzf6Xs9AV6OTWHDZ097y+3Ifk+nnm
         p+mbGsLlNZ82UcuP/QR43leOFw7zSUPJHrv/V9qo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6d31bf169a8265204b8d@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.14 12/39] media: mceusb: sanity check for prescaler value
Date:   Fri,  5 Mar 2021 13:22:11 +0100
Message-Id: <20210305120852.379092766@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120851.751937389@linuxfoundation.org>
References: <20210305120851.751937389@linuxfoundation.org>
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
@@ -630,11 +630,18 @@ static void mceusb_dev_printdata(struct
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


