Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 458174996AD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353304AbiAXVFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443499AbiAXU5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A713EC054866;
        Mon, 24 Jan 2022 12:00:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63FC3B8122A;
        Mon, 24 Jan 2022 20:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AF4C340E8;
        Mon, 24 Jan 2022 20:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054450;
        bh=twGCo6Va5F3vSA9YOP7NgbYkHKzZtHUGT0pyg9iWBIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q061FsHD2tbA8waY01+bt7dwRiPMZ3xblangEGXfpqHxPtJyEvtGjbo+kw4jIC/OZ
         nWh3uxpJloZpZfhrtB9u4o/xZAAPtxK23btqp1OjDmmxANK3jUyM68inCNIQfLrZMx
         m8q+czoYUDZ8R66eJdLS0Pt47MiVZCVQTJ8S9wFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 361/563] bpf: Do not WARN in bpf_warn_invalid_xdp_action()
Date:   Mon, 24 Jan 2022 19:42:06 +0100
Message-Id: <20220124184036.899291970@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2cbad989033bff0256675c38f96f5faab852af4b ]

The WARN_ONCE() in bpf_warn_invalid_xdp_action() can be triggered by
any bugged program, and even attaching a correct program to a NIC
not supporting the given action.

The resulting splat, beyond polluting the logs, fouls automated tools:
e.g. a syzkaller reproducers using an XDP program returning an
unsupported action will never pass validation.

Replace the WARN_ONCE with a less intrusive pr_warn_once().

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/bpf/016ceec56e4817ebb2a9e35ce794d5c917df572c.1638189075.git.pabeni@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 706c31ae65b01..7fa4283f2a8c0 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7921,9 +7921,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
 {
 	const u32 act_max = XDP_REDIRECT;
 
-	WARN_ONCE(1, "%s XDP return value %u, expect packet loss!\n",
-		  act > act_max ? "Illegal" : "Driver unsupported",
-		  act);
+	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
+		     act > act_max ? "Illegal" : "Driver unsupported",
+		     act);
 }
 EXPORT_SYMBOL_GPL(bpf_warn_invalid_xdp_action);
 
-- 
2.34.1



