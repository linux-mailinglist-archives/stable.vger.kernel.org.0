Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692E5411EBC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346391AbhITReD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351073AbhITRby (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:31:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C5461AEB;
        Mon, 20 Sep 2021 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157483;
        bh=mntvPwIPw/A28xP3dQX3x3AcvjKZC/ZcFjfFqJ6u/40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9zAhC0FAUiNbSglmhPM2fuhbdgj2BvieT5k9BSUTmKlIj/TOAGDnYN52kNptKfbB
         +W8T9ZgIkh+edgkna2BpmfsJhfOCyvTKDVhKr/wtE3+K5B5dlURseYhOssn1msKMVV
         fMePs4TgjkxqwgYikB9UMUMNStkFi1+A1CkFBnzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>
Subject: [PATCH 4.19 012/293] clk: fix build warning for orphan_list
Date:   Mon, 20 Sep 2021 18:39:34 +0200
Message-Id: <20210920163933.678967474@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In the backport of commit bdcf1dc25324 ("clk: Evict unregistered clks
from parent caches") to the 4.19.y and 4.14.y stable trees, the
orphan_list structure was placed in the wrong location, causing loads of
build warnings on systems that do not define CONFIG_DEBUG_FS.

Fix this up by moving the structure to the correct place in the file.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -46,11 +46,6 @@ static struct hlist_head *all_lists[] =
 	NULL,
 };
 
-static struct hlist_head *orphan_list[] = {
-	&clk_orphan_list,
-	NULL,
-};
-
 /***    private data structures    ***/
 
 struct clk_core {
@@ -2629,6 +2624,11 @@ static int inited = 0;
 static DEFINE_MUTEX(clk_debug_lock);
 static HLIST_HEAD(clk_debug_list);
 
+static struct hlist_head *orphan_list[] = {
+	&clk_orphan_list,
+	NULL,
+};
+
 static void clk_summary_show_one(struct seq_file *s, struct clk_core *c,
 				 int level)
 {


