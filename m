Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8623D582B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 12:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhGZKS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 06:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:42660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232518AbhGZKS5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 06:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC40860E09;
        Mon, 26 Jul 2021 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627297166;
        bh=91oMr+7Bi7WS/VkImXMfOKAv0/2/1ZhAYa/IiV5zmb8=;
        h=Subject:To:Cc:From:Date:From;
        b=OkTzBQzenoXRsXdoGjfh+fO4vZxS3dcyLUTuYCsKWV5beV9padx28lM14Oq0q4IbD
         nPrbsS/hiqkpeItrtfQFs/kOJDpxGPTXAcnVbtAD+Jt6GetXMf9m33F7WkRqJP0CW7
         6qEkAa5hfpVUa3K41Os+SByyk4Pee4pkOZoD040I=
Subject: FAILED: patch "[PATCH] sctp: do not update transport pathmtu if SPP_PMTUD_ENABLE is" failed to apply to 5.13-stable tree
To:     lucien.xin@gmail.com, davem@davemloft.net,
        jacek.szafraniec@nokia.com, marcelo.leitner@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 12:59:12 +0200
Message-ID: <16272971528490@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 02dc2ee7c7476dd831df63d2b10cc0a162a531f1 Mon Sep 17 00:00:00 2001
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 21 Jul 2021 14:45:54 -0400
Subject: [PATCH] sctp: do not update transport pathmtu if SPP_PMTUD_ENABLE is
 not set

Currently, in sctp_packet_config(), sctp_transport_pmtu_check() is
called to update transport pathmtu with dst's mtu when dst's mtu
has been changed by non sctp stack like xfrm.

However, this should only happen when SPP_PMTUD_ENABLE is set, no
matter where dst's mtu changed. This patch is to fix by checking
SPP_PMTUD_ENABLE flag before calling sctp_transport_pmtu_check().

Thanks Jacek for reporting and looking into this issue.

v1->v2:
  - add the missing "{" to fix the build error.

Fixes: 69fec325a643 ('Revert "sctp: remove sctp_transport_pmtu_check"')
Reported-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Tested-by: Jacek Szafraniec <jacek.szafraniec@nokia.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/sctp/output.c b/net/sctp/output.c
index 9032ce60d50e..4dfb5ea82b05 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -104,8 +104,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		if (asoc->param_flags & SPP_PMTUD_ENABLE)
 			sctp_assoc_sync_pmtu(asoc);
 	} else if (!sctp_transport_pl_enabled(tp) &&
-		   !sctp_transport_pmtu_check(tp)) {
-		if (asoc->param_flags & SPP_PMTUD_ENABLE)
+		   asoc->param_flags & SPP_PMTUD_ENABLE) {
+		if (!sctp_transport_pmtu_check(tp))
 			sctp_assoc_sync_pmtu(asoc);
 	}
 

