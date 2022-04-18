Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707515056E5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243332AbiDRNrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiDRNqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3342C27143;
        Mon, 18 Apr 2022 06:00:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C28B060B3A;
        Mon, 18 Apr 2022 13:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC58C385A1;
        Mon, 18 Apr 2022 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286844;
        bh=G3r+WlNIzMT9anVEDUcHlMm/sERjt+PIsSqzrRHCOTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvOFsDUE50FjKk2GvNHpO1NTEq1QhLFBgt94dnOlqMeNvbLWZk+pqYrlrHXO8FX06
         9AJQV/yh/Zrj6bo//HsOCAZ23X11u44QzVuXahhBxsem+7RjuxTAfLf5rlsweU3fPH
         PiCnhl5m9JEUH+mHmOluVU2X2PyWmX9zXAQj/HaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 264/284] mlxsw: i2c: Fix initialization error flow
Date:   Mon, 18 Apr 2022 14:14:05 +0200
Message-Id: <20220418121220.174376447@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit d452088cdfd5a4ad9d96d847d2273fe958d6339b ]

Add mutex_destroy() call in driver initialization error flow.

Fixes: 6882b0aee180f ("mlxsw: Introduce support for I2C bus")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220407070703.2421076-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index c0dcfa05b077..3d10e6100748 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -548,6 +548,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	return 0;
 
 errout:
+	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
 
 	return err;
-- 
2.35.1



