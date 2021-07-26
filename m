Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AD93D5F49
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhGZPR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237455AbhGZPPr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A36176056C;
        Mon, 26 Jul 2021 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314975;
        bh=MWklM0rEk760mfXekcQuBCMz1VDfjcOWRYa676jgxZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4GQVywH61PmFQZkq+JWFD6PqEir94u7yHxGmMg9oLtNX3Zu1U8Ud6uX7SwlRFHf0
         j+Z/EdKsdX4vwT1Cbm81cKQ3adNyhD4PLSfpCJrIkPPb4dLZzaIdOtonF500yBJj3p
         QH0qQWfG4FYlezIw3j0N+DB/gkRZsSlwGZJ998iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/108] bpftool: Check malloc return value in mount_bpffs_for_pin
Date:   Mon, 26 Jul 2021 17:38:41 +0200
Message-Id: <20210726153832.976453423@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index 88264abaa738..a209f53901b8 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -171,6 +171,11 @@ int mount_bpffs_for_pin(const char *name)
 	int err = 0;
 
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



