Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B2A60858E
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiJVHfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiJVHem (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:34:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908A1357C5;
        Sat, 22 Oct 2022 00:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B936E60AD9;
        Sat, 22 Oct 2022 07:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2D1C433D7;
        Sat, 22 Oct 2022 07:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424068;
        bh=R9pusQAITq/r7Pnku+U28DKSfwlq7tVODE7WmxvlkmY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqIF+TsJbRFNV/ICgXAgtHDo0DS00AeOviUE/6LM+Cm89BEpCJN88fqTpCVdBBBFM
         AZAB0JU3h6eriy0M9ghxwZeyOp+lzpmc+bK78Ugtia0vxaeA7lTEdvWB8IPI2cD8i3
         aC/DZlARRXJCTZjr0m/n/t0nnA/EINXtk2ZYFiv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>, Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.19 018/717] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
Date:   Sat, 22 Oct 2022 09:18:17 +0200
Message-Id: <20221022072418.296354338@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

commit e98ecc6e94f4e6d21c06660b0f336df02836694f upstream.

Commit d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
extend the dialects from 3 to 4, but forget to decrease the extended
length when specific the dialect, then the message length is larger
than expected.

This maybe leak some info through network because not initialize the
message body.

After apply this patch, the VALIDATE_NEGOTIATE_INFO message length is
reduced from 28 bytes to 26 bytes.

Fixes: d5c7076b772a ("smb3: add smb3.1.1 to default dialect list")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc: <stable@vger.kernel.org>
Acked-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1168,9 +1168,9 @@ int smb3_validate_negotiate(const unsign
 		pneg_inbuf->Dialects[0] =
 			cpu_to_le16(server->vals->protocol_id);
 		pneg_inbuf->DialectCount = cpu_to_le16(1);
-		/* structure is big enough for 3 dialects, sending only 1 */
+		/* structure is big enough for 4 dialects, sending only 1 */
 		inbuflen = sizeof(*pneg_inbuf) -
-				sizeof(pneg_inbuf->Dialects[0]) * 2;
+				sizeof(pneg_inbuf->Dialects[0]) * 3;
 	}
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,


