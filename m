Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB18B81AB8
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfHENIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbfHENIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:08:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 559252067D;
        Mon,  5 Aug 2019 13:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010522;
        bh=MOuKC8I1RoB4fNZwnZbzsS0b8tFGJ5lvAPB/Q8JQVmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV6Z585Ig0c9RHab2z+RLMvUoMFqyPM+8yuGNmWoqPb28PO64+vq5OdlUiaZCL16e
         iKUlGY+h4AxPRzQZlOTbHLAf0u1WcP7B16sZzVib8HJ6mge9+a1MWU5PjvkRN5xu/y
         C03PCnR7cl5COW2NM4aql0NU4J0YHVyl20VhLsSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Doug Ledford <dledford@redhat.com>
Subject: [PATCH 4.14 38/53] IB/hfi1: Fix Spectre v1 vulnerability
Date:   Mon,  5 Aug 2019 15:03:03 +0200
Message-Id: <20190805124932.331142598@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 6497d0a9c53df6e98b25e2b79f2295d7caa47b6e upstream.

sl is controlled by user-space, hence leading to a potential
exploitation of the Spectre variant 1 vulnerability.

Fix this by sanitizing sl before using it to index ibp->sl_to_sc.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://lore.kernel.org/lkml/20180423164740.GY17484@dhcp22.suse.cz/

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Link: https://lore.kernel.org/r/20190731175428.GA16736@embeddedor
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hfi1/verbs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -54,6 +54,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <rdma/opa_addr.h>
+#include <linux/nospec.h>
 
 #include "hfi.h"
 #include "common.h"
@@ -1587,6 +1588,7 @@ static int hfi1_check_ah(struct ib_devic
 	sl = rdma_ah_get_sl(ah_attr);
 	if (sl >= ARRAY_SIZE(ibp->sl_to_sc))
 		return -EINVAL;
+	sl = array_index_nospec(sl, ARRAY_SIZE(ibp->sl_to_sc));
 
 	sc5 = ibp->sl_to_sc[sl];
 	if (sc_to_vlt(dd, sc5) > num_vls && sc_to_vlt(dd, sc5) != 0xf)


