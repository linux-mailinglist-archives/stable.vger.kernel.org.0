Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EA766CB91
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjAPRPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:15:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbjAPROe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB524C6C7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:55:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C0B5B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682CDC433D2;
        Mon, 16 Jan 2023 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888110;
        bh=AA65B6Ub8loLIpRU9RK3yZ+0OMUupVgjH46chE+YGs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rycHdskU15Hua0yGwcgwfLqV3qq5WmzK2ZH2XC/dzqdJIXnhXsZXLYoc7H1JPe8UW
         Pq7C7SEdPWIKC3ug6CK60qKzkzpiybfGjvyEUwt2HoeI/6kAqGana4tJNlog6bDML9
         57Z3B3qxxnA51AgGg/nCErkbgNoFXwaBx8YO4tK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zack Rusin <zackr@vmware.com>,
        Michael Banack <banackm@vmware.com>,
        Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 4.19 405/521] drm/vmwgfx: Validate the box size for the snooped cursor
Date:   Mon, 16 Jan 2023 16:51:07 +0100
Message-Id: <20230116154905.203599705@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit 4cf949c7fafe21e085a4ee386bb2dade9067316e upstream.

Invalid userspace dma surface copies could potentially overflow
the memcpy from the surface to the snooped image leading to crashes.
To fix it the dimensions of the copybox have to be validated
against the expected size of the snooped cursor.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 2ac863719e51 ("vmwgfx: Snoop DMA transfers with non-covering sizes")
Cc: <stable@vger.kernel.org> # v3.2+
Reviewed-by: Michael Banack <banackm@vmware.com>
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026031936.1004280-1-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -179,7 +179,8 @@ void vmw_kms_cursor_snoop(struct vmw_sur
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */


