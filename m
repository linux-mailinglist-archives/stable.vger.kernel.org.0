Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709E62B65B5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbgKQN6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730342AbgKQNTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:06 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF703241A5;
        Tue, 17 Nov 2020 13:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619146;
        bh=iVmNXVvgpuvsEhl5cXeuZuMvCztFssgpKilqgSpfTc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f26FVqzpERPL1MKoqNVceaRx9jSgpm8R7sETEEVO2ZqMRG3Y9TVas08i5IEjaWMbK
         MUNJcEAjaUxZPSIAvI6JWimP3jH6Oylxw/MkOc8CZIgausAGJmNkvpkhM4L/AS/IPD
         pyRB3KZ+byGggTDSLGiI8aoLrgqoPCXARiGj4aXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/101] perf tools: Add missing swap for ino_generation
Date:   Tue, 17 Nov 2020 14:04:40 +0100
Message-Id: <20201117122113.750655697@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit fe01adb72356a4e2f8735e4128af85921ca98fa1 ]

We are missing swap for ino_generation field.

Fixes: 5c5e854bc760 ("perf tools: Add attr->mmap2 support")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20201101233103.3537427-2-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/session.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f016d1b330e54..6a2037b52098b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -488,6 +488,7 @@ static void perf_event__mmap2_swap(union perf_event *event,
 	event->mmap2.maj   = bswap_32(event->mmap2.maj);
 	event->mmap2.min   = bswap_32(event->mmap2.min);
 	event->mmap2.ino   = bswap_64(event->mmap2.ino);
+	event->mmap2.ino_generation = bswap_64(event->mmap2.ino_generation);
 
 	if (sample_id_all) {
 		void *data = &event->mmap2.filename;
-- 
2.27.0



