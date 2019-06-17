Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8211D4929D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbfFQVWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:46540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729446AbfFQVV7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:21:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1F5C20652;
        Mon, 17 Jun 2019 21:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806519;
        bh=oiaXuwdwqq/GHNRR2Kmron3M687TpMIX5+ylb2xkcXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5FkdBUUazlJ4ozwMyo9QjQ2lFvaLCEFWIeLT9fD8G6Vx+WunqK9gwiel6nyMJvug
         hbmZHwO0L3V+36xl9iHnCE14m/60mBvkeB3l9IKQifd0I+EjuqIno6mnDvXt593XZ2
         CLt6+9hgxnu20/J6fE8EM54MsdoGVYpW5IV3IdMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 079/115] tracing: Prevent hist_field_var_ref() from accessing NULL tracing_map_elts
Date:   Mon, 17 Jun 2019 23:09:39 +0200
Message-Id: <20190617210804.026342755@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 55267c88c003a3648567beae7c90512d3e2ab15e ]

hist_field_var_ref() is an implementation of hist_field_fn_t(), which
can be called with a null tracing_map_elt elt param when assembling a
key in event_hist_trigger().

In the case of hist_field_var_ref() this doesn't make sense, because a
variable can only be resolved by looking it up using an already
assembled key i.e. a variable can't be used to assemble a key since
the key is required in order to access the variable.

Upper layers should prevent the user from constructing a key using a
variable in the first place, but in case one slips through, it
shouldn't cause a NULL pointer dereference.  Also if one does slip
through, we want to know about it, so emit a one-time warning in that
case.

Link: http://lkml.kernel.org/r/64ec8dc15c14d305295b64cdfcc6b2b9dd14753f.1555597045.git.tom.zanussi@linux.intel.com

Reported-by: Vincent Bernat <vincent@bernat.ch>
Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 0a200d42fa96..f50d57eac875 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1815,6 +1815,9 @@ static u64 hist_field_var_ref(struct hist_field *hist_field,
 	struct hist_elt_data *elt_data;
 	u64 var_val = 0;
 
+	if (WARN_ON_ONCE(!elt))
+		return var_val;
+
 	elt_data = elt->private_data;
 	var_val = elt_data->var_ref_vals[hist_field->var_ref_idx];
 
-- 
2.20.1



