Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFC03A9F1
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbfFIQ4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732946AbfFIQ4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:56:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D67206BB;
        Sun,  9 Jun 2019 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099377;
        bh=AMZ8Pa2Ga+mp4EZucYbNG5walQoPEp9pXA06i9UB7AQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=imwTmK6xMgTqDpwl2eyXueb6tSi8qLiBHbnuNg7yxhcTsxN5yNSUpW4+gu5TdFT/s
         KYlHRkqj4bgH2kuSre4JZEQD6YybnZ+0zIvOfhilrV20hPlcPQ21JVggtKgjBFZZAU
         GPToy/3T9zyU9bXDKurQFAjDB8o2Fk2IoHBnBBpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran Kolukuluru <kirank@ami.com>,
        Kamlakant Patel <kamlakantp@marvell.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 4.4 021/241] ipmi:ssif: compare block number correctly for multi-part return messages
Date:   Sun,  9 Jun 2019 18:39:23 +0200
Message-Id: <20190609164148.394112907@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamlakant Patel <kamlakantp@marvell.com>

commit 55be8658c7e2feb11a5b5b33ee031791dbd23a69 upstream.

According to ipmi spec, block number is a number that is incremented,
starting with 0, for each new block of message data returned using the
middle transaction.

Here, the 'blocknum' is data[0] which always starts from zero(0) and
'ssif_info->multi_pos' starts from 1.
So, we need to add +1 to blocknum while comparing with multi_pos.

Fixes: 7d6380cd40f79 ("ipmi:ssif: Fix handling of multi-part return messages").
Reported-by: Kiran Kolukuluru <kirank@ami.com>
Signed-off-by: Kamlakant Patel <kamlakantp@marvell.com>
Message-Id: <1556106615-18722-1-git-send-email-kamlakantp@marvell.com>
[Also added a debug log if the block numbers don't match.]
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Cc: stable@vger.kernel.org # 4.4
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_ssif.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -695,12 +695,16 @@ static void msg_done_handler(struct ssif
 			/* End of read */
 			len = ssif_info->multi_len;
 			data = ssif_info->data;
-		} else if (blocknum != ssif_info->multi_pos) {
+		} else if (blocknum + 1 != ssif_info->multi_pos) {
 			/*
 			 * Out of sequence block, just abort.  Block
 			 * numbers start at zero for the second block,
 			 * but multi_pos starts at one, so the +1.
 			 */
+			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
+				dev_dbg(&ssif_info->client->dev,
+					"Received message out of sequence, expected %u, got %u\n",
+					ssif_info->multi_pos - 1, blocknum);
 			result = -EIO;
 		} else {
 			ssif_inc_stat(ssif_info, received_message_parts);


