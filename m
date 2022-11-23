Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D044635351
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 09:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiKWIxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 03:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiKWIxf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 03:53:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57151E9338
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 00:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E638061B46
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 08:53:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF73FC433C1;
        Wed, 23 Nov 2022 08:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669193613;
        bh=eajCaM8wkk1agCpDXI7qjFENGV8/iUU8UjuoL8MlOlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBh2gyoV8e98gctjw1DRNkxprIyTeC/8Pk2Nm9o6cRAIYf5EhlQ26PVieZmciEuHF
         C3QiR/+sFsKQYj70KSUCqoTcvG8nO58cD/ChQZ02Im4/gGLiZGWngKtqaoHFV8/3p9
         2+ofLaK3hrFXx+3iNwDn3GGJQKFqP6R6kqwwsQsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 16/76] ALSA: hda: fix potential memleak in add_widget_node
Date:   Wed, 23 Nov 2022 09:50:15 +0100
Message-Id: <20221123084547.262488085@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 9a5523f72bd2b0d66eef3d58810c6eb7b5ffc143 upstream.

As 'kobject_add' may allocated memory for 'kobject->name' when return error.
And in this function, if call 'kobject_add' failed didn't free kobject.
So call 'kobject_put' to recycling resources.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221110144539.2989354-1-yebin@huaweicloud.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/hdac_sysfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/hda/hdac_sysfs.c
+++ b/sound/hda/hdac_sysfs.c
@@ -345,8 +345,10 @@ static int add_widget_node(struct kobjec
 		return -ENOMEM;
 	kobject_init(kobj, &widget_ktype);
 	err = kobject_add(kobj, parent, "%02x", nid);
-	if (err < 0)
+	if (err < 0) {
+		kobject_put(kobj);
 		return err;
+	}
 	err = sysfs_create_group(kobj, group);
 	if (err < 0) {
 		kobject_put(kobj);


