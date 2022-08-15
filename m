Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944AF5948D0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354176AbiHOXrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354608AbiHOXqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3038C039;
        Mon, 15 Aug 2022 13:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDAE360F0C;
        Mon, 15 Aug 2022 20:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A61C43140;
        Mon, 15 Aug 2022 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594466;
        bh=QmY7IY0N8v9tui8zXSS90JphJI9wW2dfzECDf4wggX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=197K9dbeoyv9AANhg0X23O2aZG8SG5wcrcr3C8NHlbmCtG94P1/6Zo/vKPwjtWSqs
         lKB6l8eHNYXPvo//wLfY7fn+L5rgCqE39JHf37KuJYPlyacR13s+VkWthl/0U3qG7N
         VQTKlZ/rRlsvt4nBEmLR5hj63+EbL+V3/jlDv34g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0457/1157] media: atomisp: revert "dont pass a pointer to a local variable"
Date:   Mon, 15 Aug 2022 19:56:53 +0200
Message-Id: <20220815180457.875359702@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a3b36a8ce3d0c277fe243fa1be6bd3f606ed130f ]

The gcc is warning about returning a pointer to a local variable
is a false positive.

The type of handle is "struct ia_css_rmgr_vbuf_handle **" and
"h.vptr" is left to NULL, so the "if ((*handle)->vptr == 0x0)"
check always succeeds when the "*handle = &h;" statement which
gcc warns about executes. Leading to this statement being executed:

	rmgr_pop_handle(pool, handle);

If that succeeds,  then *handle has been set to point to one of
the pre-allocated array of handles, so it no longer points to h.

If that fails the following statement will be executed:

	/* Note that handle will change to an internally maintained one */
	ia_css_rmgr_refcount_retain_vbuf(handle);

Which allocated a new handle from the array of pre-allocated handles
and then makes *handle point to this. So the address of h is actually
never returned.

The fix for the false-postive compiler warning actually breaks the code,
the new:

	**handle = h;

is part of a "if (pool->copy_on_write) { ... }" which means that the
handle where *handle points to should be treated read-only, IOW
**handle must never be set, instead *handle must be set to point to
a new handle (with a copy of the contents of the old handle).

The old code correctly did this and the new fixed code gets this wrong.

Note there is another patch in this series, which fixes the warning
in another way.

Link: https://lore.kernel.org/linux-media/20220612160556.108264-2-hdegoede@redhat.com
Fixes: fa1451374ebf ("media: atomisp: don't pass a pointer to a local variable")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c b/drivers/staging/media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c
index 39604752785b..d96aaa4bc75d 100644
--- a/drivers/staging/media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c
+++ b/drivers/staging/media/atomisp/pci/runtime/rmgr/src/rmgr_vbuf.c
@@ -254,7 +254,7 @@ void rmgr_pop_handle(struct ia_css_rmgr_vbuf_pool *pool,
 void ia_css_rmgr_acq_vbuf(struct ia_css_rmgr_vbuf_pool *pool,
 			  struct ia_css_rmgr_vbuf_handle **handle)
 {
-	struct ia_css_rmgr_vbuf_handle h = { 0 };
+	struct ia_css_rmgr_vbuf_handle h;
 
 	if ((!pool) || (!handle) || (!*handle)) {
 		IA_CSS_LOG("Invalid inputs");
@@ -272,7 +272,7 @@ void ia_css_rmgr_acq_vbuf(struct ia_css_rmgr_vbuf_pool *pool,
 			h.size = (*handle)->size;
 			/* release ref to current buffer */
 			ia_css_rmgr_refcount_release_vbuf(handle);
-			**handle = h;
+			*handle = &h;
 		}
 		/* get new buffer for needed size */
 		if ((*handle)->vptr == 0x0) {
-- 
2.35.1



