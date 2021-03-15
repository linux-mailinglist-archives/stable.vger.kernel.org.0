Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D333B703
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhCON7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232295AbhCON6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04E4764EEE;
        Mon, 15 Mar 2021 13:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816691;
        bh=p76rbDwW1w8jCes+Z2r7yGvDwugLj1yjh7B30IYj5qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VD+oTcY05G91vNVgJG9xTVitEb100DC0MqXS8jnlnY+oAnIyxEZpkXiGAhOJNuWKa
         L7ux3/ancaDUxfyCWFeHBGQV/oKmNxmoHZXqzcNUXSB7lmxWl1ScuGB2c+AiAYSv4s
         PzBvkNgI46JqV+jXwjmLzC14CuoLLtDHeK8rt8D0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 009/120] netfilter: x_tables: gpf inside xt_find_revision()
Date:   Mon, 15 Mar 2021 14:56:00 +0100
Message-Id: <20210315135720.318743938@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Vasily Averin <vvs@virtuozzo.com>

commit 8e24edddad152b998b37a7f583175137ed2e04a5 upstream.

nested target/match_revfn() calls work with xt[NFPROTO_UNSPEC] lists
without taking xt[NFPROTO_UNSPEC].mutex. This can race with module unload
and cause host to crash:

general protection fault: 0000 [#1]
Modules linked in: ... [last unloaded: xt_cluster]
CPU: 0 PID: 542455 Comm: iptables
RIP: 0010:[<ffffffff8ffbd518>]  [<ffffffff8ffbd518>] strcmp+0x18/0x40
RDX: 0000000000000003 RSI: ffff9a5a5d9abe10 RDI: dead000000000111
R13: ffff9a5a5d9abe10 R14: ffff9a5a5d9abd8c R15: dead000000000100
(VvS: %R15 -- &xt_match,  %RDI -- &xt_match.name,
xt_cluster unregister match in xt[NFPROTO_UNSPEC].match list)
Call Trace:
 [<ffffffff902ccf44>] match_revfn+0x54/0xc0
 [<ffffffff902ccf9f>] match_revfn+0xaf/0xc0
 [<ffffffff902cd01e>] xt_find_revision+0x6e/0xf0
 [<ffffffffc05a5be0>] do_ipt_get_ctl+0x100/0x420 [ip_tables]
 [<ffffffff902cc6bf>] nf_getsockopt+0x4f/0x70
 [<ffffffff902dd99e>] ip_getsockopt+0xde/0x100
 [<ffffffff903039b5>] raw_getsockopt+0x25/0x50
 [<ffffffff9026c5da>] sock_common_getsockopt+0x1a/0x20
 [<ffffffff9026b89d>] SyS_getsockopt+0x7d/0xf0
 [<ffffffff903cbf92>] system_call_fastpath+0x25/0x2a

Fixes: 656caff20e1 ("netfilter 04/09: x_tables: fix match/target revision lookup")
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/x_tables.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -335,6 +335,7 @@ static int match_revfn(u8 af, const char
 	const struct xt_match *m;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(m, &xt[af].match, list) {
 		if (strcmp(m->name, name) == 0) {
 			if (m->revision > *bestp)
@@ -343,6 +344,7 @@ static int match_revfn(u8 af, const char
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return match_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -355,6 +357,7 @@ static int target_revfn(u8 af, const cha
 	const struct xt_target *t;
 	int have_rev = 0;
 
+	mutex_lock(&xt[af].mutex);
 	list_for_each_entry(t, &xt[af].target, list) {
 		if (strcmp(t->name, name) == 0) {
 			if (t->revision > *bestp)
@@ -363,6 +366,7 @@ static int target_revfn(u8 af, const cha
 				have_rev = 1;
 		}
 	}
+	mutex_unlock(&xt[af].mutex);
 
 	if (af != NFPROTO_UNSPEC && !have_rev)
 		return target_revfn(NFPROTO_UNSPEC, name, revision, bestp);
@@ -376,12 +380,10 @@ int xt_find_revision(u8 af, const char *
 {
 	int have_rev, best = -1;
 
-	mutex_lock(&xt[af].mutex);
 	if (target == 1)
 		have_rev = target_revfn(af, name, revision, &best);
 	else
 		have_rev = match_revfn(af, name, revision, &best);
-	mutex_unlock(&xt[af].mutex);
 
 	/* Nothing at all?  Return 0 to try loading module. */
 	if (best == -1) {


