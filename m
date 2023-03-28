Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC05F6CC413
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjC1O7z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbjC1O7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5464F1BCE
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B9C1B81CAF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A802C433D2;
        Tue, 28 Mar 2023 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015568;
        bh=1oxUom6yZBsD5bhDWZ+GhCNF0prAnTjRbDDGMpAXb1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yr3e6XVa96VSnUF81F/f7tBvzCT0QY7QcxiFhuOxE5/lqaCz2r0xxvR6sF+3f7FuX
         BVzaEbjRVizNRcbH4ji0MKGB5YmjA1oq4tQYzkjHYOV/WptgWnfpSbQ0KMCELhizfX
         Th3UmKoDP6T5GVDiQm4CXGYvfUv9GnYm9NDWWP/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tzung-Bi Shih <tzungbi@kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/224] platform/chrome: cros_ec_chardev: fix kernel data leak from ioctl
Date:   Tue, 28 Mar 2023 16:41:33 +0200
Message-Id: <20230328142621.268852416@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 0de7c255254e0..d6de5a2941282 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -284,7 +284,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	    u_cmd.insize > EC_MAX_MSG_BYTES)
 		return -EINVAL;
 
-	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
+	s_cmd = kzalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
 		return -ENOMEM;
-- 
2.39.2



