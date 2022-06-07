Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F3E5417A2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378925AbiFGVEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379179AbiFGVCJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73CF188EBD;
        Tue,  7 Jun 2022 11:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6522B6160D;
        Tue,  7 Jun 2022 18:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7030FC385A5;
        Tue,  7 Jun 2022 18:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627607;
        bh=UkTbKdloFik5b/VHaRD1dza9i2d0N/klIUWUZfxdVnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e1YTQwRO9vzpSHy3Pz9EIh64CmWtnFXpb+joWZn3l8sEgFz5aH56oOlINglb21/6q
         rs1KKtFSanDrgEynvSujsvonVUIF6y9bVlijZ3Fjllu203MWMe1GsLwLGzs9e+ysFh
         n0vTIVyr99ErDjavaRSYwwAjLK1CvAKFng4Ag6nI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Luis=20Lara=20Carrascal?= 
        <manualinux@yahoo.es>, Mikulas Patocka <mpatocka@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 5.18 021/879] fs/ntfs3: provide block_invalidate_folio to fix memory leak
Date:   Tue,  7 Jun 2022 18:52:19 +0200
Message-Id: <20220607165003.290298143@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 724bbe49c5e427cb077357d72d240a649f2e4054 upstream.

The ntfs3 filesystem lacks the 'invalidate_folio' method and it causes
memory leak. If you write to the filesystem and then unmount it, the
cached written data are not freed and they are permanently leaked.
Fixes: 7ba13abbd31e ("fs: Turn block_invalidatepage into block_invalidate_folio")

Reported-by: José Luis Lara Carrascal <manualinux@yahoo.es>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: stable@vger.kernel.org  # v5.18
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -1951,6 +1951,7 @@ const struct address_space_operations nt
 	.direct_IO	= ntfs_direct_IO,
 	.bmap		= ntfs_bmap,
 	.dirty_folio	= block_dirty_folio,
+	.invalidate_folio = block_invalidate_folio,
 };
 
 const struct address_space_operations ntfs_aops_cmpr = {


