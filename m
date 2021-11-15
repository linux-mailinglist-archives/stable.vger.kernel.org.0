Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 455DE45247E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbhKPBjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:39:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239097AbhKOSb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:31:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65FE561041;
        Mon, 15 Nov 2021 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999130;
        bh=C9uQHME2H372VngYuYoy6qwHXHWamBb+ovEHyIbUGv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlOigN0b8Jt4Rv3Q2sc79pYbRK/pDc7IgwqnooZ9oX9K9Ys+7DiZp7R0QzjanUklp
         KZGYOzpHq+FX6bKidk4rlD8xjYRlFEhbAovzM6quMcV9+vXyoywKFoWUWjI4ccZALT
         rmh4ltHc6dwyHNmEKrcM67R5lC/guIB0aaJEcnLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.14 188/849] coresight: trbe: Fix incorrect access of the sink specific data
Date:   Mon, 15 Nov 2021 17:54:31 +0100
Message-Id: <20211115165426.535169131@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit bb5293e334af51b19b62d8bef1852ea13e935e9b upstream.

The TRBE driver wrongly treats the aux private data as the TRBE driver
specific buffer for a given perf handle, while it is the ETM PMU's
event specific data. Fix this by correcting the instance to use
appropriate helper.

Cc: stable <stable@vger.kernel.org>
Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20210921134121.2423546-2-suzuki.poulose@arm.com
[Fixed 13 character SHA down to 12]
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -366,7 +366,7 @@ static unsigned long __trbe_normal_offse
 
 static unsigned long trbe_normal_offset(struct perf_output_handle *handle)
 {
-	struct trbe_buf *buf = perf_get_aux(handle);
+	struct trbe_buf *buf = etm_perf_sink_config(handle);
 	u64 limit = __trbe_normal_offset(handle);
 	u64 head = PERF_IDX2OFF(handle->head, buf);
 


