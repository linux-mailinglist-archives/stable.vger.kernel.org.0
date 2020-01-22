Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6A71451E0
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgAVJbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729637AbgAVJbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:31:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A36724672;
        Wed, 22 Jan 2020 09:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685481;
        bh=0wWvWshp+tvgSFI8pOHOJrx1Z8wnPY0sv8HdFJhYBDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7si5bRl7mz1nWde0buWQb4KAnPXsYhbKJ+EmW4+ghOomVMSZ9DWJeO9DcNyOZ3py
         NmdqQBZE1A0cfYs4JEG2hx0qtpzbVbtsyLmsT2B8+/nHRNi+F6HmkBX+rThixuZT4l
         7jgK4XLvt1J5IKKQ7DuHZ1ZOi0C09ahLbFOoO23E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 04/76] rsi: add fix for crash during assertions
Date:   Wed, 22 Jan 2020 10:28:20 +0100
Message-Id: <20200122092752.135518029@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
References: <20200122092751.587775548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sanjay Konduri <sanjay.konduri@redpinesignals.com>

commit abd39c6ded9db53aa44c2540092bdd5fb6590fa8 upstream.

Observed crash in some scenarios when assertion has occurred,
this is because hw structure is freed and is tried to get
accessed in some functions where null check is already
present. So, avoided the crash by making the hw to NULL after
freeing.

Signed-off-by: Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -199,6 +199,7 @@ void rsi_mac80211_detach(struct rsi_hw *
 		ieee80211_stop_queues(hw);
 		ieee80211_unregister_hw(hw);
 		ieee80211_free_hw(hw);
+		adapter->hw = NULL;
 	}
 
 	rsi_remove_dbgfs(adapter);


