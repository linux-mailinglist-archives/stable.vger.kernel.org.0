Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA4360897D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiJVIgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiJVIc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6332D12A5;
        Sat, 22 Oct 2022 01:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 550C260B23;
        Sat, 22 Oct 2022 07:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626E4C433D7;
        Sat, 22 Oct 2022 07:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424345;
        bh=KzHqx2mfIHoyi1WiueYBo5GyvE9Q9Y8B+TZngBTNrwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K4rgI4k7gh2A3Sbwh5MYDQGzhlYplNKetmTJCE0dUsdd0NlXhWt2hOleKEsNUHZ75
         nyvvPRnc405rkpgYb1C202HUbTk4es8+nlyvu0HOWXlaPYGmwQIAet9T9HjuuGRhZN
         X2OpG+jPXezb2SoGBB9C2KuaDTEGEeIQAgd7rQuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.19 112/717] f2fs: fix wrong continue condition in GC
Date:   Sat, 22 Oct 2022 09:19:51 +0200
Message-Id: <20221022072435.271034123@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 605b0a778aa2599aa902ae639b8e9937c74b869b upstream.

We should decrease the frozen counter.

Cc: stable@vger.kernel.org
Fixes: 325163e9892b ("f2fs: add gc_urgent_high_remaining sysfs node")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -97,14 +97,10 @@ static int gc_thread_func(void *data)
 		 */
 		if (sbi->gc_mode == GC_URGENT_HIGH) {
 			spin_lock(&sbi->gc_urgent_high_lock);
-			if (sbi->gc_urgent_high_limited) {
-				if (!sbi->gc_urgent_high_remaining) {
-					sbi->gc_urgent_high_limited = false;
-					spin_unlock(&sbi->gc_urgent_high_lock);
-					sbi->gc_mode = GC_NORMAL;
-					continue;
-				}
-				sbi->gc_urgent_high_remaining--;
+			if (sbi->gc_urgent_high_limited &&
+					!sbi->gc_urgent_high_remaining--) {
+				sbi->gc_urgent_high_limited = false;
+				sbi->gc_mode = GC_NORMAL;
 			}
 			spin_unlock(&sbi->gc_urgent_high_lock);
 		}


