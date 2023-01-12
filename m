Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB22667718
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237313AbjALOjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbjALOjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:39:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7B2517CD
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:29:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D6B62031
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06C5C433F1;
        Thu, 12 Jan 2023 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533743;
        bh=4FwF9Oe93DQjDUA9RWhKH2Q8v4ZzerYzK6uTEumESR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrzCvqMdnY3J96fvft2un6ItN2BinTJbXqccVv8pwF+8NNA4uWlGqDDdAXLxSXdL2
         sC2U5hbJWWw/elz/FqUJgkBS2YBBdGb9oZNjBJ7EwBC5TUWehTjzs/0XKErzUOqsd0
         apqp40JVUuRJUZb/HLhrIN3FuDDsb3i8ZHiSM7z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 578/783] nvme: fix the NVME_CMD_EFFECTS_CSE_MASK definition
Date:   Thu, 12 Jan 2023 14:54:54 +0100
Message-Id: <20230112135551.039617116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 685e6311637e46f3212439ce2789f8a300e5050f ]

3 << 16 does not generate the correct mask for bits 16, 17 and 18.
Use the GENMASK macro to generate the correct mask instead.

Fixes: 84fef62d135b ("nvme: check admin passthru command effects")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index bfed36e342cc..fe39ed9e9303 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_NVME_H
 #define _LINUX_NVME_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 
@@ -528,7 +529,7 @@ enum {
 	NVME_CMD_EFFECTS_NCC		= 1 << 2,
 	NVME_CMD_EFFECTS_NIC		= 1 << 3,
 	NVME_CMD_EFFECTS_CCC		= 1 << 4,
-	NVME_CMD_EFFECTS_CSE_MASK	= 3 << 16,
+	NVME_CMD_EFFECTS_CSE_MASK	= GENMASK(18, 16),
 	NVME_CMD_EFFECTS_UUID_SEL	= 1 << 19,
 };
 
-- 
2.35.1



