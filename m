Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B424E28F2
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348590AbiCUOAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348584AbiCUN6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212C215DABC;
        Mon, 21 Mar 2022 06:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A51DF612E7;
        Mon, 21 Mar 2022 13:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0619C340E8;
        Mon, 21 Mar 2022 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870935;
        bh=YxizQVir2MiOV58U+ZMYBGDDtJL9oDimqsdgBqpeyys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBCkKnDtRtQALYVwLc4FRorWqpOjRLK73DeSokKHkNRcS5ZxJLDmXtTdRFGPz92er
         WaaeaaLdN7YByk7M1ZBLmBYmJmfM6xm5EHurVqXFrMYCbgwSoh2vgvcGqzxoQZwF0Q
         b42E9HqslZx5SFmG1WgjegJ8ruCTsBa+oaheDjXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Wei <lucaswei@google.com>
Subject: [PATCH 4.19 22/57] fs: sysfs_emit: Remove PAGE_SIZE alignment check
Date:   Mon, 21 Mar 2022 14:52:03 +0100
Message-Id: <20220321133222.632387689@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Wei <lucaswei@google.com>

For kernel releases older than 4.20, using the SLUB alloctor will cause
this alignment check to fail as that allocator did NOT align kmalloc
allocations on a PAGE_SIZE boundry.

Remove the check for these older kernels as it is a false-positive and
causes problems on many devices.

Signed-off-by: Lucas Wei <lucaswei@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/file.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -572,8 +572,7 @@ int sysfs_emit(char *buf, const char *fm
 	va_list args;
 	int len;
 
-	if (WARN(!buf || offset_in_page(buf),
-		 "invalid sysfs_emit: buf:%p\n", buf))
+	if (WARN(!buf, "invalid sysfs_emit: buf:%p\n", buf))
 		return 0;
 
 	va_start(args, fmt);


