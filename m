Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2A260B775
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbiJXTYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232354AbiJXTXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:23:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997C07AC2A;
        Mon, 24 Oct 2022 10:57:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC6BCB81928;
        Mon, 24 Oct 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36150C433D6;
        Mon, 24 Oct 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615211;
        bh=dTXimvS3/PRD19esBnkIqkWImn4hUbImLSQIDJLpmfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TBlW9CVV/LcUwtL5wxRm7IdPaoD1iR+qXPNOlqlzVT9kyB9TGdEY/ROsdPlgGl1Oq
         Tx9XLZQX7DM6p/AfHXHmR/2/sHpTJduh8lyBDC0ifv3AZ2MMxCuotiHOfNloF/qDJ1
         4ef4Bk2kfIiXfd1+aY0ancB0IuaBK8Sf8qD0dMDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 134/530] smb3: must initialize two ACL struct fields to zero
Date:   Mon, 24 Oct 2022 13:27:58 +0200
Message-Id: <20221024113051.119721776@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit f09bd695af3b8ab46fc24e5d6954a24104c38387 upstream.

Coverity spotted that we were not initalizing Stbz1 and Stbz2 to
zero in create_sd_buf.

Addresses-Coverity: 1513848 ("Uninitialized scalar variable")
Cc: <stable@vger.kernel.org>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2pdu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2354,7 +2354,7 @@ create_sd_buf(umode_t mode, bool set_own
 	unsigned int acelen, acl_size, ace_count;
 	unsigned int owner_offset = 0;
 	unsigned int group_offset = 0;
-	struct smb3_acl acl;
+	struct smb3_acl acl = {};
 
 	*len = roundup(sizeof(struct crt_sd_ctxt) + (sizeof(struct cifs_ace) * 4), 8);
 
@@ -2427,6 +2427,7 @@ create_sd_buf(umode_t mode, bool set_own
 	acl.AclRevision = ACL_REVISION; /* See 2.4.4.1 of MS-DTYP */
 	acl.AclSize = cpu_to_le16(acl_size);
 	acl.AceCount = cpu_to_le16(ace_count);
+	/* acl.Sbz1 and Sbz2 MBZ so are not set here, but initialized above */
 	memcpy(aclptr, &acl, sizeof(struct smb3_acl));
 
 	buf->ccontext.DataLength = cpu_to_le32(ptr - (__u8 *)&buf->sd);


