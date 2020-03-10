Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822A317F82B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgCJMpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgCJMpo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:45:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FC84246A3;
        Tue, 10 Mar 2020 12:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844343;
        bh=RgWQTyHdcLxiItYJgVlfVwe7pcSBd6MgDeEO513H4hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q5jRh2P3YzP+sqVhXG+CuMkE34lfyNi4/D0dFqrLHzH5XQ3EOBygIWB104veVaX6n
         KlkUWt1eLPG+m8fKkaqSziXZphZu5LYQ6BX51uV3mx43/LtWyoo1zx5dHz5Uuk3Mii
         eGVP3P+LnQTTps4cCzriT3SDy2TyObCpEJFHBb74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 47/88] perf hists browser: Restore ESC as "Zoom out" of DSO/thread/etc
Date:   Tue, 10 Mar 2020 13:38:55 +0100
Message-Id: <20200310123617.786381578@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123606.543939933@linuxfoundation.org>
References: <20200310123606.543939933@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 3f7774033e6820d25beee5cf7aefa11d4968b951 upstream.

We need to set actions->ms.map since 599a2f38a989 ("perf hists browser:
Check sort keys before hot key actions"), as in that patch we bail out
if map is NULL.

Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: 599a2f38a989 ("perf hists browser: Check sort keys before hot key actions")
Link: https://lkml.kernel.org/n/tip-wp1ssoewy6zihwwexqpohv0j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/ui/browsers/hists.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -2930,6 +2930,7 @@ static int perf_evsel__hists_browse(stru
 
 				continue;
 			}
+			actions->ms.map = map;
 			top = pstack__peek(browser->pstack);
 			if (top == &browser->hists->dso_filter) {
 				/*


