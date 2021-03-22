Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC7B344176
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbhCVMdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCVMct (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E6826199F;
        Mon, 22 Mar 2021 12:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416369;
        bh=eJDuW1nCbwhN9OjJD1WjXaKufCCg/gLcBm8Mwb7Kxdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DJoH65wuerbYUkucoO1RYa/qcs5WKqcecRDMdXlyq213urPVVi5JNDD4bqTf/dSYp
         GCoN6YIDTt8lE4WSChGTh1TDPkpjRig/rRpGzh7HNz5FwOMZhAeRgGzRuktHgM4Hkp
         kyc802Y+7ssi6GUryI+Sv/eE6OsWx/HkPajW4afw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Elias Rudberg <mail@eliasrudberg.se>
Subject: [PATCH 5.11 081/120] usb: typec: Remove vdo[3] part of tps6598x_rx_identity_reg struct
Date:   Mon, 22 Mar 2021 13:27:44 +0100
Message-Id: <20210322121932.375287307@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
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
@@ -64,7 +64,6 @@ enum {
 struct tps6598x_rx_identity_reg {
 	u8 status;
 	struct usb_pd_identity identity;
-	u32 vdo[3];
 } __packed;
 
 /* Standard Task return codes */


