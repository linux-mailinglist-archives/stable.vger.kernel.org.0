Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B30AA5AB10F
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbiIBNDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238632AbiIBNCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DEE10D4F8;
        Fri,  2 Sep 2022 05:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D79DC620C5;
        Fri,  2 Sep 2022 12:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF78AC433B5;
        Fri,  2 Sep 2022 12:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122398;
        bh=WYQUAaHzuh1gTk7tpo20isuFPFLINoLlLgreSnsWMtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGqdMLdbkFsAp2lNQEY4ppD/yNkcllquA0qNw4FdF5wZG4141toZxiJvD24hWOjFb
         yauxSz0xbq2vtxouYDx4L9taZXCMRRwbJqUUaRt3njJsW8FrtDuD/mWkXr1obPYdpx
         PEM2DYu//VlLyAyfw1ynFGGRQktIjsM+fIaxa+T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5.10 34/37] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Fri,  2 Sep 2022 14:19:56 +0200
Message-Id: <20220902121400.239846375@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121359.177846782@linuxfoundation.org>
References: <20220902121359.177846782@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_filestream.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
 


