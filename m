Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFAE3126BCD
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfLSS7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:59:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730408AbfLSSxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 443EA20674;
        Thu, 19 Dec 2019 18:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781624;
        bh=J5/14ErjQFX/vUZvANlmfZEZ14nE/YRklZ5JEAAXeqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G4fTqlmljGM47x95GjNMy659zFC5Ocrd91E/3nsQPq/vSE8C+8cFjdRMvPzm3AXwG
         yqRUSW6U0RSIOgZZ7rCWmLT03rFvORVj2GMlFilaf1dAI5zQsJmtTAZYp0GxmbfiiO
         ErRUqjGM6CqMflVYzNtu92kkXZ8LxZQahV+m2p28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 14/80] PM / QoS: Redefine FREQ_QOS_MAX_DEFAULT_VALUE to S32_MAX
Date:   Thu, 19 Dec 2019 19:34:06 +0100
Message-Id: <20191219183050.779066263@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leonard Crestez <leonard.crestez@nxp.com>

commit c6a3aea93571a5393602256d8f74772bd64c8225 upstream.

QOS requests for DEFAULT_VALUE are supposed to be ignored but this is
not the case for FREQ_QOS_MAX. Adding one request for MAX_DEFAULT_VALUE
and one for a real value will cause freq_qos_read_value to unexpectedly
return MAX_DEFAULT_VALUE (-1).

This happens because freq_qos max value is aggregated with PM_QOS_MIN
but FREQ_QOS_MAX_DEFAULT_VALUE is (-1) so it's smaller than other
values.

Fix this by redefining FREQ_QOS_MAX_DEFAULT_VALUE to S32_MAX.

Looking at current users for freq_qos it seems that none of them create
requests for FREQ_QOS_MAX_DEFAULT_VALUE.

Fixes: 77751a466ebd ("PM: QoS: Introduce frequency QoS")
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reported-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pm_qos.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -256,7 +256,7 @@ static inline s32 dev_pm_qos_raw_resume_
 #endif
 
 #define FREQ_QOS_MIN_DEFAULT_VALUE	0
-#define FREQ_QOS_MAX_DEFAULT_VALUE	(-1)
+#define FREQ_QOS_MAX_DEFAULT_VALUE	S32_MAX
 
 enum freq_qos_req_type {
 	FREQ_QOS_MIN = 1,


