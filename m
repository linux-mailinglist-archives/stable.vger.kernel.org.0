Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2316C69495E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbjBMO6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231146AbjBMO6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B681A961
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2E6D6116D
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AE0C433EF;
        Mon, 13 Feb 2023 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300274;
        bh=k7PqQOrF5xspToiOfP7aPjQqI1WWJ+YcXR8QTunBXBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l904CMeKjRUT885gFwODlLYUPznNB2sfSPitekTUHy5roqAlj5ieqoOAkZPbJQF4f
         wEI8VPIo50dJthXRhDkWgoXnGScrExCYMRQsAsm8RnnhnVG3XQ3/UZk7Z9ieDGkjBd
         sFV27KPE3IxKJOU8hslGATy6181P1YE2fzdxppgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 16/67] IB/hfi1: Restore allocated resources on failed copyout
Date:   Mon, 13 Feb 2023 15:48:57 +0100
Message-Id: <20230213144733.111928702@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 6601fc0d15ffc20654e39486f9bef35567106d68 ]

Fix a resource leak if an error occurs.

Fixes: f404ca4c7ea8 ("IB/hfi1: Refactor hfi_user_exp_rcv_setup() IOCTL")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167354736291.2132367.10894218740150168180.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/file_ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 686d170a5947e..1c1172aeb36e9 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -1318,12 +1318,15 @@ static int user_exp_rcv_setup(struct hfi1_filedata *fd, unsigned long arg,
 		addr = arg + offsetof(struct hfi1_tid_info, tidcnt);
 		if (copy_to_user((void __user *)addr, &tinfo.tidcnt,
 				 sizeof(tinfo.tidcnt)))
-			return -EFAULT;
+			ret = -EFAULT;
 
 		addr = arg + offsetof(struct hfi1_tid_info, length);
-		if (copy_to_user((void __user *)addr, &tinfo.length,
+		if (!ret && copy_to_user((void __user *)addr, &tinfo.length,
 				 sizeof(tinfo.length)))
 			ret = -EFAULT;
+
+		if (ret)
+			hfi1_user_exp_rcv_invalid(fd, &tinfo);
 	}
 
 	return ret;
-- 
2.39.0



