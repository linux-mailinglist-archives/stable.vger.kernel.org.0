Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CDF60B8D0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbiJXTys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbiJXTyJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3BB72AC7A;
        Mon, 24 Oct 2022 11:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B6FBB815A6;
        Mon, 24 Oct 2022 12:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F677C433D7;
        Mon, 24 Oct 2022 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614814;
        bh=no5vOmkhHLyVqt6U3EgfFJ8+Ho+hX3MnrTKAZBQ4eAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9jOTIVkIIK1BXj2rg8WBcOUtaufzowUpsaSdmBF3e7sfZFVmhk865ysylI50/qjA
         VnaJERNLUjuPpwrEb7n9FPK+lLqz7SeTJUjqreQwliuFfV4M+rz6Vgzu4fWHPqL6EI
         n6krLRdyBNLxrQgGeVaSlMo72SITW8JPPbyEb1NI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>, Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 014/530] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
Date:   Mon, 24 Oct 2022 13:25:58 +0200
Message-Id: <20221024113045.659243504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1137,9 +1137,9 @@ int smb3_validate_negotiate(const unsign
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


