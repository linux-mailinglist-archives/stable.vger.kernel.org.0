Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C06CC2C4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbjC1Osc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbjC1OsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:48:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF41BDE9
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79BC1B80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C391FC433D2;
        Tue, 28 Mar 2023 14:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014884;
        bh=SvsT3LJ93mp/9QSQJ/xhqWMvY75Cvq9Hvb98wVl3j+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W0UGbh20Emeuzdj1gDIGqKqecONFvDvRZ4tAjKtGRLpSt+iYJMyrwGIKyEOqakmQh
         H7R4dg7PeiZO8isnucfgOyAAElWHX59VWcVK8WHIpFXcc9fIwnOP9WRDFHUuP0avoj
         1G7mJMJZuR1Dqxd2XU9EJZWOC5E/64birwGcMIE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 087/240] ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
Date:   Tue, 28 Mar 2023 16:40:50 +0200
Message-Id: <20230328142623.402735421@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 342edb60dcda7a409430359b0cac2864bb9dfe44 ]

Smatch static checker warning:
 fs/ksmbd/vfs.c:1040 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'length'
 fs/ksmbd/vfs.c:1041 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'start'

Fix unexpected result that could caused from negative start and length.

Fixes: f44158485826 ("cifsd: add file operations")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index abe7ea1c8a2f5..b553d93a94eb5 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7463,13 +7463,16 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (in_count == 0)
 		return -EINVAL;
 
+	start = le64_to_cpu(qar_req->file_offset);
+	length = le64_to_cpu(qar_req->length);
+
+	if (start < 0 || length < 0)
+		return -EINVAL;
+
 	fp = ksmbd_lookup_fd_fast(work, id);
 	if (!fp)
 		return -ENOENT;
 
-	start = le64_to_cpu(qar_req->file_offset);
-	length = le64_to_cpu(qar_req->length);
-
 	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
 				   qar_rsp, in_count, out_count);
 	if (ret && ret != -E2BIG)
-- 
2.39.2



