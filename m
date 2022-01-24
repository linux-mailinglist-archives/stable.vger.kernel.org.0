Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C026B49A29A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365856AbiAXXvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356424AbiAXWz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:55:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78006C0680BD;
        Mon, 24 Jan 2022 13:10:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 401AAB810BD;
        Mon, 24 Jan 2022 21:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E52C340E5;
        Mon, 24 Jan 2022 21:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058603;
        bh=GenLxtxLRHNWfA86dEZ+thJRET1S9HTGCB7UNjRlrEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i52JiI3TTBbe8kszDIbz5mnNnirjtwDoK5q661/dXpzXlGrqlckxUU639KUh3BgHd
         /DOSeg+cMPK2iDsPHCRzpUzytbi0mM/eeopgOTx9hSGEzm80Y0roFa3AzD3oNbjexP
         Mk46JPpXSMczI85bUMwU/fRoh6O2/MXwc6gfpdlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Paul Chaignon <paul@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0343/1039] bpftool: Enable line buffering for stdout
Date:   Mon, 24 Jan 2022 19:35:32 +0100
Message-Id: <20220124184136.830520895@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index 28237d7cef67f..8fbcff9d557d9 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -400,6 +400,8 @@ int main(int argc, char **argv)
 	};
 	int opt, ret;
 
+	setlinebuf(stdout);
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.34.1



