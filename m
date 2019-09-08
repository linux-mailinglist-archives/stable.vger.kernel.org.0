Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE1ACE5C
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbfIHMrs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbfIHMrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:47:43 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89BD52196F;
        Sun,  8 Sep 2019 12:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946863;
        bh=/Tc/KeZM2tcLgkwQkolR8y+hBSI4+tI3PX06LjjUKII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9W5U5vVY2FjEaww2KaAJqflhr1k9qs7w9j2svSf/mEBPO3drurKmJAweCPVJQGF7
         +2mfGyyglpgUVSF2+f9slTrQXZGdm4tXHvm7pTthAc6QUC5MEpCLrJCGZCAspJCQEm
         PV0bSG+DSlPTjCXxSDHbGPa19eD2YaRij9l3ryU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/57] liquidio: add cleanup in octeon_setup_iq()
Date:   Sun,  8 Sep 2019 13:41:52 +0100
Message-Id: <20190908121136.504767578@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6f967f8b1be7001b31c46429f2ee7d275af2190f ]

If oct->fn_list.enable_io_queues() fails, no cleanup is executed, leading
to memory/resource leaks. To fix this issue, invoke
octeon_delete_instr_queue() before returning from the function.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/request_manager.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/request_manager.c b/drivers/net/ethernet/cavium/liquidio/request_manager.c
index 8f746e1348d4c..3deb3c07681fd 100644
--- a/drivers/net/ethernet/cavium/liquidio/request_manager.c
+++ b/drivers/net/ethernet/cavium/liquidio/request_manager.c
@@ -238,8 +238,10 @@ int octeon_setup_iq(struct octeon_device *oct,
 	}
 
 	oct->num_iqs++;
-	if (oct->fn_list.enable_io_queues(oct))
+	if (oct->fn_list.enable_io_queues(oct)) {
+		octeon_delete_instr_queue(oct, iq_no);
 		return 1;
+	}
 
 	return 0;
 }
-- 
2.20.1



