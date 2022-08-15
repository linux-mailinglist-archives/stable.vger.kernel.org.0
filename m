Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 084CF594466
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346872AbiHOWTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349628AbiHOWRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1372BB37;
        Mon, 15 Aug 2022 12:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C6F60BC2;
        Mon, 15 Aug 2022 19:40:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C89C43470;
        Mon, 15 Aug 2022 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592426;
        bh=YaFyEq5TNnM0erthFu+YMa+BtPUKxaeMZE5sVwUj5uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2PjpCIzrjoTKHpCJbDk322kk0gUew7TyjJZHxueV6KLYiAZANlKPUc/APnPDMi/uU
         mGUxeepO4YoAENfg9oCTSKmE5U1RefnSCmCRtcDFEFN8e3k89HH1nP6dsvVSzR0ZHk
         iqUoRy2fQGeT2gkvhjZd3AT5tbKAcU/ZTuRDSsEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.19 0108/1157] ksmbd: fix memory leak in smb2_handle_negotiate
Date:   Mon, 15 Aug 2022 19:51:04 +0200
Message-Id: <20220815180443.954277531@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit aa7253c2393f6dcd6a1468b0792f6da76edad917 upstream.

The allocated memory didn't free under an error
path in smb2_handle_negotiate().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17815
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1139,12 +1139,16 @@ int smb2_handle_negotiate(struct ksmbd_w
 			       status);
 			rsp->hdr.Status = status;
 			rc = -EINVAL;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 
 		rc = init_smb3_11_server(conn);
 		if (rc < 0) {
 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			kfree(conn->preauth_info);
+			conn->preauth_info = NULL;
 			goto err_out;
 		}
 


