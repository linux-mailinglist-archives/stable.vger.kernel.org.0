Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A778D6CC33E
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233405AbjC1Ow3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233436AbjC1OwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:52:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822681FF3
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BD8BB81CAF
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8E8C4339B;
        Tue, 28 Mar 2023 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015118;
        bh=fU+/5WrZwYJwMCKb6EdYeKNx4M1eiPsjd7FUh0LOzqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8TCN9rWehZVVoLc9OmxbsbBpT+ixpO6gnhjecSGBZOurMCdL8XYHD3u71aocACqH
         FmOSecJdJopqZl1m5QhS+IyEe3S7X8AuBhegQ6E3vq29a8UhjKymnYHbHzwOnwTsGN
         tji+H6IM4fCWrNptePBn4FMY0+Sm4UD+luW9rkA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 165/240] cifs: empty interface list when server doesnt support query interfaces
Date:   Tue, 28 Mar 2023 16:42:08 +0200
Message-Id: <20230328142626.553734690@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
@@ -717,7 +717,7 @@ SMB3_request_interfaces(const unsigned i
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;


