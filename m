Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA62149A907
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321929AbiAYDUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47272 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350390AbiAXTuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:50:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E99560916;
        Mon, 24 Jan 2022 19:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31978C340E5;
        Mon, 24 Jan 2022 19:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053819;
        bh=DIgOYh03wvGFM6IJ9KVgmDtuQm5cPvldYLsK2fYZFS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UpB0S+hT+NxGW0jsNFzckQ8B/JMargJefU/i0rZT7YnG9000+p/l/ZHnCT2Pp0zDn
         OgyxdQeSVVtzABY4I+owx3lFRAzs0J4pSiGCZgSicMcjgwXBTeIqVD1iKXdizfz5E+
         qLZrJZxwBY4raCuGiOEy9Q6gM4fT6SKg4dILWuAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Paul Chaignon <paul@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 188/563] bpftool: Enable line buffering for stdout
Date:   Mon, 24 Jan 2022 19:39:13 +0100
Message-Id: <20220124184030.919378117@linuxfoundation.org>
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

From: Paul Chaignon <paul@isovalent.com>

[ Upstream commit 1a1a0b0364ad291bd8e509da104ac8b5b1afec5d ]

The output of bpftool prog tracelog is currently buffered, which is
inconvenient when piping the output into other commands. A simple
tracelog | grep will typically not display anything. This patch fixes it
by enabling line buffering on stdout for the whole bpftool binary.

Fixes: 30da46b5dc3a ("tools: bpftool: add a command to dump the trace pipe")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Paul Chaignon <paul@isovalent.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20211220214528.GA11706@Mem
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index c58a135dc355e..1854d6b978604 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -396,6 +396,8 @@ int main(int argc, char **argv)
 	};
 	int opt, ret;
 
+	setlinebuf(stdout);
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.34.1



