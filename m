Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215AC58705D
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiHAS1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 14:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiHAS1S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 14:27:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95A92B24E
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 11:27:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9781368AA6; Mon,  1 Aug 2022 20:27:14 +0200 (CEST)
Date:   Mon, 1 Aug 2022 20:27:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-nvme@lists.infradead.org, hch@lst.de,
        muneendra.kumar@broadcom.com, james.smart@broadcom.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "nvme-fc: fold t fc_update_appid into
 fc_appid_store"
Message-ID: <20220801182714.GA17613@lst.de>
References: <20220801162713.17324-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801162713.17324-1-emilne@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 01, 2022 at 12:27:13PM -0400, Ewan D. Milne wrote:
> This reverts commit c814153c83a892dfd42026eaa661ae2c1f298792.
> 
> The commit c814153c83a8 "nvme-fc: fold t fc_update_appid into fc_appid_store"
> changed the userspace interface, because the code that decrements "count"
> to remove a trailing '\n' in the parsing results in the decremented value being
> incorrectly be returned from the sysfs write.  Fix this by revering the commit.

Wouldn't something like the patch below be much simpler and cleaner:


diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 9987797620b6d..e24ab688f00d5 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3878,6 +3878,7 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
 static ssize_t fc_appid_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
+	size_t orig_count = count;
 	u64 cgrp_id;
 	int appid_len = 0;
 	int cgrpid_len = 0;
@@ -3902,7 +3903,7 @@ static ssize_t fc_appid_store(struct device *dev,
 	ret = blkcg_set_fc_appid(app_id, cgrp_id, sizeof(app_id));
 	if (ret < 0)
 		return ret;
-	return count;
+	return orig_count;
 }
 static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
 #endif /* CONFIG_BLK_CGROUP_FC_APPID */
