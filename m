Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655DB603BFB
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJSImE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbiJSIku (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:40:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1939680F7D;
        Wed, 19 Oct 2022 01:39:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86E12B822D1;
        Wed, 19 Oct 2022 08:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE511C433D7;
        Wed, 19 Oct 2022 08:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168747;
        bh=jBoTbudxBixvFylnCwkGubpi1p23EEKMHTLT51gJ8yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrffrh7X06cksoPcc86hWA3se0axooEjBP8G1e6B0cXxnbQBoMrKbKURE2UTyWdMJ
         AH1vIvL5p5hU16p32zzCTkcDPCyved0+6RyXAUVF5jjDzdwyjZR1HeFTUYLBM7tXTh
         XZ8LCWr3+gqgRtYXO8YsTOD3Ve6KjY+U048cT24w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.0 041/862] fs: dlm: fix race between test_bit() and queue_work()
Date:   Wed, 19 Oct 2022 10:22:08 +0200
Message-Id: <20221019083251.817711321@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit eef6ec9bf390e836a6c4029f3620fe49528aa1fe upstream.

This patch fixes a race by using ls_cb_mutex around the bit
operations and conditional code blocks for LSFL_CB_DELAY.

The function dlm_callback_stop() expects to stop all callbacks and
flush all currently queued onces. The set_bit() is not enough because
there can still be queue_work() after the workqueue was flushed.
To avoid queue_work() after set_bit(), surround both by ls_cb_mutex.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/ast.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/dlm/ast.c
+++ b/fs/dlm/ast.c
@@ -200,13 +200,13 @@ void dlm_add_cb(struct dlm_lkb *lkb, uin
 	if (!prev_seq) {
 		kref_get(&lkb->lkb_ref);
 
+		mutex_lock(&ls->ls_cb_mutex);
 		if (test_bit(LSFL_CB_DELAY, &ls->ls_flags)) {
-			mutex_lock(&ls->ls_cb_mutex);
 			list_add(&lkb->lkb_cb_list, &ls->ls_cb_delay);
-			mutex_unlock(&ls->ls_cb_mutex);
 		} else {
 			queue_work(ls->ls_callback_wq, &lkb->lkb_cb_work);
 		}
+		mutex_unlock(&ls->ls_cb_mutex);
 	}
  out:
 	mutex_unlock(&lkb->lkb_cb_mutex);
@@ -288,7 +288,9 @@ void dlm_callback_stop(struct dlm_ls *ls
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
+	mutex_lock(&ls->ls_cb_mutex);
 	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	mutex_unlock(&ls->ls_cb_mutex);
 
 	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);


