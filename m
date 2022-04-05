Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C685A4F38C0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377161AbiDEL2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349661AbiDEJuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:50:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C82112F;
        Tue,  5 Apr 2022 02:48:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14692615E3;
        Tue,  5 Apr 2022 09:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF0CC385A1;
        Tue,  5 Apr 2022 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152128;
        bh=EN/h9MuQ8YPinwPxDQ9qw4apglfU/7kLJJV2EWiYFP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQlsoJAfoWXsDXHhs0pjsIplHTdEH/W3tswdOgHElJhDR/Fq2DGPY1meJ7Nw4cJ8N
         C9gKkFNuMNCSmhoW2uBAhR1EpVvZiQUft3UFEbhrZTqvlr69Saz3UMplEAk36Kxage
         85738zYvITC+VqkaKdVAs9ecmO1HRb3uK+lSsgT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/913] remoteproc: qcom_wcnss: Add missing of_node_put() in wcnss_alloc_memory_region
Date:   Tue,  5 Apr 2022 09:27:58 +0200
Message-Id: <20220405070358.305769205@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 8f90161a66bc3d6b9fe8dde4d9028d20eae1b62a ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: aed361adca9f ("remoteproc: qcom: Introduce WCNSS peripheral image loader")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220308063102.10049-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_wcnss.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/remoteproc/qcom_wcnss.c b/drivers/remoteproc/qcom_wcnss.c
index ebadc6c08e11..b17742eac9ff 100644
--- a/drivers/remoteproc/qcom_wcnss.c
+++ b/drivers/remoteproc/qcom_wcnss.c
@@ -501,6 +501,7 @@ static int wcnss_alloc_memory_region(struct qcom_wcnss *wcnss)
 	}
 
 	ret = of_address_to_resource(node, 0, &r);
+	of_node_put(node);
 	if (ret)
 		return ret;
 
-- 
2.34.1



