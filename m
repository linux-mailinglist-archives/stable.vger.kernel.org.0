Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AFC540851
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348823AbiFGR5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348804AbiFGR43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:56:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3BC147835;
        Tue,  7 Jun 2022 10:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2637861529;
        Tue,  7 Jun 2022 17:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35556C385A5;
        Tue,  7 Jun 2022 17:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623615;
        bh=tnAe93SYP99oq9aPLJXM6HiLXx1WHUx4j4CKjrXLn2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhPhb4WHet+1d179j/QkctuqRC/nVC5BbAFmm4jMg/ZfnUszdInmFfGSbkjXhKXmL
         AE2YZZHDSZ1lvAlCFDOnZ8Tc2E3mlVUBC6OFUK6IdIHUd4HTWZk3HEG1ow0Okol+Hz
         W1DErL2jge5S74QJ4hUGosXbn5Elg3fvMHXIB1PI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 029/667] cifs: when extending a file with falloc we should make files not-sparse
Date:   Tue,  7 Jun 2022 18:54:54 +0200
Message-Id: <20220607164935.669191862@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit f66f8b94e7f2f4ac9fffe710be231ca8f25c5057 upstream.

as this is the only way to make sure the region is allocated.
Fix the conditional that was wrong and only tried to make already
non-sparse files non-sparse.

Cc: stable@vger.kernel.org
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -3791,7 +3791,7 @@ static long smb3_simple_falloc(struct fi
 		if (rc)
 			goto out;
 
-		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
+		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 		eof = cpu_to_le64(off + len);


