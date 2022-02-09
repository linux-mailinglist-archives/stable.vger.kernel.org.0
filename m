Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091304AFD59
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 20:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiBIT1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 14:27:25 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiBIT0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 14:26:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D890E00E262;
        Wed,  9 Feb 2022 11:19:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A97BB82389;
        Wed,  9 Feb 2022 19:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D703DC340E7;
        Wed,  9 Feb 2022 19:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644434144;
        bh=PqONi1GkjZKoc6dk/U8NdQWip3lI+pZwr6JwSkDsVCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNe476sz6jo/iVLlime0rLYP9reLGh8ffDGUZa5Vn00zgC05cE81FP5yMGnG6JVFV
         /q2QIH1h15yj3qL9yytOk1XEGCJirECBMfOOBiNpD91Bht+RyURAnyqLO/TvNDaxeZ
         qJKWd1ZCy2W4gc0oVrq3OiuR2cNWwVwwg3zxG0+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.15 4/5] ksmbd: fix SMB 3.11 posix extension mount failure
Date:   Wed,  9 Feb 2022 20:14:29 +0100
Message-Id: <20220209191250.132189906@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
References: <20220209191249.980911721@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit 9ca8581e79e51c57e60b3b8e3b89d816448f49fe upstream.

cifs client set 4 to DataLength of create_posix context, which mean
Mode variable of create_posix context is only available. So buffer
validation of ksmbd should check only the size of Mode except for
the size of Reserved variable.

Fixes: 8f77150c15f8 ("ksmbd: add buffer validation for SMB2_CREATE_CONTEXT")
Cc: stable@vger.kernel.org # v5.15+
Reported-by: Steve French <smfrench@gmail.com>
Tested-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2690,7 +2690,7 @@ int smb2_open(struct ksmbd_work *work)
 					(struct create_posix *)context;
 				if (le16_to_cpu(context->DataOffset) +
 				    le32_to_cpu(context->DataLength) <
-				    sizeof(struct create_posix)) {
+				    sizeof(struct create_posix) - 4) {
 					rc = -EINVAL;
 					goto err_out1;
 				}


