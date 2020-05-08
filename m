Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A62F1CAB7E
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgEHMoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgEHMoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEEA8206B8;
        Fri,  8 May 2020 12:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941847;
        bh=qFlqZJofQ0JYxLIwzenmfLslAYPbsKPPLBL4n5eMBKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjsMVoQFIwTOL5XRDAU1pogSCqDNJhzNvYo166qid9XIhiYtACQ4wVR3HTlaC3HOe
         d9ARopuBBQMn54uem22PKfMQ8VAon6SebVhtIh8Eslux9mn6kG1mMoxeIk+5EHVDj1
         GsgRhI/TlkNZF5brpVvjc2Rc+COJFFjM/TRkABeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Liping Zhang <liping.zhang@spreadtrum.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.4 197/312] netfilter: nf_tables: fix a wrong check to skip the inactive rules
Date:   Fri,  8 May 2020 14:33:08 +0200
Message-Id: <20200508123138.296946730@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

commit 8fff1722f705ce5023a0d6d77a31a9d013be2a34 upstream.

nft_genmask_cur has already done left-shift operator on the gencursor,
so there's no need to do left-shift operator on it again.

Fixes: ea4bd995b0f2 ("netfilter: nf_tables: add transaction helper functions")
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -130,7 +130,7 @@ next_rule:
 	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
 
 		/* This rule is not active, skip. */
-		if (unlikely(rule->genmask & (1 << gencursor)))
+		if (unlikely(rule->genmask & gencursor))
 			continue;
 
 		rulenum++;


