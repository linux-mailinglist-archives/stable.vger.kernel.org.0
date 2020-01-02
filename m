Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64312F04B
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:52:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgABWWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:22:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbgABWWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:22:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F322222C3;
        Thu,  2 Jan 2020 22:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003766;
        bh=Yb86dZj1zmqQt6V3G33LYnP/wlfh0kQGGKcZlNl/Qlg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=05QjX7kKOt+H19WxBw1Q0hNiZaepLCPuxB+E3G7ASZArOHM5PeqwU5WSGdjFhj9lr
         +cQrw4yPK3jxwetSYKHJEU55amuBMXe4UyrM/1EYwkmDPHJOTh15CxNZ3sawTrTjQR
         m01t1kP4MBY+qHoqFVugaW3zILSeihmLmiTQpFKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mattias Jacobsson <2pi@mok.nu>,
        Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sanskriti Sharma <sansharm@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.19 079/114] perf strbuf: Remove redundant va_end() in strbuf_addv()
Date:   Thu,  2 Jan 2020 23:07:31 +0100
Message-Id: <20200102220037.065790380@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220029.183913184@linuxfoundation.org>
References: <20200102220029.183913184@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattias Jacobsson <2pi@mok.nu>

commit 099be748865eece21362aee416c350c0b1ae34df upstream.

Each call to va_copy() should have one, and only one, corresponding call
to va_end(). In strbuf_addv() some code paths result in va_end() getting
called multiple times. Remove the superfluous va_end().

Signed-off-by: Mattias Jacobsson <2pi@mok.nu>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sanskriti Sharma <sansharm@redhat.com>
Link: http://lkml.kernel.org/r/20181229141750.16945-1-2pi@mok.nu
Fixes: ce49d8436cff ("perf strbuf: Match va_{add,copy} with va_end")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/strbuf.c |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -109,7 +109,6 @@ static int strbuf_addv(struct strbuf *sb
 			return ret;
 		}
 		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap_saved);
-		va_end(ap_saved);
 		if (len > strbuf_avail(sb)) {
 			pr_debug("this should not happen, your vsnprintf is broken");
 			va_end(ap_saved);


