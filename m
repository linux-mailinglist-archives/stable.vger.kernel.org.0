Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AB937C5D7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhELPnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234024AbhELPjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:39:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F6E761C72;
        Wed, 12 May 2021 15:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832837;
        bh=8vmq9Puda2Dmx8qN1xYgteUcNEpTEsxOm+8xqqF05IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0mARaEOf9fAi/5W1gGV7R5YkvOZqiXT9kaVbPewYTzwZE/vYj05k7HqEgmlgvqZyd
         FEGGKQNPR6CMzSHW1gTOHGZ5bjjycuHugmTNLoMxJvYQbEnHIJCh7XePERMKuSTA5+
         ne0UsPY9QFheOmR+ZdPP1mMHGGvq7HdumPDeGM0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/530] xfs: fix return of uninitialized value in variable error
Date:   Wed, 12 May 2021 16:48:39 +0200
Message-Id: <20210512144833.206660175@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 3b6dd9a9aeeada19d0c820ff68e979243a888bb6 ]

A previous commit removed a call to xfs_attr3_leaf_read that
assigned an error return code to variable error. We now have
a few early error return paths to label 'out' that return
error if error is set; however error now is uninitialized
so potentially garbage is being returned.  Fix this by setting
error to zero to restore the original behaviour where error
was zero at the label 'restart'.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd8e6418a0d3..96ac7e562b87 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -928,6 +928,7 @@ restart:
 	 * Search to see if name already exists, and get back a pointer
 	 * to where it should go.
 	 */
+	error = 0;
 	retval = xfs_attr_node_hasname(args, &state);
 	if (retval != -ENOATTR && retval != -EEXIST)
 		goto out;
-- 
2.30.2



