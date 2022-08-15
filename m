Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B03593923
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242591AbiHOSmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243955AbiHOSlv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BED65F8;
        Mon, 15 Aug 2022 11:25:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E51B60FDA;
        Mon, 15 Aug 2022 18:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DBDC433C1;
        Mon, 15 Aug 2022 18:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587924;
        bh=LMkp6NyyuV2Ez/uJw716SkPh5MsLtM2lf94sqx8wvtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Afrz65FgGG57HRV1z7jFO0WG5ReQ4TJuWd9QcbMXX/GzsYHbz8mvw3q/mb5307dva
         4g1zc9/y5kz8OolamzL48hB33s2BH6hADIqTI989InTQBSlBXB8jOT/d0w1urn8B3+
         7RFEpKyrAigq5OvrvJMZLhzgmB5bJMJlQ03GMr+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/779] wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
Date:   Mon, 15 Aug 2022 19:58:03 +0200
Message-Id: <20220815180347.495994260@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b88d28146c30a8e14f0f012d56ebf19b68a348f4 ]

If the copy_from_user() fails or the user gives invalid date then the
correct thing to do is to return a negative error code.  (Currently it
returns success).

I made a copy additional related cleanups:
1) There is no need to check "buffer" for NULL.  That's handled by
copy_from_user().
2) The "h2c_len" variable cannot be negative because it is unsigned
and because sscanf() does not return negative error codes.

Fixes: 610247f46feb ("rtlwifi: Improve debugging by using debugfs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/YoOLnDkHgVltyXK7@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
index 901cdfe3723c..0b1bc04cb6ad 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.c
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.c
@@ -329,8 +329,8 @@ static ssize_t rtl_debugfs_set_write_h2c(struct file *filp,
 
 	tmp_len = (count > sizeof(tmp) - 1 ? sizeof(tmp) - 1 : count);
 
-	if (!buffer || copy_from_user(tmp, buffer, tmp_len))
-		return count;
+	if (copy_from_user(tmp, buffer, tmp_len))
+		return -EFAULT;
 
 	tmp[tmp_len] = '\0';
 
@@ -340,8 +340,8 @@ static ssize_t rtl_debugfs_set_write_h2c(struct file *filp,
 			 &h2c_data[4], &h2c_data[5],
 			 &h2c_data[6], &h2c_data[7]);
 
-	if (h2c_len <= 0)
-		return count;
+	if (h2c_len == 0)
+		return -EINVAL;
 
 	for (i = 0; i < h2c_len; i++)
 		h2c_data_packed[i] = (u8)h2c_data[i];
-- 
2.35.1



