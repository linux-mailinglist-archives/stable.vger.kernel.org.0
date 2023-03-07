Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F72C6AF488
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233839AbjCGTRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjCGTQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:16:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1CAAA715
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA36DB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C43C433EF;
        Tue,  7 Mar 2023 19:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215626;
        bh=MN7mt4EJtJlJgrqnWQh0pD1BIBqByyhxDQkx5h5Y4OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ov0hTMOz0gyTbpz0VifaVAjKLr8p9tClll5rPmiBkqSYbHSiBVwFQwOTL7qXSW1zw
         iHq/wSVHlO008Rag1Vfm4QvYWUkGqcc88VSM7xvkOaaGz8ZjVWbzVb62jBzIU1D+i9
         l/E6vdVZqvmI1XfyuXB24C+alT4BKKclhAmBAdzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krishna Kurapati PSSNV <quic_kriskura@quicinc.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/567] usb: gadget: configfs: Restrict symlink creation is UDC already binded
Date:   Tue,  7 Mar 2023 18:00:57 +0100
Message-Id: <20230307165919.792325720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <quic_ugoswami@quicinc.com>

[ Upstream commit 89e7252d6c7e7eeb31971cd7df987316ecc64ff5 ]

During enumeration or composition switch,a userspace process
agnostic of the conventions of configs can try to create function
symlinks even after the UDC is bound to current config which is
not correct. Potentially it can create duplicates within the
current config.

Prevent this by adding a check if udc_name already exists, then bail
out of cfg_link.

Following is an example:

Step1:
ln -s X1 ffs.a
-->cfg_link
--> usb_get_function(ffs.a)
	->ffs_alloc

	CFG->FUNC_LIST: <ffs.a>
	C->FUNCTION: <empty>

Step2:
echo udc.name > /config/usb_gadget/g1/UDC
--> UDC_store
	->composite_bind
	->usb_add_function

	CFG->FUNC_LIST: <empty>
	C->FUNCTION: <ffs.a>

Step3:
ln -s Y1 ffs.a
-->cfg_link
-->usb_get_function(ffs.a)
	->ffs_alloc

	CFG->FUNC_LIST: <ffs.a>
	C->FUNCTION: <ffs.a>

both the lists corresponds to the same function instance ffs.a
but the usb_function* pointer is different because in step 3
ffs_alloc has created a new reference to usb_function* for
ffs.a and added it to cfg_list.

Step4:
Now a composition switch involving <ffs.b,ffs.a> is executed.

the composition switch will involve 3 things:
	1. unlinking the previous functions existing
	2. creating new symlinks
	3. writing UDC

However, the composition switch is generally taken care by
userspace process which creates the symlinks in its own
nomenclature(X*) and removes only those.
So it won't be able to remove Y1 which user had created
by own.

Due to this the new symlinks cannot be created for ffs.a
since the entry already exists in CFG->FUNC_LIST.

The state of the CFG->FUNC_LIST is as follows:
	CFG->FUNC_LIST: <ffs.a>

Fixes: 88af8bbe4ef7 ("usb: gadget: the start of the configfs interface")
Signed-off-by: Krishna Kurapati PSSNV <quic_kriskura@quicinc.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/20230201132308.31523-1-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 891d8e4023221..5cbf4084daedc 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -428,6 +428,12 @@ static int config_usb_cfg_link(
 	 * from another gadget or a random directory.
 	 * Also a function instance can only be linked once.
 	 */
+
+	if (gi->composite.gadget_driver.udc_name) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	list_for_each_entry(iter, &gi->available_func, cfs_list) {
 		if (iter != fi)
 			continue;
-- 
2.39.2



