Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE954179C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357959AbiFGVEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377303AbiFGVCo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51EE123883;
        Tue,  7 Jun 2022 11:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35E4B8239B;
        Tue,  7 Jun 2022 18:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A42C385A5;
        Tue,  7 Jun 2022 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627699;
        bh=0wUPtvcxsDb/X2qUcKd/zlt/iXNEj20UtsVY8xySO5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ebM/M2QKZ3ObhQ2hKSB9pjymjUlXMUkgQvluoOjQwRIQXzXGdnVZ3XGNyYS0s2eRI
         7XFYMtXSxAGOkwuahU0wYgFyBJvgZQmpYXcRBzddAjB9ZmlSPsjVmbTyzoMuAz/ldF
         3vDZ9m6AvIf+xv3AfHVueq4nvK6AQ0d0vJhEEIYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganapathi Kamath <hgkamath@hotmail.com>,
        Kari Argillander <kari.argillander@gmail.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 024/879] fs/ntfs3: Keep preallocated only if option prealloc enabled
Date:   Tue,  7 Jun 2022 18:52:22 +0200
Message-Id: <20220607165003.376780972@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit e95113ed4d428219e3395044e29f5713fc446720 upstream.

If size of file was reduced, we still kept allocated blocks.
This commit makes ntfs3 work as other fs like btrfs.
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214719
Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")

Reported-by: Ganapathi Kamath <hgkamath@hotmail.com>
Tested-by: Ganapathi Kamath <hgkamath@hotmail.com>
Reviewed-by: Kari Argillander <kari.argillander@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -495,7 +495,7 @@ static int ntfs_truncate(struct inode *i
 
 	down_write(&ni->file.run_lock);
 	err = attr_set_size(ni, ATTR_DATA, NULL, 0, &ni->file.run, new_size,
-			    &new_valid, true, NULL);
+			    &new_valid, ni->mi.sbi->options->prealloc, NULL);
 	up_write(&ni->file.run_lock);
 
 	if (new_valid < ni->i_valid)


