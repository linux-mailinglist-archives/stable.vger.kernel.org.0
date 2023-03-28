Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A456CC476
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbjC1PFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjC1PFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE17EB55
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85AC96184D
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C82C433D2;
        Tue, 28 Mar 2023 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015831;
        bh=PxJrrQ9FG7EzxvS52Ir8afBB5c9uOMVZBBHfDzOZzgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6nl1x6GmMmAQskbE3HFxvRcAeDpW+cRZ00OCKs1PYwuDYFY1drMj7njAzRIP9t5K
         vEBlDJJrApF5KD0LGVF2jzZj8JjbH56hgENhh8PEYwa5zqBxjnnXjB1RfC6tV+dUEK
         9lzvQwQM3nHX7OFN69f/KrMvIFQwJKoeQGb/On1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miao Lihua <441884205@qq.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 192/224] ksmbd: set FILE_NAMED_STREAMS attribute in FS_ATTRIBUTE_INFORMATION
Date:   Tue, 28 Mar 2023 16:43:08 +0200
Message-Id: <20230328142625.375998320@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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
@@ -4954,6 +4954,10 @@ static int smb2_get_info_filesystem(stru
 
 		info->Attributes |= cpu_to_le32(server_conf.share_fake_fscaps);
 
+		if (test_share_config_flag(work->tcon->share_conf,
+		    KSMBD_SHARE_FLAG_STREAMS))
+			info->Attributes |= cpu_to_le32(FILE_NAMED_STREAMS);
+
 		info->MaxPathNameComponentLength = cpu_to_le32(stfs.f_namelen);
 		len = smbConvertToUTF16((__le16 *)info->FileSystemName,
 					"NTFS", PATH_MAX, conn->local_nls, 0);


