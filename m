Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD213D6068
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhGZPWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237281AbhGZPWL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:22:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED38760FC3;
        Mon, 26 Jul 2021 16:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315359;
        bh=Wc/+22xp43Ft+kw6i25b0XjpraQarER52Im8JwEnjT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oartOaqJYJB7ddt9bFHEoP5buuejfanU4zqIj7fZ5dmPD5gsp1DPddnN21ubD6ZfA
         EO0bwMsgXSeUq2jr/Pqmhx7o/Wg/b3ctaYWtGQ7HJ1QCfBmL4XT6j2Dzj2OLnZcyN6
         2xCah3Qh7SBAdh+qUvFPZLsf6NMVEsobW2Vm9TLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Klauser <tklauser@distanz.ch>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin@isovalent.com>,
        Roman Gushchin <guro@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/167] bpftool: Check malloc return value in mount_bpffs_for_pin
Date:   Mon, 26 Jul 2021 17:38:17 +0200
Message-Id: <20210726153841.544171340@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
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
index 65303664417e..6ebf2b215ef4 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -221,6 +221,11 @@ int mount_bpffs_for_pin(const char *name)
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



