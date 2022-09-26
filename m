Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E6B5EA26B
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbiIZLHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbiIZLGU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:06:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923AF4F67A;
        Mon, 26 Sep 2022 03:34:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EC6160112;
        Mon, 26 Sep 2022 10:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D1DC433C1;
        Mon, 26 Sep 2022 10:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188436;
        bh=75DfJ5Yqg1z2SFT3L+O7MKMIFpGoOqNpgcehWq6lixc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhZwlRluCTNhM3Mx9Gw0QmsMDzGO5Cy+2w8qcxRMSKmo3RYtkvyAZTg/gf8gPB/pu
         6M2TzkT2VkcaFbXaU2ZE1Si4+MiL/h2gV/MfrMNn3YmqW611fLohBVLPOK3pjKuhaQ
         NYHg0T0OAbyhAwtfcvdlqEaWaQ5Mb/YwYQWGQW4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 120/141] s390/dasd: fix Oops in dasd_alias_get_start_dev due to missing pavgroup
Date:   Mon, 26 Sep 2022 12:12:26 +0200
Message-Id: <20220926100758.811434203@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit db7ba07108a48c0f95b74fabbfd5d63e924f992d upstream.

Fix Oops in dasd_alias_get_start_dev() function caused by the pavgroup
pointer being NULL.

The pavgroup pointer is checked on the entrance of the function but
without the lcu->lock being held. Therefore there is a race window
between dasd_alias_get_start_dev() and _lcu_update() which sets
pavgroup to NULL with the lcu->lock held.

Fix by checking the pavgroup pointer with lcu->lock held.

Cc: <stable@vger.kernel.org> # 2.6.25+
Fixes: 8e09f21574ea ("[S390] dasd: add hyper PAV support to DASD device driver, part 1")
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20220919154931.4123002-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_alias.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -675,12 +675,12 @@ int dasd_alias_remove_device(struct dasd
 struct dasd_device *dasd_alias_get_start_dev(struct dasd_device *base_device)
 {
 	struct dasd_eckd_private *alias_priv, *private = base_device->private;
-	struct alias_pav_group *group = private->pavgroup;
 	struct alias_lcu *lcu = private->lcu;
 	struct dasd_device *alias_device;
+	struct alias_pav_group *group;
 	unsigned long flags;
 
-	if (!group || !lcu)
+	if (!lcu)
 		return NULL;
 	if (lcu->pav == NO_PAV ||
 	    lcu->flags & (NEED_UAC_UPDATE | UPDATE_PENDING))
@@ -697,6 +697,11 @@ struct dasd_device *dasd_alias_get_start
 	}
 
 	spin_lock_irqsave(&lcu->lock, flags);
+	group = private->pavgroup;
+	if (!group) {
+		spin_unlock_irqrestore(&lcu->lock, flags);
+		return NULL;
+	}
 	alias_device = group->next;
 	if (!alias_device) {
 		if (list_empty(&group->aliaslist)) {


