Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700F21D8144
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgERRqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbgERRqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ACA020671;
        Mon, 18 May 2020 17:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823991;
        bh=qB6S69za/upDjQ6IFjis/RN+7uHzhvhl5QWOHDKyVAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wZd3Odnhxu9r56Gd59gzXAtO007/3nxt3OG03lJ4Jwxn1tGcDWlRZRxqcJ8dXeXA
         q28tkD4jWaQPQXm3po44z+imb9U/klmHSzxxf1xWN7FxJcne7JaY3+05TQFWaCrxIC
         xP/uHQvqH3AfkzmiK2yDTMxJ35IqznyKzYnTQmUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 027/114] batman-adv: Fix refcnt leak in batadv_store_throughput_override
Date:   Mon, 18 May 2020 19:35:59 +0200
Message-Id: <20200518173508.630185262@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 6107c5da0fca8b50b4d3215e94d619d38cc4a18c upstream.

batadv_show_throughput_override() invokes batadv_hardif_get_by_netdev(),
which gets a batadv_hard_iface object from net_dev with increased refcnt
and its reference is assigned to a local pointer 'hard_iface'.

When batadv_store_throughput_override() returns, "hard_iface" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The issue happens in one error path of
batadv_store_throughput_override(). When batadv_parse_throughput()
returns NULL, the refcnt increased by batadv_hardif_get_by_netdev() is
not decreased, causing a refcnt leak.

Fix this issue by jumping to "out" label when batadv_parse_throughput()
returns NULL.

Fixes: 0b5ecc6811bd ("batman-adv: add throughput override attribute to hard_ifaces")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/batman-adv/sysfs.c
+++ b/net/batman-adv/sysfs.c
@@ -1081,7 +1081,7 @@ static ssize_t batadv_store_throughput_o
 	ret = batadv_parse_throughput(net_dev, buff, "throughput_override",
 				      &tp_override);
 	if (!ret)
-		return count;
+		goto out;
 
 	old_tp_override = atomic_read(&hard_iface->bat_v.throughput_override);
 	if (old_tp_override == tp_override)


