Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E4823A4F1
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgHCMbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbgHCMbq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:31:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80EF208E4;
        Mon,  3 Aug 2020 12:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457905;
        bh=Hy8mBhV7h9SLwvg7GqfwObL1tL77wSLQh01A/CTIrhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq+s4C6vfk0jeZhnLAkglojCP564gH8MRuQyRgEY4eEANy6j5z+K2GdYG+yCiN/JW
         bJQx9TGnwpFc1uvnQwDPDpvfftHHUWtdK5+wyOVL10M76AzndC1oM2lBw2CT/skMGI
         /oYKwo1toVMtksa5Jc294nfTTgoutqTiRfA3xjxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 05/56] tracing: Have error path in predicate_parse() free its allocated memory
Date:   Mon,  3 Aug 2020 14:19:20 +0200
Message-Id: <20200803121850.577138860@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 96c5c6e6a5b6db592acae039fed54b5c8844cd35 ]

In predicate_parse, there is an error path that is not going to
out_free instead it returns directly which leads to a memory leak.

Link: http://lkml.kernel.org/r/20190920225800.3870-1-navid.emamdoost@gmail.com

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index b949c3917c679..9be3d1d1fcb47 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -451,8 +451,10 @@ predicate_parse(const char *str, int nr_parens, int nr_preds,
 
 		switch (*next) {
 		case '(':					/* #2 */
-			if (top - op_stack > nr_parens)
-				return ERR_PTR(-EINVAL);
+			if (top - op_stack > nr_parens) {
+				ret = -EINVAL;
+				goto out_free;
+			}
 			*(++top) = invert;
 			continue;
 		case '!':					/* #3 */
-- 
2.25.1



