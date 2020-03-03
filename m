Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A050177F79
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731347AbgCCRvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:51:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731631AbgCCRu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD7B020728;
        Tue,  3 Mar 2020 17:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257858;
        bh=3v3FPTsDVsy/CU2qctd5vstqr4cMjD4cLFEwgWTJDjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCEd1hBX6uq05+YglXc9oX7OMUqfTYvGrr3Q2L5RnB6BZAtK7NpvfRRwg0gnKBQ/D
         Y8fDQ6xNUK0TJmGqxPf2uHSS6L984FW/x142lZwaa0BRqFN40UoUD83CZEdlEvty3h
         8AQxyxMmHFNJ9mtya9ooGqFTzpqx9vKu3ucI63dQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.5 155/176] perf maps: Add missing unlock to maps__insert() error case
Date:   Tue,  3 Mar 2020 18:43:39 +0100
Message-Id: <20200303174322.429303788@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cengiz Can <cengiz@kernel.wtf>

commit 85fc95d75970ee7dd8e01904e7fb1197c275ba6b upstream.

`tools/perf/util/map.c` has a function named `maps__insert` that
acquires a write lock if its in multithread context.

Even though this lock is released when function successfully completes,
there's a branch that is executed when `maps_by_name == NULL` that
returns from this function without releasing the write lock.

Added an `up_write` to release the lock when this happens.

Fixes: a7c2b572e217 ("perf map_groups: Auto sort maps by name, if needed")
Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200120141553.23934-1-cengiz@kernel.wtf
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/map.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -549,6 +549,7 @@ void maps__insert(struct maps *maps, str
 
 			if (maps_by_name == NULL) {
 				__maps__free_maps_by_name(maps);
+				up_write(&maps->lock);
 				return;
 			}
 


