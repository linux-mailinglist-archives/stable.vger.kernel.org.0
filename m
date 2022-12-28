Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72A87657A30
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiL1PIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiL1PIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:08:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540EF13DD0
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:08:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E636F61365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D44C433D2;
        Wed, 28 Dec 2022 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240118;
        bh=5r1L8NuKrGsUQuiacWiDRv1vkEBcGZIBQ0zlO5wooEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3CGYqKQjjPdRyHxDlme7szQVZgjYLutKCptaDQduU8G59GrCQ/W6B1E4qfVbocJV
         nCsL12lR5N4FJOWqVL+gEWgvTehbF7eypANVkLWts/D+ahdLD5/8hWJ7Tdc4C/sDm+
         N91MmHggLDCgvp5t5hnNcS9iK7ApgdIIp9eaYmTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang He <windhl@126.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/731] media: c8sectpfe: Add of_node_put() when breaking out of loop
Date:   Wed, 28 Dec 2022 15:36:58 +0100
Message-Id: <20221228144305.592813331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 63ff05a1ad242a5a0f897921c87b70d601bda59c ]

In configure_channels(), we should call of_node_put() when breaking
out of for_each_child_of_node() which will automatically increase
and decrease the refcount.

Fixes: c5f5d0f99794 ("[media] c8sectpfe: STiH407/10 Linux DVB demux support")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 338b205ae3a7..88d0188397e7 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -940,6 +940,7 @@ static int configure_channels(struct c8sectpfei *fei)
 		if (ret) {
 			dev_err(fei->dev,
 				"configure_memdma_and_inputblock failed\n");
+			of_node_put(child);
 			goto err_unmap;
 		}
 		index++;
-- 
2.35.1



