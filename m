Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A50627EB1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237407AbiKNMuf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiKNMuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:50:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096E411A3D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:50:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9866561175
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8843BC433D6;
        Mon, 14 Nov 2022 12:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430230;
        bh=o1ead+5rBVTZ7mRzhCWAICO6KlZSC0g7GmAHxAPXBbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E33dT1zvqRKcjWabG5hkbn0u9M/3pnf4S+eCb9HE2gXISMD3sYFTRaA5uQd1/y3+q
         OlhxhRj0nPi2SsZ7LY6KwfER3DmQD4rDIu80l1tcuqb+5ZVZslHrSgICmk/MA/sVgk
         GdgFHIrjoXSCIHNSXJtbEwH4E/+Ltp67hASztgso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ye Bin <yebin10@huawei.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 63/95] ALSA: hda: fix potential memleak in add_widget_node
Date:   Mon, 14 Nov 2022 13:45:57 +0100
Message-Id: <20221114124445.154145675@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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
@@ -346,8 +346,10 @@ static int add_widget_node(struct kobjec
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


