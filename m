Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBA33031A8
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbhAYSxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:53:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731279AbhAYSxw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:53:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C004E2074B;
        Mon, 25 Jan 2021 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600791;
        bh=6/ggl5O6X5ty4jZKvBiscLmFgeezdL+nq4Ufp0LkcBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PTwLokje5+nSvBjaAfDyaAlon+ctWn8Nf0Gqw5uU0ssvLmYqnKLlI/mmK/jY+D1p
         BeDfu8F0hH37m+dB+OxWjZfWwjAIyugCCrwKje6v77p4XusCWg+y4Bxt86z01RLqqQ
         vlLsC2kSd63n/oxyaHsY52tE08plNLwTY6TlyRn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kent Gibson <warthog618@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.10 151/199] tools: gpio: fix %llu warning in gpio-event-mon.c
Date:   Mon, 25 Jan 2021 19:39:33 +0100
Message-Id: <20210125183222.587410865@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Gibson <warthog618@gmail.com>

commit 2fe7c2f99440d52613e1cf845c96e8e463c28111 upstream.

Some platforms, such as mips64, don't map __u64 to long long unsigned
int so using %llu produces a warning:

gpio-event-mon.c:110:37: warning: format ‘%llu’ expects argument of type ‘long long unsigned int’, but argument 3 has type ‘__u64’ {aka ‘long unsigned int’} [-Wformat=]
  110 |   fprintf(stdout, "GPIO EVENT at %llu on line %d (%d|%d) ",
      |                                  ~~~^
      |                                     |
      |                                     long long unsigned int
      |                                  %lu
  111 |    event.timestamp_ns, event.offset, event.line_seqno,
      |    ~~~~~~~~~~~~~~~~~~
      |         |
      |         __u64 {aka long unsigned int}

Replace the %llu with PRIu64 and cast the argument to uint64_t.

Fixes: 03fd11b03362 ("tools/gpio/gpio-event-mon: fix warning")
Signed-off-by: Kent Gibson <warthog618@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/gpio/gpio-event-mon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/gpio/gpio-event-mon.c
+++ b/tools/gpio/gpio-event-mon.c
@@ -107,8 +107,8 @@ int monitor_device(const char *device_na
 			ret = -EIO;
 			break;
 		}
-		fprintf(stdout, "GPIO EVENT at %llu on line %d (%d|%d) ",
-			event.timestamp_ns, event.offset, event.line_seqno,
+		fprintf(stdout, "GPIO EVENT at %" PRIu64 " on line %d (%d|%d) ",
+			(uint64_t)event.timestamp_ns, event.offset, event.line_seqno,
 			event.seqno);
 		switch (event.id) {
 		case GPIO_V2_LINE_EVENT_RISING_EDGE:


