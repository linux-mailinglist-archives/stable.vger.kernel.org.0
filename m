Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C561266CA92
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234217AbjAPREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234258AbjAPRDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E464A245
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:45:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD17B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCE7C433F0;
        Mon, 16 Jan 2023 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887555;
        bh=x1OLKnw77KOXJUEPfeT5NdvA3ainjt9wRTIxK006xiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R733TMEvAIeG7XeXEInNe6SFoa0i0rMzG/OVb3sqskm5FzPzH69FuXHe92eNgo43H
         aX/XusFdzEe8WYOjU3SwuCXov86WyQP4usWZVnlKOVihwf+QDR30uJ57AftWy/TOiA
         HAgrdfZ8ftZYv1wSqUbjzngw1hQ+9bh4xDzcC5z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joe Perches <joe@perches.com>,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 193/521] scsi: mpt3sas: Add ioc_<level> logging macros
Date:   Mon, 16 Jan 2023 16:47:35 +0100
Message-Id: <20230116154855.704486053@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Joe Perches <joe@perches.com>

[ Upstream commit 645a20c6821cd1ab58af8a1f99659e619c216efd ]

These macros can help identify specific logging uses and eventually perhaps
reduce object sizes.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 78316e9dfc24 ("scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 96dc15e90bd8..941a4faf20be 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -160,6 +160,15 @@ struct mpt3sas_nvme_cmd {
  */
 #define MPT3SAS_FMT			"%s: "
 
+#define ioc_err(ioc, fmt, ...)						\
+	pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_notice(ioc, fmt, ...)					\
+	pr_notice("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_warn(ioc, fmt, ...)						\
+	pr_warn("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+#define ioc_info(ioc, fmt, ...)						\
+	pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
+
 /*
  *  WarpDrive Specific Log codes
  */
-- 
2.35.1



