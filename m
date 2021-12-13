Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4CC47269E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhLMJxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:53:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41600 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235383AbhLMJuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:50:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A791CE0E7A;
        Mon, 13 Dec 2021 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C326C341C5;
        Mon, 13 Dec 2021 09:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389012;
        bh=T/BiCObvvFI+lM3daIrVjCm/eLx18KrlFu81miRfABM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEt3atTiYSFFSpF/3n+9fAlZthyTa2T9wrX1OyN+qXBxTqBvm+a80av2VlKp03J+D
         bsuvYuWX/EXHjGL8/GyADbOKegHhmg51s9H7cKPhnyIXnX1oFEoJ+o13F8KvcCMJW7
         PSSxP4J0mwbsRKNQzMce6XilLMV1ZJ17+j47naPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Hochholdinger <markus@hochholdinger.net>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.10 054/132] md: fix update super 1.0 on rdev size change
Date:   Mon, 13 Dec 2021 10:29:55 +0100
Message-Id: <20211213092940.980646075@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Hochholdinger <markus@hochholdinger.net>

commit 55df1ce0d4e086e05a8ab20619c73c729350f965 upstream.

The superblock of version 1.0 doesn't get moved to the new position on a
device size change. This leads to a rdev without a superblock on a known
position, the raid can't be re-assembled.

The line was removed by mistake and is re-added by this patch.

Fixes: d9c0fa509eaf ("md: fix max sectors calculation for super 1.0")
Cc: stable@vger.kernel.org
Signed-off-by: Markus Hochholdinger <markus@hochholdinger.net>
Reviewed-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2252,6 +2252,7 @@ super_1_rdev_size_change(struct md_rdev
 
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
+		rdev->sb_start = sb_start;
 	}
 	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);


