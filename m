Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF4E60877A
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbiJVICL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiJVIAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:00:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A160253BD6;
        Sat, 22 Oct 2022 00:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F354B82E20;
        Sat, 22 Oct 2022 07:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73B3C433D7;
        Sat, 22 Oct 2022 07:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424871;
        bh=FGLUiA+nI5EoWurmpv9dwxt2Cwd9+rHSJ5m5kYCZDGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvlJOOH0zUz/2cGCojgm2eB7PVb9N5O68I60841tNneeaoR+MuaAXtu0SO9A0eNHL
         KdMX7nUp6lVFOKGOiPApKm3Rg4foVrcFeBR9R5GR9hJYVPkSAMePFa2l/IHu+LEMmi
         eAaxfDu58WF9XMOTzY2KfjmvsgOOakBXmJxqViPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Guenter Roeck <groeck@chromium.org>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 308/717] platform/chrome: fix memory corruption in ioctl
Date:   Sat, 22 Oct 2022 09:23:07 +0200
Message-Id: <20221022072507.107751863@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



