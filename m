Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C8F274F2
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 06:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfEWELx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 00:11:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43346 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfEWELx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 00:11:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id f25so2389829pgv.10
        for <stable@vger.kernel.org>; Wed, 22 May 2019 21:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cIR4uZkuyWa04euQiCUXLsu2isyA73co7gQ2Qrl8bH8=;
        b=pmYGFSUhpfMN6LBOaEospHtIoiqG4ljEPBCqoBNvPoby75XGXeRArEJpDfADsADkF+
         JQB3WU6O/sqwUFXIrh8jToZBUu1nmLqe0Y0TvsbBYRrkl9DSSCkYl5+/X7gEcf5J2OX3
         zzIqHCigBUUEJ3z4bfuhjtSIS1o+JVXcjYV5P1Sq5kTtyWlg2g6+8j2U+DulqjlM+pKk
         eAJfKbSKFGjPpWNsFWIWeAf4RAk789bQtzff+1g1L7hOiXnfHzkpNLXoCqx/LRwZipaQ
         Xu4XnVuqFJYazApHiE8mLC9bk5tBjD/MFSwlWczbo89lbFhz9XQx9uWnvgl++hn8Oq0J
         2x5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cIR4uZkuyWa04euQiCUXLsu2isyA73co7gQ2Qrl8bH8=;
        b=NmYC1nFxLKpnerA6PRrSQBIgcQYvANfhwV37w62UDaxS+EGvAgP3BA/jss2Ub+2RNH
         sQ6BhTZYFmNqJ+YYhYb874pAdLOhsgU2os1T8ga66axfHAqpVnRm4xlkoKRnEd+pLGEi
         Zokg/fRQVg2+te35xRHOX1+L6OF7hulUZt9f5hSbYKx6iXJXQByXGlJPhGVF4zGnJicV
         27u9D0Sp3R9+sv9c6a3Cth4Ts3/KgU52bMA916Mbenomx9nZfZVSVw0vq47giploV9lo
         DTspEQCy1Z5VBSollIDf1U8tSKO+srrHXNIVlHMKzJOQKrqskDPZYNrnPpMLCClH1zo+
         uwuQ==
X-Gm-Message-State: APjAAAW6ASc14Usi2oSx45onOMggW1qe74hovcfinIppVeOKdG5DR8Bv
        n6nV0FFxy5aladFVqCxLMdpdtQ==
X-Google-Smtp-Source: APXvYqwq0iTNmGUGyzcarb7+3TA6nn2I6TpaOxPmYfScvhomfwpWtUcjnFXft9Hkxn7jpQpmV2hT6A==
X-Received: by 2002:a63:5443:: with SMTP id e3mr93859550pgm.265.1558584712907;
        Wed, 22 May 2019 21:11:52 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c14sm27128096pgl.43.2019.05.22.21.11.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 21:11:52 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     sashal@kernel.org, decui@microsoft.com
Cc:     stable@vger.kernel.org, Stephen Hemminger <sthemmin@microsoft.com>
Subject: [PATCH 8/8] vmbus: fix subchannel removal
Date:   Wed, 22 May 2019 21:11:34 -0700
Message-Id: <20190523041134.26321-9-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523041134.26321-1-sthemmin@microsoft.com>
References: <20190523041134.26321-1-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit b5679cebf780c6f1c2451a73bf1842a4409840e7 upstream

The changes to split ring allocation from open/close, broke
the cleanup of subchannels. This resulted in problems using
uio on network devices because the subchannel was left behind
when the network device was unbound.

The cause was in the disconnect logic which used list splice
to move the subchannel list into a local variable. This won't
work because the subchannel list is needed later during the
process of the rescind messages (relid2channel).

The fix is to just leave the subchannel list in place
which is what the original code did. The list is cleaned
up later when the host rescind is processed.

Without the fix, we have a lot of "hang" issues in netvsc when we
try to change the NIC's MTU, set the number of channels, etc.

Fixes: ae6935ed7d42 ("vmbus: split ring buffer allocation from open")
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 170770339720..8e23ed6ea9ab 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -701,20 +701,12 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 int vmbus_disconnect_ring(struct vmbus_channel *channel)
 {
 	struct vmbus_channel *cur_channel, *tmp;
-	unsigned long flags;
-	LIST_HEAD(list);
 	int ret;
 
 	if (channel->primary_channel != NULL)
 		return -EINVAL;
 
-	/* Snapshot the list of subchannels */
-	spin_lock_irqsave(&channel->lock, flags);
-	list_splice_init(&channel->sc_list, &list);
-	channel->num_sc = 0;
-	spin_unlock_irqrestore(&channel->lock, flags);
-
-	list_for_each_entry_safe(cur_channel, tmp, &list, sc_list) {
+	list_for_each_entry_safe(cur_channel, tmp, &channel->sc_list, sc_list) {
 		if (cur_channel->rescind)
 			wait_for_completion(&cur_channel->rescind_event);
 
-- 
2.20.1

