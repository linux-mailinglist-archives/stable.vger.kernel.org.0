Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3090847296C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbhLMKU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbhLMKS1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:18:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2375BC08E884;
        Mon, 13 Dec 2021 01:56:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E515AB80E26;
        Mon, 13 Dec 2021 09:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35726C34601;
        Mon, 13 Dec 2021 09:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389389;
        bh=cmUs+c0Bm5Tmi7gJOlk7Ewmu1KjnnZnSqifgvRzERxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f54Qod5cl7W+xCkVCquqZ78BgTspQ91qBx31pPr8naLCfpEhxYwoy+jtrG1zhzaM5
         g+6mkf9TwBm49CH1TxmD3SMjDwyhOAj6V3QTLiw0d6ICQDAmzlIEUSuQA+bmUHXuD9
         1HHJ4G+omes7XkwFXDd4TWL2vguJzVtaDOZK1COA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Hochholdinger <markus@hochholdinger.net>,
        Xiao Ni <xni@redhat.com>, Song Liu <songliubraving@fb.com>
Subject: [PATCH 5.15 083/171] md: fix update super 1.0 on rdev size change
Date:   Mon, 13 Dec 2021 10:29:58 +0100
Message-Id: <20211213092947.854248567@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -2193,6 +2193,7 @@ super_1_rdev_size_change(struct md_rdev
 
 		if (!num_sectors || num_sectors > max_sectors)
 			num_sectors = max_sectors;
+		rdev->sb_start = sb_start;
 	}
 	sb = page_address(rdev->sb_page);
 	sb->data_size = cpu_to_le64(num_sectors);


