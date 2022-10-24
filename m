Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1BF60A4E4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiJXMST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiJXMQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:16:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F238111F;
        Mon, 24 Oct 2022 04:56:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9AB61257;
        Mon, 24 Oct 2022 11:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEF1C433C1;
        Mon, 24 Oct 2022 11:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612590;
        bh=XvMEixgT9BGjJ6ja9ttKqMsTyosvpjjoTnATBzIPtLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sr0v2DSNSuxlRxTLOlpgk/J2JaZ9qHC/KlC4qrXAUsZpo8RCUTbPwBMWtvbORqCob
         mLu7pnJjPX8jy4hm4I0tawz2JsBcn6v0DtF73WfrgQQt8D7TIXcAq/5rbX02ZQyE0/
         9sx4wsqVX2ItyQVEfk1nHA0xGHVi1oZoEzKsnRSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 4.19 044/229] fs: dlm: fix race between test_bit() and queue_work()
Date:   Mon, 24 Oct 2022 13:29:23 +0200
Message-Id: <20221024113000.523018503@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -286,7 +286,9 @@ void dlm_callback_stop(struct dlm_ls *ls
 
 void dlm_callback_suspend(struct dlm_ls *ls)
 {
+	mutex_lock(&ls->ls_cb_mutex);
 	set_bit(LSFL_CB_DELAY, &ls->ls_flags);
+	mutex_unlock(&ls->ls_cb_mutex);
 
 	if (ls->ls_callback_wq)
 		flush_workqueue(ls->ls_callback_wq);


