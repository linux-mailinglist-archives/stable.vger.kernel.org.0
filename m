Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FA659D8AD
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbiHWJwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352284AbiHWJv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:51:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEE89F0EA;
        Tue, 23 Aug 2022 01:45:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 224AEB81C39;
        Tue, 23 Aug 2022 08:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75668C433C1;
        Tue, 23 Aug 2022 08:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242651;
        bh=VjhgaeQuIzUr58TJv2AShtXaQvD2k3yhALj3E6r+uoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y0UiCzsoCUYkF+2JN9VOaXzDq6zsdvFS/Ivwt9iUvaef/Wfci57YRDAVabn1obLOP
         s2Ae/eWPJNXbTb7z71J6eLtTkNjYtz8LwMgSQtUPANmiG8pJKbqAwm/g3I41lz++UK
         G2wC14ZHKnx2vCwU2q/3HAAJKNufa6g5hknrOOdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "Ewan D. Milne" <emilne@redhat.com>,
        James Smart <jsmart2021@gmail.com>,
        Muneendra Kumar M <muneendra.kumar@broadcom.com>
Subject: [PATCH 5.19 154/365] nvme-fc: fix the fc_appid_store return value
Date:   Tue, 23 Aug 2022 10:00:55 +0200
Message-Id: <20220823080124.671691940@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 9317d0014499182c77a03cd095e83bcfb0f53750 upstream.

"nvme-fc: fold t fc_update_appid into fc_appid_store" accidentally
changed the userspace interface for the appid attribute, because the code
that decrements "count" to remove a trailing '\n' in the parsing results
in the decremented value being incorrectly be returned from the sysfs
write.  Fix this by keeping an orig_count variable for the full length
of the write.

Fixes: c814153c83a8 ("nvme-fc: fold t fc_update_appid into fc_appid_store")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
Tested-by:  Muneendra Kumar M <muneendra.kumar@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 8d14df8eeab8..127abaf9ba5d 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3880,6 +3880,7 @@ static int fc_parse_cgrpid(const char *buf, u64 *id)
 static ssize_t fc_appid_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
+	size_t orig_count = count;
 	u64 cgrp_id;
 	int appid_len = 0;
 	int cgrpid_len = 0;
@@ -3904,7 +3905,7 @@ static ssize_t fc_appid_store(struct device *dev,
 	ret = blkcg_set_fc_appid(app_id, cgrp_id, sizeof(app_id));
 	if (ret < 0)
 		return ret;
-	return count;
+	return orig_count;
 }
 static DEVICE_ATTR(appid_store, 0200, NULL, fc_appid_store);
 #endif /* CONFIG_BLK_CGROUP_FC_APPID */
-- 
2.37.2



