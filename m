Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360C96D4724
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232895AbjDCOR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbjDCOR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:17:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF42951B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76E1C61CDA
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4A4C433EF;
        Mon,  3 Apr 2023 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531446;
        bh=rVNf+AKk2ufjOYRoxKKnEQBb4JcfDxF4mdj3aCzLVmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FScDHJ2m1s9Obw1DCZg5bTkHiT5gTcgSXcd9rgSZBVKhVzLwrFfyC1nda3Zj0x9T/
         nQ0aELnkrG/k++2Lhtut17EyEm59ZeUgYw9hePx/IbkOQ4IIMYc64JKKq2xD4dxJrt
         UuUatM8zmzlV93vuWqM70tgdwElFUklewfCbarZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 36/84] cifs: empty interface list when server doesnt support query interfaces
Date:   Mon,  3 Apr 2023 16:08:37 +0200
Message-Id: <20230403140354.585526474@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
References: <20230403140353.406927418@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 896cd316b841053f6df95ab77b5f1322c16a8e18 upstream.

When querying server interfaces returns -EOPNOTSUPP,
clear the list of interfaces. Assumption is that multichannel
would be disabled too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -475,7 +475,7 @@ SMB3_request_interfaces(const unsigned i
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;


