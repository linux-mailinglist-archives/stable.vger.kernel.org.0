Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12D7505250
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiDRMlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240420AbiDRMjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1808B28981;
        Mon, 18 Apr 2022 05:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17F09B80EC3;
        Mon, 18 Apr 2022 12:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64309C385A1;
        Mon, 18 Apr 2022 12:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284976;
        bh=lPXSw59v08NPSWuDxS3W0dFUB6XP8tMGUG8g+kBOXB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yki3TnnPP2vP+IpZnvxJj9S+x6gCU2s0AWRsgXr6zhD693Vd0BqJvYfAS3SoTQhdB
         hs4tvVD3t9UnlGKH8FIU8GfwH/5oZpZFuSV/L+095giZ835OtbbEZfzflv2ca8e866
         ouguMhSlXIB6om+zPYKFdnDXw0N6O7bH/hV3JE08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/189] mlxsw: i2c: Fix initialization error flow
Date:   Mon, 18 Apr 2022 14:11:28 +0200
Message-Id: <20220418121202.438973383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 939b692ffc33..ce843ea91464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -650,6 +650,7 @@ static int mlxsw_i2c_probe(struct i2c_client *client,
 	return 0;
 
 errout:
+	mutex_destroy(&mlxsw_i2c->cmd.lock);
 	i2c_set_clientdata(client, NULL);
 
 	return err;
-- 
2.35.1



