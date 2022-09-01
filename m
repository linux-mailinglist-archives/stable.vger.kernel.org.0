Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB2B5A8DA2
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbiIAFtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233236AbiIAFtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:33 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B751178FB;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m17-20020a7bce11000000b003a5bedec07bso738296wmc.0;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xLW9Gby42tyiBFlIoDzW7LpOcnfeeekTuyuaQuWlQqE=;
        b=g5h3FoJOwX1B/0q2TzBNU8HK5HFXNm3CfXKFc71pJYk04OeKbSr/Xri6VQvGfF8EYU
         GFN1BqNZ0vo4ZCecNeK864N13E8kVOMjlwFW0KidBaApGVNcNPJsRUF8P6vQrbh5tPC0
         /F63ULDpTvsGQTS2zoxNkLBaj1c10w6QOQyWIXC08jYOO4XjJaVXmaBZiTgJK3oNjhvK
         xy9jCJIMhabxnrBpLwBru76InUebvagezSbpeYyWHC9TNX/NrlGzwBSbfvgRRpR3lqUo
         +y2/ABJPRX2Z6vYomlnQenwBizG2pkG9LFBF3JEhdHkQXU01DSPSG5TK7z/EO9+kWr7+
         e0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xLW9Gby42tyiBFlIoDzW7LpOcnfeeekTuyuaQuWlQqE=;
        b=hqKPqzmft1hlVXNI3VgeVjlSjW/q+2JzJsjUAoINL5pRsweU6e5BJ/nzrr5hNp0QrS
         HeOSgBT+bmbwOKvlQwPZri5o2sI8HH/50ltuer309nUgfslhfsjpGTOoq4+iM7emfJV3
         eyKC2RWaMDD1tbrus0BzW74cuAr9TyGjyK+GneWBjlqvV4tqqAFv3xeEKNJ3D9SPZQlD
         WVExacfIAciMv93TYLSfskyoNZZTj52i+vEOqBBRj/L2hu0dgZIFGaXaIdXRpDEaMCD4
         yCREbUiDaYB1+KYdHtPv4CebVNgbHnulSs7wEANAm2ZxeMXlMv59eP9XCacUXscv7BBx
         ERGw==
X-Gm-Message-State: ACgBeo0DXw8HCe+OHyF/UtFGFWCM8KI+en//fNf0rvN8bUPaxm064Rmq
        rHxENc1xcNRxQShm8M3H8nM=
X-Google-Smtp-Source: AA6agR6lpyfen3E7ZZCl4CVsrYGtXwlqRud7ZXBehC5nogXSgojiQRclt8jcM6AlFw9ZEijwPW+8OA==
X-Received: by 2002:a05:600c:384f:b0:3a6:603c:4338 with SMTP id s15-20020a05600c384f00b003a6603c4338mr3948107wmr.192.1662011348618;
        Wed, 31 Aug 2022 22:49:08 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:08 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 v2 4/7] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Thu,  1 Sep 2022 08:48:51 +0300
Message-Id: <20220901054854.2449416-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f650df7171b882dca737ddbbeb414100b31f16af upstream.

The filestream AG selection loop uses pagf data to aid in AG
selection, which depends on pagf initialization. If the in-core
structure is not initialized, the caller invokes the AGF read path
to do so and carries on. If another task enters the loop and finds
a pagf init already in progress, the AGF read returns -EAGAIN and
the task continues the loop. This does not increment the current ag
index, however, which means the task spins on the current AGF buffer
until unlocked.

If the AGF read I/O submitted by the initial task happens to be
delayed for whatever reason, this results in soft lockup warnings
via the spinning task. This is reproduced by xfs/170. To avoid this
problem, fix the AGF trylock failure path to properly iterate to the
next AG. If a task iterates all AGs without making progress, the
trylock behavior is dropped in favor of blocking locks and thus a
soft lockup is no longer possible.

Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index db23e455eb91..bc41ec0c483d 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
-- 
2.25.1

