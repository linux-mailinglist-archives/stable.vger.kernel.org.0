Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C075D6D4772
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbjDCOUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbjDCOUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:20:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C131996
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C69561D17
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B03CC43325;
        Mon,  3 Apr 2023 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531585;
        bh=uQ5UaCmFtXHeFp3gX6zcla6YwLqloL+K8mNimWJRMSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTVDZZ5aGTzJg7mLLZJB2GVWYZKmoadBRk1AW8h4o8CUqp9xJJQVhPndXJXpygqBg
         yodqrE3wVTjBd95XQrInXMpcdP4ETbFxhds7pfYiMo6Dd0WjJgxDazsPEE8QGyvLyi
         NbzUWxx4DaVwIV+rUJ5CfqfrMUHJgVzE6vND0JQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/104] platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl
Date:   Mon,  3 Apr 2023 16:08:19 +0200
Message-Id: <20230403140405.341158399@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit b20cf3f89c56b5f6a38b7f76a8128bf9f291bbd3 ]

It is possible to peep kernel page's data by providing larger `insize`
in struct cros_ec_command[1] when invoking EC host commands.

Fix it by using zeroed memory.

[1]: https://elixir.bootlin.com/linux/v6.2/source/include/linux/platform_data/cros_ec_proto.h#L74

Fixes: eda2e30c6684 ("mfd / platform: cros_ec: Miscellaneous character device to talk with the EC")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230324010658.1082361-1-tzungbi@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_chardev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index 1f5f4a46ab748..4791b62c2923f 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -285,7 +285,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	    u_cmd.insize > EC_MAX_MSG_BYTES)
 		return -EINVAL;
 
-	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
+	s_cmd = kzalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
 		return -ENOMEM;
-- 
2.39.2



