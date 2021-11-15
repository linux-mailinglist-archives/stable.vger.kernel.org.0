Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1003F452195
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244304AbhKPBFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245503AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB03B63244;
        Mon, 15 Nov 2021 18:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001363;
        bh=C9uQHME2H372VngYuYoy6qwHXHWamBb+ovEHyIbUGv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znuf655GEq7A/hxaQ+jiNbAvY43QJjA7vVCZ5BaLRdKNCzXdJ7O1p1jIdLZISevV6
         wQp6P7g3LUfIS2bAD9/tFTVm1AbQdCRfJhid3j+zy6u7ViEchPOyv8/H+ldq9SlfLU
         26YIKbVeec0h1a8j1vpt50rUuVTlFESonTCeb83Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.15 161/917] coresight: trbe: Fix incorrect access of the sink specific data
Date:   Mon, 15 Nov 2021 17:54:16 +0100
Message-Id: <20211115165434.228054166@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
 


