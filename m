Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827F9F7CC0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbfKKStX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbfKKStW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32747222C1;
        Mon, 11 Nov 2019 18:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498162;
        bh=5JEQzBaVD+E8HXLBNVDBN6pR2xH6E2s/FT8ItNrMRsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hZZEHobIMX45GvvjIv1zcpq0vTgwo9FW/SVM6QmJwSWHJdopMm5vq/vbkDyY8Kxz+
         /A/vXxA8Geumy5+88yKyHFs9Gbwd+23U6rJDSFRR2KTI1dgyRSAWNHS53W7E412i9+
         XueDKQ/XpnCqFpWOW2VwIb6AiRrT6I6xAp2czPkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Keeping <john@metanate.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andres Freund <andres@anarazel.de>
Subject: [PATCH 5.3 041/193] perf map: Use zalloc for map_groups
Date:   Mon, 11 Nov 2019 19:27:03 +0100
Message-Id: <20191111181503.990965328@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Keeping <john@metanate.com>

commit ab6cd0e5276e24403751e0b3b8ed807738a8571f upstream.

In the next commit we will add new fields to map_groups and we need
these to be null if no value is assigned.  The simplest way to achieve
this is to request zeroed memory from the allocator.

Signed-off-by: John Keeping <john@metanate.com>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: john keeping <john@metanate.com>
Link: http://lkml.kernel.org/r/20190815100146.28842-1-john@metanate.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andres Freund <andres@anarazel.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -637,7 +637,7 @@ bool map_groups__empty(struct map_groups
 
 struct map_groups *map_groups__new(struct machine *machine)
 {
-	struct map_groups *mg = malloc(sizeof(*mg));
+	struct map_groups *mg = zalloc(sizeof(*mg));
 
 	if (mg != NULL)
 		map_groups__init(mg, machine);


