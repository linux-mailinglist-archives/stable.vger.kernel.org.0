Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF00378566
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhEJLAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhEJKz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5082A61075;
        Mon, 10 May 2021 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643453;
        bh=Zrn6PZ/vD053kAqHNW7k7BCKX5TpMdTryt4Px1tVa7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0RdaM/nk4nUlny7rvAXixGYzOP45nWZRTPV5zy0U0hcM6UegBi1RCWhCTKpACrX+1
         /+vqK420cmNBTR9bJC1gwPSjE0C5zelWZamyTiFmor9rdBrg0nhJvk1vVdw/RaoBn6
         7bDFtTOznZ+A5iprFPGVDHdgKPpTquScaGxdX3Y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Shuo Chen <shuochen@google.com>,
        Jason Baron <jbaron@akamai.com>
Subject: [PATCH 5.11 007/342] dyndbg: fix parsing file query without a line-range suffix
Date:   Mon, 10 May 2021 12:16:37 +0200
Message-Id: <20210510102010.349904686@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuo Chen <shuochen@google.com>

commit 7b1ae248279bea33af9e797a93c35f49601cb8a0 upstream.

Query like 'file tcp_input.c line 1234 +p' was broken by
commit aaebe329bff0 ("dyndbg: accept 'file foo.c:func1' and 'file
foo.c:10-100'") because a file name without a ':' now makes the loop in
ddebug_parse_query() exits early before parsing the 'line 1234' part.
As a result, all pr_debug() in tcp_input.c will be enabled, instead of only
the one on line 1234.  Changing 'break' to 'continue' fixes this.

Fixes: aaebe329bff0 ("dyndbg: accept 'file foo.c:func1' and 'file foo.c:10-100'")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Shuo Chen <shuochen@google.com>
Acked-by: Jason Baron <jbaron@akamai.com>
Link: https://lore.kernel.org/r/20210414212400.2927281-1-giantchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/dynamic_debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -396,7 +396,7 @@ static int ddebug_parse_query(char *word
 			/* tail :$info is function or line-range */
 			fline = strchr(query->filename, ':');
 			if (!fline)
-				break;
+				continue;
 			*fline++ = '\0';
 			if (isalpha(*fline) || *fline == '*' || *fline == '?') {
 				/* take as function name */


