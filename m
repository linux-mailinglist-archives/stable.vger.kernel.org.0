Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC2C1EA8FB
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 19:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgFAR5k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727924AbgFAR5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:57:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D0332074B;
        Mon,  1 Jun 2020 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034254;
        bh=M/qD2bSLMro1+y1z/qphHFNwZ6JthlbwfLtVxqnMl/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQU2mr1gG6u4DG8MFzoAhf1eaXvD1pCJiOpp+9ux4juaLOTygYxz1Kl+GLubeOVSP
         voj8MO3+ve0Aqedfywk4L+okptqJs/cmYwOpgANnbdZcn8dEMRIcpVFlEOpATk2YeP
         yidxX4UyUF5CXqgSXDWRVfkAvtSfHeZ7KUwwNyvQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Kalderon <Michal.Kalderon@cavium.com>,
        Ariel Elior <Ariel.Elior@cavium.com>,
        Doug Ledford <dledford@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 12/61] IB/cma: Fix reference count leak when no ipv4 addresses are set
Date:   Mon,  1 Jun 2020 19:53:19 +0200
Message-Id: <20200601174013.911117659@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
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
@@ -208,11 +208,13 @@ static inline void iboe_addr_get_sgid(st
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


