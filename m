Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 857FD603BE7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiJSIks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiJSIjv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:39:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0A98110C;
        Wed, 19 Oct 2022 01:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 263B9B821CD;
        Wed, 19 Oct 2022 08:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11599C433D6;
        Wed, 19 Oct 2022 08:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168694;
        bh=ueD2SFqWj/bYjwtd+JoqGKckBkUCZOJQi3XXO3Pu9Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xBdwLJ4986qjZT90lZcH9anBbSifyYFcZkd+HKjXYSXMcR4lR69B5o+73GE3cXq22
         VpLkWp3kaNWiAgpSCB6M1fzZjSxosnK8lQ3LSHWd2Fpu1yfOya6AEF3R3ZzdcYJIRn
         xdawRpa6Rz+zfnsCnszzR4tgjgmluFEYpRUkIKes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>, Tom Talpey <tom@talpey.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 023/862] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
Date:   Wed, 19 Oct 2022 10:21:50 +0200
Message-Id: <20221019083251.029839151@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1169,9 +1169,9 @@ int smb3_validate_negotiate(const unsign
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


