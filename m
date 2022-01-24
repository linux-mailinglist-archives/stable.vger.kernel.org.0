Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF5499118
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349050AbiAXUJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:09:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376681AbiAXUDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:03:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41AEC0619D2;
        Mon, 24 Jan 2022 11:30:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C2B614BE;
        Mon, 24 Jan 2022 19:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9390FC340E5;
        Mon, 24 Jan 2022 19:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052602;
        bh=tZrs0Jt+SIkesNUNBAwCsJLLP2xGRVcbKR9NellZksk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCe0lorceJvyg1mu7IGsBu+evQQ9TOpSQesfxk1od7oUO+TaUSqrywAUs5s1ti6zO
         DCH1Ns3dbBKaypQtk7WIETIRSvt4uqvKyZTw/M5SGCIJI6mFNWt13ZLjwirlxei2k3
         eOqjQU4jVov8R7vXkh/C/Iiep9WJS2Y3LmNZpao0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Paul Chaignon <paul@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/320] bpftool: Enable line buffering for stdout
Date:   Mon, 24 Jan 2022 19:41:20 +0100
Message-Id: <20220124183956.994730693@linuxfoundation.org>
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
index 7d3cfb0ccbe61..4b03983acbefe 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -362,6 +362,8 @@ int main(int argc, char **argv)
 	};
 	int opt, ret;
 
+	setlinebuf(stdout);
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.34.1



