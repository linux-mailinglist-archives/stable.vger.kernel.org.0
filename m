Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750BDF7BA2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfKKSiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728943AbfKKSiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:38:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84DD02173B;
        Mon, 11 Nov 2019 18:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497486;
        bh=YUrDBmEZdgID93bbtuJb1eaRIraFqaGkPIKly41YPBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKbu4VSdg00xvLJIW8J5qFPKdVX25WQM2kJoXhMYaqUCUHcelDS7h1OcMXLH76tij
         F6VZR3qU8G+51HI6U4PUjWMDhy7OWZH9QdlF7mKcTe76ktHNGAZLGel++r9PhqihI8
         Fmz1wgTV7u6dA3F69JXoGi6oXuwvc33/PISH7jVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Lixu <lixu.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/105] HID: intel-ish-hid: fix wrong error handling in ishtp_cl_alloc_tx_ring()
Date:   Mon, 11 Nov 2019 19:28:40 +0100
Message-Id: <20191111181445.725737941@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 16ff7bf6dbcc6f77d2eec1ac9120edf44213c2f1 ]

When allocating tx ring buffers failed, should free tx buffers, not rx buffers.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp/client-buffers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp/client-buffers.c b/drivers/hid/intel-ish-hid/ishtp/client-buffers.c
index b9b917d2d50db..c41dbb167c91b 100644
--- a/drivers/hid/intel-ish-hid/ishtp/client-buffers.c
+++ b/drivers/hid/intel-ish-hid/ishtp/client-buffers.c
@@ -90,7 +90,7 @@ int ishtp_cl_alloc_tx_ring(struct ishtp_cl *cl)
 	return	0;
 out:
 	dev_err(&cl->device->dev, "error in allocating Tx pool\n");
-	ishtp_cl_free_rx_ring(cl);
+	ishtp_cl_free_tx_ring(cl);
 	return	-ENOMEM;
 }
 
-- 
2.20.1



