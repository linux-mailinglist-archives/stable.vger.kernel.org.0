Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9E66CC36A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbjC1Oxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjC1Oxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627F1D307
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A8B61840
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41E7C4339B;
        Tue, 28 Mar 2023 14:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015219;
        bh=bZs2l0LpMuRs8IYfsVN2edPTMCbeJoRtCneFFHKZ4TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrC7brVTsVEXbLEwHS1372Xaxz2fR8dfDOsBf3QTttVQz9cQjeO8kC/lXDVc5+R40
         Aqru1f9DtKLVyj0qlLUjaT1edJCnNeGdJn8vP9RJC4nfzaOBNsf27w8EqNMB8n6jRb
         ThOgjFeE/bHo27QMsgsHthlwY6YZaW1TQjTsV1Wk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miao Lihua <441884205@qq.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 210/240] ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION
Date:   Tue, 28 Mar 2023 16:42:53 +0200
Message-Id: <20230328142628.434248285@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 728f14c72b71a19623df329c1c7c9d1452e56f1e upstream.

If vfs objects = streams_xattr in ksmbd.conf FILE_NAMED_STREAMS should
be set to Attributes in FS_ATTRIBUTE_INFORMATION. MacOS client show
"Format: SMB (Unknown)" on faked NTFS and no streams support.

Cc: stable@vger.kernel.org
Reported-by: Miao Lihua <441884205@qq.com>
Tested-by: Miao Lihua <441884205@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -4956,6 +4956,10 @@ static int smb2_get_info_filesystem(stru
 
 		info->Attributes |= cpu_to_le32(server_conf.share_fake_fscaps);
 
+		if (test_share_config_flag(work->tcon->share_conf,
+		    KSMBD_SHARE_FLAG_STREAMS))
+			info->Attributes |= cpu_to_le32(FILE_NAMED_STREAMS);
+
 		info->MaxPathNameComponentLength = cpu_to_le32(stfs.f_namelen);
 		len = smbConvertToUTF16((__le16 *)info->FileSystemName,
 					"NTFS", PATH_MAX, conn->local_nls, 0);


