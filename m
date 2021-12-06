Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D67C46A0BA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 17:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359091AbhLFQMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 11:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389491AbhLFQJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 11:09:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6ACC08EA70;
        Mon,  6 Dec 2021 07:47:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47ABAB810E7;
        Mon,  6 Dec 2021 15:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F014C34901;
        Mon,  6 Dec 2021 15:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638805650;
        bh=lo3M3xkoyD402mjuwDreQGcgQnyDDzqTBJXHePTXdAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZCYMz/OzrnUomXXAu5mIgoik9BsQKRVotzppsBtO8lFOsYtIxJBLOXba9O2eJ4oV
         SLEirEie48xRw+oDIG/ZiBDuXA7sw60HEssUCb0kHy79e+nHGIFkYq7MG/E++LOmrz
         HC0KWZdgOSux+0+1muUMtm1Oan1ajnsW4midxqFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@vgerk.kernel.org,
        Tom Zanussi <zanussi@kernel.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 047/130] tracing/histograms: String compares should not care about signed values
Date:   Mon,  6 Dec 2021 15:56:04 +0100
Message-Id: <20211206145601.312041619@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 450fec13d9170127678f991698ac1a5b05c02e2f upstream.

When comparing two strings for the "onmatch" histogram trigger, fields
that are strings use string comparisons, which do not care about being
signed or not.

Do not fail to match two string fields if one is unsigned char array and
the other is a signed char array.

Link: https://lore.kernel.org/all/20211129123043.5cfd687a@gandalf.local.home/

Cc: stable@vgerk.kernel.org
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Yafang Shao <laoar.shao@gmail.com>
Fixes: b05e89ae7cf3b ("tracing: Accept different type for synthetic event fields")
Reviewed-by: Masami Hiramatsu <mhiramatsu@kernel.org>
Reported-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3344,7 +3344,7 @@ static int check_synth_field(struct synt
 
 	if (strcmp(field->type, hist_field->type) != 0) {
 		if (field->size != hist_field->size ||
-		    field->is_signed != hist_field->is_signed)
+		    (!field->is_string && field->is_signed != hist_field->is_signed))
 			return -EINVAL;
 	}
 


