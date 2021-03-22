Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC5F34429B
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhCVMoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhCVMlz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:41:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83703619A0;
        Mon, 22 Mar 2021 12:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416779;
        bh=18/D6XC8fh7LaP2i+q6d31ZSmvL8g5J9GiIDu+oK5mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aZUUVMIUNR9rHJ8vIAH5HF9261yBS+t4QfWeZgu/5Lkxr/8C3BaPDNGLCswNX/9D4
         FIKQRXy2LR+/a7Hq+2ndqrtq26OFEcVXDP0nMMRmVTUDuZxmzKNQs142GPjIny6z3Z
         WcHjljSzwz91Ia90fmuI0liQ1ohpdOThi1M2jIv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Elias Rudberg <mail@eliasrudberg.se>
Subject: [PATCH 5.10 119/157] usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct
Date:   Mon, 22 Mar 2021 13:27:56 +0100
Message-Id: <20210322121937.541342534@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Elias Rudberg <mail@eliasrudberg.se>

commit 3cac9104bea41099cf622091f0c0538bcb19050d upstream.

Remove the unused "u32 vdo[3]" part in the tps6598x_rx_identity_reg
struct. This helps avoid "failed to register partner" errors which
happen when tps6598x_read_partner_identity() fails because the
amount of data read is 12 bytes smaller than the struct size.
Note that vdo[3] is already in usb_pd_identity and hence
shouldn't be added to tps6598x_rx_identity_reg as well.

Fixes: f6c56ca91b92 ("usb: typec: Add the Product Type VDOs to struct usb_pd_identity")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Elias Rudberg <mail@eliasrudberg.se>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311124710.6563-1-mail@eliasrudberg.se
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tps6598x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/typec/tps6598x.c
+++ b/drivers/usb/typec/tps6598x.c
@@ -62,7 +62,6 @@ enum {
 struct tps6598x_rx_identity_reg {
 	u8 status;
 	struct usb_pd_identity identity;
-	u32 vdo[3];
 } __packed;
 
 /* Standard Task return codes */


