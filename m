Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2B3C502F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240092AbhGLHbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343643AbhGLH2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:28:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 071596192D;
        Mon, 12 Jul 2021 07:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074654;
        bh=lehlT4m/InziezWCU44sOcqIerWh2hOgXlby/PasnhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJHbnvj5C9qWhX8CWf9Nb+nm938vzpQNG20QIVJuPaHTd1k4QD8ERdDVG5Qfl3D3E
         oLw0J4xgav0ngboqchS5+VIKwMDleexXn0vzUE/nii+3L8CjQscXmBfAWfb4xMm2jP
         ciapKM0aaTHC06nlao3UMhRt2I8LVCPnJY2bqXKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 652/700] selftests/ftrace: fix event-no-pid on 1-core machine
Date:   Mon, 12 Jul 2021 08:12:15 +0200
Message-Id: <20210712061045.209762504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

[ Upstream commit 07b60713b57a8f952d029a2b6849d003d9c16108 ]

When running event-no-pid test on small machines (e.g. cloud 1-core
instance), other events might not happen:

    + cat trace
    + cnt=0
    + [ 0 -eq 0 ]
    + fail No other events were recorded
    [15] event tracing - restricts events based on pid notrace filtering [FAIL]

Schedule a simple sleep task to be sure that some other process events
get recorded.

Fixes: ebed9628f5c2 ("selftests/ftrace: Add test to test new set_event_notrace_pid file")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/event/event-no-pid.tc  | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/event/event-no-pid.tc b/tools/testing/selftests/ftrace/test.d/event/event-no-pid.tc
index e6eb78f0b954..9933ed24f901 100644
--- a/tools/testing/selftests/ftrace/test.d/event/event-no-pid.tc
+++ b/tools/testing/selftests/ftrace/test.d/event/event-no-pid.tc
@@ -57,6 +57,10 @@ enable_events() {
     echo 1 > tracing_on
 }
 
+other_task() {
+    sleep .001 || usleep 1 || sleep 1
+}
+
 echo 0 > options/event-fork
 
 do_reset
@@ -94,6 +98,9 @@ child=$!
 echo "child = $child"
 wait $child
 
+# Be sure some other events will happen for small systems (e.g. 1 core)
+other_task
+
 echo 0 > tracing_on
 
 cnt=`count_pid $mypid`
-- 
2.30.2



