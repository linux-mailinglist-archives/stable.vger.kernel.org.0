Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60DA20131E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390231AbgFSP5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390560AbgFSPUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:20:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A135820771;
        Fri, 19 Jun 2020 15:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580024;
        bh=74wKcSC/1/uY7MLx3rVRs5Efvh1k7Obe/4c2cXj8RbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SVSS48iR8o5gteYU+s/04b+nXJasyYT61zb5RomzVMz0sETCX2UMPDoO0QG5YQmOa
         t5phOCq2S7wMHlsHtwvAHCcmCVO5a53vviDvGxOGP0g0x74DpFEE9zKbKnXGDNYP7w
         FNGt/6chFcnr5nuEp6+SkHDriFDhQ3kv8dROKT8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 094/376] e1000: Distribute switch variables for initialization
Date:   Fri, 19 Jun 2020 16:30:12 +0200
Message-Id: <20200619141714.789670361@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a34c7f5156654ebaf7eaace102938be7ff7036cb ]

Variables declared in a switch statement before any case statements
cannot be automatically initialized with compiler instrumentation (as
they are not part of any execution flow). With GCC's proposed automatic
stack variable initialization feature, this triggers a warning (and they
don't get initialized). Clang's automatic stack variable initialization
(via CONFIG_INIT_STACK_ALL=y) doesn't throw a warning, but it also
doesn't initialize such variables[1]. Note that these warnings (or silent
skipping) happen before the dead-store elimination optimization phase,
so even when the automatic initializations are later elided in favor of
direct initializations, the warnings remain.

To avoid these problems, move such variables into the "case" where
they're used or lift them up into the main function body.

drivers/net/ethernet/intel/e1000/e1000_main.c: In function ‘e1000_xmit_frame’:
drivers/net/ethernet/intel/e1000/e1000_main.c:3143:18: warning: statement will never be executed [-Wswitch-unreachable]
 3143 |     unsigned int pull_size;
      |                  ^~~~~~~~~

[1] https://bugs.llvm.org/show_bug.cgi?id=44916

Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 0d51cbc88028..05bc6e216bca 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3136,8 +3136,9 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 		if (skb->data_len && hdr_len == len) {
 			switch (hw->mac_type) {
+			case e1000_82544: {
 				unsigned int pull_size;
-			case e1000_82544:
+
 				/* Make sure we have room to chop off 4 bytes,
 				 * and that the end alignment will work out to
 				 * this hardware's requirements
@@ -3158,6 +3159,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 				}
 				len = skb_headlen(skb);
 				break;
+			}
 			default:
 				/* do nothing */
 				break;
-- 
2.25.1



