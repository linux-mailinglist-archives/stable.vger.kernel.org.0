Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D492603D83
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiJSJDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJSJC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:02:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A7D95E72;
        Wed, 19 Oct 2022 01:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 531E2617D1;
        Wed, 19 Oct 2022 08:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC7AC433C1;
        Wed, 19 Oct 2022 08:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169671;
        bh=FGLUiA+nI5EoWurmpv9dwxt2Cwd9+rHSJ5m5kYCZDGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xdb6PY/AkXp2s+ImeWD4wPj4V82RIOeHNvdEhMZBqVBeUVjL26j7u/cqZ5QyBKaPQ
         yX28o8T6QhxfU0byffuXGRo+wvsGtBsXDqmCOCJvelCSCXR/6i1kfnJoIHLtJSQfvg
         v9APonAEMdacZU/7xiTu+Uz2Ld+k5Sv0f/nj8K/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <groeck@chromium.org>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 364/862] platform/chrome: fix memory corruption in ioctl
Date:   Wed, 19 Oct 2022 10:27:31 +0200
Message-Id: <20221019083306.085879814@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 8a07b45fd3c2dda24fad43639be5335a4595196a ]

If "s_mem.bytes" is larger than the buffer size it leads to memory
corruption.

Fixes: eda2e30c6684 ("mfd / platform: cros_ec: Miscellaneous character device to talk with the EC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/Yv8dpCFZJdbUT5ye@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_chardev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index fd33de546aee..0de7c255254e 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -327,6 +327,9 @@ static long cros_ec_chardev_ioctl_readmem(struct cros_ec_dev *ec,
 	if (copy_from_user(&s_mem, arg, sizeof(s_mem)))
 		return -EFAULT;
 
+	if (s_mem.bytes > sizeof(s_mem.buffer))
+		return -EINVAL;
+
 	num = ec_dev->cmd_readmem(ec_dev, s_mem.offset, s_mem.bytes,
 				  s_mem.buffer);
 	if (num <= 0)
-- 
2.35.1



