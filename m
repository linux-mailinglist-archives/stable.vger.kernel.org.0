Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573346CC47A
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbjC1PFW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbjC1PFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:05:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87B4EC53
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04330B81D7B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6684DC433D2;
        Tue, 28 Mar 2023 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015836;
        bh=IsZj2ccIzRI2FDoe8U9lkSzZwr0stP7t6RDTMoctU2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CghMlHd4ncLElli8+05e1PPhXOOYY7MwytnUCRteh6NB4/ckaQKDWqxb8eaBTsGT7
         jM1biYaEGb96AhtLJ+fvCSeMs9N3OvRxZmdv5XuiEu//PTQCUdZB1jmALFxAL9Amrx
         MaYu87Q+dQTtJQYD474TsmJdSogVAccHrAuCVJSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Steve French <stfrench@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 6.1 194/224] ksmbd: return STATUS_NOT_SUPPORTED on unsupported smb2.0 dialect
Date:   Tue, 28 Mar 2023 16:43:10 +0200
Message-Id: <20230328142625.462202630@linuxfoundation.org>
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

commit b53e8cfec30b93c120623232ba27c041b1ef8f1a upstream.

ksmbd returned "Input/output error" when mounting with vers=2.0 to
ksmbd. It should return STATUS_NOT_SUPPORTED on unsupported smb2.0
dialect.

Cc: stable@vger.kernel.org
Reported-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -434,7 +434,7 @@ int ksmbd_extract_shortname(struct ksmbd
 
 static int __smb2_negotiate(struct ksmbd_conn *conn)
 {
-	return (conn->dialect >= SMB21_PROT_ID &&
+	return (conn->dialect >= SMB20_PROT_ID &&
 		conn->dialect <= SMB311_PROT_ID);
 }
 
@@ -465,7 +465,7 @@ int ksmbd_smb_negotiate_common(struct ks
 		}
 	}
 
-	if (command == SMB2_NEGOTIATE_HE && __smb2_negotiate(conn)) {
+	if (command == SMB2_NEGOTIATE_HE) {
 		ret = smb2_handle_negotiate(work);
 		init_smb2_neg_rsp(work);
 		return ret;


