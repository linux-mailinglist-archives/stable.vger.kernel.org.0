Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1C14269A4
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241466AbhJHLjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242839AbhJHLiM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B16961528;
        Fri,  8 Oct 2021 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692786;
        bh=FlF0C5pTyhwqZe9Kk0C0Ky9Z+HSsYFmaSW3wgo+/9K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KlnwBh5Z/TMIO//Lt+7s96k8HLUl1LwbRTyThSwQa4WlB1tFBcsOnTXQCAkkdA39
         AZzadjYkPDNRS+3oYMPpThmCFOeoiC1wwgvZ4t4WgK7jG1Nlw3udM36Dtp1BaaSoXz
         a5oAL98e4AKKyYqIXntgiLL0dsxPdZNAefd3hZzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anand K Mistry <amistry@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.14 45/48] perf/x86: Reset destroy callback on event init failure
Date:   Fri,  8 Oct 2021 13:28:21 +0200
Message-Id: <20211008112721.564046491@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anand K Mistry <amistry@google.com>

commit 02d029a41dc986e2d5a77ecca45803857b346829 upstream.

perf_init_event tries multiple init callbacks and does not reset the
event state between tries. When x86_pmu_event_init runs, it
unconditionally sets the destroy callback to hw_perf_event_destroy. On
the next init attempt after x86_pmu_event_init, in perf_try_init_event,
if the pmu's capabilities includes PERF_PMU_CAP_NO_EXCLUDE, the destroy
callback will be run. However, if the next init didn't set the destroy
callback, hw_perf_event_destroy will be run (since the callback wasn't
reset).

Looking at other pmu init functions, the common pattern is to only set
the destroy callback on a successful init. Resetting the callback on
failure tries to replicate that pattern.

This was discovered after commit f11dd0d80555 ("perf/x86/amd/ibs: Extend
PERF_PMU_CAP_NO_EXCLUDE to IBS Op") when the second (and only second)
run of the perf tool after a reboot results in 0 samples being
generated. The extra run of hw_perf_event_destroy results in
active_events having an extra decrement on each perf run. The second run
has active_events == 0 and every subsequent run has active_events < 0.
When active_events == 0, the NMI handler will early-out and not record
any samples.

Signed-off-by: Anand K Mistry <amistry@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210929170405.1.I078b98ee7727f9ae9d6df8262bad7e325e40faf0@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2467,6 +2467,7 @@ static int x86_pmu_event_init(struct per
 	if (err) {
 		if (event->destroy)
 			event->destroy(event);
+		event->destroy = NULL;
 	}
 
 	if (READ_ONCE(x86_pmu.attr_rdpmc) &&


