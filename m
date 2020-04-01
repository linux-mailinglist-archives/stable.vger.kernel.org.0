Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CF119B1F8
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389018AbgDAQjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:39:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389232AbgDAQjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:39:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A5D20772;
        Wed,  1 Apr 2020 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759180;
        bh=CJKaPqpSF/6554jKMxbP73kFxnplmF6Dn0Bz9JIrEdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rs9SKdcXSTXYu5RhmV76PIGr4mXPtPokQXCpOD3M3EtX4zM7mhS7hoZ6Yri/BsZoe
         si9OwB/8MijrGonSRPWcF797X2xHlbVjOGwaC0aCVHFuV9orjU/vfo3FD252XO58MB
         ExDWzQCApQ4MD3VIjFe/LFqWN7DCce09nQIjVz+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        disconnect3d <dominik.b.czarnota@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Changbin Du <changbin.du@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, John Keeping <john@metanate.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Lentine <mlentine@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 102/102] perf map: Fix off by one in strncpy() size argument
Date:   Wed,  1 Apr 2020 18:18:45 +0200
Message-Id: <20200401161549.020442250@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: disconnect3d <dominik.b.czarnota@gmail.com>

commit db2c549407d4a76563c579e4768f7d6d32afefba upstream.

This patch fixes an off-by-one error in strncpy size argument in
tools/perf/util/map.c. The issue is that in:

        strncmp(filename, "/system/lib/", 11)

the passed string literal: "/system/lib/" has 12 bytes (without the NULL
byte) and the passed size argument is 11. As a result, the logic won't
match the ending "/" byte and will pass filepaths that are stored in
other directories e.g. "/system/libmalicious/bin" or just
"/system/libmalicious".

This functionality seems to be present only on Android. I assume the
/system/ directory is only writable by the root user, so I don't think
this bug has much (or any) security impact.

Fixes: eca818369996 ("perf tools: Add automatic remapping of Android libraries")
Signed-off-by: disconnect3d <dominik.b.czarnota@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Keeping <john@metanate.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Lentine <mlentine@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20200309104855.3775-1-dominik.b.czarnota@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -88,7 +88,7 @@ static inline bool replace_android_lib(c
 		return true;
 	}
 
-	if (!strncmp(filename, "/system/lib/", 11)) {
+	if (!strncmp(filename, "/system/lib/", 12)) {
 		char *ndk, *app;
 		const char *arch;
 		size_t ndk_length;


