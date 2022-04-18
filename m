Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBB6A5051EA
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiDRMkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbiDRMjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1E11B78F;
        Mon, 18 Apr 2022 05:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 63A7560F0A;
        Mon, 18 Apr 2022 12:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E343C385A7;
        Mon, 18 Apr 2022 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285087;
        bh=1ZR11ZiS9Zx+BLT5iJLPGmUOQMhGcjaQF2rDXTOW1JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQyKXcrFtnc2z6jGw9Sm8efQd1B/gYrV76FhFHkOrQDWdo5OBsUZuAhRcJSjiOhiF
         5v5P/gENOPAsR3KxcsrGowcR24xvuUpPNBOu/kOe6Fjwp1IwyBcDLAykpnqGMjXtPX
         BP5/tX8/KhYv+Jl7S2uK7wquJ0A1THerrc1qJC4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/189] cifs: potential buffer overflow in handling symlinks
Date:   Mon, 18 Apr 2022 14:12:00 +0200
Message-Id: <20220418121203.341805767@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 64c4a37ac04eeb43c42d272f6e6c8c12bfcf4304 ]

Smatch printed a warning:
	arch/x86/crypto/poly1305_glue.c:198 poly1305_update_arch() error:
	__memcpy() 'dctx->buf' too small (16 vs u32max)

It's caused because Smatch marks 'link_len' as untrusted since it comes
from sscanf(). Add a check to ensure that 'link_len' is not larger than
the size of the 'link_str' buffer.

Fixes: c69c1b6eaea1 ("cifs: implement CIFSParseMFSymlink()")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 852e54ee82c2..bbdf3281559c 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -85,6 +85,9 @@ parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_link_len,
 	if (rc != 1)
 		return -EINVAL;
 
+	if (link_len > CIFS_MF_SYMLINK_LINK_MAXLEN)
+		return -EINVAL;
+
 	rc = symlink_hash(link_len, link_str, md5_hash);
 	if (rc) {
 		cifs_dbg(FYI, "%s: MD5 hash failure: %d\n", __func__, rc);
-- 
2.35.1



