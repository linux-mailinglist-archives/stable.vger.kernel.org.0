Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CC62B63EC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387471AbgKQNmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:42:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387465AbgKQNmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:42:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122B72468D;
        Tue, 17 Nov 2020 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620563;
        bh=TW0kadzJVG5/0T+RUDy7xRV2L7Vy902zfmm/D1KQlZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/RPhNVf9xhXVKV4oP6dHtjGDokjhioydIITHhSuD2VnORRlqb0pvw0uZpwl0IXkJ
         IagHh2Zoz7IXiJOXxPm8CVgaMSFdeg/mcDAMckjRTZmavNowSXxBMS9cbLphUQ6OSD
         G2JLDHdtDqni5zcMIb5wjmlgpnKVk1IpkucYbQjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.9 254/255] coresight: Fix uninitialised pointer bug in etm_setup_aux()
Date:   Tue, 17 Nov 2020 14:06:34 +0100
Message-Id: <20201117122151.294783768@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

commit 39a7661dcf655c8198fd5d72412f5030a8e58444 upstream.

Commit [bb1860efc817] changed the sink handling code introducing an
uninitialised pointer bug. This results in the default sink selection
failing.

Prior to commit:

static void etm_setup_aux(...)

<snip>
        struct coresight_device *sink;
<snip>

        /* First get the selected sink from user space. */
        if (event->attr.config2) {
                id = (u32)event->attr.config2;
                sink = coresight_get_sink_by_id(id);
        } else {
                sink = coresight_get_enabled_sink(true);
        }
<ctd>

*sink always initialised - possibly to NULL which triggers the
automatic sink selection.

After commit:

static void etm_setup_aux(...)

<snip>
        struct coresight_device *sink;
<snip>

        /* First get the selected sink from user space. */
        if (event->attr.config2) {
                id = (u32)event->attr.config2;
                sink = coresight_get_sink_by_id(id);
        }
<ctd>

*sink pointer uninitialised when not providing a sink on the perf command
line. This breaks later checks to enable automatic sink selection.

Fixes: bb1860efc817 ("coresight: etm: perf: Sink selection using sysfs is deprecated")
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201029164559.1268531-3-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etm-perf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -210,7 +210,7 @@ static void *etm_setup_aux(struct perf_e
 	u32 id;
 	int cpu = event->cpu;
 	cpumask_t *mask;
-	struct coresight_device *sink;
+	struct coresight_device *sink = NULL;
 	struct etm_event_data *event_data = NULL;
 
 	event_data = alloc_event_data(cpu);


