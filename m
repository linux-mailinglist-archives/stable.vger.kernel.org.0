Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22DCE3D5F3B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhGZPRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237413AbhGZPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5110D60FED;
        Mon, 26 Jul 2021 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314836;
        bh=8PUFWCwIFACyJkXYGlu+2hFKuSyoFNQfdVjch8m4P8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qCTyG4yILegwxxV8Me588vspLKDRyOpn5E+LmEwygpqNz8pyLNyNvLRozxFcS3EKe
         QQlTGfVkLX0aUmLR1jJ0D8Z2/BWaGGYWaH7sqFZY8rqHxz7/rMfHbTHnCXuUR3wdth
         9YqRkyn0ZRYEjnQie1QehYEQ6oLRwDxzV/0wbXrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/120] bpftool: Check malloc return value in mount_bpffs_for_pin
Date:   Mon, 26 Jul 2021 17:38:46 +0200
Message-Id: <20210726153834.757935564@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

[ Upstream commit d444b06e40855219ef38b5e9286db16d435f06dc ]

Fix and add a missing NULL check for the prior malloc() call.

Fixes: 49a086c201a9 ("bpftool: implement prog load command")
Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Acked-by: Roman Gushchin <guro@fb.com>
Link: https://lore.kernel.org/bpf/20210715110609.29364-1-tklauser@distanz.ch
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 158469f57461..7faf24ef3c80 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -182,6 +182,11 @@ int do_pin_fd(int fd, const char *name)
 		goto out;
 
 	file = malloc(strlen(name) + 1);
+	if (!file) {
+		p_err("mem alloc failed");
+		return -1;
+	}
+
 	strcpy(file, name);
 	dir = dirname(file);
 
-- 
2.30.2



