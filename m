Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACDD27C6D5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731194AbgI2LtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731034AbgI2Lsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74CCA20848;
        Tue, 29 Sep 2020 11:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380126;
        bh=LQo4A7F/glkXOjrnFWGh2QqNH7/8jpL8XU+FFWi0Ou8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAFvLAsQReNSKUW41pVm7yBdhRyTageVJUy7cgdLc9d0Dq5w0hh+UPY34hKoOgTUU
         3YLiXTIKh3+pZI3X/z9LauD3VRUEvjV3gSXYXuU4G1tGVCoIf3Zw+meAS299jNg+BU
         YslUcT+FrxRqh+hBvIu7Kidbn+ObZskku6WdYOqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>,
        Tom Rix <trix@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.8 79/99] tracing: fix double free
Date:   Tue, 29 Sep 2020 13:02:02 +0200
Message-Id: <20200929105933.617398637@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 46bbe5c671e06f070428b9be142cc4ee5cedebac upstream.

clang static analyzer reports this problem

trace_events_hist.c:3824:3: warning: Attempt to free
  released memory
    kfree(hist_data->attrs->var_defs.name[i]);

In parse_var_defs() if there is a problem allocating
var_defs.expr, the earlier var_defs.name is freed.
This free is duplicated by free_var_defs() which frees
the rest of the list.

Because free_var_defs() has to run anyway, remove the
second free fom parse_var_defs().

Link: https://lkml.kernel.org/r/20200907135845.15804-1-trix@redhat.com

Cc: stable@vger.kernel.org
Fixes: 30350d65ac56 ("tracing: Add variable support to hist triggers")
Reviewed-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_events_hist.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3865,7 +3865,6 @@ static int parse_var_defs(struct hist_tr
 
 			s = kstrdup(field_str, GFP_KERNEL);
 			if (!s) {
-				kfree(hist_data->attrs->var_defs.name[n_vars]);
 				ret = -ENOMEM;
 				goto free;
 			}


