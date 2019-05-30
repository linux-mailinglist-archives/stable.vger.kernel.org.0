Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE892EFE3
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbfE3DSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbfE3DSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:35 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 325A92479B;
        Thu, 30 May 2019 03:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186315;
        bh=G4Ukji/71z2u2uhgTzoL7dunEcMO79AC69J39W+kNTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6c1JL97jjngTKztym5OVskBXWURho6FvCiSFMFQi3AbIi9j0Z0bzgez2AuKlWYMY
         ooODeCpzbavvhTIW7VtdXpVpk8QlhmHP7joYDQAAtUfHU2gnMupcxMDokj15vtszMh
         AGEVgFCl70oSI6Bu0nqj8Bs1nWaw+A6aCjO0RJ/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        stable@kernel.org
Subject: [PATCH 4.14 002/193] ext4: do not delete unlinked inode from orphan list on failed truncate
Date:   Wed, 29 May 2019 20:04:16 -0700
Message-Id: <20190530030447.267370009@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit ee0ed02ca93ef1ecf8963ad96638795d55af2c14 upstream.

It is possible that unlinked inode enters ext4_setattr() (e.g. if
somebody calls ftruncate(2) on unlinked but still open file). In such
case we should not delete the inode from the orphan list if truncate
fails. Note that this is mostly a theoretical concern as filesystem is
corrupted if we reach this path anyway but let's be consistent in our
orphan handling.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5450,7 +5450,7 @@ int ext4_setattr(struct dentry *dentry,
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error) {
-				if (orphan)
+				if (orphan && inode->i_nlink)
 					ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}


