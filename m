Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD764499AC9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447083AbiAXVqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377494AbiAXVhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC40C0BD134;
        Mon, 24 Jan 2022 12:24:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4A3614F5;
        Mon, 24 Jan 2022 20:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47A3C340E5;
        Mon, 24 Jan 2022 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055850;
        bh=jQGBoTqr9shnkEu4/oGJtKoL0aT8tTQAr2VKPfxz14c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfyUJjQAJQAWq09BSltEbl8a34HV9OfYaUpyz0ZPvym5n/37AZ0IkoqJuSHQCow04
         ogU8DDggK0A3qboFQT+j5MCNeBCqVWIoNAkdegdXojWjsdRn2Opf5FPQUe0GxNrejW
         wlagtbvG/GOrpWRgQ4ImI5qoRLt37zCt+S7YCJ8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>,
        Paul Chaignon <paul@isovalent.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 285/846] bpftool: Enable line buffering for stdout
Date:   Mon, 24 Jan 2022 19:36:42 +0100
Message-Id: <20220124184110.756508559@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 02eaaf065f651..d27ec4f852bbb 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -402,6 +402,8 @@ int main(int argc, char **argv)
 	};
 	int opt, ret;
 
+	setlinebuf(stdout);
+
 	last_do_help = do_help;
 	pretty_output = false;
 	json_output = false;
-- 
2.34.1



