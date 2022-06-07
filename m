Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65C3541A0E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376553AbiFGV2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376901AbiFGV1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:27:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A298E152412;
        Tue,  7 Jun 2022 12:02:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34C2C6179F;
        Tue,  7 Jun 2022 19:02:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C54C385A5;
        Tue,  7 Jun 2022 19:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628520;
        bh=dbWiRrbUEdq/jShUoMSStxSROdj/mfEgDgb1SJh4nPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mc3JKcJcjQbJ4wS8ZQaRlI01OPU6RQmOlnkTPVF11ieq3wzCH3TMgqRy9qWkLjXlX
         oGPi49+kDu7QEBCHZOd4lJJPlPcOEQHg5Ij02HmfeZ8mmyIPeS039SSToK7X7Ve9+F
         RzwMqZGcNuvHNx+1HSSHH+EjzWYxmJdVTZf7EymI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        "Juan A. Suarez" <jasuarez@igalia.com>,
        Melissa Wen <melissa.srw@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 358/879] drm/v3d: Fix null pointer dereference of pointer perfmon
Date:   Tue,  7 Jun 2022 18:57:56 +0200
Message-Id: <20220607165013.255708953@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit ce7a1ecf3f9f1fccaf67295307614511d8e11b13 ]

In the unlikely event that pointer perfmon is null the WARN_ON return path
occurs after the pointer has already been deferenced. Fix this by only
dereferencing perfmon after it has been null checked.

Fixes: 26a4dc29b74a ("drm/v3d: Expose performance counters to userspace")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Reviewed-by: Juan A. Suarez <jasuarez@igalia.com>
Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220424183512.1365683-1-colin.i.king@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_perfmon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_perfmon.c b/drivers/gpu/drm/v3d/v3d_perfmon.c
index 0288ef063513..f6a88abccc7d 100644
--- a/drivers/gpu/drm/v3d/v3d_perfmon.c
+++ b/drivers/gpu/drm/v3d/v3d_perfmon.c
@@ -25,11 +25,12 @@ void v3d_perfmon_start(struct v3d_dev *v3d, struct v3d_perfmon *perfmon)
 {
 	unsigned int i;
 	u32 mask;
-	u8 ncounters = perfmon->ncounters;
+	u8 ncounters;
 
 	if (WARN_ON_ONCE(!perfmon || v3d->active_perfmon))
 		return;
 
+	ncounters = perfmon->ncounters;
 	mask = GENMASK(ncounters - 1, 0);
 
 	for (i = 0; i < ncounters; i++) {
-- 
2.35.1



