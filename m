Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56E55B740B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiIMPO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiIMPOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:14:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B1111C10;
        Tue, 13 Sep 2022 07:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DBC2614D8;
        Tue, 13 Sep 2022 14:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7692FC433C1;
        Tue, 13 Sep 2022 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079623;
        bh=GcjtwSEugB1O2z4YUmCKyKLq83SW/UG+NvZNEfKsXmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0BmLaf8RuJOkxr3UAltXH6IStqzVSKXNOjP8NUnqCBn7XiBFKfA479uow69MU7p+
         YdZjSbzQ6pwkFQ1FWo8BneRWqZdz6TD2icP40rwfXGL9MKW9ub55HkgCpZ30Za3am8
         c3XuLn6qNsuI+AxwP1+2eGENM0Va046NHheKIz1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+14b0e8f3fd1612e35350@syzkaller.appspotmail.com,
        stable <stable@kernel.org>,
        Khalid Masum <khalid.masum.92@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 11/61] vt: Clear selection before changing the font
Date:   Tue, 13 Sep 2022 16:07:13 +0200
Message-Id: <20220913140347.056052738@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 566f9c9f89337792070b5a6062dff448b3e7977f upstream.

When changing the console font with ioctl(KDFONTOP) the new font size
can be bigger than the previous font. A previous selection may thus now
be outside of the new screen size and thus trigger out-of-bounds
accesses to graphics memory if the selection is removed in
vc_do_resize().

Prevent such out-of-memory accesses by dropping the selection before the
various con_font_set() console handlers are called.

Reported-by: syzbot+14b0e8f3fd1612e35350@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Tested-by: Khalid Masum <khalid.masum.92@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Link: https://lore.kernel.org/r/YuV9apZGNmGfjcor@p100
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4175,9 +4175,11 @@ static int con_font_set(struct vc_data *
 	console_lock();
 	if (vc->vc_mode != KD_TEXT)
 		rc = -EINVAL;
-	else if (vc->vc_sw->con_font_set)
+	else if (vc->vc_sw->con_font_set) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_set(vc, &font, op->flags);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	kfree(font.data);
@@ -4204,9 +4206,11 @@ static int con_font_default(struct vc_da
 		console_unlock();
 		return -EINVAL;
 	}
-	if (vc->vc_sw->con_font_default)
+	if (vc->vc_sw->con_font_default) {
+		if (vc_is_sel(vc))
+			clear_selection();
 		rc = vc->vc_sw->con_font_default(vc, &font, s);
-	else
+	} else
 		rc = -ENOSYS;
 	console_unlock();
 	if (!rc) {


