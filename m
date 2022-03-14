Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4255D4D830D
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240799AbiCNMMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242944AbiCNMLW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:11:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D4233A1D;
        Mon, 14 Mar 2022 05:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E9A8B80DF4;
        Mon, 14 Mar 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C3D2C340EC;
        Mon, 14 Mar 2022 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259810;
        bh=AUqtvabMwOT8H1tChuw/4DbeorIaoD6A+b5KC2+sjwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OpBxBWK0Vfx75ut1DBbC2UvQC+n8HbjrkiDg/JwfkGfgXi5Ti7c3+fZ6CensAXFhy
         FfRZZvQ3wxHhaB1oA5VdCvDbdI50aEbTEGdgWN2oePxzcLPnWwWKDZVuiwPFngZVLK
         /FNRhCnONNaAmxeDH2vvjRH8RpAi8LcgAEbrwMcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 095/110] watch_queue: Fix to release page in ->release()
Date:   Mon, 14 Mar 2022 12:54:37 +0100
Message-Id: <20220314112745.679098297@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112743.029192918@linuxfoundation.org>
References: <20220314112743.029192918@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit c1853fbadcba1497f4907971e7107888e0714c81 upstream.

When a pipe ring descriptor points to a notification message, the
refcount on the backing page is incremented by the generic get function,
but the release function, which marks the bitmap, doesn't drop the page
ref.

Fix this by calling generic_pipe_buf_release() at the end of
watch_queue_pipe_buf_release().

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -54,6 +54,7 @@ static void watch_queue_pipe_buf_release
 	bit += page->index;
 
 	set_bit(bit, wqueue->notes_bitmap);
+	generic_pipe_buf_release(pipe, buf);
 }
 
 // No try_steal function => no stealing


