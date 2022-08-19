Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7661E59A56E
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbiHSSPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350677AbiHSSPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:32 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC60A167E1;
        Fri, 19 Aug 2022 11:14:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y127so2026680pfy.5;
        Fri, 19 Aug 2022 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=xf7q2uZJ9/EeuM4aGbB6um/xCXexSzccPg0zIf1ywqc=;
        b=qT0zGuXKeC6J8pgeDXYeeHywNkG1rYQl4LM42tUj3sNLkmYtmqFj3vNjx4vbKj3JOr
         JJEaSnVn28oqzV5Z/cYThLLQRATGuf62lvUzgna8O2uqcsQblK2tcfx1Dy3BiME4Z/3Q
         lBDE3zF9bCbST1utHkPMOexrdJ7neVUMQQpddQtGf3Q4DQ+3yzmh9URA3RhqpgKRXTav
         3CfN/VaBSX/pZm0q5+j3/ObOQEPfCjl5HAHrQ8PAgz+mNIC83w7+tAWZMp85HCNrJQHF
         XjnRjHoLyx4DZmJwgSAJNYCSlc2LIgYshKSZw+eteiVRLMLg/w9fPONMrBVjc+ltqZrh
         qVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=xf7q2uZJ9/EeuM4aGbB6um/xCXexSzccPg0zIf1ywqc=;
        b=p8e2uVHZXEBUL/H3Ajp0mtEJnymehroN9BY3sQM0JY9BHs0rDHMcrHzkAk/43YBab0
         I/PPcZzpnwzpQWREuTzcDXsDAQqPfXjvDSiv6ouShIoY6ncChashhdVWhg530l27YfOh
         IN/shDKLdUfvbFbIF2sPC9bXkz2y012Zrt1JDmEJX+5xpepu5OiI77t5zZEyk7YE02H3
         6VbtNNe9txrpzIbJ/JUMnGkUakUU2mLjuyp/Ae74QuDmNMMzUmifzeSAJPqiHFwJoR2v
         uSu/0FeGEJAzXjGbNGt6WN2YTyI+sDN+FU0vMToFn+ORt3Qk9hhIY7jCAecHN2ha1HFM
         jpPw==
X-Gm-Message-State: ACgBeo2f/zMBEsShgh/a0P6k7rbF1Uo9yuxCEurJb+UASPn23hdkFGxy
        KUm5ZZghTSNFXiRyJnaKQYyu9ha76PTMfQ==
X-Google-Smtp-Source: AA6agR4+qKUsowB7oZMTqJjY13Ew0mdog/mLSAjkvNz7NYE1q1rZwuDFdRuzNhmKpbXOaD3DDf4/tQ==
X-Received: by 2002:a05:6a00:1ac6:b0:52f:55f8:c3d3 with SMTP id f6-20020a056a001ac600b0052f55f8c3d3mr8995307pfv.76.1660932886084;
        Fri, 19 Aug 2022 11:14:46 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:45 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 7/9] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Fri, 19 Aug 2022 11:14:29 -0700
Message-Id: <20220819181431.4113819-8-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
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

[ Upstream commit f650df7171b882dca737ddbbeb414100b31f16af ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 6a3ce0f6dc9e..be9bcf8a1f99 100644
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
2.37.1.595.g718a3a8f04-goog

