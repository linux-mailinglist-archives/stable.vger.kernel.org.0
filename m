Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B46059DD0B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241821AbiHWLVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357410AbiHWLTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:19:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508738A1FB;
        Tue, 23 Aug 2022 02:22:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01C9CB8105C;
        Tue, 23 Aug 2022 09:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3DEC433C1;
        Tue, 23 Aug 2022 09:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246540;
        bh=idCiegonDk0H2RnGtNWkTYVbSqZO3DS9G9eAn+pbU3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LYpJMgSNeMOtQ8UpxPmhIz4mqmo6MImnrLH/NEc8QgSlqasPw0jwIT9FJ1WnfrT4C
         mylChNFEf9I54ejOBHYxbE7lZNs5S7nKF0vNVI9Ah6CnK7k49gDeor7bMoPeRWEm10
         uX7TPqX4oMDBZYUiAyk58+eFGYAUo+1cZFcFVy7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/389] i2c: mux-gpmux: Add of_node_put() when breaking out of loop
Date:   Tue, 23 Aug 2022 10:23:41 +0200
Message-Id: <20220823080121.569468311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Liang He <windhl@126.com>

[ Upstream commit 6435319c34704994e19b0767f6a4e6f37439867b ]

In i2c_mux_probe(), we should call of_node_put() when breaking out
of for_each_child_of_node() which will automatically increase and
decrease the refcount.

Fixes: ac8498f0ce53 ("i2c: i2c-mux-gpmux: new driver")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-gpmux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/muxes/i2c-mux-gpmux.c b/drivers/i2c/muxes/i2c-mux-gpmux.c
index f830535cff12..480ec74e6134 100644
--- a/drivers/i2c/muxes/i2c-mux-gpmux.c
+++ b/drivers/i2c/muxes/i2c-mux-gpmux.c
@@ -138,6 +138,7 @@ static int i2c_mux_probe(struct platform_device *pdev)
 	return 0;
 
 err_children:
+	of_node_put(child);
 	i2c_mux_del_adapters(muxc);
 err_parent:
 	i2c_put_adapter(parent);
-- 
2.35.1



