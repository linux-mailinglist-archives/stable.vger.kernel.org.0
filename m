Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 903A7D233F
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 10:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388140AbfJJIkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388130AbfJJIkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:40:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27CF120B7C;
        Thu, 10 Oct 2019 08:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696835;
        bh=oa2NT2zv5l9tMMIX6F4HpjCTpgWSGAsS/4FodnBtrSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywK8vEgViQKSaMhBYGKQJ0rVSrsNzFqXsHxG0BOnoMnDpIGZ1eUiWH174W+DswwoL
         vRDsKYbuUernABN1sJkfdzZXnAuTub4zNfeLnswss9v97rKeovxF1eygAYtPj4+VsQ
         uZYizPHEACyd9tFxKQRgg887KvR+4rHcP4+tg4WE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Wang <kevin1.wang@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.3 069/148] drm/amd/powerplay: change metrics update period from 1ms to 100ms
Date:   Thu, 10 Oct 2019 10:35:30 +0200
Message-Id: <20191010083615.605747762@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kevin Wang <kevin1.wang@amd.com>

commit e0e4a2ce7a059d051c66cd7c94314fef3cd91aea upstream.

v2:
change period from 10ms to 100ms (typo error)

too high frequence to update mertrics table will cause smu firmware
error,so change mertrics table update period from 1ms to 100ms
(navi10, 12, 14)

Signed-off-by: Kevin Wang <kevin1.wang@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.3.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -532,7 +532,7 @@ static int navi10_get_metrics_table(stru
 	struct smu_table_context *smu_table= &smu->smu_table;
 	int ret = 0;
 
-	if (!smu_table->metrics_time || time_after(jiffies, smu_table->metrics_time + HZ / 1000)) {
+	if (!smu_table->metrics_time || time_after(jiffies, smu_table->metrics_time + msecs_to_jiffies(100))) {
 		ret = smu_update_table(smu, SMU_TABLE_SMU_METRICS, 0,
 				(void *)smu_table->metrics_table, false);
 		if (ret) {


