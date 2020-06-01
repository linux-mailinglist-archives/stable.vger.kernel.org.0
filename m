Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB061EAF31
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgFAR4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:37208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbgFAR4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:56:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDADB2074B;
        Mon,  1 Jun 2020 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034198;
        bh=jJlvg5Icn2RSmfrA3Oj+7GiZzqZOSE+7heMsTdczNG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLMjDxX5TzqeFSc8TQ2a0SVItUGfzKUKRUXz6nGDCGPu1KxM+yVaViO79tasAjp58
         Q3+6/D1FhdPqd/b4XN3iF9rWdC5xxVq9q3WyVmHG6UKqIefud1/ekPmgBABy4LqICM
         YiXlYLzwIXvZDsvqydQV8I3Ip6dLyYp3x8xizRq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <Michal.Kalderon@cavium.com>,
        Ariel Elior <Ariel.Elior@cavium.com>,
        Doug Ledford <dledford@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 08/48] IB/cma: Fix reference count leak when no ipv4 addresses are set
Date:   Mon,  1 Jun 2020 19:53:18 +0200
Message-Id: <20200601173954.755172639@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601173952.175939894@linuxfoundation.org>
References: <20200601173952.175939894@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kalderon, Michal <Michal.Kalderon@cavium.com>

commit 963916fdb3e5ad4af57ac959b5a03bf23f7568ca upstream.

Once in_dev_get is called to receive in_device pointer, the
in_device reference counter is increased, but if there are
no ipv4 addresses configured on the net-device the ifa_list
will be null, resulting in a flow that doesn't call in_dev_put
to decrease the ref_cnt.
This was exposed when running RoCE over ipv6 without any ipv4
addresses configured

Fixes: commit 8e3867310c90 ("IB/cma: Fix a race condition in iboe_addr_get_sgid()")

Signed-off-by: Michal Kalderon <Michal.Kalderon@cavium.com>
Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/rdma/ib_addr.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -200,11 +200,13 @@ static inline void iboe_addr_get_sgid(st
 	dev = dev_get_by_index(&init_net, dev_addr->bound_dev_if);
 	if (dev) {
 		ip4 = in_dev_get(dev);
-		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address) {
+		if (ip4 && ip4->ifa_list && ip4->ifa_list->ifa_address)
 			ipv6_addr_set_v4mapped(ip4->ifa_list->ifa_address,
 					       (struct in6_addr *)gid);
+
+		if (ip4)
 			in_dev_put(ip4);
-		}
+
 		dev_put(dev);
 	}
 }


