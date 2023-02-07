Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3117068D84E
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjBGNIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:08:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232267AbjBGNIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:08:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C233B0D0
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1924761440
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF04C433EF;
        Tue,  7 Feb 2023 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775228;
        bh=Dc+iMzuihmCLQGO7bhJClC1Hh9LN/ktbwKl+J/4cAVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJgFIwkfiURbnhMdiN5qnCz8omYwxnNjO3MIdDr2k4eNhbnP5pjSZeQtEiEVSyJgt
         f8CbVVTw+Qihy6lR3QQ1WdI/lQzQcYT2tbvMxc3uAy8Ns9ArkWA9rT8keNabqWmNAy
         Ik718ic8dttDfBVaeyH+dhnw99r01x6ex48ddJG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.1 150/208] nvmem: qcom-spmi-sdam: fix module autoloading
Date:   Tue,  7 Feb 2023 13:56:44 +0100
Message-Id: <20230207125641.239311202@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 1ca7fca349316231bbaa68d16f819a08d683c5a7 upstream.

Add the missing module device table so that the driver can be autoloaded
when built as a module.

Fixes: 40ce9798794f ("nvmem: add QTI SDAM driver")
Cc: stable@vger.kernel.org	# 5.6
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230127104015.23839-11-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/qcom-spmi-sdam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvmem/qcom-spmi-sdam.c b/drivers/nvmem/qcom-spmi-sdam.c
index 4fcb63507ecd..8499892044b7 100644
--- a/drivers/nvmem/qcom-spmi-sdam.c
+++ b/drivers/nvmem/qcom-spmi-sdam.c
@@ -166,6 +166,7 @@ static const struct of_device_id sdam_match_table[] = {
 	{ .compatible = "qcom,spmi-sdam" },
 	{},
 };
+MODULE_DEVICE_TABLE(of, sdam_match_table);
 
 static struct platform_driver sdam_driver = {
 	.driver = {
-- 
2.39.1



