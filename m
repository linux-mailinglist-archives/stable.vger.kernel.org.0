Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3831F14F70
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbfEFPKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFOeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236B5204EC;
        Mon,  6 May 2019 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153256;
        bh=h5G9h/bRS+IuYmY6CVOdg7fWktl2RLXV8mvmFo2gtw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnxr0nOlgT3c3IPKAScI05eBnoBWaWvXyOuqO+45Okj9qQx5SXSRLz9iBP15Yc6iS
         cK3kM5dwGCFdAMEG2b9BCJhQ3UhOb6U7/dvdqvASBPPNaip1+DfPmiJPw7Yc/ce9pF
         5k9jv2H2Bx5++Sm2uDZiVgSWW9mXlY/Y+VDTesYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.0 005/122] mwifiex: Make resume actually do something useful again on SDIO cards
Date:   Mon,  6 May 2019 16:31:03 +0200
Message-Id: <20190506143055.201621206@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit b82d6c1f8f8288f744a9dcc16cd3085d535decca upstream.

The commit fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent
adapter status variables") had a fairly straightforward bug in it.  It
contained this bit of diff:

 - if (!adapter->is_suspended) {
 + if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {

As you can see the patch missed the "!" when converting to the atomic
bitops.  This meant that the resume hasn't done anything at all since
that commit landed and suspend/resume for mwifiex SDIO cards has been
totally broken.

After fixing this mwifiex suspend/resume appears to work again, at
least with the simple testing I've done.

Fixes: fc3a2fcaa1ba ("mwifiex: use atomic bitops to represent adapter status variables")
Cc: <stable@vger.kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/marvell/mwifiex/sdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -181,7 +181,7 @@ static int mwifiex_sdio_resume(struct de
 
 	adapter = card->adapter;
 
-	if (test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
+	if (!test_bit(MWIFIEX_IS_SUSPENDED, &adapter->work_flags)) {
 		mwifiex_dbg(adapter, WARN,
 			    "device already resumed\n");
 		return 0;


