Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAD46B4567
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbjCJOdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:33:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjCJOdM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4ECBDF7
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6340AB822DA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D2BC433EF;
        Fri, 10 Mar 2023 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458775;
        bh=iZ/l1D7n9bUaD2CVwAjGbidvRBZxgkUpNuSq4Ha1DH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=reFY077DEr/FSwkRAhVWXZgCbnvWQO/zSk7sYBxievnu8FpniduNYpuv5tnPW4PQn
         YGPHGW8hBH4Vhw7JcID+sxkZfSrCdiDNGd1t4LBI72XvQ0J46C3MfqQOrRxNyDE5VM
         OKu2CY44oNXOy2wN0d7ukhi2WJMqu8aHzu8gSZP4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/357] cifs: Fix lost destroy smbd connection when MR allocate failed
Date:   Fri, 10 Mar 2023 14:37:09 +0100
Message-Id: <20230310133740.863234673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit e9d3401d95d62a9531082cd2453ed42f2740e3fd ]

If the MR allocate failed, the smb direct connection info is NULL,
then smbd_destroy() will directly return, then the connection info
will be leaked.

Let's set the smb direct connection info to the server before call
smbd_destroy().

Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 2cea6c25d1b0e..66265e7303cd4 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1784,6 +1784,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
-- 
2.39.2



