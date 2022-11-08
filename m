Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F062C6213D8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbiKHNy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:54:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiKHNy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:54:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DF01E0
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:54:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 827F761595
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D08C433C1;
        Tue,  8 Nov 2022 13:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915665;
        bh=Wiuhcs5szipMvq297UpLPxghDLhGbRvOyiXKFWSQ16U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSuYGMXMhpNDRhkUx2CJVujtr24f0L/Zxzw35tfkx5INhVTcj4GuKG6mfffks3wuS
         UYfRMFsvw8+xPBfnfrd2jQ2AicS7tB0ka/O1yy3LYoZh201o0MCc5y3+/Q/jW95+Z0
         gbItX/889HBISf2IyjHqVcuJ/DZAM6x3rQfuQRLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/118] s390/boot: add secure boot trailer
Date:   Tue,  8 Nov 2022 14:38:55 +0100
Message-Id: <20221108133343.178844248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit aa127a069ef312aca02b730d5137e1778d0c3ba7 ]

This patch enhances the kernel image adding a trailer as required for
secure boot by future firmware versions.

Cc: <stable@vger.kernel.org> # 5.2+
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/compressed/vmlinux.lds.S | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/s390/boot/compressed/vmlinux.lds.S b/arch/s390/boot/compressed/vmlinux.lds.S
index 9427e2cd0c15..11bf3919610e 100644
--- a/arch/s390/boot/compressed/vmlinux.lds.S
+++ b/arch/s390/boot/compressed/vmlinux.lds.S
@@ -91,8 +91,17 @@ SECTIONS
 		_compressed_start = .;
 		*(.vmlinux.bin.compressed)
 		_compressed_end = .;
-		FILL(0xff);
-		. = ALIGN(4096);
+	}
+
+#define SB_TRAILER_SIZE 32
+	/* Trailer needed for Secure Boot */
+	. += SB_TRAILER_SIZE; /* make sure .sb.trailer does not overwrite the previous section */
+	. = ALIGN(4096) - SB_TRAILER_SIZE;
+	.sb.trailer : {
+		QUAD(0)
+		QUAD(0)
+		QUAD(0)
+		QUAD(0x000000207a49504c)
 	}
 	_end = .;
 
-- 
2.35.1



