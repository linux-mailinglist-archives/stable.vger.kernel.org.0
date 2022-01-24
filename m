Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ADD49A915
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322026AbiAYDU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:20:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34014 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352987AbiAXUHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:07:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E1EA6133D;
        Mon, 24 Jan 2022 20:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80B2C340E5;
        Mon, 24 Jan 2022 20:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054834;
        bh=TbXTETSQ1YQILlp9xSgjvtLzrsicT/Saq34wBUA5fk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8Lkl1SLsdCY0UXjDLyOgjfCUHYNKTU6aZSvsAlSD/a98meF3HUl9wwoiUtzyR0s/
         A1i3aBfhX7hyepPNhakiTiue0BtCbJnVxiNV3uZnqzhxA2jNIz2Z9cX79KJAsmYOmA
         qeVvr9bgfSHt+hod7CN1VQEZVR+xTMWUj4qKNMRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.10 518/563] clk: si5341: Fix clock HW provider cleanup
Date:   Mon, 24 Jan 2022 19:44:43 +0100
Message-Id: <20220124184042.361906453@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 49a8f2bc8d88702783c7e163ec84374e9a022f71 upstream.

The call to of_clk_add_hw_provider was not undone on remove or on probe
failure, which could cause an oops on a subsequent attempt to retrieve
clocks for the removed device. Switch to the devm version of the
function to avoid this issue.

Fixes: 3044a860fd09 ("clk: Add Si5341/Si5340 driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220112203816.1784610-1-robert.hancock@calian.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-si5341.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -1576,7 +1576,7 @@ static int si5341_probe(struct i2c_clien
 			clk_prepare(data->clk[i].hw.clk);
 	}
 
-	err = of_clk_add_hw_provider(client->dev.of_node, of_clk_si5341_get,
+	err = devm_of_clk_add_hw_provider(&client->dev, of_clk_si5341_get,
 			data);
 	if (err) {
 		dev_err(&client->dev, "unable to add clk provider\n");


