Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B3B493BE
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfFQV0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729837AbfFQV0I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D9D2070B;
        Mon, 17 Jun 2019 21:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806767;
        bh=zI8Hg35TXwTztuYQyEiWjGDdTu0c1cknvU8BVyrffpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csx/NrO6A3UfFFx+IbddhFU8Y5FXJj7GNvdnmV0I0mgaMfMLW349skhrXZtZQAh6o
         DDOV1+wfVS4Y68Xlm2xGVMVPMAZRqvUubAarp85srKsvOBnrhwo4k78agNVXI5O+k+
         RUFpcPG7QEBAgG/U6ccy0nvhst2uupyrODS18dSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Bernat <vincent@bernat.ch>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/75] tracing: Prevent hist_field_var_ref() from accessing NULL tracing_map_elts
Date:   Mon, 17 Jun 2019 23:10:01 +0200
Message-Id: <20190617210754.686952639@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
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
index 11853e90b649..3f34cfb66a85 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1632,6 +1632,9 @@ static u64 hist_field_var_ref(struct hist_field *hist_field,
 	struct hist_elt_data *elt_data;
 	u64 var_val = 0;
 
+	if (WARN_ON_ONCE(!elt))
+		return var_val;
+
 	elt_data = elt->private_data;
 	var_val = elt_data->var_ref_vals[hist_field->var_ref_idx];
 
-- 
2.20.1



