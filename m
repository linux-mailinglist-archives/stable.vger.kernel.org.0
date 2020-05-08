Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE34C1CAF1A
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgEHNOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728289AbgEHMq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16DF62145D;
        Fri,  8 May 2020 12:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942016;
        bh=oUncj4ZTgEbLMvRgVhyKKWVu5NsBh1svonvVs+5ViS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCsZ0eTeTwrSyShLL4yoG1oq9FB5PGQ6mmon65LRZVXRkoGVlaRfzu0IB0ZLzU6+D
         736NB9/TkD3O/Vb/JhkWMziddnlCB1n7uvo7woycXBWDxmvshNiKNyYGxXExDaetDF
         bV6223GgWdKB10xkXGoh0ii4eSLZdkzzx3ZfnVdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 262/312] macvtap: segmented packet is consumed
Date:   Fri,  8 May 2020 14:34:13 +0200
Message-Id: <20200508123142.851600982@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit be0bd3160165e42783d8215f426e41c07179c08a upstream.

If GSO packet is segmented and its segments are properly queued,
we call consume_skb() instead of kfree_skb() to be drop monitor
friendly.

Fixes: 3e4f8b7873709 ("macvtap: Perform GSO on forwarding path.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vlad Yasevich <vyasevic@redhat.com>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -373,7 +373,7 @@ static rx_handler_result_t macvtap_handl
 			goto wake_up;
 		}
 
-		kfree_skb(skb);
+		consume_skb(skb);
 		while (segs) {
 			struct sk_buff *nskb = segs->next;
 


