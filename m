Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C163059DA02
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352084AbiHWKE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352637AbiHWKCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF62A223C;
        Tue, 23 Aug 2022 01:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 901E66122F;
        Tue, 23 Aug 2022 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8174CC433D6;
        Tue, 23 Aug 2022 08:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244620;
        bh=PHEOO4VX3NtboMTjBW2N8IPFgmpRi7rwB6g2Y1tQN/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5mbqSfXh9uTl8Eem5S7VdahUEp2u4B0KSnSP5s94qCaX1UkPXlZmUy1trEDBc9cx
         YR/uz2DssCaf/QZdeAVVhv6mpUTxSc9q3TVr5oXSi1Im5IHvXF5d7RKfjmlP5r+XYp
         dvp0uL20WVQqjq+xHTbxsRRDyltG08zZveRoclY4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.15 124/244] fs/ntfs3: uninitialized variable in ntfs_set_acl_ex()
Date:   Tue, 23 Aug 2022 10:24:43 +0200
Message-Id: <20220823080103.212067936@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

commit d4073595d0c61463ec3a87411b19e2a90f76d3f8 upstream.

The goto out calls kfree(value) on an uninitialized pointer.  Just
return directly as the other error paths do.

Fixes: 460bbf2990b3 ("fs/ntfs3: Do not change mode if ntfs_set_ea failed")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -561,7 +561,7 @@ static noinline int ntfs_set_acl_ex(stru
 			err = posix_acl_update_mode(mnt_userns, inode, &mode,
 						    &acl);
 			if (err)
-				goto out;
+				return err;
 		}
 		name = XATTR_NAME_POSIX_ACL_ACCESS;
 		name_len = sizeof(XATTR_NAME_POSIX_ACL_ACCESS) - 1;


