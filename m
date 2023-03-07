Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CC06AEA83
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjCGReb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjCGReP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCB7497C4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8116E61519
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D5CC4339B;
        Tue,  7 Mar 2023 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210198;
        bh=4Nt92KzbsqU8PigjDhTRfGAusiZGoIGgOoXHeJkDaRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yhf7BuVGF4vnbrJetJy2yNT5MXZfekPFIClOVNSEpD05ipFOIMPJVmEDFXyxr57ec
         eA21QLhPACvLKOQkcSSDq7lwoAW2WXA1TyUn4EoxscV9VQyqG4pDjBzTvRQ3s9Gjpe
         1CL+anJCI4sRR6pD41+ho2WQ1om1SaMujkp1ZZMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        David Howells <dhowells@redhat.com>,
        Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0457/1001] cifs: Fix lost destroy smbd connection when MR allocate failed
Date:   Tue,  7 Mar 2023 17:53:49 +0100
Message-Id: <20230307170041.205711239@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 8c816b25ce7c6..101dab87cad1a 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1700,6 +1700,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
-- 
2.39.2



