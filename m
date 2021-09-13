Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30342409620
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345510AbhIMOsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:48:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346430AbhIMOqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:46:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B173463223;
        Mon, 13 Sep 2021 13:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541525;
        bh=d0bhEeVlY/ajmP4a1Icwbf5i9Cn0ygByw4Bj7ZGLf0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXPeVosi+rx1otLDOJAdPba/AIYimeqK9aBh0o8Nwh3/cWLNoKFpgSZ8n6Jj07Rko
         UbaXVGaOHoUaBy/g1FCDmfXvZx/Vx7vSZJ20uAZ9zA1RByxUi06st6SlZSt4HwEyh5
         BeWMmWVPOda82PMj0xW1mGzHzaklOBu3dF3AvLhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.14 331/334] bootconfig: Fix missing return check of xbc_node_compose_key function
Date:   Mon, 13 Sep 2021 15:16:25 +0200
Message-Id: <20210913131124.627720597@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julio Faracco <jcfaracco@gmail.com>

commit 903bd067faa837fddb6e5c8b740c3374dc582f04 upstream.

The function `xbc_show_list should` handle the keys during the
composition. Even the errors returned by the compose function. Instead
of removing the `ret` variable, it should save the value and show the
exact error. This missing variable is causing a compilation issue also.

Link: https://lkml.kernel.org/r/163077087861.222577.12884543474750968146.stgit@devnote2

Fixes: e5efaeb8a8f5 ("bootconfig: Support mixing a value and subkeys under a key")
Signed-off-by: Julio Faracco <jcfaracco@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bootconfig/main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/bootconfig/main.c
+++ b/tools/bootconfig/main.c
@@ -111,9 +111,11 @@ static void xbc_show_list(void)
 	char key[XBC_KEYLEN_MAX];
 	struct xbc_node *leaf;
 	const char *val;
+	int ret;
 
 	xbc_for_each_key_value(leaf, val) {
-		if (xbc_node_compose_key(leaf, key, XBC_KEYLEN_MAX) < 0) {
+		ret = xbc_node_compose_key(leaf, key, XBC_KEYLEN_MAX);
+		if (ret < 0) {
 			fprintf(stderr, "Failed to compose key %d\n", ret);
 			break;
 		}


