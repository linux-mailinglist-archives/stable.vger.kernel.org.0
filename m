Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A415EA610
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbiIZM25 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiIZM2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:28:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE88B4400;
        Mon, 26 Sep 2022 04:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F55760B5E;
        Mon, 26 Sep 2022 10:33:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C45C433B5;
        Mon, 26 Sep 2022 10:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188394;
        bh=87r5EfZIsVxcIQtOJKNmuQAaS5cjmGw7XRhwBSdSeuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KF/4B3ZhFpDb1N37h/Vkzgq+9PwGAcEB1DhnG3zsurkkcMtwWn7Txnhdw9h1RkISd
         AMUHALJU9s/wFN2Yjs0ABjo8YOLROOK0TgMxkQc5O1hKOLE+TQSt7VWhAxITUIF8nQ
         PzDffu7lN99uzt0LrKGtc91i4lZVXa+pV+nvwwmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Khalil Blaiech <kblaiech@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/141] i2c: mlxbf: prevent stack overflow in mlxbf_i2c_smbus_start_transaction()
Date:   Mon, 26 Sep 2022 12:12:42 +0200
Message-Id: <20220926100759.383918686@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit de24aceb07d426b6f1c59f33889d6a964770547b ]

memcpy() is called in a loop while 'operation->length' upper bound
is not checked and 'data_idx' also increments.

Fixes: b5b5b32081cd206b ("i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC")
Reviewed-by: Khalil Blaiech <kblaiech@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxbf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-mlxbf.c b/drivers/i2c/busses/i2c-mlxbf.c
index 042c83b90734..d78fb24d5588 100644
--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -744,6 +744,9 @@ mlxbf_i2c_smbus_start_transaction(struct mlxbf_i2c_priv *priv,
 		if (flags & MLXBF_I2C_F_WRITE) {
 			write_en = 1;
 			write_len += operation->length;
+			if (data_idx + operation->length >
+					MLXBF_I2C_MASTER_DATA_DESC_SIZE)
+				return -ENOBUFS;
 			memcpy(data_desc + data_idx,
 			       operation->buffer, operation->length);
 			data_idx += operation->length;
-- 
2.35.1



