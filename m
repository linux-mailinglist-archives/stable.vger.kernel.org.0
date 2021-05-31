Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE28A39605E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233487AbhEaOZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232997AbhEaOXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45818619CD;
        Mon, 31 May 2021 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468730;
        bh=V+Ak+bq9QckCL6JpOKpd2weyQMBPabw2Ue2S46kTYZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tO1KIbYjtXXCOKsSqkXLRh3CStrmdBZkh+WSHrDntyporMBc3Em8TMuP8skdSB7Ml
         hDiUX5CW5l9IGQUqFpk3cnGcN6TGlR6rhW4xyZMe8ov6Qtmh0yfkXAcQSXwtMbqMVd
         5bx8vfef+YnEaHPMWzmGrSMDNkP2e4eyILhbalqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/177] Revert "isdn: mISDN: Fix potential NULL pointer dereference of kzalloc"
Date:   Mon, 31 May 2021 15:14:22 +0200
Message-Id: <20210531130651.539613736@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 36a2c87f7ed9e305d05b9a5c044cc6c494771504 ]

This reverts commit 38d22659803a033b1b66cd2624c33570c0dde77d.

Because of recent interactions with developers from @umn.edu, all
commits from them have been recently re-reviewed to ensure if they were
correct or not.

Upon review, this commit was found to be incorrect for the reasons
below, so it must be reverted.  It will be fixed up "correctly" in a
later kernel change.

While it looks like the original change is correct, it is not, as none
of the setup actually happens, and the error value is not propagated
upwards.

Cc: Aditya Pakki <pakki001@umn.edu>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/r/20210503115736.2104747-47-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 008a74a1ed44..7a051435c406 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -249,9 +249,6 @@ hfcsusb_ph_info(struct hfcsusb *hw)
 	int i;
 
 	phi = kzalloc(struct_size(phi, bch, dch->dev.nrbchan), GFP_ATOMIC);
-	if (!phi)
-		return;
-
 	phi->dch.ch.protocol = hw->protocol;
 	phi->dch.ch.Flags = dch->Flags;
 	phi->dch.state = dch->state;
-- 
2.30.2



