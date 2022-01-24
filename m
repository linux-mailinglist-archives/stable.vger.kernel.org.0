Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B58498E2B
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354947AbiAXTjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32808 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350901AbiAXTdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:33:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5183F61488;
        Mon, 24 Jan 2022 19:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EB0C340E5;
        Mon, 24 Jan 2022 19:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052832;
        bh=tZM5TML74UbfSY7dpcQg47KWZMIdishfAIuWtvqaerk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyS/jJCEXFQxvrCr/DY6Ulf9zZ+7hlFhckzP+6ORs7HzQJtOMleBApEENWrcbBDUp
         qCmA4W5QXFTXxJRc2QWuEGZdMTJAep/vto6FVFhlHmlAIw1p0uK+v4mIu3EdxuPKjw
         GWTmPQNIWfXhkEnheBuLI0cm2jgzzyvKgShtiQMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/320] bpf: Do not WARN in bpf_warn_invalid_xdp_action()
Date:   Mon, 24 Jan 2022 19:42:52 +0100
Message-Id: <20220124184000.041545255@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
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
index b90c0b5a10112..92ce4d46f02e4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6912,9 +6912,9 @@ void bpf_warn_invalid_xdp_action(u32 act)
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



