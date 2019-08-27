Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09B59F65B
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfH0Wqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 18:46:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44554 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfH0Wqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 18:46:44 -0400
Received: by mail-ot1-f68.google.com with SMTP id w4so789213ote.11;
        Tue, 27 Aug 2019 15:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X+nREUwlvZXeg9X1aSX0ROEww5kCvuINCgrBH5wkbvw=;
        b=AaNy3pDQEz4qKUspyqPvb/jUVpmOatG2OMB/sfCKSylcXVoApZPklZVchlOZQfRE1L
         p87wAnWdZeR9RrlOY/7xFUk1jZiRYmq7mfSIyyUjifWPyO2omyXEBvMto5xpnUJz0os3
         ghIOSBq74gba7SFTuZx9cVEi7JYSmiKwJuxTA6hSN4Y5ugyyhUffNddvx5/Yohz89slD
         1xcVm9nT5tYkGauj/wFH0fm6aIzRR7kF0exOObDrIbtNMb3QwxCvqA7xSEfIV16QtdT1
         KHn2PcY/df0l14EGlt40Bw+NoBK7csYul9oSCyjVx33TZ2e9xgQcKpR4ZW2mLNTe+o9k
         sRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X+nREUwlvZXeg9X1aSX0ROEww5kCvuINCgrBH5wkbvw=;
        b=ju8Yf13Ony7IlPXYTzqXNyEQsFuXQr67DUD/kVW6A2ydazXeURxX7iNjsLaJbS1790
         5BMwZfTQgA2/tgiN3q+HtKlHBt/GQ6NktVEZQB37vzXMutOk3yPFDkKiGi4QTNuSVeiK
         NJejZWuJHZQ6wRuiRrxYOvLnuo54DcNov2ljnJUUkmbQLCgCB6JuXEC0ZWQt4cWXHAvF
         1U+P9FIUUiA5JgAj87JcQQ5wHXo+o/n87Ibbnp2LIKnILD9OxgQvDa6ZTcied1JbBn9Y
         6kJulL9al+k/7qqGNie+IG/AzUBb/mXLMkmwz9gJ2qAWnJ1HrqA/dBF+NwRKrICftEJq
         +Gnw==
X-Gm-Message-State: APjAAAU4XpHLwIs8Tc925wr1+7CtSGQC8mKMy0lLJ2sDLqJr7YBlNM9H
        WrbBjK68yJ5zYnGGdMwBeK32zsCY
X-Google-Smtp-Source: APXvYqyC9uItvFTAEkvyjpaI4wJtSJfSyQOnYnSFOkp2/pG8b3xd6J1sDqIVmRQNwC5EVuwRNRed2Q==
X-Received: by 2002:a9d:70cf:: with SMTP id w15mr849477otj.320.1566946003753;
        Tue, 27 Aug 2019 15:46:43 -0700 (PDT)
Received: from localhost.localdomain (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.gmail.com with ESMTPSA id a94sm289911otb.15.2019.08.27.15.46.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 15:46:43 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] mac80211: Correctly set noencrypt for PAE frames
Date:   Tue, 27 Aug 2019 17:41:20 -0500
Message-Id: <20190827224120.14545-3-denkenz@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190827224120.14545-1-denkenz@gmail.com>
References: <20190827224120.14545-1-denkenz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The noencrypt flag was intended to be set if the "frame was received
unencrypted" according to include/uapi/linux/nl80211.h.  However, the
current behavior is opposite of this.

Cc: stable@vger.kernel.org
Fixes: 018f6fbf540d ("mac80211: Send control port frames over nl80211")
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7c4aeac006fb..8514c1f4ca90 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2447,7 +2447,7 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 		      skb->protocol == cpu_to_be16(ETH_P_PREAUTH)) &&
 		     sdata->control_port_over_nl80211)) {
 		struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-		bool noencrypt = status->flag & RX_FLAG_DECRYPTED;
+		bool noencrypt = (status->flag & RX_FLAG_DECRYPTED) == 0;
 
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
-- 
2.19.2

