Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 514C911F76
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfEBPre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfEBPYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:24:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E92ED208C4;
        Thu,  2 May 2019 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810649;
        bh=5GKA2ndTMnBO9OGe+bY2RSGvKe0hCCrXFPdVQ/SPbLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flwfVSUVx3EffgBh/QnFfoAbQKcbodQDXzv7+FDEDuZAteUZIu515RRNuzJsbySdS
         HlTxbJHokKN5PdNH1IgYMgeoPYcaoQF6jKAifldCnWPEH00xI2MBA03YbrEyogJWd7
         1rSGv9Y4iOX5yQvUd28PcdLKbTg+y3F8YGNI86G0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.14 26/49] staging: rtlwifi: rtl8822b: fix to avoid potential NULL pointer dereference
Date:   Thu,  2 May 2019 17:21:03 +0200
Message-Id: <20190502143327.196651698@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143323.397051088@linuxfoundation.org>
References: <20190502143323.397051088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d70d70aec9632679dd00dcc1b1e8b2517e2c7da0 ]

skb allocated via dev_alloc_skb can fail and return a NULL pointer.
This patch avoids such a scenario and returns, consistent with other
invocations.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/staging/rtlwifi/rtl8822be/fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/rtlwifi/rtl8822be/fw.c b/drivers/staging/rtlwifi/rtl8822be/fw.c
index acabb2470d55..02ca3157c5a5 100644
--- a/drivers/staging/rtlwifi/rtl8822be/fw.c
+++ b/drivers/staging/rtlwifi/rtl8822be/fw.c
@@ -752,6 +752,8 @@ void rtl8822be_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool b_dl_finished)
 		      u1_rsvd_page_loc, 3);
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	memcpy((u8 *)skb_put(skb, totalpacketlen), &reserved_page_packet,
 	       totalpacketlen);
 
-- 
2.19.1



