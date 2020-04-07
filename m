Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6261A1570
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgDGTA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:00:57 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40091 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGTA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 15:00:56 -0400
Received: by mail-ot1-f67.google.com with SMTP id q2so1512260otk.7;
        Tue, 07 Apr 2020 12:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i6Rke21c7HzyIE71azx+YQ2nW1pQCz0twQ+N1utavcs=;
        b=jPj8NKg0WYgoAO+45DKwLOhaP4AukUCrZr8EPlWBKEyrrOhsClxMi0q0ot59czhts2
         ZTvuhzN4BvSa5hiL78unndB4vfTk1cZjLtoRQRXN+sos6duXtVm3Q2STdGIeyKWHzFCG
         oMySyzMZHEzGRo/wfJJagmR5PLmrFfN1SF3B6D4atT+HLF71P0Z+lqkt7Idw75wkvF5U
         tNYlLgVc2AzMFFIBfmfVTl0ZG5E2/P4yjdt1h57q4Ni9S+VL6s6oHlYgR7ROuGNSWbg7
         5PhEhFz4JoVMOVwEvX5aevDwiNgV7J0Uq526RkcbvfAQj1aGhP7hvaFAuIgPLEupguJP
         IKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=i6Rke21c7HzyIE71azx+YQ2nW1pQCz0twQ+N1utavcs=;
        b=kIjXVNfvGjZqzEMXImFWAhHCfBtdwu6P3Fas+th1q54kS+fLzhe8tl3+RlzGpPmK+k
         oY7GMLk2cAmdeQJgvI8SeuaD4OaS07SUBGnHLtRoc//hkBpoM4cWN+P20Lg/MtcRTfKv
         JqKmySj2zTcD13ikYv6IC3oot3t2hHjghtI+FKnVIky4dfvi9UOHCjkQxh/31KoeG6Hq
         TNN1dd1tYnja1ByVXxMlo0ecXy8VE7luoUDN5G2evv5qGRPZfUfZek0m+7obXMSk2gd+
         rpFlHPlAZvrEDnT2Zc742fF3mg4ipm1md7vrCg901t/H40BguCdx3Z7EJQs2sjEfBxrF
         e6eA==
X-Gm-Message-State: AGi0Puar9ir3OsAvLJQplxjqhX9zntZT50gi7aObXkJy8a4M6EYqMPuD
        Tk/XvCKmh9+cCb9XgNRL+1iWAony
X-Google-Smtp-Source: APiQypLRexzIAh5Oj1MLcufKS8JAKqh3ZYQMqJFvW9CNm0qFaVPWpaMi/u95QNFhUYnCyJDyM2rzfg==
X-Received: by 2002:a9d:12a6:: with SMTP id g35mr2778402otg.333.1586286054777;
        Tue, 07 Apr 2020 12:00:54 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id w13sm5399983otm.7.2020.04.07.12.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 12:00:54 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] b43legacy: Fix case where channel status is corrupted
Date:   Tue,  7 Apr 2020 14:00:43 -0500
Message-Id: <20200407190043.1686-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes commit 75388acd0cd8 ("add mac80211-based driver for
legacy BCM43xx devices")

In https://bugzilla.kernel.org/show_bug.cgi?id=207093, a defect in
b43legacy is reported. Upon testing, thus problem exists on PPC and
X86 platforms, is present in the oldest kernel tested (3.2), and
has been present in the driver since it was first added to the kernel.

The problem is a corrupted channel status received from the device.
Both the internal card in a PowerBook G4 and the PCMCIA version
(Broadcom BCM4306 with PCI ID 14e4:4320) have the problem. Only Rev, 2
(revision 4 of the 802.11 core) of the chip has been tested. No other
devices using b43legacy are available for testing.

Various sources of the problem were considered. Buffer overrun and
other sources of corruption within the driver were rejected because
the faulty channel status is always the same, not a random value.
It was concluded that the faulty data is coming from the device, probably
due to a firmware bug. As that source is not available, the driver
must take appropriate action to recover.

At present, the driver reports the error, and them continues to process
the bad packet. This is believed that to be a mistake, and the correct
action is to drop the correpted packet.

Fixes: 75388acd0cd8 ("add mac80211-based driver for legacy BCM43xx devices")
Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested by: F. Erhard <erhard_f@mailbox.org>
---

Kali

This bug has been present since 2007 with no complaints. In addition,
the user with a problem already has the fix. I see no rush with this one.

Larry
---
 drivers/net/wireless/broadcom/b43legacy/xmit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43legacy/xmit.c b/drivers/net/wireless/broadcom/b43legacy/xmit.c
index e9b23c2e5bd4..efd63f4ce74f 100644
--- a/drivers/net/wireless/broadcom/b43legacy/xmit.c
+++ b/drivers/net/wireless/broadcom/b43legacy/xmit.c
@@ -558,6 +558,7 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 	default:
 		b43legacywarn(dev->wl, "Unexpected value for chanstat (0x%X)\n",
 		       chanstat);
+		goto drop;
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(skb), &status, sizeof(status));
-- 
2.26.0

