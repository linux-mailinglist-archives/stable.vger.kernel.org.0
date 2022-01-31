Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D54A449E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350551AbiAaLbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351257AbiAaL1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:27:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC017C06176C;
        Mon, 31 Jan 2022 03:16:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B92261120;
        Mon, 31 Jan 2022 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C17EC340F0;
        Mon, 31 Jan 2022 11:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627807;
        bh=PDdpZt7AHPHXZe6U2v2wShYmb1XFB5RGAmHqGoiNsLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZ7SfnWIddIoa//hH0aW+zDjs/v5o2X8zDwrKdougklWq6XxQl8kafKcttucnYIgx
         JWlIDj8lKkbbZY/Ix53W5FG31FH5NI2TVRwF3+3iDUsKIZj4w3iKnyxKvAoUR9l9zh
         7uLfoJ9R5eYOQEpqTAWXxxL3wfcgErhNcrz79DVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.16 032/200] tracing: Dont inc err_log entry count if entry allocation fails
Date:   Mon, 31 Jan 2022 11:54:55 +0100
Message-Id: <20220131105234.649732364@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Zanussi <zanussi@kernel.org>

commit 67ab5eb71b37b55f7c5522d080a1b42823351776 upstream.

tr->n_err_log_entries should only be increased if entry allocation
succeeds.

Doing it when it fails won't cause any problems other than wasting an
entry, but should be fixed anyway.

Link: https://lkml.kernel.org/r/cad1ab28f75968db0f466925e7cba5970cec6c29.1643319703.git.zanussi@kernel.org

Cc: stable@vger.kernel.org
Fixes: 2f754e771b1a6 ("tracing: Don't inc err_log entry count if entry allocation fails")
Signed-off-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7734,7 +7734,8 @@ static struct tracing_log_err *get_traci
 		err = kzalloc(sizeof(*err), GFP_KERNEL);
 		if (!err)
 			err = ERR_PTR(-ENOMEM);
-		tr->n_err_log_entries++;
+		else
+			tr->n_err_log_entries++;
 
 		return err;
 	}


